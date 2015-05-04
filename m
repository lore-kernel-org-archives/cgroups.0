From: Mike Galbraith <umgwanakikbuti-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] sched: Relax a restriction in sched_rt_can_attach()
Date: Mon, 04 May 2015 07:39:24 +0200
Message-ID: <1430717964.3129.62.camel@gmail.com>
References: <5546C34C.7050202@huawei.com>
	 <1430709236.3129.42.camel@gmail.com> <5546F80B.3070802@huawei.com>
	 <1430716247.3129.44.camel@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :content-type:mime-version:content-transfer-encoding;
        bh=jzHKW/KGoOZbQc9LjeuJsovVahO+GzEXrF0QwzfO7F0=;
        b=A31mda4v1vnjJDAQL0w80+zSJZrIf5Qx9g/j1UK67tkdu/KA8/VDJhUG6pNdcxVg9O
         u5t+xpgVmXtSQAhIs2sC22s4k9yH3X9YGdW9CAeNXrwxsv8LtpWtgx+zsDfiP2prGaKm
         pcags4dSzhTf4a7pdWzhaFXDq1OMwKRt27o9MSPK6gv55EHCVwaHA/JCCEQx0YarE7D4
         ZuwuruR2Fc2qc3cjhN631w2eHwJIA6c/RXCulinDXArvdA2b4ecONxnRSIOJ/+os8Rjs
         AWHMofdeTgMWe4T9FYYYqEFNq+QrZO0hwmmn4uSAH6f3FGhReEFX6uEkWmslelJ7a9T2
         +dgQ==
In-Reply-To: <1430716247.3129.44.camel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Zefan Li <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Mon, 2015-05-04 at 07:10 +0200, Mike Galbraith wrote:
> On Mon, 2015-05-04 at 12:39 +0800, Zefan Li wrote:
> 
> > >> We are moving toward unified hierarchy where all the cgroup controllers
> > >> are bound together, so it would make cgroups easier to use if we have less
> > >> restrictions on attaching tasks between cgroups.
> > > 
> > > Forcing group scheduling overhead on users if they want cpuset or memory
> > > cgroup functionality would be far from wonderful.  Am I interpreting the
> > > implications of this unification/binding properly?
> > > 
> > > (I hope not, surely the plan is not to utterly _destroy_ cgroup utility)
> > > 
> > 
> > Some degree of flexibility is provided so that you may disable some controllers
> > in a subtree. For example:
> > 
> > root                  ---> child1
> > (cpuset,memory,cpu)        (cpuset,memory)
> >                       \
> >                        \-> child2
> >                            (cpu)
> 
> Whew, that's a relief.  Thanks.

But somehow I'm not feeling a whole lot better.

"May" means if you don't explicitly take some action to disable group
scheduling, you get it (I don't care if I have an off button), but that
would also seemingly mean that we would then have rt tasks in taskgroups
with no bandwidth allocated, ie you have to make group scheduling for rt
tasks meaningless until a bandwidth appeared, and to make bandwidth
appear, you'd have to stop the world, distribute, continue, no?

The current "just say no" seems a lot more sensible.

	-Mike
