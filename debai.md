CASE STUDY 2

**ỨNG DỤNG QUẢN LÝ VÀ GIAO CÔNG VIỆC NHÓM**

*Flutter • Node.js/Express REST API • MongoDB • Email Notification*

# 1. Mục tiêu và phạm vi

Ứng dụng cho phép người dùng quản lý công việc cá nhân, giao công việc cho một hoặc nhiều người, chia sẻ công việc để nhiều người cùng xem hoặc chỉnh sửa theo quyền, theo dõi tiến độ và gửi thông báo qua email.

Phạm vi bắt buộc đề xuất: đăng ký/đăng nhập; CRUD công việc; giao việc; chia sẻ và phân quyền; thông báo trong ứng dụng; gửi email khi giao việc hoặc chia sẻ. Các chức năng nâng cao có thể triển khai sau.

# 2. Danh sách chức năng

## A. Quản lý tài khoản và xác thực

* Đăng ký tài khoản bằng họ tên, email và mật khẩu.
* Đăng nhập bằng email và mật khẩu.
* Đăng xuất khỏi hệ thống.
* Xem và cập nhật thông tin cá nhân.
* Đổi mật khẩu.

## B. Quản lý công việc

* Xem danh sách công việc được tạo, được giao, được nhận và được chia sẻ.
* Xem chi tiết công việc; tạo, chỉnh sửa và xóa công việc.
* Cập nhật trạng thái: chưa thực hiện, đang thực hiện, đã hoàn thành.
* Thiết lập mức độ ưu tiên: thấp, trung bình, cao.
* Thiết lập ngày bắt đầu và hạn hoàn thành.
* Tìm kiếm theo tên; lọc theo trạng thái, ưu tiên, người phụ trách.
* Sắp xếp theo hạn hoàn thành, mức độ ưu tiên hoặc thời gian tạo.

## C. Giao việc và chia sẻ

* Giao công việc cho một người hoặc nhiều người thông qua email/tài khoản.
* Chỉ định người phụ trách chính.
* Chia sẻ công việc cho nhiều người để cùng xem.
* Cấp quyền chỉ xem (viewer) hoặc chỉnh sửa (editor).
* Xem danh sách người được giao và người được chia sẻ.
* Thay đổi hoặc thu hồi quyền truy cập.
* Theo dõi tiến độ; phân loại theo vai trò người tạo, người phụ trách và người được chia sẻ.

## D. Thông báo qua email và trong ứng dụng

* Gửi email khi giao công việc mới.
* Gửi email khi mời người dùng xem hoặc tham gia công việc.
* Gửi email khi hạn hoàn thành hoặc thông tin quan trọng thay đổi.
* Gửi email khi công việc hoàn thành.
* Nhắc việc trước hạn theo lịch cấu hình, ví dụ 24 giờ.
* Lưu lịch sử gửi email và trạng thái thành công/thất bại.
* Hiển thị thông báo trong ứng dụng, đánh dấu đã đọc và mở công việc liên quan.

## E. Thống kê và tiện ích

* Thống kê tổng số công việc theo trạng thái.
* Thống kê công việc được giao và công việc đang phụ trách.
* Hiển thị công việc sắp đến hạn và đã quá hạn.
* Xem lịch sử hoạt động của công việc.
* Hiển thị trạng thái tải dữ liệu, thông báo lỗi và kết quả thao tác.

# 3. Danh sách màn hình

