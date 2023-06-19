From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: remove unneeded nodes_or() in
 cpuset_change_task_nodemask()
Date: Mon, 19 Jun 2023 10:37:57 -0400
Message-ID: <c32a0bad-b20f-e53b-a38a-5da687b8a205@redhat.com>
References: <20230617083043.2065556-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687185483;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n81+s1XEobkyuHvPUCbHGRBITPBL/Ux61aHB9fOgZks=;
        b=eRrDuNebKAAyEMwcEgJtiRi/FuDoYMiNErV20tBL6m/EpVvl6lj2M1s8w2jNzX46L+nphx
        Xsq+81aY7BcupxnrInvSgpZFG+JqQMQpTv5KfxO3xQu3VXaSCnLluGsjQvn7JOicv0Qfwh
        yBPhfDr89twlps/9hYiCW/mvhzP2rP0=
Content-Language: en-US
In-Reply-To: <20230617083043.2065556-1-linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 6/17/23 04:30, Miaohe Lin wrote:
> The tsk->mems_allowed is changed before calling mpol_rebind_task() and
> being reassigned right after it. But tsk->mems_allowed is not needed
> inside mpol_rebind_task(). So remove unneeded tsk->mems_allowed modify
> via nodes_or() here.
>
> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>   kernel/cgroup/cpuset.c | 1 -
>   1 file changed, 1 deletion(-)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index 58e6f18f01c1..33a429c1179f 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -1941,7 +1941,6 @@ static void cpuset_change_task_nodemask(struct task_struct *tsk,
>   	local_irq_disable();
>   	write_seqcount_begin(&tsk->mems_allowed_seq);
>   
> -	nodes_or(tsk->mems_allowed, tsk->mems_allowed, *newmems);
>   	mpol_rebind_task(tsk, newmems);
>   	tsk->mems_allowed = *newmems;
>   

That line was inserted by commit cc9a6c8776615 ("cpuset: mm: reduce 
large amounts of memory barrier related damage v3"). At first glance, it 
does looks like it is not necessary. However, I am not sure if a race is 
possible that will produce a false failure because of missing this line.

My 2 cents.

Cheers,
Longman

