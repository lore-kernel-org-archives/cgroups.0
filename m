From: Vincent Donnefort <vincent.donnefort@arm.com>
Subject: Re: [RFC PATCH 5/6] sched/isolation: Make HK_FLAG_DOMAIN mutable
Date: Wed, 21 Jul 2021 15:28:45 +0100
Message-ID: <20210721142726.GA206211@e120877-lin.cambridge.arm.com>
References: <20210714135420.69624-1-frederic@kernel.org>
 <20210714135420.69624-6-frederic@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20210714135420.69624-6-frederic@kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Frederic Weisbecker <frederic@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Alex Belits <abelits@marvell.com>, Nitesh Lal <nilal@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Nicolas Saenz <nsaenzju@redhat.com>, Christoph Lameter <cl@gentwo.de>, Marcelo Tosatti <mtosatti@redhat.com>, Zefan Li <lizefan.x@bytedance.com>, cgroups@vger.kernel.org

Hi Frederic,

[...]

>  
> +// Only support HK_FLAG_DOMAIN for now
> +// TODO: propagate the changes through all interested subsystems:
> +// workqueues, net, pci; ...
> +void housekeeping_cpumask_set(struct cpumask *mask, enum hk_flags flags)
> +{
> +	/* Only HK_FLAG_DOMAIN change supported for now */
> +	if (WARN_ON_ONCE(flags != HK_FLAG_DOMAIN))
> +		return;
>  
> +	if (!static_key_enabled(&housekeeping_overridden.key)) {
> +		if (cpumask_equal(mask, cpu_possible_mask))
> +			return;
> +		if (WARN_ON_ONCE(!alloc_cpumask_var(&hk_domain_mask, GFP_KERNEL)))
> +			return;
> +		cpumask_copy(hk_domain_mask, mask);
> +		static_branch_enable(&housekeeping_overridden);

I get a warning here. static_branch_enable() is trying to take cpus_read_lock().
But the same lock is already taken by cpuset_write_u64().

Also, shouldn't it set HK_FLAG_DOMAIN in housekeeping_flags to enable
housekeeping if the kernel started without isolcpus="" ?

-- 
Vincent
