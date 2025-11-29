class ApiEndPoints{

  static const baseUrl = "http://10.0.2.2:3001";
  // static const baseUrl = "http://192.168.1.68:3001";

  // authentication
  static const login = "${baseUrl}/api/auth/login";

  static const register = "${baseUrl}/api/auth/register";
  //blog
  static const getAllBlogs = "${baseUrl}/api/blog/all";

  static const postBlogs= "${baseUrl}/api/blog/post"; 


  //feedback
  static const createFeedback = "${baseUrl}/api/feedback/create";
  //password
  static const verifyOTP = "${baseUrl}/api/auth/verify-otp";

  static const forgotPassword = "${baseUrl}/api/auth/forgot-password";

  //change password
  static const changePassword = "${baseUrl}/api/auth/change-password";

  static const passwordReset = "${baseUrl}api/auth/reset-password";
//profile creation and update
  static const profileCreation = "${baseUrl}/api/profile/create";

  static const updateStudentProfileImage = "${baseUrl}/api/profile/update";

  static const checkIfProfileExist = "${baseUrl}/api/profile/exists";

  static const studentProfileUpdate = "${baseUrl}/api/profile/update";

  static const fetchAllUsers = "${baseUrl}/api/auth/users";
  static const fetchProfileData ="${baseUrl}/api/profile/exists";

//friend request
  static const sendFriendRequest = "${baseUrl}/api/friendRequest/friend-requests";

  static const getFriendRequest = "${baseUrl}/api/friendRequest/friend-requests";

  // fees
static const getAllFees = "${baseUrl}/api/collegeFees/fees";



// esewa
static const initializePaymentWithEsewa = "${baseUrl}/api/payFees/initialize-payment";
static const fetchPaymentHistory = "${baseUrl}/api/payFees/payment-history";

//postfees
  static const postFees = "${baseUrl}/api/collegeFees/fees";



static const getEvents = "${baseUrl}/api/eventCalender/getEvents";
  static const getAcademic = "${baseUrl}/api/academic/events";

  // Exam Seat Planning
  static const getAllClassrooms = "${baseUrl}/api/classrooms/all";
  static const createClassroom = "${baseUrl}/api/classrooms/create";
  static const updateClassroom = "${baseUrl}/api/classrooms/update";
  
  static const getAllExams = "${baseUrl}/api/exams/all";
  static const createExam = "${baseUrl}/api/exams/create";
  static const getUpcomingExams = "${baseUrl}/api/exams/upcoming";
  
  static const generateSeatAllocation = "${baseUrl}/api/seat-allocation/generate";
  static const getSeatAllocation = "${baseUrl}/api/seat-allocation/get";
  static const getMySeatAllocations = "${baseUrl}/api/seat-allocation/my-seats";
  static const publishSeatAllocation = "${baseUrl}/api/seat-allocation/publish";
  static const getClassroomLayout = "${baseUrl}/api/classrooms/layout";

  // Notifications
  static const getMyNotifications = "${baseUrl}/api/notifications/my-notifications";
  static const getUnreadCount = "${baseUrl}/api/notifications/unread-count";
  static const markNotificationRead = "${baseUrl}/api/notifications/mark-read";
  static const markAllNotificationsRead = "${baseUrl}/api/notifications/mark-all-read";
  static const sendTestNotification = "${baseUrl}/api/notifications/test";
  static const sendNotificationToUser = "${baseUrl}/api/notifications/send-to-user";
  static const sendNotificationToRole = "${baseUrl}/api/notifications/send-to-role";
  static const broadcastNotification = "${baseUrl}/api/notifications/broadcast";

  // Announcements
  static const getActiveAnnouncements = "${baseUrl}/api/announcements/active/list";
  static const getAllAnnouncements = "${baseUrl}/api/announcements";

}