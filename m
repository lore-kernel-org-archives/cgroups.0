From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RESEND PATCH RFC] cgroup: support numabalancing disable in
 cgroup level
Date: Mon, 13 Dec 2021 09:23:49 -1000
Message-ID: <YbedxU6tBfEiOWkC@slm.duckdns.org>
References: <20211213150506.61780-1-wanghonglei@didichuxing.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OYwOYi+vHNjHufw03EAiBDrxI3hclHuJAr4CB/iB7rw=;
        b=R7Xj2R5KQ4GN+oqiU5wpFKhFFh6TRybzWFHY50ahw05kOWtmuBqrTJ9vXIFLImgbg0
         cEXuWQZ5p4N0v/FOuszokHpKwbqWKdR6qoGoLH/SthoMJzo2grwIsAe20tedR+JYfImt
         z+R/3pfF2T9mW53rFpYAMbeyzSWvSqJKKcSaqLX+2DIoBgyKBLr7BZPys0rHY+WsfDn4
         sRKw5hLgOraRGVsqBQy5UCBssMw4XpUTsJe9bX00XAQFXX7HdUoS5xmtt9KmiouMC8de
         XRugChP5mR6tp2QioW9QnbuHghFsrl5MjL3V/DQA47QzsFl8FBBkNb8EOlevXpAkC+du
         P2rg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20211213150506.61780-1-wanghonglei-j11cvHKnkmPwvR0lvYjcXw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Honglei Wang <wanghonglei-j11cvHKnkmPwvR0lvYjcXw@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jameshongleiwang-KN7UnAbNpbg@public.gmane.org

Hello,

On Mon, Dec 13, 2021 at 11:05:06PM +0800, Honglei Wang wrote:
> +#ifdef CONFIG_NUMA_BALANCING
> +static void __cgroup_numabalancing_disable_set(struct cgroup *cgrp, bool nb_disable)
> +{
> +	struct css_task_iter it;
> +	struct task_struct *task;
> +
> +	lockdep_assert_held(&cgroup_mutex);
> +
> +	spin_lock_irq(&css_set_lock);
> +	if (nb_disable)
> +		set_bit(CGRP_NUMABALANCING_DISABLE, &cgrp->flags);
> +	else
> +		clear_bit(CGRP_NUMABALANCING_DISABLE, &cgrp->flags);
> +	spin_unlock_irq(&css_set_lock);
> +
> +	css_task_iter_start(&cgrp->self, 0, &it);
> +	while ((task = css_task_iter_next(&it))) {
> +		/*
> +		 * We don't care about NUMA placement if the task is exiting.
> +		 * And we don't NUMA balance for kthreads.
> +		 */
> +		if (task->flags & (PF_EXITING | PF_KTHREAD))
> +			continue;
> +		task->numa_cgrp_disable = nb_disable;
> +	}
> +	css_task_iter_end(&it);
> +}

All it's doing is setting some property recursively and I don't think it
makes sense to keep expanding cgroup interface for this sort of usage. It's
not distributing any resource in hierarchical way and the whole feature can
be replaced by inheritable per-process interface with some scripting. Unless
there are some other compelling reasons, this is gonna be a strong nack from
cgroup side.

Thanks.

-- 
tejun
