Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793876399;
	b=eR47NoWXDsd5IoSVT7tGlQoNHifMDvFeWF3dlBuc/fZ8D+mIR8qAfFkybwcmpZ9ZHx4f
	 mvxqrH6owVZsxQ7FLX5tIsU98huZ/f3UWGpJycwyPkCo1ZqbSkJV/v3uB4kvfm6TBm37U
	 v3XZjsHIehT6GlFcVOp96mt8QeGWFSyThfNQ7LBg441qk/yse1UZoscZ+KWUlFpPmPif7
	 lAipBcjzmpIimpAzviOwe6NAo7/9H79Mqsr062uOS7T8T4bgdAwCNA5HQukqj520kR3Kn
	 cy7pNeFVNtoR5YryYY7dfOQy5SQ8Ur445QI8+Miqq6R41CAVlmknwZnS9gzPx89HM4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793876399;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 X-Received:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=Oek9BHm9kE/i/pAixALrJCjyIzhOnrADlEzuRw14Asc=;
	b=oAvPA0arqolE+IkWp27MR49xzjiOgEg1TZpj2bdBIomqVdL9oJgO7XGZwlfIMFgF3GaT
	 f8w+ZgWv/01M+nmrPuKFjV6Ipbun6lliLWnohv4ZSJQbXYS/Z7mO8s2MMQFx/GflOIJhH
	 0VqrLQU/+wAp2B5TvgS1bHRbJQNchKEz4gHZ2rpe+xf+Jy/1FMXMohBoRzYZEI7MiLC/h
	 ZVCM/zKrd3U/iEhydw5bEhGryFrjCSIf56xkL8aU6PEtQBb5bIuzPyMp60lft8rGiL1Go
	 p/srlacK2P2oxSVMhqobWzFkMKCXArhEOp06rUu+2Y8FsdhUHx7jD87Ouk4Hnd6ZIFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=cekl2FdR;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=gZiczuIE;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6471E606D82E
	for <cgroups@vger.kernel.org>; Thu,  5 Nov 2026 10:59:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6471E606D82E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=cekl2FdR;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=gZiczuIE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1793876397;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Oek9BHm9kE/i/pAixALrJCjyIzhOnrADlEzuRw14Asc=;
	b=cekl2FdRYSxDVWLaO2b5rc50UWb6AchPKYdj2MEADONAaBAUywzaUJe4b+XQ3ahnO2gfjO
	z7A1UwQC8qsZPnykQfOhs24VPtHeg3p7E+MtQ2nv8NKyohBJG1ol1CSCuCcXwyxQ+q0lsf
	EwM8RTrCjVTARyYfV9zP6xxEL4TqWKc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-517-sjSYZdnHPCKrtiENChRw3Q-1; Thu, 05 Nov 2026 05:59:56 -0500
X-MC-Unique: sjSYZdnHPCKrtiENChRw3Q-1
X-Mimecast-MFC-AGG-ID: sjSYZdnHPCKrtiENChRw3Q_1793876395
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-490ed502749so754317f8f.2
        for <cgroups@vger.kernel.org>; Thu, 05 Nov 2026 02:59:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1793876395; x=1794481195; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Oek9BHm9kE/i/pAixALrJCjyIzhOnrADlEzuRw14Asc=;
        b=gZiczuIEW2yUUWdrcRC4doXHKTnqUbq4594ohoQ04aWzVwkVJJFmci0C9jmcUwoSzt
         PFyhfph+AzZlOOIn+OK5F9E5EbiT5hy0BsH5HX9EjSttOscmpMOt91rbv9mkyXyX0ADG
         u9DXBqqsjZ9i9SNGWUIiFTgH0j/uG9lbB9sl2ARY4TkTmOyEAyW8mWQ2m4UB8KpZZ0aJ
         rJUDHf6zC3gx9B0F5qqRtfcbPXo73n8tzCGmQPWedtPuKMcnIJfQECdTRfw7bwErTyPM
         2hy/x0etXMhY6dGYipNB6J042Dv36ssXVIJCr92EulQJOiXW67Dc9I+naEJyA5HStQ3M
         lkow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793876395; x=1794481195;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Oek9BHm9kE/i/pAixALrJCjyIzhOnrADlEzuRw14Asc=;
        b=NU4TNzN/5Yt6hEBWx+c5SPvFuXvYvyqOFUJvLAz1Y15qzPDfZURIqbIBC65c967ixj
         Qac0T63wmPItDffDjCaVOp54K183p6Umaoif3KxbuKvD/IuqJkvCmSo5N2lBH0XiT9r0
         OS+o//K74p5MXwZt9oxP4s8gmbWu6ryiaFcLUAptavJeaihHDLCAi3UsSfbBX64Ok+Hc
         fO59lYwxWqHOYV5KkhgtXamO0H/9u+zQOd99oYeJCngDsaMcg1rs2FTfYQFQZPvtDqFO
         XX4ymbYzfGJuHd4ZC6/F4V6uppiRk2Alvp45wi3f5yupliNGytmfI9xoOyYqKBzmwErk
         KBgg==