|  |  |
| --- | --- |
| **Màn hình** | **Chức năng chính** |
| 1. Đăng nhập | Nhập email/mật khẩu, kiểm tra thông tin và chuyển đến danh sách công việc; liên kết sang đăng ký. |
| 2. Đăng ký tài khoản | Nhập họ tên, email, mật khẩu và xác nhận mật khẩu; kiểm tra email trùng và tạo tài khoản. |
| 3. Danh sách công việc | Hiển thị công việc liên quan; phân loại công việc của tôi, được giao cho tôi, được chia sẻ; tìm kiếm, lọc, sắp xếp và tạo mới. |
| 4. Chi tiết công việc | Hiển thị mô tả, thời hạn, trạng thái, người tạo, người phụ trách, người được chia sẻ; mở chỉnh sửa, giao việc hoặc quản lý chia sẻ. |
| 5. Thêm công việc | Nhập tên, mô tả, ngày bắt đầu, hạn hoàn thành, mức độ ưu tiên và trạng thái ban đầu. |
| 6. Chỉnh sửa công việc | Cập nhật thông tin công việc và trạng thái theo quyền được cấp. |
| 7. Giao công việc | Tìm người theo tên/email, chọn một hoặc nhiều người phụ trách, chọn người phụ trách chính và xác nhận giao việc. |
| 8. Quản lý chia sẻ và quyền truy cập | Thêm người được xem, cấp viewer/editor, thay đổi quyền và thu hồi quyền chia sẻ. |
| 9. Thông báo | Xem thông báo giao việc, chia sẻ và thay đổi trạng thái; đánh dấu đã đọc và mở công việc liên quan. |
| 10. Cá nhân và thống kê | Xem/cập nhật hồ sơ, đổi mật khẩu, đăng xuất và xem số liệu công việc theo trạng thái, hạn hoàn thành. |

Ghi chú: Xác nhận xóa, chọn người nhận và chọn quyền chia sẻ có thể thực hiện bằng hộp thoại; không nhất thiết phải tạo màn hình riêng. Email được gửi bởi backend, không gửi trực tiếp từ Flutter.

# 4. Cấu trúc dữ liệu MongoDB

MongoDB dùng collection thay cho bảng quan hệ truyền thống. Đề xuất 6 collection chính: users, tasks, task\_shares, notifications, email\_logs và task\_activities.

## 4.1. Collection users — Tài khoản

|  |  |  |
| --- | --- | --- |
| **Trường** | **Kiểu dữ liệu** | **Ý nghĩa** |
| \_id | ObjectId | Mã người dùng |
| fullName | String | Họ tên |
| email | String | Email đăng nhập; tạo unique index |
| passwordHash | String | Mật khẩu đã băm, không lưu mật khẩu thô |
| avatarUrl | String | Đường dẫn ảnh đại diện, tùy chọn |
| createdAt | Date | Ngày tạo tài khoản |
| updatedAt | Date | Ngày cập nhật |

## 4.2. Collection tasks — Công việc

|  |  |  |
| --- | --- | --- |
| **Trường** | **Kiểu dữ liệu** | **Ý nghĩa** |
| \_id | ObjectId | Mã công việc |
| title | String | Tên công việc |
| description | String | Mô tả |
| createdBy | ObjectId | Người tạo công việc |
| assigneeIds | Array<ObjectId> | Danh sách người được giao |
| primaryAssigneeId | ObjectId | Người phụ trách chính |
| startDate | Date | Ngày bắt đầu |
| dueDate | Date | Hạn hoàn thành |
| priority | String | low, medium, high |
| status | String | todo, in\_progress, completed |
| createdAt | Date | Ngày tạo |
| updatedAt | Date | Ngày cập nhật |

## 4.3. Collection task\_shares — Chia sẻ và phân quyền

|  |  |  |
| --- | --- | --- |
| **Trường** | **Kiểu dữ liệu** | **Ý nghĩa** |
| \_id | ObjectId | Mã bản ghi chia sẻ |
| taskId | ObjectId | Công việc được chia sẻ |
| userId | ObjectId | Người được chia sẻ |
| permission | String | viewer hoặc editor |
| sharedBy | ObjectId | Người cấp quyền |
| createdAt | Date | Thời điểm chia sẻ |

Nên tạo unique compound index cho taskId + userId để tránh nhiều bản ghi chia sẻ trùng nhau. Người được giao và người được chia sẻ có thể trùng nhau; backend phải kiểm tra quyền nhất quán.

## 4.4. Collection notifications — Thông báo

