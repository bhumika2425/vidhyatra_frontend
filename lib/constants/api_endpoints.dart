class ApiEndPoints{
  static const baseUrl = "http://172.25.7.232:3001";

  //authentication
  static const login = "${baseUrl}/api/auth/login";

  static const register = "${baseUrl}/api/auth/register";
  //blog
  static const getAllBlogs = "${baseUrl}/api/blog/all";

  static const postBlogs= "${baseUrl}/api/blog/post";

  static const fetchProfileData ="${baseUrl}/api/profile/";

  static const createFeedback = "${baseUrl}/api/feedback/create";

  static const verifyOTP = "${baseUrl}/api/auth/verify-otp";

  static const forgotPassword = "${baseUrl}/api/auth/forgot-password";

  static const passwordReset = "${baseUrl}api/auth/reset-password";

  static const profileCreation = "${baseUrl}/api/profile/create";

  static const updateStudentProfileImage = "${baseUrl}/api/profile/update";

  static const checkIfProfileExist = "${baseUrl}/api/profile/exists";

  static const studentProfileUpdate = "${baseUrl}/api/profile/update";


}