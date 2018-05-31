From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v9 3/7] cpuset: Add cpuset.sched.load_balance flag to v2
Date: Thu, 31 May 2018 18:08:57 +0200
Message-ID: <20180531160857.GM12180@hirez.programming.kicks-ass.net>
References: <1527601294-3444-1-git-send-email-longman@redhat.com>
 <1527601294-3444-4-git-send-email-longman@redhat.com>
 <20180531122638.GJ12180@hirez.programming.kicks-ass.net>
 <42cc1f44-2355-1c0c-b575-49c863303c42@redhat.com>
 <20180531152050.GK12180@hirez.programming.kicks-ass.net>
 <ebe7f0c1-b2dc-57ad-e5cb-7edf0fee4626@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=0QOwRxESCMF6JuqJd8MdrY+MklytCyX6FiA0QLhgpuU=; b=qhi9ZUpfAFvnNM7TWasYDXvTY
        939AR6tEQvAfNSdLlLuQUzj9RhzihpYly3e1Jm6Z7fI6li14v+FWXD+TMTGbxrF6JDD2IjD8tvQsd
        M+0pEJKwxxMeWejNgrc+86VPKbL1u01mPLnpv+vUN2aZ5wtOd7Ge1VMChpxaJah5ZEFf4Pm7Vjy1Z
        GN8biTHLclCFdfgmjfbZax1Mr1unjSJRN02EfhexWPkh4hmOD75XzSXhlHA8Hg5jZXYJrvfFB65tk
        LjiuVOFmKmGfLuSRLb4w65g6mdv3g9DNz90LYWptZUigCl3BWDFG/j7gNEbc786uz6RFJcmaJN3Pe
    
Content-Disposition: inline
In-Reply-To: <ebe7f0c1-b2dc-57ad-e5cb-7edf0fee4626@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Ingo Molnar <mingo@redhat.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, Mike Galbraith <efault@gmx.de>, torvalds@linux-foundation.org, Roman Gushchin <guro@fb.com>, Juri Lelli <juri.lelli@redhat.com>, Patrick Bellasi <patrick.bellasi@arm.com>, Thomas Gleixner <tglx@linutronix.de>

On Thu, May 31, 2018 at 11:36:39AM -0400, Waiman Long wrote:
> > I'm on the fence myself; the only thing I'm fairly sure of is that tying
> > this particular behaviour to the load-balance knob seems off.
> 
> The main reason for doing it this way is that I don't want to have
> load-balanced partition with no cpu in it. How about we just don't allow
> consume-all at all. Each partition must have at least 1 cpu.

I suspect that might be sufficient. It certainly is for the use-cases
I'm aware of. You always want a system/control set which runs the
regular busy work of running a system.

Then you have one (or more) partitions to run your 'important' work.

> > I also think we should not mix the 'consume all' thing with the
> > 'fully-partitioned' thing, as they are otherwise unrelated.
>
> The "consume all" and "fully-partitioned" look the same to me. Are you
> talking about allocating all the CPUs in a partition to sub-partitions
> so that there is no CPU left in the parent partition?

Not sure what you're asking. "consume all" is allowing sub-partitions to
allocate all CPUs of the parent, such that there are none left.

"fully-partitioned" is N cpus but no load-balancing, also equivalent to
N 1 CPU parititions.

They are distinct things. Disabling load-balancing should not affect how
many CPUs can be allocated to sub-partitions, the moment you hit 1 CPU
the load balancing is effectively off already. Going down to 0 CPUs
isn't a problem for the load-balancer, it wasn't doing anything anyway.

So the question is if someone really needs the one partition without
balancing over N separate paritions.
