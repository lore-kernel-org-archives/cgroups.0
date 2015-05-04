From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] sched: Relax a restriction in sched_rt_can_attach()
Date: Mon, 4 May 2015 17:11:10 +0800
Message-ID: <554737AE.5040402@huawei.com>
References: <5546C34C.7050202@huawei.com>  <1430709236.3129.42.camel@gmail.com> <5546F80B.3070802@huawei.com>  <1430716247.3129.44.camel@gmail.com> <1430717964.3129.62.camel@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430717964.3129.62.camel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

>>> Some degree of flexibility is provided so that you may disable some controllers
>>> in a subtree. For example:
>>>
>>> root                  ---> child1
>>> (cpuset,memory,cpu)        (cpuset,memory)
>>>                       \
>>>                        \-> child2
>>>                            (cpu)
>>
>> Whew, that's a relief.  Thanks.
> 
> But somehow I'm not feeling a whole lot better.
> 
> "May" means if you don't explicitly take some action to disable group
> scheduling, you get it (I don't care if I have an off button), but that
> would also seemingly mean that we would then have rt tasks in taskgroups
> with no bandwidth allocated, ie you have to make group scheduling for rt
> tasks meaningless until a bandwidth appeared, and to make bandwidth
> appear, you'd have to stop the world, distribute, continue, no?
> 
> The current "just say no" seems a lot more sensible.
> 

I just realized we allow removing/adding controllers from/to cgroups
while there are tasks in them, which isn't safe unless we eliminate all
can_attach callbacks. We've done so for some cgroup subsystems, but
there are still a few of them...
