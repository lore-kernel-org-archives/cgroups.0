From: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] sched: Relax a restriction in sched_rt_can_attach()
Date: Mon, 4 May 2015 12:39:39 +0800
Message-ID: <5546F80B.3070802@huawei.com>
References: <5546C34C.7050202@huawei.com> <1430709236.3129.42.camel@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430709236.3129.42.camel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On 2015/5/4 11:13, Mike Galbraith wrote:
> On Mon, 2015-05-04 at 08:54 +0800, Zefan Li wrote:
>> It's allowed to promote a task from normal to realtime after it has been
>> attached to a non-root cgroup, but it will fail if the attaching happens
>> after it has become realtime. I don't see how this restriction is useful.
> 
> In the CONFIG_RT_GROUP_SCHED case, promotion will fail is there is no
> bandwidth allocated.
> 

Right. I forgot to mention this patch affects !CONFIG_RT_GROUP_SCHED only,
though it should be obvious by reading the change.

>> We are moving toward unified hierarchy where all the cgroup controllers
>> are bound together, so it would make cgroups easier to use if we have less
>> restrictions on attaching tasks between cgroups.
> 
> Forcing group scheduling overhead on users if they want cpuset or memory
> cgroup functionality would be far from wonderful.  Am I interpreting the
> implications of this unification/binding properly?
> 
> (I hope not, surely the plan is not to utterly _destroy_ cgroup utility)
> 

Some degree of flexibility is provided so that you may disable some controllers
in a subtree. For example:

root                  ---> child1
(cpuset,memory,cpu)        (cpuset,memory)
                      \
                       \-> child2
                           (cpu)
