Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795489795;
	b=LrnSW3ODgkl1t/LTjEsH9cG+3JtJBGHxiFbeRtwZ60/jZ3PVbMWnkdhO4km0DWrfgbld
	 i0VI5E4WGRSmdB9qeDFoVhT2RisNP+rlJWXqOgngNi0eihg/IMH8Da17No5u0PbTofizl
	 umDJUN+3ECbDprfxuiylwBSOupcl0IvcfFrLzBjGGOi6F+1RGe5UJ39QD8El/y31lZ8Jz
	 AgPdd8mLP5BFOz763PrBIhHVCVceSBMaKmowCRafmjozsGu2oFT+7QwhASXuEoh11FG9X
	 50yucJPr5ypbaAXxmy0Ksqho73Db/rPAIfxrHqtj5a/VOvv8oGQYEtWfayygXGwkzwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795489795;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=LeVH1Wb7I2cz1kvArxz3Yqt1F/X3e5c7jawrva0ZrZ0=;
	b=Z8xbgBmuE0ccpexCFqWCMyhc7v/QvVdC6E9bPNY2cXvu0XnsuJUzzNsoPMWuA1QS+zJ9
	 jdPKkma3C1ynaTOK2wpvWtX07z+QnZF2sDdFvsx9Q6qOCkH1Fvr2JwW+tVGmqwdi1fj2V
	 6h5qgpSIgMlXnZ/nVZqprLPMEJ0EcZdOnSMAbL3mMviCfShmtItZfWN6hbLYghOxAIpTu
	 Np5xFEoqoFZ7CZiMdhIAM/av1da7Az29sKVYCGEPmR1kd24o62vw0eJNF2dq+tJ0mOBpG
	 LMS5kepceEQKX2mzAx+1kRH+ForjsAMf4PSt/6j4uGPlTdTsyPxB6dkm6oLS/zG7TZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=piESi2If;
	arc=none smtp.remote-ip=95.215.58.12
Received: from mta1.migadu.com (out-12.mta1.migadu.com [95.215.58.12])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF5F606A321
	for <cgroups@vger.kernel.org>; Tue, 24 Nov 2026 03:09:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6EF5F606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=piESi2If
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=OgGjLcQqQkF/sMaNd876V9rWHHm4sRIP4rYDo2hI4Zw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795489792; v=1; x=1796094592;
 b=piESi2IfxfWUbEXHDYg5846LTjpUQxvAF5h+6RANrJRN4BvjlTiP4ePP4NbIQN3J7v+EnWEQ
 de7/u54/6QeKbG15VJGCwQhOcgPGKGdN0XR8lr97XjBX7pa2oAsvfyO0wMIi5Ljlet0YwpacuIY
 EPc3vp3X+sHINKDQ+TA2C+dQ=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 72f020aafd17f071;
	Tue, 24 Nov 2026 03:09:52 +0000
X-Mizu-Trace-ID: 72f020aafd17f071
X-Migadu-Flow: FLOW_OUT
Message-ID: <ed325697-76b3-4859-906c-8755532bb54c@linux.dev>
Date: Tue, 24 Nov 2026 11:09:43 +0800
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH-next v2 2/3] sched/isolation: Forbid the boot CPU from
 being domain isolated
To: Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
 Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, Ridong Chen <ridong.chen@linux.dev>,
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 K Prateek Nayak <kprateek.nayak@amd.com>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>,
 Frederic Weisbecker <frederic@kernel.org>, Thomas Gleixner <tglx@kernel.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
References: <20261123041209.382726-1-longman@redhat.com>
 <20261123041209.382726-3-longman@redhat.com>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <20261123041209.382726-3-longman@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/11/23 12:12, Waiman Long 写道:
