const User = require('../models/User');
const jwt = require('jsonwebtoken');

const generateToken = (id) => jwt.sign({ id }, process.env.JWT_SECRET, { expiresIn: process.env.JWT_EXPIRES_IN });

exports.register = async (req, res) => {
  try {
    const { fullName, email, password } = req.body;
    const userExists = await User.findOne({ email });
    if (userExists) return res.status(400).json({ success: false, message: 'Email này đã được sử dụng' });

    const user = await User.create({ fullName, email, passwordHash: password });
    res.status(201).json({ success: true, token: generateToken(user._id), data: user });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};

exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;
    const user = await User.findOne({ email });
    
    if (!user || !(await user.matchPassword(password))) {
      return res.status(401).json({ success: false, message: 'Email hoặc mật khẩu không chính xác' });
    }
    res.status(200).json({ success: true, token: generateToken(user._id), data: user });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
};
