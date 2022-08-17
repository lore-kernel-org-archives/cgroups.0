From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v5 1/3] sched: Use user_cpus_ptr for saving user provided
 cpumask in sched_setaffinity()
Date: Wed, 17 Aug 2022 10:46:28 +0200
Message-ID: <Yvyq5GBtU+XxLSaP@worktop.programming.kicks-ass.net>
References: <20220816192734.67115-1-longman@redhat.com>
 <20220816192734.67115-2-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=CKeCiigKMtOdgr4YLuQq0s6tHiN60WT8O1gsyf1py6Y=; b=OYd1O3mEkB+wAABrc+5g7lt0dm
        S+0AdbaoEm8UtVjwn+dC5BXqtsgv3oynpOR8By0PJCSCNJvzHZ5h940eGMSrNDeKiEukda2HZhArL
        ze3zylI40u7KNiWAI161EbKzjOYT0kuCvfTd2aaVvxaqn91cFB5B9L4+bW7iNVxkAZ6pBlDDJG7I0
        WV2+66RpxVyfHz/+acnMp4WoS0kV8qnsyhZ9vmZ4GQW4Wr4OL+jvPu8pWPu7/h/67pKyamyymVBSq
        zvqfZCQIW6HxCFZQ3/Ma9XqACtBoXlNb43JuULRrCn6X3bXUU+6OTceIBiTR5FJQSz1Wl77gPBJi2
        vtQYWo9Q==;
Content-Disposition: inline
In-Reply-To: <20220816192734.67115-2-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Tue, Aug 16, 2022 at 03:27:32PM -0400, Waiman Long wrote:
> @@ -8079,10 +8056,11 @@ int dl_task_check_affinity(struct task_struct *p, const struct cpumask *mask)
>  #endif
>  
>  static int
> -__sched_setaffinity(struct task_struct *p, const struct cpumask *mask)
> +__sched_setaffinity(struct task_struct *p, const struct cpumask *mask, bool save_mask)
>  {
>  	int retval;
>  	cpumask_var_t cpus_allowed, new_mask;
> +	struct cpumask *user_mask = NULL;
>  
>  	if (!alloc_cpumask_var(&cpus_allowed, GFP_KERNEL))
>  		return -ENOMEM;

Please move that retval down so the variable declarations are properly
ordered again.

> @@ -8098,8 +8076,33 @@ __sched_setaffinity(struct task_struct *p, const struct cpumask *mask)
>  	retval = dl_task_check_affinity(p, new_mask);
>  	if (retval)
>  		goto out_free_new_mask;
> +
> +	/*
> +	 * Save the user requested mask into user_cpus_ptr if save_mask set.
> +	 * pi_lock is used for protecting user_cpus_ptr.
> +	 */
> +	if (save_mask && !p->user_cpus_ptr) {
> +		user_mask = kmalloc(cpumask_size(), GFP_KERNEL);
> +
> +		if (!user_mask) {
> +			retval = -ENOMEM;
> +			goto out_free_new_mask;
> +		}
> +	}
> +	if (save_mask) {
> +		unsigned long flags;
> +
> +		raw_spin_lock_irqsave(&p->pi_lock, flags);
> +		if (!p->user_cpus_ptr) {
> +			p->user_cpus_ptr = user_mask;
> +			user_mask = NULL;
> +		}
> +
> +		cpumask_copy(p->user_cpus_ptr, mask);
> +		raw_spin_unlock_irqrestore(&p->pi_lock, flags);
> +	}

How about:

	if (save_mask) {
		if (!p->user_cpus_ptr) {
			...
		}
		...
	}

?