X-Forwarded-Encrypted: i=1; AKwUvBxVCrRBPMeTm5V7kbXSUjObd3LbRVq0TLQbHjZHekau1RjCeWJAXF8k6TccEO5w+XFtYcDSDiX2@vger.kernel.org
X-Gm-Message-State: APuU4Z/mhaSjFxcnBR88neW0/Ogl9DsOVz1CeUfOi7ZjYDE9BaZzOcs6
	gLDAPxK8hTM1tb0BmgfRMh0z+8SZa9CniXuFuSyP+m98k+NXaefIs89LRK1nGz5HO2nDAmRYmbg
	HiSHta7p77b8k7kNDGAOpulyADvg4XzVCerpGTKC1vRTxalSqhbCAevzCFdY=
X-Gm-Gg: AYBFou3UaiCyFTdS2SSjfLz1HYXgbUWM/59YaF6owOUfoiRrNRH3Uo24Nkkyggt+cVO
	9aTKK7nLP07dNphEA6qsrxQzHtdE39DomKnROrjo9fbGHj1GCJ5UiaF4yVQbL1izxaMAwnHyZf4
	Vdj5A5XH6pdzFW6nRhaUKjC/K+kvWQ0JT7hawp86J4mRvhzRlTpHIQaZm9CYpYrXUYZp/44iSY5
	cKOemm9nO6SSc6pRYvSCcdwQLu4hGfXek/eZAvI5to8Q7avTxr+M/4dkEAzE73vH+EElbjEq1GI
	8lAbiuvwR/qrkaRi583zbei36cHffXdrOdZ4h+KIb8BSCeJRNXndUfTCAMOcmbdmyytqqRzEvXU
	lCwMUnd5OEmenDrbRyQDxdI4STRnd7i1OSFIcDPN9RxQ94dvzLH+AdscNrH4hHPgJBdoBMW527Y
	fq8Q==
X-Received: by 2002:a05:6000:1acb:b0:48b:a7:6396 with SMTP id ffacd0b85a97d-48e6e4f56dbmr39400074f8f.41.1793876395118;
        Thu, 05 Nov 2026 02:59:55 -0800 (PST)
X-Received: by 2002:a05:6000:1acb:b0:48b:a7:6396 with SMTP id ffacd0b85a97d-48e6e4f56dbmr39400028f8f.41.1793876394719;
        Thu, 05 Nov 2026 02:59:54 -0800 (PST)
Received: from jlelli-thinkpadt14gen4.remote.csb ([151.29.158.90])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48fed5521c7sm9157524f8f.39.2026.11.05.02.59.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 02:59:54 -0800 (PST)
Date: Thu, 5 Nov 2026 11:59:51 +0100
From: Juri Lelli <juri.lelli@redhat.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	linux-kernel@vger.kernel.org,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Luca Abeni <luca.abeni@santannapisa.it>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Waiman Long <longman@redhat.com>,
	Ridong Chen <ridong.chen@linux.dev>, Tejun Heo <tj@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Shuah Khan <shuah@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>, cgroups@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v2 05/21] sched/deadline: Do not BUG() on a deadline task
 with no active CPU allowed
