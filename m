From: Zhao Lei <zhaolei-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: RE: [PATCH v2 2/2] cpuacct: split usage into user_usage and sys_usage.
Date: Wed, 16 Mar 2016 18:39:52 +0800
Message-ID: <009601d17f70$2cbc07c0$86341740$@cn.fujitsu.com>
References: <cover.1457082730.git.zhaolei@cn.fujitsu.com> <340a5ec9cb4e7f97b3a41f3dc657b9aca4c76f25.1457082730.git.zhaolei@cn.fujitsu.com> <20160310132728.GX6344@twins.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160310132728.GX6344-ndre7Fmf5hadTX5a5knrm8zTDFooKrT+cvkQGrU6aU0@public.gmane.org>
Content-Language: zh-cn
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: 'Peter Zijlstra' <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

Hi, Peter Zijlstra

Thanks for so detailed review.

> -----Original Message-----
> From: Peter Zijlstra [mailto:peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org]
> Sent: Thursday, March 10, 2016 9:27 PM
> To: Zhao Lei <zhaolei-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org;
> mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; Yang Dongsheng
> <yangds.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
> Subject: Re: [PATCH v2 2/2] cpuacct: split usage into user_usage and
> sys_usage.
> 
> On Fri, Mar 04, 2016 at 05:47:06PM +0800, Zhao Lei wrote:
> > +static u64 cpuacct_cpuusage_read(struct cpuacct *ca, int cpu,
> > +				 enum cpuacct_usage_index index)
> >  {
> > +	struct cpuacct_usage *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
> > +	u64 data = 0;
> > +	int i = 0;
> > +
> > +	/*
> > +	 * We allow index == CPUACCT_USAGE_NRUSAGE here to read
> > +	 * the sum of suages.
> > +	 */
> > +	BUG_ON(index > CPUACCT_USAGE_NRUSAGE);
> > +
> > +	if (index == CPUACCT_USAGE_NRUSAGE) {
> > +		raw_spin_lock_irq(&cpu_rq(cpu)->lock);
> > +		for (i = 0; i < CPUACCT_USAGE_NRUSAGE; i++)
> > +			data += cpuusage->usages[i];
> > +		raw_spin_unlock_irq(&cpu_rq(cpu)->lock);
> 
> Why do you unconditionally take the lock here? You really don't need it
> on 64 bit.
> 
Yes, will fix.

> > +
> > +		goto out;
> > +	}
> >
> >  #ifndef CONFIG_64BIT
> >  	/*
> >  	 * Take rq->lock to make 64-bit read safe on 32-bit platforms.
> >  	 */
> >  	raw_spin_lock_irq(&cpu_rq(cpu)->lock);
> > +	data = cpuusage->usages[index];
> >  	raw_spin_unlock_irq(&cpu_rq(cpu)->lock);
> >  #else
> > +	data = cpuusage->usages[index];
> >  #endif
> >
> > +out:
> >  	return data;
> >  }
> >
> > +static void cpuacct_cpuusage_write(struct cpuacct *ca, int cpu,
> > +				   enum cpuacct_usage_index index, u64 val)
> >  {
> > +	struct cpuacct_usage *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
> > +	int i = 0;
> > +
> > +	/*
> > +	 * We allow index == CPUACCT_USAGE_NRUSAGE here to write
> > +	 * val to each index of usages.
> > +	 */
> > +	BUG_ON(index > CPUACCT_USAGE_NRUSAGE);
> > +
> > +	if (index == CPUACCT_USAGE_NRUSAGE) {
> > +		raw_spin_lock_irq(&cpu_rq(cpu)->lock);
> > +		for (i = 0; i < CPUACCT_USAGE_NRUSAGE; i++)
> > +			cpuusage->usages[i] = val;
> > +		raw_spin_unlock_irq(&cpu_rq(cpu)->lock);
> > +
> > +		return;
> > +	}
> 
> Same for the above, and the below is dead code, you only ever call this
> with NRUSAGE.
> 
Good point.

> >  #ifndef CONFIG_64BIT
> >  	/*
> >  	 * Take rq->lock to make 64-bit write safe on 32-bit platforms.
> >  	 */
> >  	raw_spin_lock_irq(&cpu_rq(cpu)->lock);
> > +	cpuusage->usages[index] = val;
> >  	raw_spin_unlock_irq(&cpu_rq(cpu)->lock);
> >  #else
> > +	cpuusage->usages[index] = val;
> >  #endif
> >  }
> >
> 
> > @@ -246,9 +344,15 @@ void cpuacct_charge(struct task_struct *tsk, u64
> cputime)
> >
> >  	ca = task_ca(tsk);
> >
> > +	user_time = user_mode(task_pt_regs(tsk));
> > +
> >  	while (true) {
> > -		u64 *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
> > -		*cpuusage += cputime;
> > +		struct cpuacct_usage *cpuusage = per_cpu_ptr(ca->cpuusage, cpu);
> > +
> > +		if (user_time)
> > +			cpuusage->usages[CPUACCT_USAGE_USER] += cputime;
> > +		else
> > +			cpuusage->usages[CPUACCT_USAGE_SYSTEM] += cputime;
> >
> >  		ca = parent_ca(ca);
> >  		if (!ca)
> 
> Have you tried to measure the performance impact of this?
> 
> Also, that code seems particularly silly for not using this_cpu_ptr().
> After all, we only ever call this on current.
> 
> Also that ca iteration looks daft, should we fix that to read:
> 
> 	for (ca = task_ca(tsk); ca; ca = parent_ca(ca))
I'll rewrite this code block.

Thanks
Zhaolei



