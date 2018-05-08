From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH 6/7] psi: pressure stall information for CPU, memory, and
 IO
Date: Mon, 7 May 2018 17:42:36 -0700
Message-ID: <024fba07-eece-3878-0924-ea9fd601542d@infradead.org>
References: <20180507210135.1823-1-hannes@cmpxchg.org>
 <20180507210135.1823-7-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Xj+3oakpcy22bmyAScx8kqQ7kcQrMQCp7PiTuv06FeQ=; b=r/+f5nOjMtVxbE7otZYPT7k5m4
        l9y0/+HRc4Ei1HcL5ZGJs3MgjJac8zdtZE2Ywbk8MIzJwu8TMxpsGmzxGnXw46aId4cOJrw3RPYz5
        bP0MFJCQ5ZDl6IjXqUCf2NWsdVuNN2zplScXg3TJd4StwBnHqIUK+/l3HvAc7EmL0sLR5rJA5qCiG
        hL0OzYBuYmMQJidaT5R7cjcx9Xk9yRpGYff/GpTgQvT6vbS+QaXZ3bH1KCaIYOp1z0ibh18NPIlCF
        CAd/xgqE+ZBD05s3gniVAJPgHqKM8oOyBRDMIqna0MRGEE9V0RzEnd/HxruNg/RTCKjh236AlYiSk
      
In-Reply-To: <20180507210135.1823-7-hannes@cmpxchg.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-block@vger.kernel.org, cgroups@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linuxfoundation.org>, Tejun Heo <tj@kernel.org>, Balbir Singh <bsingharora@gmail.com>, Mike Galbraith <efault@gmx.de>, Oliver Yang <yangoliver@me.com>, Shakeel Butt <shakeelb@google.com>, xxx xxx <x.qendo@gmail.com>, Taras Kondratiuk <takondra@cisco.com>, Daniel Walker <danielwa@cisco.com>, Vinayak Menon <vinmenon@codeaurora.org>, Ruslan Ruslichenko <rruslich@cisco.com>, kernel-team@fb.com

On 05/07/2018 02:01 PM, Johannes Weiner wrote:
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> ---
>  Documentation/accounting/psi.txt |  73 ++++++
>  include/linux/psi.h              |  27 ++
>  include/linux/psi_types.h        |  84 ++++++
>  include/linux/sched.h            |  10 +
>  include/linux/sched/stat.h       |  10 +-
>  init/Kconfig                     |  16 ++
>  kernel/fork.c                    |   4 +
>  kernel/sched/Makefile            |   1 +
>  kernel/sched/core.c              |   3 +
>  kernel/sched/psi.c               | 424 +++++++++++++++++++++++++++++++
>  kernel/sched/sched.h             | 166 ++++++------
>  kernel/sched/stats.h             |  91 ++++++-
>  mm/compaction.c                  |   5 +
>  mm/filemap.c                     |  15 +-
>  mm/page_alloc.c                  |  10 +
>  mm/vmscan.c                      |  13 +
>  16 files changed, 859 insertions(+), 93 deletions(-)
>  create mode 100644 Documentation/accounting/psi.txt
>  create mode 100644 include/linux/psi.h
>  create mode 100644 include/linux/psi_types.h
>  create mode 100644 kernel/sched/psi.c
> 
> diff --git a/Documentation/accounting/psi.txt b/Documentation/accounting/psi.txt
> new file mode 100644
> index 000000000000..e051810d5127
> --- /dev/null
> +++ b/Documentation/accounting/psi.txt
> @@ -0,0 +1,73 @@

Looks good to me.


> diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
> new file mode 100644
> index 000000000000..052c529a053b
> --- /dev/null
> +++ b/kernel/sched/psi.c
> @@ -0,0 +1,424 @@
> +/*
> + * Measure workload productivity impact from overcommitting CPU, memory, IO
> + *
> + * Copyright (c) 2017 Facebook, Inc.
> + * Author: Johannes Weiner <hannes@cmpxchg.org>
> + *
> + * Implementation
> + *
> + * Task states -- running, iowait, memstall -- are tracked through the
> + * scheduler and aggregated into a system-wide productivity state. The
> + * ratio between the times spent in productive states and delays tells
> + * us the overall productivity of the workload.
> + *
> + * The ratio is tracked in decaying time averages over 10s, 1m, 5m
> + * windows. Cumluative stall times are tracked and exported as well to

               Cumulative

> + * allow detection of latency spikes and custom time averaging.
> + *
> + * Multiple CPUs
> + *
> + * To avoid cache contention, times are tracked local to the CPUs. To
> + * get a comprehensive view of a system or cgroup, we have to consider
> + * the fact that CPUs could be unevenly loaded or even entirely idle
> + * if the workload doesn't have enough threads. To avoid artifacts
> + * caused by that, when adding up the global pressure ratio, the
> + * CPU-local ratios are weighed according to their non-idle time:
> + *
> + *   Time the CPU had stalled tasks    Time the CPU was non-idle
> + *   ------------------------------ * ---------------------------
> + *                Walltime            Time all CPUs were non-idle
> + */


> +
> +/**
> + * psi_memstall_leave - mark the end of an memory stall section

                                    end of a memory

> + * @flags: flags to handle nested memdelay sections
> + *
> + * Marks the calling task as no longer stalled due to lack of memory.
> + */
> +void psi_memstall_leave(unsigned long *flags)
> +{



-- 
~Randy