> It is reported that with CONFIG_CPUSETS=n, a kernel booted with
> isolcpus=domain,0 hits the BUG() in select_fallback_rq() during boot
> [1]. At boot time, cpu 0 is the only CPU online and an unbound kworker
> cannot be run on a domain isolated CPU causing kernel panic.
> 
> Sashiko also reports that domain isolating the boot CPU can break system
> suspend and trigger a BUG_ON() [2]. So it is problematic if the boot CPU
> is domain isolated.
> 
> There may be other kernel subsystems that have problem if the boot CPU
> is domain isolated as most of them won't take into account the fact that
> boot CPU is currently allowed to be domain isolated. Given the fact
> that the boot CPU is likely to be disallowed from the nohz_full list,
> it makes sense that we should not allow the boot CPU from being set in
> the isolcpus boot parameter as well. This will also avoid the kind of
> problems listed above.
> 
> Do that by clearing the boot CPU from the isolcpus range when it is
> specified in the boot command line. A warning may also be printed when
> that happens. If the users want to have boot CPU in the managed_irq
> or nohz isolation list, a standalone isolcpus boot parameter will be
> needed instead of combining domain and other flags in the same isolcpus
> boot parameter.
> 
> This is indeed a change in behavior which is customer visible. So the
> kernel-paremeters.txt is updated to mention the fact that boot CPU
> cannot be isolated.
> 
> [1] https://lore.kernel.org/lkml/20261117144817.265109-1-mathieu.desnoyers@efficios.com
> [2] https://sashiko.dev/#/patchset/20261108180849.1268263-1-longman%40redhat.com
> 
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>  .../admin-guide/kernel-parameters.txt         |  7 +++---
>  kernel/sched/isolation.c                      | 22 +++++++++++++++----
>  2 files changed, 22 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 930cee4de79a..1c8bf3583b0b 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -2954,11 +2954,12 @@ Kernel parameters
>  
>  			  You can move a process onto or off an "isolated" CPU via
>  			  the CPU affinity syscalls or cpuset.
> -			  <cpu number> begins at 0 and the maximum value is
> -			  "number of CPUs in system - 1".
> +			  <cpu number> begins at 0 and the maximum value
> +			  is "number of CPUs in system - 1". However boot
> +			  CPU (cpu 0) cannot be domain isolated as it
> +			  may cause problem with some kernel subsystems.
>  
>  			managed_irq
> -
>  			  Isolate from being targeted by managed interrupts
>  			  which have an interrupt mask containing isolated
>  			  CPUs. The affinity of managed interrupts is
> diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
> index c0c8b8862cbd..de8152351450 100644
> --- a/kernel/sched/isolation.c
> +++ b/kernel/sched/isolation.c
> @@ -231,6 +231,7 @@ static int __init housekeeping_setup(char *str, unsigned long flags)
>  {
>  	cpumask_var_t non_housekeeping_mask, housekeeping_staging;
>  	unsigned int first_cpu;
> +	int boot_cpu = smp_processor_id();
>  	int err = 0;
>  
>  	if ((flags & HK_FLAG_KERNEL_NOISE) && !(housekeeping.flags & HK_FLAG_KERNEL_NOISE)) {
> @@ -253,12 +254,25 @@ static int __init housekeeping_setup(char *str, unsigned long flags)
>  
>  	first_cpu = cpumask_first_and(cpu_present_mask, housekeeping_staging);
>  	if (first_cpu >= nr_cpu_ids || first_cpu >= setup_max_cpus) {
> -		__cpumask_set_cpu(smp_processor_id(), housekeeping_staging);
> -		__cpumask_clear_cpu(smp_processor_id(), non_housekeeping_mask);
> +		__cpumask_set_cpu(boot_cpu, housekeeping_staging);
> +		__cpumask_clear_cpu(boot_cpu, non_housekeeping_mask);
>  		if (!housekeeping.flags) {
> -			pr_warn("Housekeeping: must include one present CPU, "
> -				"using boot CPU:%d\n", smp_processor_id());
> +			pr_warn("Housekeeping: must include one present CPU, using boot CPU:%d\n",
> +				boot_cpu);
>  		}
> +	} else if ((flags & HK_FLAG_DOMAIN) &&
> +		   cpumask_test_cpu(boot_cpu, non_housekeeping_mask)) {
> +		/*
> +		 * If the same isolcpus boot parameter covers both domain and
> +		 * managed_irq/nohz, the boot CPU will also be removed from the
> +		 * managed_irq/nohz isolation list. Users have to use a separate
> +		 * isolcpus boot parameter for them if they want to include the
> +		 * boot CPU.
> +		 */
> +		pr_warn("Housekeeping: Boot CPU must not be domain isolated, clearing %d from isolcpus range\n",
> +			 boot_cpu);
> +		__cpumask_set_cpu(boot_cpu, housekeeping_staging);
> +		__cpumask_clear_cpu(boot_cpu, non_housekeeping_mask);
>  	}
>  
>  	if (cpumask_empty(non_housekeeping_mask))

Built and boot-tested on a 32-vCPU x86-64 VM with CONFIG_CPUSETS=y/n.
Verified CPU 0 handling with combined and separate domain/managed_irq
parameters, including a successful boot with CONFIG_CPUSETS=n and
isolcpus=domain,0. The cpuset selftests passed with CONFIG_CPUSETS=y.

Acked-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Tested-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
