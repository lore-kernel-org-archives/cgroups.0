From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cpuset: Fix the bug that subpart_cpus updated wrongly in
 update_cpumask()
Date: Tue, 18 Jan 2022 15:21:44 -0500
Message-ID: <7610638e-9954-a6b2-63b2-e1df334a288f@redhat.com>
References: <20220118100518.2381118-1-dtcccc@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1642537311;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Y8gyhqFvKMeBPNaQH3F4JAzHy306fMW6cgpFncW//cw=;
        b=QV53UVZ/BYqP0ijap8Pv1d1/rtme04KvBjm9FN4cjeMpcMXivtSPd2p0P+EpmpD7muhDC2
        qfw2w0/daZe3WYQyna3k+Z6gZofX7xK6u+yGRej+zRHVjV7ySHqrDKk3pzVww7eOWBO4PT
        1erNdqDiBUfLYXhPfq5UNs0FNGguifo=
Content-Language: en-US
In-Reply-To: <20220118100518.2381118-1-dtcccc-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Tianchen Ding <dtcccc-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, "Peter Zijlstra (Intel)" <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 1/18/22 05:05, Tianchen Ding wrote:
> subparts_cpus should be limited as a subset of cpus_allowed, but it is
> updated wrongly by using cpumask_andnot(). Use cpumask_and() instead to
> fix it.
>
> Fixes: ee8dde0cd2ce ("cpuset: Add new v2 cpuset.sched.partition flag")
> Signed-off-by: Tianchen Ding <dtcccc-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> ---
>   kernel/cgroup/cpuset.c | 3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index bb3531e7fda7..804ff5738c5f 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1635,8 +1635,7 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
>   	 * Make sure that subparts_cpus is a subset of cpus_allowed.
>   	 */
>   	if (cs->nr_subparts_cpus) {
> -		cpumask_andnot(cs->subparts_cpus, cs->subparts_cpus,
> -			       cs->cpus_allowed);
> +		cpumask_and(cs->subparts_cpus, cs->subparts_cpus, cs->cpus_allowed);
>   		cs->nr_subparts_cpus = cpumask_weight(cs->subparts_cpus);
>   	}
>   	spin_unlock_irq(&callback_lock);

Thanks for the fix.

Reviewed-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

