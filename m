From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 8/9] psi: pressure stall information for CPU, memory, and
 IO
Date: Mon, 6 Aug 2018 11:40:51 -0400
Message-ID: <20180806154051.GA14209@cmpxchg.org>
References: <20180801151958.32590-1-hannes@cmpxchg.org>
 <20180801151958.32590-9-hannes@cmpxchg.org>
 <20180803165641.GA2476@hirez.programming.kicks-ass.net>
 <20180806150550.GA9888@cmpxchg.org>
 <20180806152528.GM2494@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=qGtFj7QGQQt9S5+V3oAQSCBbiSZ7fGINDfjcXzvk80A=;
        b=doipVUdhWQjSItLgotm8duswFctbnFegpnQzV8RbRWdGIBRLv4YoA4CdkusAOiMjtI
         gFA0jFlkbOr2humb2F+PzGx1sQmQsyESlBXXmBRIHN5kaRJ07i1P1GbuCODQtfM10dbj
         Fm33vvDZdiXtFyk1SwCw30dF26jTaU4w5Msi4wr06kM1xIRwjUwq5l5aU49g1WmWrK/s
         jmtELt0EA5SuLdTLyLTf6l3ybX4JKr33fmYWbpIS0yvtnjEgl8f8G9idOVNBOEHQfrSH
         Gjb/AP8fa/0hkJYASs03WBYrzR75uVwYzlsEuYbhcJnhk+YY1nT5Ruf3aLpKMFG8MmLe
         q36A==
Content-Disposition: inline
In-Reply-To: <20180806152528.GM2494@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Drake <drake@endlessm.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Mike Galbraith <efault@gmx.de>, Shakeel Butt <shakeelb@google.com>, Peter Enderborg <peter.enderborg@sony.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Mon, Aug 06, 2018 at 05:25:28PM +0200, Peter Zijlstra wrote:
> On Mon, Aug 06, 2018 at 11:05:50AM -0400, Johannes Weiner wrote:
> > Argh, that's right. This needs an explicit count if we want to access
> > it locklessly. And you already said you didn't like that this is the
> > only state not derived purely from the task counters, so maybe this is
> > the way to go after all.
> > 
> > How about something like this (untested)?
> 
> 
> > +static inline void psi_switch(struct rq *rq, struct task_struct *prev,
> > +			      struct task_struct *next)
> > +{
> > +	if (psi_disabled)
> > +		return;
> > +
> > +	if (unlikely(prev->flags & PF_MEMSTALL))
> > +		psi_task_change(prev, rq_clock(rq), TSK_RECLAIMING, 0);
> > +	if (unlikely(next->flags & PF_MEMSTALL))
> > +		psi_task_change(next, rq_clock(rq), 0, TSK_RECLAIMING);
> > +}
> 
> 
> Urgh... can't say I really like that.
> 
> I would really rather do that scheduler_tick() thing to avoid the remote
> update. The tick is a lot less hot than the switch path and esp.
> next->flags might be a cold line (prev->flags is typically the same line
> as prev->state so we already have that, but I don't think anybody now
> looks at next->flags or its line, so that'd be cold load).

Okay, the tick updater sounds like a much better option then. HZ
frequency should produce more than recent enough data.

That means we will retain the not-so-nice PF_MEMSTALL flag test under
rq lock, but it'll eliminate most of that memory ordering headache.

I'll do that. Thanks!
