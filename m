From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 08/10] psi: pressure stall information for CPU, memory,
 and IO
Date: Fri, 13 Jul 2018 11:21:53 +0200
Message-ID: <20180713092153.GU2494@hirez.programming.kicks-ass.net>
References: <20180712172942.10094-1-hannes@cmpxchg.org>
 <20180712172942.10094-9-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=2C5DiRxAKxunCQKYIQkx/Rgm0QgITk3DrBrhZP1/ja8=; b=2U9ep7vv5RmMFKsZ2dM9pT5Ti
        i8BxciHGxf+cWk+2GI5cZIN/g3ffUAmsyhMaiowS1NJP5D9UUkxUyC40tF1D230UEwSxL6aAfXiPf
        /tPAdkbI03Dn6Sdb1F+jw2PKIr9924iAdCfCU+KF8C7A7EO1rfH/JWEVeYju5pejy382JYX6VSD+y
        jYeBb9Bdi6vAjDkUNAVQpAJaDAWbSEO3iVlF309N7fiG0ZMZhknfwoGPGIPardBsdJ9Spl9FHcesO
        CpQjdwhQwqtv5tUGARrG47f1uvrQYycJbOMqj8phfm9u26VKoaj4VX3Z3b9F9rsKdPVKLTYYsWS17
      
Content-Disposition: inline
In-Reply-To: <20180712172942.10094-9-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Mike Galbraith <efault@gmx.de>, Shakeel Butt <shakeelb@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Thu, Jul 12, 2018 at 01:29:40PM -0400, Johannes Weiner wrote:
> +static inline void psi_ttwu_dequeue(struct task_struct *p)
> +{
> +	if (psi_disabled)
> +		return;
> +	/*
> +	 * Is the task being migrated during a wakeup? Make sure to
> +	 * deregister its sleep-persistent psi states from the old
> +	 * queue, and let psi_enqueue() know it has to requeue.
> +	 */
> +	if (unlikely(p->in_iowait || (p->flags & PF_MEMSTALL))) {
> +		struct rq_flags rf;
> +		struct rq *rq;
> +		int clear = 0;
> +
> +		if (p->in_iowait)
> +			clear |= TSK_IOWAIT;
> +		if (p->flags & PF_MEMSTALL)
> +			clear |= TSK_MEMSTALL;
> +
> +		rq = __task_rq_lock(p, &rf);
> +		update_rq_clock(rq);
> +		psi_task_change(p, rq_clock(rq), clear, 0);
> +		p->sched_psi_wake_requeue = 1;
> +		__task_rq_unlock(rq, &rf);
> +	}
> +}

Still NAK, what happened to this here:

  https://lkml.kernel.org/r/20180514083353.GN12217@hirez.programming.kicks-ass.net

