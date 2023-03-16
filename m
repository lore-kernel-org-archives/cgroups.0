From: Waiman Long <longman@redhat.com>
Subject: Re: [PATCH] cgroup: fix display of forceidle time at root
Date: Wed, 15 Mar 2023 22:19:10 -0400
Message-ID: <bfbdef64-1b8c-4168-2576-f6d4a112686b@redhat.com>
References: <20230315214029.899573-1-joshdon@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678933154;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D6EX5i+Qe8tR7m3emFCoOQSet9tLg5nf9Z6njJr0SW8=;
        b=OEWRZe+6MInvsoozwnM5yHyM676oTwPIyl7erbGC5l5saKFqbgCRlBkTOm2uyeoKZGLrGY
        zEILuXnfVp2OvYURI3BK/x6oM0/w6POIsiuM71BnykDiQEjdo8wLXBPRFUVWPmjsjpj7L6
        JE16ItTbhm/siPWNY7MdgqAyteRv5Yg=
Content-Language: en-US
In-Reply-To: <20230315214029.899573-1-joshdon@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Josh Don <joshdon@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On 3/15/23 17:40, Josh Don wrote:
> We need to reset forceidle_sum to 0 when reading from root, since the
> bstat we accumulate into is stack allocated.
>
> To make this more robust, just replace the existing cputime reset with a
> memset of the overall bstat.
>
> Signed-off-by: Josh Don <joshdon@google.com>
> ---
>   kernel/cgroup/rstat.c | 4 +---
>   1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
> index 831f1f472bb8..0a2b4967e333 100644
> --- a/kernel/cgroup/rstat.c
> +++ b/kernel/cgroup/rstat.c
> @@ -457,9 +457,7 @@ static void root_cgroup_cputime(struct cgroup_base_stat *bstat)
>   	struct task_cputime *cputime = &bstat->cputime;
>   	int i;
>   
> -	cputime->stime = 0;
> -	cputime->utime = 0;
> -	cputime->sum_exec_runtime = 0;
> +	memset(bstat, 0, sizeof(*bstat));
>   	for_each_possible_cpu(i) {
>   		struct kernel_cpustat kcpustat;
>   		u64 *cpustat = kcpustat.cpustat;

How about adding the following fixes tag?

Fixes: 1fcf54deb767 ("sched/core: add forced idle accounting for cgroups")

Cheers,
Longman