|  |  |  |
| --- | --- | --- |
| **Trường** | **Kiểu dữ liệu** | **Ý nghĩa** |
| \_id | ObjectId | Mã thông báo |
| userId | ObjectId | Người nhận |
| taskId | ObjectId | Công việc liên quan |
| type | String | Loại sự kiện |
| title | String | Tiêu đề |
| message | String | Nội dung |
| isRead | Boolean | Đã đọc hay chưa |
| createdAt | Date | Thời điểm tạo |

## 4.5. Collection email\_logs — Lịch sử gửi email

|  |  |  |
| --- | --- | --- |
| **Trường** | **Kiểu dữ liệu** | **Ý nghĩa** |
| \_id | ObjectId | Mã lịch sử |
| taskId | ObjectId/null | Công việc liên quan, có thể rỗng |
| recipientEmail | String | Email người nhận |
| eventType | String | Sự kiện kích hoạt |
| subject | String | Tiêu đề email |
| status | String | pending, sent, failed |
| attempts | Number | Số lần thử gửi |
| errorMessage | String | Lỗi nếu gửi thất bại |
| sentAt | Date | Thời điểm gửi thành công |
| createdAt | Date | Thời điểm tạo yêu cầu |

## 4.6. Collection task\_activities — Lịch sử hoạt động

|  |  |  |
| --- | --- | --- |
| **Trường** | **Kiểu dữ liệu** | **Ý nghĩa** |
| \_id | ObjectId | Mã hoạt động |
| taskId | ObjectId | Công việc liên quan |
| userId | ObjectId | Người thực hiện |
| action | String | Tạo, sửa, giao việc, chia sẻ, đổi trạng thái… |
| details | Object | Chi tiết thay đổi |
| createdAt | Date | Thời điểm thực hiện |

# 5. Cấu trúc thư mục dự án

## 5.1. Frontend — Flutter

task\_manager/
├── android/
├── assets/
│ └── images/
├── lib/
│ ├── main.dart
│ ├── app.dart
│ ├── models/
│ │ ├── user.dart
│ │ ├── task.dart
│ │ ├── task\_share.dart
│ │ ├── notification.dart
│ │ └── task\_activity.dart
│ ├── services/
│ │ ├── api\_client.dart
│ │ ├── auth\_service.dart
│ │ ├── task\_service.dart
│ │ ├── user\_service.dart
│ │ ├── task\_share\_service.dart
│ │ ├── notification\_service.dart
│ │ └── statistics\_service.dart
│ ├── screens/
│ │ ├── auth/
│ │ │ ├── login\_screen.dart
│ │ │ └── register\_screen.dart
│ │ ├── tasks/
│ │ │ ├── task\_list\_screen.dart
│ │ │ ├── task\_detail\_screen.dart
│ │ │ ├── task\_create\_screen.dart
│ │ │ └── task\_edit\_screen.dart
│ │ ├── assignment/
│ │ │ └── assign\_task\_screen.dart
│ │ ├── sharing/
│ │ │ └── task\_sharing\_screen.dart
│ │ ├── notifications/
│ │ │ └── notification\_screen.dart
│ │ └── profile/
│ │ └── profile\_screen.dart
│ ├── widgets/
│ │ ├── task\_card.dart
│ │ ├── status\_badge.dart
│ │ ├── priority\_badge.dart
│ │ ├── user\_selector.dart
│ │ └── loading\_view.dart
│ └── utils/
│ ├── validators.dart
│ ├── constants.dart
│ └── date\_formatter.dart
├── pubspec.yaml
└── README.md

## 5.2. Backend — Node.js, Express và MongoDB

