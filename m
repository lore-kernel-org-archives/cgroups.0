From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: simplify the percpu kthreads check in
 update_tasks_cpumask()
Date: Tue, 4 Jul 2023 23:14:01 -0400
Message-ID: <bc8202fd-a31c-2b08-bd01-8b5868aab230@redhat.com>
References: <20230704113049.1019118-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688526847;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=nrkEIq6dhRR9ar//G8iVT0D1nMSlQSq+xiDuYGm9BDg=;
        b=NX0ENdAXG2I5kH3R72J9gVnjgGNp2O1xGmbust3klMAh6st8PpkPUohq/TuBIsmDvDLGso
        HPfdet+KzngdKins42sDfQXmNF5Oodqs23khyL60dgHjS1IkckNPKU+R7F3koVcvH6esER
        tF9PQWR5Iu09E6B1ZkGx7tzcaetY2rk=
Content-Language: en-US
In-Reply-To: <20230704113049.1019118-1-linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 7/4/23 07:30, Miaohe Lin wrote:
> kthread_is_per_cpu() can be called directly without checking whether
> PF_KTHREAD is set in task->flags. So remove PF_KTHREAD check to make
> code more concise.
>
> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>   kernel/cgroup/cpuset.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 58e6f18f01c1..601c40da8e03 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1230,7 +1230,7 @@ static void update_tasks_cpumask(struct cpuset *cs, struct cpumask *new_cpus)
>   			/*
>   			 * Percpu kthreads in top_cpuset are ignored
>   			 */
> -			if ((task->flags & PF_KTHREAD) && kthread_is_per_cpu(task))
> +			if (kthread_is_per_cpu(task))
>   				continue;
>   			cpumask_andnot(new_cpus, possible_mask, cs->subparts_cpus);
>   		} else {

The initial intention was to ignore only percpu kthreads. The current 
code likely ignore all the kthreads. Removing the PF_KTHREAD flag, 
however, may introduce unexpected regression at this point. I would like 
to hold off for now until more investigation are done.

Thanks,
Longman

