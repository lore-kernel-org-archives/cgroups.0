From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] sched: Relax a restriction in sched_rt_can_attach()
Date: Tue, 5 May 2015 11:54:31 +0800
Message-ID: <55483EF7.7070905@huawei.com>
References: <5546C34C.7050202@huawei.com> <1430709236.3129.42.camel@gmail.com> <5546F80B.3070802@huawei.com> <1430716247.3129.44.camel@gmail.com> <1430717964.3129.62.camel@gmail.com> <554737AE.5040402@huawei.com> <20150504123738.GZ21418@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150504123738.GZ21418-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 2015/5/4 20:37, Peter Zijlstra wrote:
> On Mon, May 04, 2015 at 05:11:10PM +0800, Zefan Li wrote:
> 
>> Some degree of flexibility is provided so that you may disable some controllers
>> in a subtree. For example:
>>
>> root                  ---> child1
>> (cpuset,memory,cpu)        (cpuset,memory)
>>                       \
>>                        \-> child2
>>                            (cpu)
> 
> Uhm, how does that work? Would a task their effective cgroup be the
> first parent that has a controller enabled?
> 
> In particular, in your example, if T were part of child1, would its cpu
> controller be root?
> 
>> I just realized we allow removing/adding controllers from/to cgroups
>> while there are tasks in them, which isn't safe unless we eliminate all
>> can_attach callbacks. We've done so for some cgroup subsystems, but
>> there are still a few of them...
> 
> You can't remove can_attach(), we must be able to disallow joining a
> cgroup.
> 
> If that results in you not being able to change the cgroup setup with
> tasks in, so be it -- that seems like a sane restriction anyhow.
> 

I wasn't thinking about removing can_attach() before I noticed this issue.

But I was wondering if we can change the default value of cpu.rt_runtime_us
from 0 to -1? So by default the RT tasks can be attached to a newly-created
cgroup without users having to make any configuration, and those tasks are
confined by the parent cgroup, which is what we have with cfs bw control.
This require some changes to the code, but I guess it's do-able?
