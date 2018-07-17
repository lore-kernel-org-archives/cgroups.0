From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RFC PATCH 10/10] psi: aggregate ongoing stall events when
 somebody reads pressure
Date: Tue, 17 Jul 2018 17:13:36 +0200
Message-ID: <20180717151336.GZ2476@hirez.programming.kicks-ass.net>
References: <20180712172942.10094-1-hannes@cmpxchg.org>
 <20180712172942.10094-11-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=t9ZAv4duUj3psYRV4CqKfV+SpMBL8ia1fEdGq4TRoS8=; b=NmCwbxcsh22vR+PAy9YlSa8ft
        V3EfCNxX/qzkaKCsr8QuGOnIvbdsH0DfZT3nOx+Ud3TFjZdoV4U2ka/Q7B6b8LEZOi+JLS/c4TKPI
        ARp/6Ij6FVegHxhEFsEAgTlnyWZhzAnq5r84MIcvbzNzGfdIluTtVQmL4Va1+msoEr40vR5l3AXnt
        jW7G9D8yifj1EmelmNq/jBoBC75SQaAItono+vtEzxaMnEM2eu3KSetWE25nCOQoj6gw5kbze7OF9
        E4PEkGWQi2HzajvQJEvG0fXbBn4TeGWcdshJLhLaVUpPHccYoqzLFd6n8wFU0GZxZY48GqH59HsIW
      
Content-Disposition: inline
In-Reply-To: <20180712172942.10094-11-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Mike Galbraith <efault@gmx.de>, Shakeel Butt <shakeelb@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Thu, Jul 12, 2018 at 01:29:42PM -0400, Johannes Weiner wrote:
> @@ -218,10 +216,36 @@ static bool psi_update_stats(struct psi_group *group)
>  	for_each_online_cpu(cpu) {
>  		struct psi_group_cpu *groupc = per_cpu_ptr(group->cpus, cpu);
>  		unsigned long nonidle;
> +		struct rq_flags rf;
> +		struct rq *rq;
> +		u64 now;
>  
> -		if (!groupc->nonidle_time)
> +		if (!groupc->nonidle_time && !groupc->nonidle)
>  			continue;
>  
> +		/*
> +		 * We come here for two things: 1) periodic per-cpu
> +		 * bucket flushing and averaging and 2) when the user
> +		 * wants to read a pressure file. For flushing and
> +		 * averaging, which is relatively infrequent, we can
> +		 * be lazy and tolerate some raciness with concurrent
> +		 * updates to the per-cpu counters. However, if a user
> +		 * polls the pressure state, we want to give them the
> +		 * most uptodate information we have, including any
> +		 * currently active state which hasn't been timed yet,
> +		 * because in case of an iowait or a reclaim run, that
> +		 * can be significant.
> +		 */
> +		if (ondemand) {
> +			rq = cpu_rq(cpu);
> +			rq_lock_irq(rq, &rf);

That's a DoS right there..
