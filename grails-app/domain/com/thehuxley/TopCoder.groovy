package com.thehuxley

import java.io.Serializable;
import java.util.ArrayList;


class TopCoder implements Serializable{
	ShiroUser user
	double points
	
	public static void generateList(){		
	TopCoder.executeUpdate("delete from TopCoder")

        List list = TopCoder.executeQuery(""" Select up.user,sum(up.problem.nd) as points from UserProblem up left join up.problem
                                          where up.status = 1 and up.similarity <> 3 and up.problem.status = 2 and up.user.id not in (Select cp.user.id from ClusterPermissions cp where cp.group.name = 'BlackList' ) group by up.user.id order by sum(up.problem.nd) desc""")

        int position = 1
        list.each{
            TopCoder topcoder = new TopCoder(user: it[0],points: it[1]).save()
            it[0].topCoderPosition =  position
            it[0].topCoderScore = it[1]
            position++
        }
	}
}