Message-ID: <auxhp05Xmz9LYOo-@jlelli-thinkpadt14gen4.remote.csb>
References: <20261104211207.1392343-1-mathieu.desnoyers@efficios.com>
 <20261104211207.1392343-6-mathieu.desnoyers@efficios.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261104211207.1392343-6-mathieu.desnoyers@efficios.com>

Hello,

On 04/11/26 16:11, Mathieu Desnoyers wrote:
> dl_task_root_domain_cpu() finds the root domain that holds a deadline
> task's bandwidth from the first active CPU of the task's mask, and
> BUG()s when the mask has none. A mask can have none:
> 
>  - a task boosted into the deadline class by priority inheritance keeps
>    the affinity of its own policy, which may allow one CPU alone, or a
>    cpuset of one. dl_task_needs_bw_move() and set_cpus_allowed_dl()
>    take it for a deadline task, dl_task(p) being true, and look the root
>    domain up from the mask they are replacing, which allows that CPU,
>    inactive by then: the cpuset code updates the masks of a cpuset's
>    tasks once the CPU is inactive, and select_fallback_rq() widens the
>    mask of a task it pushes off that CPU;
>  - with admission control off (sched_rt_runtime_us at -1), a deadline
>    task may be pinned to fewer CPUs than its root domain spans, and
>    those may all go offline.
> 
> Both take the kernel down on the first try, in 8-CPU VMs of v7.4-rc1
> with the four deadline fixes of sched/urgent. The priority inheritance
            ^^^
Not sure how much sense will this info make when reading this changelog
in the future. :)

> one, which asks for no unusual configuration, through the wakeup of the
> boosted owner:
> 
>   kernel BUG at kernel/sched/deadline.c:3340!
>   CPU: 7 UID: 0 PID: 0 Comm: swapper/7
>   RIP: 0010:set_cpus_allowed_dl+0xf0/0x100
>   Call Trace:
>    <IRQ>
>    set_cpus_allowed_force+0x9f/0xf0
>    cpuset_cpus_allowed_fallback+0x12b/0x1d0
>    select_fallback_rq+0x238/0x340
>    try_to_wake_up+0x2a0/0xb70
> 
> Fall back to the CPU the task last ran on, which these callers used
> before the commit this one fixes. Its root domain may have no active CPU
> left: the previous patch has __dl_sub() and __dl_add() take that. Ten
> rounds of each case leave no warning with it.
> 
> Fixes: b4a61fdc19c5 ("sched/deadline: Fix stale root domain in cpuset bandwidth transfer")
> Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> ---
>  kernel/sched/deadline.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
> index dadda1a528ec..30a52e42c26d 100644
> --- a/kernel/sched/deadline.c
> +++ b/kernel/sched/deadline.c
> @@ -3338,13 +3338,19 @@ static void task_woken_dl(struct rq *rq, struct task_struct *p)
>   * current cpus_mask (not yet updated to the new mask) to find the
>   * actual root domain. Use cpus_mask rather than cpus_ptr, which
>   * may be temporarily narrowed by migrate_disable().
> + *
> + * The mask has no active CPU left when the CPUs it allows went offline,
> + * which the affinity of a deadline task allows with admission control
> + * off, and that of a task boosted into the deadline class by priority
> + * inheritance always: fall back to the CPU the task last ran on.
>   */
>  static unsigned int dl_task_root_domain_cpu(struct task_struct *p)
>  {
>  	unsigned int cpu;
>  
>  	cpu = cpumask_first_and(&p->cpus_mask, cpu_active_mask);
> -	BUG_ON(cpu >= nr_cpu_ids);
> +	if (cpu >= nr_cpu_ids)
> +		cpu = task_cpu(p);
>  	return cpu;
>  }

At least (worst case) we fall back to how things were before my change
introduced the regression.

Acked-by: Juri Lelli <juri.lelli@redhat.com>

Thanks,
Juri

