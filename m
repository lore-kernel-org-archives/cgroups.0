From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 8/9] psi: pressure stall information for CPU, memory, and
 IO
Date: Fri, 7 Sep 2018 12:24:58 +0200
Message-ID: <20180907102458.GP24106@hirez.programming.kicks-ass.net>
References: <20180828172258.3185-1-hannes@cmpxchg.org>
 <20180828172258.3185-9-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=B+dRi740mod0o9eX5oP25W/39hKnSCs5AlkFv7wdLzE=; b=LzRt3K/BCZhQ62ztfj5+Vuwzb
        1Wrcml2mW7uBnYKGj5V5s5xKbcv1VCEn8RG961+8Ly+wcTXcPgGcA9C3RB1jdthOjo27bO9TcBQ6B
        3ljyLbGR9O8e2PewO8nbTmHxph5auSHS5w8ZZPui1rT5wSXfB5K+yczMkgMHsbzEmA2bLZlS6Vhy+
        tJo9euLKQQsjKM5SoGYF8G0O916XE0j56/4JXQ13AmSeZ4KW6ehApLcpPpcKuJCL99X4l6r1E6W69
        dyDZSDqBkcTdcX2FG2DZkzrzOdHCysYo3xZEI2bkNNTE4Dp+HFIVk0ba1ih+uf4FntCsdVEVyVcGy
    
Content-Disposition: inline
In-Reply-To: <20180828172258.3185-9-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Ingo Molnar <mingo@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Daniel Drake <drake@endlessm.com>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Peter Enderborg <peter.enderborg@sony.com>, Shakeel Butt <shakeelb@google.com>, Mike Galbraith <efault@gmx.de>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Tue, Aug 28, 2018 at 01:22:57PM -0400, Johannes Weiner wrote:
> +static void psi_clock(struct work_struct *work)
> +{
> +	struct delayed_work *dwork;
> +	struct psi_group *group;
> +	bool nonidle;
> +
> +	dwork = to_delayed_work(work);
> +	group = container_of(dwork, struct psi_group, clock_work);
> +
> +	/*
> +	 * If there is task activity, periodically fold the per-cpu
> +	 * times and feed samples into the running averages. If things
> +	 * are idle and there is no data to process, stop the clock.
> +	 * Once restarted, we'll catch up the running averages in one
> +	 * go - see calc_avgs() and missed_periods.
> +	 */
> +
> +	nonidle = update_stats(group);
> +
> +	if (nonidle) {
> +		unsigned long delay = 0;
> +		u64 now;
> +
> +		now = sched_clock();
> +		if (group->next_update > now)
> +			delay = nsecs_to_jiffies(group->next_update - now) + 1;
> +		schedule_delayed_work(dwork, delay);
> +	}
> +}

Just a little nit; I would expect a function called *clock() to return a
time.