task\_manager\_api/
├── src/
│ ├── server.js
│ ├── app.js
│ ├── config/
│ │ ├── database.js
│ │ └── email.js
│ ├── models/
│ │ ├── User.js
│ │ ├── Task.js
│ │ ├── TaskShare.js
│ │ ├── Notification.js
│ │ ├── EmailLog.js
│ │ └── TaskActivity.js
│ ├── controllers/
│ │ ├── authController.js
│ │ ├── userController.js
│ │ ├── taskController.js
│ │ ├── assignmentController.js
│ │ ├── taskShareController.js
│ │ ├── notificationController.js
│ │ └── statisticsController.js
│ ├── routes/
│ │ ├── authRoutes.js
│ │ ├── userRoutes.js
│ │ ├── taskRoutes.js
│ │ ├── assignmentRoutes.js
│ │ ├── taskShareRoutes.js
│ │ ├── notificationRoutes.js
│ │ └── statisticsRoutes.js
│ ├── services/
│ │ ├── emailService.js
│ │ ├── notificationService.js
│ │ └── taskService.js
│ ├── middleware/
│ │ ├── authMiddleware.js
│ │ ├── permissionMiddleware.js
│ │ ├── validateMiddleware.js
│ │ └── errorMiddleware.js
│ ├── validators/
│ │ ├── authValidator.js
│ │ └── taskValidator.js
│ └── utils/
│ └── emailTemplates.js
├── .env.example
├── .gitignore
├── package.json
└── README.md

# 6. Danh sách API endpoint

Base URL minh họa: http://localhost:3000/api

Các API nghiệp vụ cần yêu cầu token xác thực; backend kiểm tra quyền trên từng công việc.

## 6.1. Xác thực — /auth

|  |  |  |
| --- | --- | --- |
| **Method** | **Endpoint** | **Chức năng** |
| POST | /auth/register | Đăng ký tài khoản |
| POST | /auth/login | Đăng nhập |
| GET | /auth/me | Lấy thông tin người dùng hiện tại |
| PUT | /auth/me | Cập nhật thông tin cá nhân |
| PUT | /auth/change-password | Đổi mật khẩu |

## 6.2. Người dùng — /users

|  |  |  |
| --- | --- | --- |
| **Method** | **Endpoint** | **Chức năng** |
| GET | /users/search?q= | Tìm người dùng theo tên hoặc email |
| GET | /users/:id | Xem thông tin công khai của người dùng |

## 6.3. Công việc — /tasks

|  |  |  |
| --- | --- | --- |
| **Method** | **Endpoint** | **Chức năng** |
| GET | /tasks | Danh sách công việc người dùng có quyền truy cập |
| POST | /tasks | Tạo công việc |
| GET | /tasks/:id | Xem chi tiết công việc |
| PUT | /tasks/:id | Cập nhật thông tin công việc |
| DELETE | /tasks/:id | Xóa công việc |
| PATCH | /tasks/:id/status | Cập nhật trạng thái |
| GET | /tasks/:id/activities | Xem lịch sử hoạt động |

## 6.4. Giao việc — /tasks/:id/assignees

|  |  |  |
| --- | --- | --- |
| **Method** | **Endpoint** | **Chức năng** |
| GET | /tasks/:id/assignees | Danh sách người được giao |
| POST | /tasks/:id/assignees | Giao việc cho một hoặc nhiều người |
| PATCH | /tasks/:id/assignees/:userId | Cập nhật vai trò/người phụ trách chính |
| DELETE | /tasks/:id/assignees/:userId | Hủy giao việc cho một người |

## 6.5. Chia sẻ — /tasks/:id/shares

|  |  |  |
| --- | --- | --- |
| **Method** | **Endpoint** | **Chức năng** |
| GET | /tasks/:id/shares | Danh sách người được chia sẻ |
| POST | /tasks/:id/shares | Chia sẻ cho một hoặc nhiều người |
| PATCH | /tasks/:id/shares/:shareId | Thay đổi quyền viewer/editor |
| DELETE | /tasks/:id/shares/:shareId | Thu hồi quyền chia sẻ |

## 6.6. Thông báo — /notifications

|  |  |  |
| --- | --- | --- |
| **Method** | **Endpoint** | **Chức năng** |
| GET | /notifications | Danh sách thông báo của người dùng |
| GET | /notifications/unread-count | Đếm thông báo chưa đọc |
| PATCH | /notifications/:id/read | Đánh dấu một thông báo đã đọc |
| PATCH | /notifications/read-all | Đánh dấu tất cả đã đọc |

## 6.7. Thống kê — /statistics

