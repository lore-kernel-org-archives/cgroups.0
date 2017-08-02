From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 2/2] sched: Implement interface for cgroup unified
 hierarchy
Date: Wed, 2 Aug 2017 18:05:11 +0200
Message-ID: <20170802160511.cb7yl65t4nmctf3y@hirez.programming.kicks-ass.net>
References: <20170720184808.1433868-1-tj@kernel.org>
 <20170720184808.1433868-3-tj@kernel.org>
 <20170729091707.lobbicnw253wzltu@hirez.programming.kicks-ass.net>
 <20170801201745.GA2311718@devbig577.frc2.facebook.com>
 <20170801214038.sp4lw6lrnl3votte@hirez.programming.kicks-ass.net>
 <20170802154135.GI2311718@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=sbudj1/bAbmyvlkha5nCRldKQzmfTibbF9RsA/euaMM=; b=bJZgXYu/eXTS9iowfaxxcgbet
        DzDWnOtSaLcrT4JMHMPFy0/3de+OlYKAloDspRbs5QRbZVQjdjWHZjU5/fMvGHXdc/Fu6KQoFief3
        MuW8il2JWx0MM0StgQm5t3NmG4DYLw8qdzQMEsKxLA8NxAKruv+tSuOG/63948nPj5QoAjvheu3Da
        Fvc9CHV8h0anCii1ppOkn+FBgj2sXtcJPsJMtD4pR+rr7zga2A2FYGSfxzhvLd+VqzEoyMhnJCwHU
        e15lW9qTa75YSDJuyIPGaUQ6KklKEMG0hGLAR+Jym/AVre/4hH22HabJKA8MKXGjd+tnEhgmgaOeh
      
Content-Disposition: inline
In-Reply-To: <20170802154135.GI2311718@devbig577.frc2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, mingo@redhat.com, longman@redhat.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, pjt@google.com, luto@amacapital.net, efault@gmx.de, torvalds@linux-foundation.org, guro@fb.com

On Wed, Aug 02, 2017 at 08:41:35AM -0700, Tejun Heo wrote:
> > Not entirely sure I follow, we currently only update the current cgroup
> > and its immediate parents, no? Or are you looking to only account into
> > the current cgroup and propagate into the parents on reading?
> 
> Yeah, shifting the cost to the readers and being smart with
> propagation so that reading isn't O(nr_descendants) but
> O(nr_descendants_which_have_run_since_last_read).  That way, we can
> show the basic stats without taxing the hot paths with reasonable
> scalability.

Right, that would be good.

> I have a couple questions about cpuacct tho.
> 
> * The stat file is sampling based and the usage files are calculated
>   from actual scheduling events.  Is this because the latter is more
>   accurate?

So I actually don't know the history of this stuff too well. But I would
think so. This all looks rather dodgy.

> * Why do we have user/sys breakdown in usage numbers?  It tries to
>   distinguish user or sys by looking at task_pt_regs().  I can't see
>   how this would work (e.g. interrupt handlers never schedule) and w/o
>   kernel preemption, the sys part is always zero.  What is this number
>   supposed to mean?

For normal scheduler stuff we account the total runtime in ns and use
the user/kernel tick samples to divide it into user/kernel time parts.
See cputime_adjust().

But looking at the cpuacct I have no clue, that looks wonky at best.

Ideally we'd reuse the normal cputime code and do the same thing
per-cgroup, but clearly that isn't happening now.

I never really looked further than that cpuacct_charge() doing _another_
cgroup iteration, even though we already account that delta to each
cgroup (modulo scheduling class crud).
