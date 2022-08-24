From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v3 07/10] sched/psi: add PSI_IRQ to track IRQ/SOFTIRQ
 pressure
Date: Wed, 24 Aug 2022 06:46:02 -0400
Message-ID: <YwYBasgyIU0iQgL3@cmpxchg.org>
References: <20220824081829.33748-1-zhouchengming@bytedance.com>
 <20220824081829.33748-8-zhouchengming@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=Aj++Fk/W1JhvrURKcMUAUKoprlyW7CHD6tgqm6w3ip8=;
        b=6Iyv3/J5KocnAeNqHO+9drc0u5aILR13sqA6Kvkg5zjYCKXLwJp7Cu69hxIFDTViq+
         HZYQlApQOCAUdvrC9loeA0eKBfIGGnditmSzzpOZ90vXY1TuDg3lsp31JoFuqP0/wSxU
         XSX4NHtEDrxhXz5fAmvszL3QwtVPl4/KNvLyXFAGbl+mLr5I/5wj2uzT7zmP6iMEYfIJ
         9vo0CLZE+RH2KthBtZt8o0SxWYfNCTmfSjT2pcY6uS8qAGOOCRMdyXDM/SlcpnzLMib+
         au4RGN94O395cioi2TT229XLk3Lnw/U/OjFCbsyXY5/YzL0Dm8dJTgMarbwsOWWBdf1o
         S4BA==
Content-Disposition: inline
In-Reply-To: <20220824081829.33748-8-zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Aug 24, 2022 at 04:18:26PM +0800, Chengming Zhou wrote:
> @@ -903,6 +903,36 @@ void psi_task_switch(struct task_struct *prev, struct task_struct *next,
>  	}
>  }
>  
> +#ifdef CONFIG_IRQ_TIME_ACCOUNTING
> +void psi_account_irqtime(struct task_struct *task, u32 delta)
> +{
> +	int cpu = task_cpu(task);
> +	void *iter = NULL;
> +	struct psi_group *group;
> +	struct psi_group_cpu *groupc;
> +	u64 now;
> +
> +	if (!task->pid)
> +		return;
> +
> +	now = cpu_clock(cpu);
> +
> +	while ((group = iterate_groups(task, &iter))) {
> +		groupc = per_cpu_ptr(group->pcpu, cpu);
> +
> +		write_seqcount_begin(&groupc->seq);
> +
> +		record_times(groupc, now);
> +		groupc->times[PSI_IRQ_FULL] += delta;
> +
> +		write_seqcount_end(&groupc->seq);
> +
> +		if (group->poll_states & (1 << PSI_IRQ_FULL))
> +			psi_schedule_poll_work(group, 1);
> +	}

Shouldn't this kick avgs_work too? If the CPU is otherwise idle,
times[PSI_IRQ_FULL] would overflow after two missed averaging runs.

avgs_work should probably also self-perpetuate when PSI_IRQ_FULL is in
changed_states. (Looking at that code, I think it can be simplified:
delete nonidle and do `if (changed_states) schedule_delayed_work()`.)