|  |  |  |
| --- | --- | --- |
| **Method** | **Endpoint** | **Chức năng** |
| GET | /statistics/tasks | Thống kê theo trạng thái |
| GET | /statistics/assignments | Thống kê việc được giao và đang phụ trách |
| GET | /statistics/deadlines | Thống kê việc sắp đến hạn và quá hạn |

## 6.8. Email — /email-logs

|  |  |  |
| --- | --- | --- |
| **Method** | **Endpoint** | **Chức năng** |
| GET | /tasks/:id/email-logs | Xem lịch sử gửi email của công việc |
| POST | /email-logs/:id/retry | Thử gửi lại email thất bại; giới hạn quyền phù hợp |

Tham số lọc gợi ý cho GET /tasks: scope=created|assigned|shared, status, priority, q, sortBy và order. Backend phải xác minh người gọi có quyền truy cập công việc trước khi trả dữ liệu.

# 7. Quy trình gửi email thông báo

1. Người dùng thao tác trên Flutter: giao việc, chia sẻ hoặc cập nhật công việc.
2. Backend xác thực người dùng, kiểm tra quyền và lưu thay đổi vào MongoDB.
3. Backend tạo thông báo trong ứng dụng và ghi nhận yêu cầu gửi email.
4. Email service gửi email qua SMTP hoặc dịch vụ email giao dịch.
5. Cập nhật trạng thái email thành sent hoặc failed; lưu lỗi và cho phép thử gửi lại khi phù hợp.

Các sự kiện nên gửi email trước: giao việc mới, chia sẻ công việc, thay đổi hạn hoàn thành và hoàn thành công việc. Nhắc việc theo thời gian cần một tác vụ định kỳ ở backend. Không lưu thông tin SMTP trực tiếp trong mã nguồn.

# 8. Phân bổ triển khai qua 3 buổi

|  |  |  |
| --- | --- | --- |
| **Buổi** | **Nội dung** | **Kết quả mong đợi** |
| Buổi 1 | Đăng ký/đăng nhập; xác thực API; danh sách và chi tiết công việc; GET dữ liệu từ MongoDB. | Người dùng đăng nhập và đọc được dữ liệu công việc. |
| Buổi 2 | Thêm/sửa/xóa; giao việc nhiều người; chia sẻ quyền viewer/editor; kiểm tra phân quyền backend. | Hoàn thành CRUD, giao việc và chia sẻ có kiểm soát. |
| Buổi 3 | Email khi giao việc/chia sẻ; thông báo trong ứng dụng; tìm kiếm, lọc, thống kê và kiểm thử. | Hoàn thiện luồng nghiệp vụ chính và kiểm thử tích hợp. |

# 9. Yêu cầu kỹ thuật và bảo mật

* Reposirity trên gitHub đặt tên là case2\_<mssv>\_<hoten>
* Mật khẩu phải được băm bằng thư viện phù hợp; không lưu hoặc trả về mật khẩu dạng rõ.
* Các API riêng tư phải xác thực token và kiểm tra quyền ở backend, không chỉ ẩn nút trên giao diện.
* Người có quyền viewer không được sửa dữ liệu; editor không mặc nhiên được xóa công việc hoặc quản lý quyền chia sẻ.
* Dùng biến môi trường cho chuỗi kết nối MongoDB, JWT secret và thông tin SMTP; không commit file .env lên GitHub.
* Email phải được gửi từ backend; ghi log trạng thái và hạn chế việc gửi lại để tránh gửi trùng.
* Kiểm tra dữ liệu đầu vào, xử lý lỗi nhất quán và không tiết lộ thông tin nhạy cảm trong thông báo lỗi.

# 10. Phạm vi bắt buộc và phần mở rộng

Bắt buộc: đăng ký/đăng nhập, CRUD công việc, giao việc, chia sẻ cho nhiều người, phân quyền xem/sửa, thông báo trong ứng dụng và email khi giao việc/chia sẻ.

Mở rộng: email nhắc hạn tự động, lịch sử hoạt động đầy đủ, thống kê nâng cao, thử gửi lại email và đổi mật khẩu nâng cao.