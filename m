From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH 2/2] sched/isolation: Add cpu_is_isolated() API
Date: Fri, 3 Feb 2023 22:53:46 -0500
Message-ID: <0f388863-9498-e61e-e2dc-965654544489@redhat.com>
References: <20230203232409.163847-1-frederic@kernel.org>
 <20230203232409.163847-3-frederic@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1675482830;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=buEB2MhYiHkTXl+iJ+h97A75R8p42T/127lL4Ay8x+c=;
        b=OP+x+lOY5d3FIuiZJPga2Tu/C9dsuy1eP6pqGNiarpmSoQwAhadwuVWDW0GY2DUvPV+LKe
        1qOav+B7fjNUGlHRajoJCm8feJmHHZbR/Eiuz1MvGY6z9sfC41rol4aY3OuLU1T5tD/Nc6
        +uRTXA9eXzgF6venSmAVckZAVMveXgQ=
Content-Language: en-US
In-Reply-To: <20230203232409.163847-3-frederic@kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Frederic Weisbecker <frederic@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>, Michal Hocko <mhocko@suse.com>, Marcelo Tosatti <mtosatti@redhat.com>, Leonardo <leobras@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, cgroups@vger.kernel.org, linux-mm@kvack.org

On 2/3/23 18:24, Frederic Weisbecker wrote:
> Provide this new API to check if a CPU has been isolated either through
> isolcpus= or nohz_full= kernel parameter.
>
> It aims at avoiding kernel load deemed to be safely spared on CPUs
> running sensitive workload that can't bear any disturbance, such as
> pcp cache draining.
>
> Suggested-by: Michal Hocko <mhocko@suse.com>
> Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
> ---
>   include/linux/sched/isolation.h | 6 ++++++
>   1 file changed, 6 insertions(+)
>
> diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
> index b645cc81fe01..088672f08469 100644
> --- a/include/linux/sched/isolation.h
> +++ b/include/linux/sched/isolation.h
> @@ -53,4 +53,10 @@ static inline bool housekeeping_cpu(int cpu, enum hk_type type)
>   	return true;
>   }
>   
> +static inline bool cpu_is_isolated(int cpu)
> +{
> +	return !housekeeping_test_cpu(cpu, HK_TYPE_DOMAIN) ||
> +		 !housekeeping_test_cpu(cpu, HK_TYPE_KERNEL_NOISE);
> +}
> +
>   #endif /* _LINUX_SCHED_ISOLATION_H */

CPUs in an isolated cpuset partition is similar to HK_TYPE_DOMAIN CPUs 
as load balancing is disabled. I can add an API to access the cpumask 
and add to this API. However, that list is dynamic as it can be changed 
at run time. Will that be a problem? Or should that be used separately?

Cheers,
Longman

