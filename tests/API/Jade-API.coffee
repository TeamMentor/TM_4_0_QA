class Jade_API
  constructor: (page)->
    @tm_35_Server = "https://tmdev01-uno.teammentor.net"
    @page         = page
    @QA_Users     = [{ name:'user', pwd: 'a'}]
    @url_Prefix   = 'show'
    @poc_Prefix   = 'poc'

  clear_Session: (callback)->
                  @page.chrome.delete_Cookie 'tm-session', 'http://localhost/', callback

  login          : (username, password, callback)=>
                    @page_Login =>
                      code = "document.querySelector('#username').value='#{username}';
                              document.querySelector('#password').value='#{password}';
                              document.querySelector('#btn-login').click()"
                      @page.chrome.eval_Script code, =>
                        @page.wait_For_Complete callback

  login_Without_MaxLength : (username, password, callback)=>
                    @page_Login =>
                      #removing required attribute to pass test
                      script ="document.querySelector('#username').removeAttribute('required');
                                 document.querySelector('#password').removeAttribute('required');"
                      @page.chrome.eval_Script script

                      code = "document.querySelector('#username').value='#{username}';
                                              document.querySelector('#password').value='#{password}';
                                              document.querySelector('#btn-login').click()"
                      @page.chrome.eval_Script code, =>
                        @page.wait_For_Complete callback

  login_As_QA   : (callback) =>
    user = @QA_Users.first()
    @login user.name, user.pwd, =>
      @page.html callback


  login_As_User: (callback) =>
    @is_User_Logged_In (value)=>
      if value
        @page.html callback
      else
        @login_As_QA callback


  is_User_Logged_In: (callback) =>

    url = @page.tm_Server + '/user/main.html'
    @.session_Cookie (cookie)->
      if (cookie is null)
        callback false
      else
        options = { headers: { 'Cookie':'tm-session='+ cookie.value} }
        url.http_With_Options options, (err, html)->
          callback html and html.contains('Logout')

  page_About          : (callback) => @page.open '/guest/about.html'                 , callback
  page_Help           : (callback) => @page.open '/help/index.html'                  , callback
  page_Home           : (callback) => @page.open '/'                                 , callback
  page_Features       : (callback) => @page.open '/guest/features.html'              , callback
  page_Login          : (callback) => @page.open '/guest/login.html'                 , callback
  page_Login_Fail     : (callback) -> @page.open '/guest/login-Fail.html'            , callback
  page_Login_Required : (callback) => @page.open '/guest/login-required.html'        , callback
  page_Main_Page      : (callback) => @page.open '/guest/default.html'               , callback
  page_Pwd_Forgot     : (callback) => @page.open '/guest/pwd-forgot.html'            , callback
  page_Pwd_Sent       : (callback) => @page.open '/guest/pwd-sent.html'              , callback
  page_Sign_Up        : (callback) => @page.open '/guest/sign-up.html'               , callback
  page_Sign_Up_Fail   : (callback) => @page.open '/guest/sign-up-Fail.html'          , callback
  page_Sign_Up_OK     : (callback) => @page.open '/guest/sign-up-OK.html'            , callback
  page_TermsAndCond   : (callback) => @page.open '/guest/terms-and-conditions.html'  , callback

  page_User_Help     : (callback        ) => @page.open '/help/index.html'           , callback
  page_User_Libraries: (callback        ) => @page.open '/libraries'                 , callback
  page_User_Library  : (callback        ) => @page.open '/library/Uno'               , callback
  page_User_Logout   : (callback        ) => @page.open '/user/logout'               , callback
  page_User_Main     : (callback        ) => @page.open '/user/main.html'            , callback
  page_User_Queries  : (callback        ) => @page.open '/library/queries'           , callback
  page_User_Graph    : (target, callback) => @page.open "/#{@url_Prefix}/#{target}"  , callback
  page_User_Graph_All: (callback        ) => @page.open "/#{@url_Prefix}"            , callback

  page_User_PoC      : (target, callback) => @page.open "/#{@poc_Prefix}/#{target}"  , callback

  render_File: (file, params, callback)->
    mixinPage = "/render/file/#{file}?#{params}"
    @.page.open mixinPage, (html, $)->
      callback($)

  render_Mixin: (file, mixin, params, callback)->
    mixinPage = "/render/mixin/#{file}/#{mixin}?#{params}"
    @.page.open mixinPage, (html, $)->
      callback($)


  session_Cookie  : (callback) =>
                      @page.chrome.cookies (cookies)->
                        for cookie in cookies
                          if cookie.name is "tm-session"
                            callback(cookie)
                            return
                        callback(null)

  user_Sign_Up    : (username, password, email, callback) =>
                      @page_Sign_Up (html, $)=>
                        #removing required attribute to pass test
                        script ="document.querySelector('#username').removeAttribute('required');
                                 document.querySelector('#password').removeAttribute('required');"
                        @page.chrome.eval_Script script
                        code = "document.querySelector('#username').value='#{username}';
                                document.querySelector('#password').value='#{password}';
                                document.querySelector('#confirm-password').value='#{password}';
                                document.querySelector('#email').value='#{email}';
                                document.querySelector('#btn-sign-up').click()"
                        @page.chrome.eval_Script code, =>
                          @page.wait_For_Complete (html, $)=>
                            callback(html, $)

module.exports = Jade_API