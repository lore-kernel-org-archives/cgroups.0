From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 8/9] psi: pressure stall information for CPU, memory, and
 IO
Date: Mon, 6 Aug 2018 17:25:28 +0200
Message-ID: <20180806152528.GM2494@hirez.programming.kicks-ass.net>
References: <20180801151958.32590-1-hannes@cmpxchg.org>
 <20180801151958.32590-9-hannes@cmpxchg.org>
 <20180803165641.GA2476@hirez.programming.kicks-ass.net>
 <20180806150550.GA9888@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=ZdfO5PyjZXR150UMtqHm4zxkP/3ep6gC1wezPDd7wUw=; b=EgVD2YUcxlgr5gvaAdGPF1a5X
        bq1RrKJESnu+evMyio23d6fvKcFT0SO6xoEgyGCsKr4rDywUNX8yjV/q4LmRK7uSae7sBmRSXrQXV
        l3fN2NdeMNFQytE9bCEq8Q0HOxQeFaLf1OIEZ2l7AHz+Tib3Q3VJnlhXg9Tr/HtdcHJSyWnWINFYS
        VBP/R0BhbG92VEJbBM1IEqfG0ZfTnJb4VG+CoJiF4sgyknKpZz+q2VOOP01wiIqDPHoEez+rS5gHw
        Lz3YBXs60EsDU12AuBJHtyoQG2rsmN6OeOkEsF7RRDYamoq7nnVxqAfPK0AZFofVl16/JKP480l13
    
Content-Disposition: inline
In-Reply-To: <20180806150550.GA9888@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Drake <drake@endlessm.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Mike Galbraith <efault@gmx.de>, Shakeel Butt <shakeelb@google.com>, Peter Enderborg <peter.enderborg@sony.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Mon, Aug 06, 2018 at 11:05:50AM -0400, Johannes Weiner wrote:
> Argh, that's right. This needs an explicit count if we want to access
> it locklessly. And you already said you didn't like that this is the
> only state not derived purely from the task counters, so maybe this is
> the way to go after all.
> 
> How about something like this (untested)?


> +static inline void psi_switch(struct rq *rq, struct task_struct *prev,
> +			      struct task_struct *next)
> +{
> +	if (psi_disabled)
> +		return;
> +
> +	if (unlikely(prev->flags & PF_MEMSTALL))
> +		psi_task_change(prev, rq_clock(rq), TSK_RECLAIMING, 0);
> +	if (unlikely(next->flags & PF_MEMSTALL))
> +		psi_task_change(next, rq_clock(rq), 0, TSK_RECLAIMING);
> +}


Urgh... can't say I really like that.

I would really rather do that scheduler_tick() thing to avoid the remote
update. The tick is a lot less hot than the switch path and esp.
next->flags might be a cold line (prev->flags is typically the same line
as prev->state so we already have that, but I don't think anybody now
looks at next->flags or its line, so that'd be cold load).
