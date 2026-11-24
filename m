Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.32
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795489533;
	b=IFRop5LGsUg+JsZevhXa1OkYm9+QmygtEATTKzXtczcxWBIs8Cy962JA0MIVTk+jfYyo
	 KgPhvLdmovYWBlomalVUjU6EAcHqxsjl5UIs9P0kdGt3ngxuAfOUx1wPmKk5Y+vObQJ9e
	 mwmRZX7pm8hbWYcBa7eSHQuS0Sr4t6QFeiYyzBxEaY/GQ1K+9RTH6qCMya5yuoaB0YrNA
	 K+0NKpQKQ0vX81XkIlZv1cUptZGu1Exj8YaXssSTLrABznpuuhpQh3WHYqjW+cNAveCiV
	 ALyuS6Pptv7kRoAC0tdpuRhrUqSZjp37qwLaz60JqIhcWebtHmyEuZW8/IUWyqiEsrg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795489533;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=t9KS4305neDKBsFcNTS/0eSUFFO9PpJgyH3BrjeV05A=;
	b=rvskwMrW53B9SgsLPa6MBqrpy+b+dhxzRpVDNvpzLNJH0gaWpX9OkwOOtfUH/LW/ycks
	 T6oqankcgQADD9FhtveF8ZuCEFh3ft41CJ7EjnBAuWMf5JHwnCo4iZP8q52Ef7Cf2PYUD
	 qih/qdZcv7WF/+dezube5P/e0WrNbDumwbNG8o7gQ12XSr1u4vNh7gJyLxm4xMuPkoudP
	 Q/aP9pVODCly6/WonFI6gbtBxQAqGGUoPdXpnjYK7BjxO0oByk594QyRWsNbW1n7N/sR9
	 bm+aEll1LECnI/gP8jid7Rfryyked3fMNWjVThEe/4Am6e9HnkrJR02n30T18jkohDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=q6aTVuo5;
	arc=none smtp.remote-ip=91.218.175.32
Received: from mta0.migadu.com (out-32.mta0.migadu.com [91.218.175.32])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E632F606A31E
	for <cgroups@vger.kernel.org>; Tue, 24 Nov 2026 03:05:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E632F606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=q6aTVuo5
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=Dr5NpzBTKqBZbHmaCa+5JxIlMFu6dSvBFoJtjVDZExY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795489530; v=1; x=1796094330;
 b=q6aTVuo5LnpbZlwkyXgXcxDUdi7NwTSmX/VzU04aUM7Tp07Iet3sUjkypke/UYMgPb6eEUJ0
 P47P8LnLQj2F2mF6SFn+/hKoKbyeLyAbVQOUXHJSfxnQZDkfwQe2upOkAdYhCBIhBImBU7fjzdF
 uI7wLx1Bu9cniPoLzmUd8H70=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id dfdee2bf3addbc78;
	Tue, 24 Nov 2026 03:05:26 +0000
X-Mizu-Trace-ID: dfdee2bf3addbc78
X-Migadu-Flow: FLOW_OUT
Message-ID: <76951771-cbe5-4518-a118-b06a30353d88@linux.dev>
Date: Tue, 24 Nov 2026 11:05:06 +0800
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
Subject: Re: [PATCH-next v2 1/3] tick/sched: Make tick_nohz_full_mask and
 HK_TYPE_KERNEL_NOISE cpumask consistent
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
 <20261123041209.382726-2-longman@redhat.com>
Content-Language: en-US
From: Guopeng Zhang <guopeng.zhang@linux.dev>
In-Reply-To: <20261123041209.382726-2-longman@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



