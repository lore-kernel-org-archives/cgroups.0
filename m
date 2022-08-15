From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v3 2/3] sched: Provide copy_user_cpus_mask() to copy out
 user mask
Date: Mon, 15 Aug 2022 10:58:51 +0200
Message-ID: <YvoKy6OdJIkNXbtq@worktop.programming.kicks-ass.net>
References: <20220812203929.364341-1-longman@redhat.com>
 <20220812203929.364341-3-longman@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=X1Kk26FPg2jYHPvOS2s86o6tg2NoWayeOGSNjQIPE58=; b=rrsHTcvocEIu0njvXEnAoUncHw
        AS8nABWuqLfAfD9VJMaEUGdsPEJ6kYvuCMWpfsWtcOVdcgS0yDq2so/auNex1lo3b1l6EBiz2H7h5
        NRkFPzXHaXQvqlbKU5ttS02AFmeez9M8vGC1NNAV0wFw0S4T3yJdCPkBjDsW2KQfslXbjE/NEqssj
        f9cq4h6K4C70MeFyHRLsAX+QmnXpXTHZi7RP1qjvmoqokKDoIZbCmo/IK3DvgtjQ0IK5zuO60R3rS
        7U9oklNwG/wZSAIno6+HiHbYyQZ1M8VkmMjRq/p84b3nPW99Z97XtmaKhTucauSBDxImFJUpG0LrD
        VM5HOJpA==;
Content-Disposition: inline
In-Reply-To: <20220812203929.364341-3-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Valentin Schneider <vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Fri, Aug 12, 2022 at 04:39:28PM -0400, Waiman Long wrote:
> Since accessing the content of the user_cpus_ptr requires lock protection
> to ensure its validity, provide a helper function copy_user_cpus_mask()
> to facilitate its reading.

Sure, but this is atrocious.

> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -2619,6 +2619,24 @@ void release_user_cpus_ptr(struct task_struct *p)
>  	kfree(clear_user_cpus_ptr(p));
>  }
>  
> +/*
> + * Return the copied mask pointer or NULL if user mask not available.
> + */
> +struct cpumask *copy_user_cpus_mask(struct task_struct *p,
> +				    struct cpumask *user_mask)
> +{
> +	struct rq_flags rf;
> +	struct rq *rq = task_rq_lock(p, &rf);
> +	struct cpumask *mask = NULL;
> +
> +	if (p->user_cpus_ptr) {
> +		cpumask_copy(user_mask, p->user_cpus_ptr);
> +		mask = user_mask;
> +	}
> +	task_rq_unlock(rq, p, &rf);
> +	return mask;
> +}

For reading the mask you only need one of those locks, and I would
suggest p->pi_lock is much less contended than rq->lock.
