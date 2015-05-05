From: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] sched: Relax a restriction in sched_rt_can_attach()
Date: Tue, 05 May 2015 08:02:40 +0200
Message-ID: <1430805760.3215.16.camel@gmail.com>
References: <5546C34C.7050202@huawei.com>
	 <1430709236.3129.42.camel@gmail.com> <5546F80B.3070802@huawei.com>
	 <1430716247.3129.44.camel@gmail.com> <1430717964.3129.62.camel@gmail.com>
	 <554737AE.5040402@huawei.com>
	 <20150504123738.GZ21418@twins.programming.kicks-ass.net>
	 <1430748582.3166.16.camel@gmail.com> <55483CF8.8030908@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :content-type:mime-version:content-transfer-encoding;
        bh=0vbLoT+PWEdHYwUoozQDM3D7mcJS53n1+0uNy0eu4zU=;
        b=mDmJx6qiSnHa4zuOeEMleRW2XnrxOIoomG+jLe1ySR0uhWs7g/wi7LQymT5QhYpqa6
         Jaif6EUShahtirpEaKKRiv08sGGDfotZPS05bP5+KyTXi+ZP6rqFchRmy+c8ShhfOF7V
         a16cLNoUbwo4HbOyOuH1O/yBr0gjo2qKAKymkBrI90Dbmub1jCbmYGqA2Byg81m9SObM
         1SkZhIIkIFinuo7SSzo6FLkx/3zQgc12pRmYUP3Xq2NKn1Q1Lds4yn4fpjcT1f0Akh1s
         PRYqUZyAdIF3JLQ9WHCnsIHM/dddmgcCB62VAwxSm64X5pxrJLH+XseljkaY8c3P2DcU
         xmkw==
In-Reply-To: <55483CF8.8030908-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, 2015-05-05 at 11:46 +0800, Zefan Li wrote:
> On 2015/5/4 22:09, Mike Galbraith wrote:
> > On Mon, 2015-05-04 at 14:37 +0200, Peter Zijlstra wrote:
> >> On Mon, May 04, 2015 at 05:11:10PM +0800, Zefan Li wrote:
> >>
> >>> Some degree of flexibility is provided so that you may disable some controllers
> >>> in a subtree. For example:
> >>>
> >>> root                  ---> child1
> >>> (cpuset,memory,cpu)        (cpuset,memory)
> >>>                       \
> >>>                        \-> child2
> >>>                            (cpu)
> >>
> >> Uhm, how does that work? Would a task their effective cgroup be the
> >> first parent that has a controller enabled?
> >>
> >> In particular, in your example, if T were part of child1, would its cpu
> >> controller be root?
> 
> correct.
> 
> > 
> > That's what I'd hope for.  I wanted to try that cgroup.subtree_control
> > gizmo to see for myself, but I don't have one, and probably won't get
> > one until I introduce systemd to my axe (again, it's a slow learner).
> > 
> 
> I'm testing in an environment without systemd.

Lucky you.

> You need to mount cgroup with a special option:
> 
>   # mount -t cgroup -o __DEVEL__sane_behavior xxx /where
> 
> If a cgroup controller has already been mounted without this option,
> you won't see it in the unified hierarchy, so firstly you need to
> delete all cgroups in it and umount it.

Yeah, I found the flag, and systemd is indeed in the way.  You already
verified what subtree_control does, so I needn't squabble with the vile
thing over cgroups possession... immediately anyway.

	-Mike