在 2026/11/23 12:12, Waiman Long 写道:
> When the nohz_full boot parameter is first set, the cpu list parameter is
> passed directly to tick_nohz_full_setup() to set up tick_nohz_full_mask
> cpumask. Then the HK_TYPE_KERNEL_NOISE cpumask will be set up as the
> inverse of given cpu list parameter. Some of the timer code and RCU
> uses tick_nohz_full_mask directly while other timer code, scheduler
> and other subsystems use the HK_TYPE_KERNEL_NOISE cpumask.
> 
> With CONFIG_PM_SLEEP_SMP && !CONFIG_PM_SLEEP_SMP_NONZERO_CPU config
> options, the boot CPU will be cleared from tick_nohz_full_mask if set
> while the corresponding HK_TYPE_KERNEL_NOISE cpumask isn't touched.
> The nohz_full entry in kernel-parameters.txt does state that the boot
> CPU will be forced outside the range to maintain the timekeeping. So it
> makes sense that the HK_TYPE_KERNEL_NOISE should be modified accordingly.
> 
> Fix this inconsistency problem by adding a new cpumask_set_cpu() init
> function to be called by tick_nohz_init() when the boot CPU is cleared
> from tick_nohz_full_mask.
> 
> PM_SLEEP_SMP_NONZERO_CPU depends on ARCH_SUSPEND_NONZERO_CPU which can
> only be set for the PowerPC architecture. Moreover CONFIG_PM_SLEEP_SMP is
> on by default, it means most kernels will not allow CPU 0 to be set in
> the tick_nohz_full_mask and hence should be set in HK_TYPE_KERNEL_NOISE
> cpumask.
> 
> Fixes: 6f1982fedd59 ("sched/isolation: Handle the nohz_full= parameter")
> Signed-off-by: Waiman Long <longman@redhat.com>
> ---
>  include/linux/sched/isolation.h |  2 ++
>  kernel/sched/isolation.c        | 11 +++++++++++
>  kernel/time/tick-sched.c        |  2 ++
>  3 files changed, 15 insertions(+)
> 
> diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
> index cf0fd03dd7a2..ae5109450ac9 100644
> --- a/include/linux/sched/isolation.h
> +++ b/include/linux/sched/isolation.h
> @@ -44,6 +44,7 @@ extern bool housekeeping_enabled(enum hk_type type);
>  extern void housekeeping_affine(struct task_struct *t, enum hk_type type);
>  extern bool housekeeping_test_cpu(int cpu, enum hk_type type);
>  extern int housekeeping_update(struct cpumask *isol_mask);
> +extern void __init housekeeping_set_cpu(int cpu, enum hk_type type);
>  extern void __init housekeeping_init(void);
>  
>  #else
> @@ -72,6 +73,7 @@ static inline bool housekeeping_test_cpu(int cpu, enum hk_type type)
>  }
>  
>  static inline int housekeeping_update(struct cpumask *isol_mask) { return 0; }
> +static inline void housekeeping_set_cpu(int cpu, enum hk_type type) { }
>  static inline void housekeeping_init(void) { }
>  #endif /* CONFIG_CPU_ISOLATION */
>  
> diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
> index 156025ef81b7..c0c8b8862cbd 100644
> --- a/kernel/sched/isolation.c
> +++ b/kernel/sched/isolation.c
> @@ -120,6 +120,17 @@ bool housekeeping_test_cpu(int cpu, enum hk_type type)
>  }
>  EXPORT_SYMBOL_GPL(housekeeping_test_cpu);
>  
> +void __init housekeeping_set_cpu(int cpu, enum hk_type type)
> +{
> +	/* Only CPU setting of HK_TYPE_KERNEL_NOISE is currently supported */
> +	if (type != HK_TYPE_KERNEL_NOISE)
> +		return;
> +
> +	if (static_branch_unlikely(&housekeeping_overridden) &&
> +	    READ_ONCE(housekeeping.flags) & BIT(type))
> +		cpumask_set_cpu(cpu, housekeeping_cpumask_dereference(type));
> +}
> +
>  int housekeeping_update(struct cpumask *isol_mask)
>  {
>  	struct cpumask *trial, *old = NULL;
> diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
> index 255488366d7c..d9f45c9f9b89 100644
> --- a/kernel/time/tick-sched.c
> +++ b/kernel/time/tick-sched.c
> @@ -22,6 +22,7 @@
>  #include <linux/sched/stat.h>
>  #include <linux/sched/nohz.h>
>  #include <linux/sched/loadavg.h>
> +#include <linux/sched/isolation.h>
>  #include <linux/module.h>
>  #include <linux/irq_work.h>
>  #include <linux/posix-timers.h>
> @@ -683,6 +684,7 @@ void __init tick_nohz_init(void)
>  			pr_warn("NO_HZ: Clearing %d from nohz_full range "
>  				"for timekeeping\n", cpu);
>  			cpumask_clear_cpu(cpu, tick_nohz_full_mask);
> +			housekeeping_set_cpu(cpu, HK_TYPE_KERNEL_NOISE);
>  		}
>  	}
>  

Built and boot-tested the v2 series on a 32-vCPU x86-64 VM with
CONFIG_NO_HZ_FULL=y and CONFIG_PM_SLEEP_SMP=y. With nohz_full=0,8-31,
verified that CPU 0 is excluded from nohz_full and included in
HK_TYPE_KERNEL_NOISE. The cpuset selftests passed.

Acked-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Tested-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Thanks,
Guopeng
