package com.thehuxley

/**
 * Created with IntelliJ IDEA.
 * User: MRomero
 * Date: 31/01/13
 * Time: 17:14
 * To change this template use File | Settings | File Templates.
 */
class UserSetting {
    int emailNotify
    ShiroUser user
    static belongsTo = [ShiroUser]

}
