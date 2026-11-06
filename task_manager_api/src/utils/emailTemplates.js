exports.getAssignTaskTemplate = (taskTitle, assignerName) => {
  return `
    <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; border: 1px solid #e0e0e0; border-radius: 8px; overflow: hidden;">
      <div style="background-color: #A50064; padding: 20px; text-align: center;">
        <h2 style="color: white; margin: 0;">Bạn có công việc mới!</h2>
      </div>
      <div style="padding: 20px;">
        <p>Chào bạn,</p>
        <p>Bạn vừa được <strong>${assignerName}</strong> giao một công việc mới trên hệ thống Task Manager.</p>
        <div style="background-color: #f9f9f9; padding: 15px; border-left: 4px solid #A50064; margin: 20px 0;">
          <h3 style="margin: 0; color: #333;">${taskTitle}</h3>
        </div>
        <p>Vui lòng mở ứng dụng để xem chi tiết và cập nhật tiến độ công việc.</p>
      </div>
    </div>
  `;
};

exports.getShareTaskTemplate = (taskTitle, sharerName, permission) => {
  const role = permission === 'editor' ? 'Chỉnh sửa' : 'Chỉ xem';
  return `
    <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; border: 1px solid #e0e0e0; border-radius: 8px; overflow: hidden;">
      <div style="background-color: #005A9C; padding: 20px; text-align: center;">
        <h2 style="color: white; margin: 0;">Một công việc vừa được chia sẻ với bạn!</h2>
      </div>
      <div style="padding: 20px;">
        <p>Chào bạn,</p>
        <p><strong>${sharerName}</strong> vừa chia sẻ công việc sau với bạn (Quyền: <strong>${role}</strong>):</p>
        <div style="background-color: #f9f9f9; padding: 15px; border-left: 4px solid #005A9C; margin: 20px 0;">
          <h3 style="margin: 0; color: #333;">${taskTitle}</h3>
        </div>
      </div>
    </div>
  `;
};

exports.getOtpTemplate = (otp) => {
  return `
    <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 0 auto; border: 1px solid #e0e0e0; border-radius: 8px; overflow: hidden;">
      <div style="background-color: #A50064; padding: 20px; text-align: center;">
        <h2 style="color: white; margin: 0;">Khôi phục mật khẩu</h2>
      </div>
      <div style="padding: 20px;">
        <p>Chào bạn,</p>
        <p>Bạn vừa yêu cầu khôi phục mật khẩu. Dưới đây là mã OTP của bạn (có hiệu lực trong 10 phút):</p>
        <div style="background-color: #f9f9f9; padding: 15px; border-left: 4px solid #A50064; margin: 20px 0; text-align: center;">
          <h1 style="margin: 0; color: #A50064; letter-spacing: 5px;">${otp}</h1>
        </div>
        <p>Nếu bạn không yêu cầu, vui lòng bỏ qua email này.</p>
      </div>
    </div>
  `;
};
