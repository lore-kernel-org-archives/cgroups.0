Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.229
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795490877;
	b=1CNG419bE+12Xwz7Vg1ZDIXLSB31Um9g76VdsKSDCCI2he/9FSLWpe1ryqXiIQfYXVp0
	 J1l5K3wXjobzn5912v/uB4ace/ZRdCJ6T3//WNaWW3W17YmWZ6+HqOo/9Zsl3OKWJW8jp
	 sGDdBUAghipR5V/2ZICRWSJTdmn7a4Wy280jrK4TtKrwkD8QaA/6Z4xF/ZkrprU/FIF6H
	 hNpn4l+q+bez1p9LhFdmGXYCiePdYLDP3UvmJkJz5XJ71+0htIcp5Lu6xN6EiijYOrp5s
	 j967O2qMon3Q6dsYB21bwhPZNAFbBAtAsVB5H7JZ7OBZoXOpVsfwYsSfeoPJdoanTlg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795490877;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=oN/cZp9q5wZoqC1lfLoWR2vXWj83Wie4hQDwsy7qSN4=;
	b=ilt4jjFUeDAV4xC5CGduNzxUD+EpA20vdr8Qu5WFV3PIww0xOMUxvdMWdNUfjkqmiCST
	 qwNbZ6JUCl5X62yDlw2oET81geCRj6G46g4ixoM3woHYY9w20Biv6LlVgAZJ7mzd2eCSS
	 Mqzu8Eu37d4U29Jug0vDLsqr0PiJSsrRmslYMnKx5aH41IDpB6feNkJ3jQg62CvdG5ykd
	 M8VBvCB8FaNB3xUpObq1t8ULRCzW79ea8fol4wYvjK0kaSkUfNj9vTCq+v2ZalppLxW5t
	 6EKIY9CHs/HGg+XxIF2XiJHG/9gpDfaXa/ihuz5qO8Z6BWOfXge1g2gKbF8mdbdivkw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=LvWVL2vm;
	arc=none smtp.remote-ip=95.215.58.229
Received: from mta1.migadu.com (out-229.mta1.migadu.com [95.215.58.229])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60C46606A32C
	for <cgroups@vger.kernel.org>; Tue, 24 Nov 2026 03:27:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 60C46606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=LvWVL2vm
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=ma8JFmeoCyTpTT72snN16G84AYASmM5bzTvQRXIbf+Q=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795490874; v=1; x=1796095674;
 b=LvWVL2vmsqiZ07mYjNpuAy99QXZuRLBrA2LsGEFgea6IxXzbjLHtY6FcdNW+vf0aQ1JwtXbR
 vvbmLznQ2MmvaKilhcmJqcCaUnJIn2U1ihYWD+UkMD6uKnpcbZv/ztJI1+2JOeAENQSKe6mflxe
 /CShumiobZa//kXBpy2ao2ug=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 1a2ced6113f13d6e;
	Tue, 24 Nov 2026 03:27:54 +0000
X-Mizu-Trace-ID: 1a2ced6113f13d6e
X-Migadu-Flow: FLOW_OUT
Message-ID: <7dbec7f4-35d0-4351-a61d-ab0a649c41d6@linux.dev>
Date: Tue, 24 Nov 2026 11:27:43 +0800
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
 <rdunlap@infradead.org>, Ingo Molnar <mingo@redhat.com>,
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 K Prateek Nayak <kprateek.nayak@amd.com>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>,
 Frederic Weisbecker <frederic@kernel.org>, Thomas Gleixner <tglx@kernel.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
 Guopeng Zhang <guopeng.zhang@linux.dev>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
References: <20261123041209.382726-1-longman@redhat.com>
 <20261123041209.382726-3-longman@redhat.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20261123041209.382726-3-longman@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/23/2026 12:12 PM, Waiman Long wrote:
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

This fixes a boot-time BUG(), so it seems worth a Fixes?


> ---
>   .../admin-guide/kernel-parameters.txt         |  7 +++---
>   kernel/sched/isolation.c                      | 22 +++++++++++++++----
>   2 files changed, 22 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
> index 930cee4de79a..1c8bf3583b0b 100644
> --- a/Documentation/admin-guide/kernel-parameters.txt
> +++ b/Documentation/admin-guide/kernel-parameters.txt
> @@ -2954,11 +2954,12 @@ Kernel parameters
>   
>   			  You can move a process onto or off an "isolated" CPU via
>   			  the CPU affinity syscalls or cpuset.
> -			  <cpu number> begins at 0 and the maximum value is
> -			  "number of CPUs in system - 1".
> +			  <cpu number> begins at 0 and the maximum value
> +			  is "number of CPUs in system - 1". However boot
> +			  CPU (cpu 0) cannot be domain isolated as it
> +			  may cause problem with some kernel subsystems.
>   
>   			managed_irq
> -
>   			  Isolate from being targeted by managed interrupts
>   			  which have an interrupt mask containing isolated
>   			  CPUs. The affinity of managed interrupts is
> diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
> index c0c8b8862cbd..de8152351450 100644
> --- a/kernel/sched/isolation.c
> +++ b/kernel/sched/isolation.c
> @@ -231,6 +231,7 @@ static int __init housekeeping_setup(char *str, unsigned long flags)
>   {
>   	cpumask_var_t non_housekeeping_mask, housekeeping_staging;
>   	unsigned int first_cpu;
> +	int boot_cpu = smp_processor_id();
>   	int err = 0;
>   
>   	if ((flags & HK_FLAG_KERNEL_NOISE) && !(housekeeping.flags & HK_FLAG_KERNEL_NOISE)) {
> @@ -253,12 +254,25 @@ static int __init housekeeping_setup(char *str, unsigned long flags)
>   
>   	first_cpu = cpumask_first_and(cpu_present_mask, housekeeping_staging);
>   	if (first_cpu >= nr_cpu_ids || first_cpu >= setup_max_cpus) {
> -		__cpumask_set_cpu(smp_processor_id(), housekeeping_staging);
> -		__cpumask_clear_cpu(smp_processor_id(), non_housekeeping_mask);
> +		__cpumask_set_cpu(boot_cpu, housekeeping_staging);
> +		__cpumask_clear_cpu(boot_cpu, non_housekeeping_mask);
>   		if (!housekeeping.flags) {
> -			pr_warn("Housekeeping: must include one present CPU, "
> -				"using boot CPU:%d\n", smp_processor_id());
> +			pr_warn("Housekeeping: must include one present CPU, using boot CPU:%d\n",
> +				boot_cpu);
>   		}
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
>   	}
>   
>   	if (cpumask_empty(non_housekeeping_mask))

The code change itself looks good to me.

Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Thanks.

-- 
Best regards
Ridong

