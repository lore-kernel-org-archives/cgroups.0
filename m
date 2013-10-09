From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: cgroup attach task - slogging cpu
Date: Wed, 9 Oct 2013 13:35:38 +0800
Message-ID: <5254EB2A.7090803@huawei.com>
References: <CALPf4Tz+Gf_Q7wKKBufCc1mtV1qVPVrOW0S1qhHxfOv6pJa2Kg@mail.gmail.com> <20131004130207.GA9338@redhat.com> <20131007184507.GD27396@htj.dyndns.org> <20131008145833.GA15600@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131008145833.GA15600-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Oleg Nesterov <oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, anjana vk <anjanvk12-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

>>>> --- a/kernel/cgroup.c
>>>> +++ b/kernel/cgroup.c
>>>> @@ -2002,7 +2002,9 @@ static int cgroup_attach_task(struct cgroup *cgrp, struct task_struct *tsk,
>>>>  		ent.task = tsk;
>>>>  		ent.cgrp = task_cgroup_from_root(tsk, root);
>>>>  		/* nothing to do if this task is already in the cgroup */
>>>> -		if (ent.cgrp == cgrp)
>>>> +		if (ent.cgrp == cgrp && !threadgroup)
>>>> +			break;
>>>> +		else if(ent.cgrp == cgrp)
>>>>  			continue;
>>
>> I have no idea know how this would make any difference.  Hmm...
> 
> I guess the patch needs a cleanup, but this code looks indeed wrong
> even if we forget about rcu/while_each_thread? Really, we should not
> "continue" if threadgroup == T, in this case we miss the last
> 
> 		if (!threadgroup)
> 			break;
> 

Yes, this is wrong.

lxc34:/mnt/tmp # echo 5207 > tasks
lxc34:/mnt/tmp # cat tasks
5207
lxc34:/mnt/tmp # echo 5207 > tasks
lxc34:/mnt/tmp # cat tasks
5207
5215
lxc34:/mnt/tmp # echo 5207 > tasks
lxc34:/mnt/tmp # cat tasks
5207
5215
5216

I wanted to attach 5207 to the cgroup, and in this case it should be
a no-op because the thread was already in this cgroup, but the result
was another thread got attached to it.

Anjana, could you revise the patch and send it out with proper changelog
and Signed-off-by? And please add "Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 3.9+"

The cpu slogging issue is another bug that we're working on.

> check in the main loop. So Anjana was right (sorry again!), and we
> should probably do
> 
> 		ent.cgrp = task_cgroup_from_root(...);
> 		if (ent.cgrp != cgrp) {
> 			retval = flex_array_put(...);
> 			...
> 		}
> 
> 		if (!threadgroup)
> 			break;
> 

Or

do {
	...
	if (ent.cgrp == cgrp)
		goto next;
	...
next:
	if (!threadgroup)
		break;
} while (...);

> Or I am wrong again?
> 

No, you are not! :)
