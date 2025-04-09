class ApiEndPoints{
  // static const baseUrl = "http://192.168.1.11:3001";
  static const baseUrl = "http://10.0.2.2:3001";


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
  static const fetchProfileData ="${baseUrl}/api/profile/";

//friend request
  static const sendFriendRequest = "${baseUrl}/api/friendRequest/friend-requests";

  static const getFriendRequest = "${baseUrl}/api/friendRequest/friend-requests";

  // fees
static const getAllFees = "${baseUrl}/api/collegeFees/fees";

// get students
static const getStudents= "${baseUrl}/api/auth/students";

// get professors
  static const getProfessors= "${baseUrl}/api/auth/teachers";

// esewa
static const initializePaymentWithEsewa = "${baseUrl}/api/payFees/initialize-esewa";

//postfees
  static const postFees = "${baseUrl}/api/collegeFees/fees";

//calender
  static const postEvents = "${baseUrl}/api/eventCalender/postEvents";
static const getEvents = "${baseUrl}/api/eventCalender/getEvents";


}