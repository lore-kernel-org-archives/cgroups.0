From: Alexander Nikiforov <a.nikiforov-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC] event about group change
Date: Mon, 02 Apr 2012 08:19:10 +0400
Message-ID: <4F7928BE.8000502@samsung.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, a.nikiforov-Sze3O3UU22JBDgjK7y7TUQ@public.gmane.org

Hello, guys,

During our work we face to problem - get events about processes die in 
user space (not all but some of them). In the past we had special module 
which solve this problem.

But now I think that this task is quite native for cgroups subsystem. 
Move interesting PIDs into special group and set event handler. We 
investigate how events made in the memcg and implement proof of concepts 
patch against mainline (maybe little bit old, but it's just RFC message) 
with the same approach to "tasks" file.

So, I see several possible use cases for others with this patch.
1) replace wait4() for processes where we dont need for return status as 
well as we want just know about changing status of some group of processes
2) As extension of 1, implementing some balancing mechanism in the user 
space between several groups. For example if some process in one group 
consume much system resources, processes in other groups will be 
protected from slowdown.
3) Extremely useful in the libcgroup (in my mind), because now it's 
unprotected against changing state with hands.

Need you opinion about this.

Thank you.


-- Best regards, Alex Nikiforov, Mobile SW, Advanced Software Group, 
Moscow R&D center, Samsung Electronics
