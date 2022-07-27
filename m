From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 9/9] sched/psi: add PSI_IRQ to track IRQ/SOFTIRQ pressure
Date: Wed, 27 Jul 2022 18:07:16 +0200
Message-ID: <YuFitL6KuCfuqujn@worktop.programming.kicks-ass.net>
References: <20220721040439.2651-1-zhouchengming@bytedance.com>
 <20220721040439.2651-10-zhouchengming@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=w9r9iD1+VJ1bB5BUofHhTNtVicBr0akZlYlPe4WCSQQ=; b=lvZsnsMXIad6IuUpCnGPnR81q2
        acnY8KBBOU1hGSV7O0ISRk6vrJNFl/RF2gWT57/zETylrGdz0kZotBUWTPyxYZkRRefybX1Zc3PMM
        OS/zAgpdVMu6hShabM3s88zg7aZWoAGhmJRap+XqlOdif7iB/6s6HyThVCwY1Gy1xbYX6U4GUSU8y
        eenB9BdltjQlPKr5ZSxn8CH1RSQ6oHLkErzSEYeYnyVqBG6KbNXc7Ipgay4x4IaYfFa6IXLqENYcI
        lZ49/7TVmlRFOWE8wJMSRk2EtilZ6o0Sx/tOtqDxsMVt2+LJXmySQ8r5lIDvmsJAuk793m0L+l/Xe
        Uhd2GcCA==;
Content-Disposition: inline
In-Reply-To: <20220721040439.2651-10-zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Jul 21, 2022 at 12:04:39PM +0800, Chengming Zhou wrote:
> diff --git a/include/linux/psi_types.h b/include/linux/psi_types.h
> index c124f7d186d0..195f123b1cd1 100644
> --- a/include/linux/psi_types.h
> +++ b/include/linux/psi_types.h
> @@ -47,7 +47,8 @@ enum psi_res {
>  	PSI_IO,
>  	PSI_MEM,
>  	PSI_CPU,
> -	NR_PSI_RESOURCES = 3,
> +	PSI_IRQ,
> +	NR_PSI_RESOURCES = 4,
>  };
>  
>  /*
> @@ -63,9 +64,11 @@ enum psi_states {
>  	PSI_MEM_FULL,
>  	PSI_CPU_SOME,
>  	PSI_CPU_FULL,
> +	PSI_IRQ_SOME,
> +	PSI_IRQ_FULL,
>  	/* Only per-CPU, to weigh the CPU in the global average: */
>  	PSI_NONIDLE,
> -	NR_PSI_STATES = 7,
> +	NR_PSI_STATES = 9,
>  };
>  
>  enum psi_aggregators {

$ pahole -EC psi_group_cpu defconfig-build/kernel/sched/build_utility.o
struct psi_group_cpu {
        /* typedef seqcount_t */ struct seqcount {
                unsigned int       sequence;                                             /*     0     4 */
        } seq __attribute__((__aligned__(64))); /*     0     4 */
        unsigned int               tasks[5];                                             /*     4    20 */
        /* typedef u32 -> __u32 */ unsigned int               state_mask;                /*    24     4 */
        /* typedef u32 -> __u32 */ unsigned int               times[7];                  /*    28    28 */
        /* typedef u64 -> __u64 */ long long unsigned int     state_start;               /*    56     8 */
        /* --- cacheline 1 boundary (64 bytes) --- */
        /* typedef u32 -> __u32 */ unsigned int               times_prev[2][7] __attribute__((__aligned__(64))); /*    64    56 */

        /* size: 128, cachelines: 2, members: 6 */
        /* padding: 8 */
        /* forced alignments: 2 */
} __attribute__((__aligned__(64)));


$ pahole -EC psi_group_cpu defconfig-build/kernel/sched/build_utility.o
struct psi_group_cpu {
        /* typedef seqcount_t */ struct seqcount {
                unsigned int       sequence;                                             /*     0     4 */
        } seq __attribute__((__aligned__(64))); /*     0     4 */
        unsigned int               tasks[5];                                             /*     4    20 */
        /* typedef u32 -> __u32 */ unsigned int               state_mask;                /*    24     4 */
        /* typedef u32 -> __u32 */ unsigned int               times[9];                  /*    28    36 */
        /* --- cacheline 1 boundary (64 bytes) --- */
        /* typedef u64 -> __u64 */ long long unsigned int     state_start;               /*    64     8 */

        /* XXX 56 bytes hole, try to pack */

        /* --- cacheline 2 boundary (128 bytes) --- */
        /* typedef u32 -> __u32 */ unsigned int               times_prev[2][9] __attribute__((__aligned__(64))); /*   128    72 */

        /* size: 256, cachelines: 4, members: 6 */
        /* sum members: 144, holes: 1, sum holes: 56 */
        /* padding: 56 */
        /* forced alignments: 2, forced holes: 1, sum forced holes: 56 */
} __attribute__((__aligned__(64)));


So yeah, I think not.
