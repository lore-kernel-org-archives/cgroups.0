From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] sched: Relax a restriction in sched_rt_can_attach()
Date: Tue, 5 May 2015 11:46:00 +0800
Message-ID: <55483CF8.8030908@huawei.com>
References: <5546C34C.7050202@huawei.com>  <1430709236.3129.42.camel@gmail.com> <5546F80B.3070802@huawei.com>  <1430716247.3129.44.camel@gmail.com> <1430717964.3129.62.camel@gmail.com>  <554737AE.5040402@huawei.com>  <20150504123738.GZ21418@twins.programming.kicks-ass.net> <1430748582.3166.16.camel@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430748582.3166.16.camel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 2015/5/4 22:09, Mike Galbraith wrote:
> On Mon, 2015-05-04 at 14:37 +0200, Peter Zijlstra wrote:
>> On Mon, May 04, 2015 at 05:11:10PM +0800, Zefan Li wrote:
>>
>>> Some degree of flexibility is provided so that you may disable some controllers
>>> in a subtree. For example:
>>>
>>> root                  ---> child1
>>> (cpuset,memory,cpu)        (cpuset,memory)
>>>                       \
>>>                        \-> child2
>>>                            (cpu)
>>
>> Uhm, how does that work? Would a task their effective cgroup be the
>> first parent that has a controller enabled?
>>
>> In particular, in your example, if T were part of child1, would its cpu
>> controller be root?

correct.

> 
> That's what I'd hope for.  I wanted to try that cgroup.subtree_control
> gizmo to see for myself, but I don't have one, and probably won't get
> one until I introduce systemd to my axe (again, it's a slow learner).
> 

I'm testing in an environment without systemd.

You need to mount cgroup with a special option:

  # mount -t cgroup -o __DEVEL__sane_behavior xxx /where

If a cgroup controller has already been mounted without this option,
you won't see it in the unified hierarchy, so firstly you need to
delete all cgroups in it and umount it.
