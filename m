From: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] sched: Relax a restriction in sched_rt_can_attach()
Date: Mon, 04 May 2015 07:10:47 +0200
Message-ID: <1430716247.3129.44.camel@gmail.com>
References: <5546C34C.7050202@huawei.com>
	 <1430709236.3129.42.camel@gmail.com> <5546F80B.3070802@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :content-type:mime-version:content-transfer-encoding;
        bh=txaSh1usDmhxnQsY2KbGpzX0fM4ZiGurq/R7vwwIKDY=;
        b=vz1Tok6JLxtVgywLEqb0k4a3WWT0J6csO+F1ps6PbaPfbbYOHduYHCfVwQkYgqtrrh
         Icc3+wihXmKsSDYed6QD5GUkFeO6Ohwp0BVofCXMD9gkvjP0t5n6UBoGBHilMIHkW2bh
         QL8nQ4SgV3puGyEeT4YjbHLX8jyqrXgaAYmIfXuXMgUK7g4CL4bTZUgKJAvRNd8hRXur
         z43dy1ntmYunGi6RQ7C1gjnLxod6w5R2BINGkME3cWgs4gAl3c/WrppCaPQgHuFTcZDa
         LLQJDnTanMrtO3LMB/y/NRAv1rdvBhBRo7/QOZ2WYs2DMIQyiLHzsUrxj7ZsyV4a0BOw
         F+Yg==
In-Reply-To: <5546F80B.3070802-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, 2015-05-04 at 12:39 +0800, Zefan Li wrote:

> >> We are moving toward unified hierarchy where all the cgroup controllers
> >> are bound together, so it would make cgroups easier to use if we have less
> >> restrictions on attaching tasks between cgroups.
> > 
> > Forcing group scheduling overhead on users if they want cpuset or memory
> > cgroup functionality would be far from wonderful.  Am I interpreting the
> > implications of this unification/binding properly?
> > 
> > (I hope not, surely the plan is not to utterly _destroy_ cgroup utility)
> > 
> 
> Some degree of flexibility is provided so that you may disable some controllers
> in a subtree. For example:
> 
> root                  ---> child1
> (cpuset,memory,cpu)        (cpuset,memory)
>                       \
>                        \-> child2
>                            (cpu)

Whew, that's a relief.  Thanks.

	-Mike

