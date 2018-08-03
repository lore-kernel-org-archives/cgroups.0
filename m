From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 8/9] psi: pressure stall information for CPU, memory, and
 IO
Date: Fri, 3 Aug 2018 19:07:33 +0200
Message-ID: <20180803170733.GC2494@hirez.programming.kicks-ass.net>
References: <20180801151958.32590-1-hannes@cmpxchg.org>
 <20180801151958.32590-9-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=5szedLwDdh86mfXSaF1CUenBlLCBHTbq16JXDwCdXgM=; b=rPUzNrvviOfJj4rJWXZG62SRr
        ZA1XxmAH2aFsOgae2LLaWGe3xyNu6a+yTRm1AKeO96b09fHdfTZP6x9dQGUtPk4h0Y+mCr5n47VL+
        yT38RhAxlL8QQKNU6uX7OUGBpC4CFNEE/mhOWYLZlm1dEH3fS+5idtAF9VVMjtnOwHDuLe+NBGdsz
        JU3o7OIzEKPMe+99qPcimd98GXecyjUAj+dsRt94+eA4jmsX+cDTSSYenrF4fDXCooCHpC4IzW2Hy
        lXrb4Euqj1Q+omTfS6yyvwK0QMbikZ6jiQ63fE/Af/utB8uStbxStc+6NxGdrQ8BPUDnk59SuVn+d
      
Content-Disposition: inline
In-Reply-To: <20180801151958.32590-9-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Drake <drake@endlessm.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Mike Galbraith <efault@gmx.de>, Shakeel Butt <shakeelb@google.com>, Peter Enderborg <peter.enderborg@sony.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Wed, Aug 01, 2018 at 11:19:57AM -0400, Johannes Weiner wrote:
> +static bool psi_update_stats(struct psi_group *group)
> +{
> +	u64 deltas[NR_PSI_STATES - 1] = { 0, };
> +	unsigned long missed_periods = 0;
> +	unsigned long nonidle_total = 0;
> +	u64 now, expires, period;
> +	int cpu;
> +	int s;
> +
> +	mutex_lock(&group->stat_lock);
> +
> +	/*
> +	 * Collect the per-cpu time buckets and average them into a
> +	 * single time sample that is normalized to wallclock time.
> +	 *
> +	 * For averaging, each CPU is weighted by its non-idle time in
> +	 * the sampling period. This eliminates artifacts from uneven
> +	 * loading, or even entirely idle CPUs.
> +	 *
> +	 * We don't need to synchronize against CPU hotplugging. If we
> +	 * see a CPU that's online and has samples, we incorporate it.
> +	 */
> +	for_each_online_cpu(cpu) {

I'm still puzzled by this.. for 99% of the machines online == possible.
Why not always iterate possible and leave it at that? This is hardly a
fast path.

