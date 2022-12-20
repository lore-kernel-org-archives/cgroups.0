From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: no need to explicitly init a global static
 variable
Date: Tue, 20 Dec 2022 11:59:00 -0500
Message-ID: <9295b73a-5a3c-b1f6-d892-0da1d356ab9f@redhat.com>
References: <20221220151415.856093-1-neelx@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671555545;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KRZ5NBQkSBEMSzVXiSUDsWEBTOjISuGVrqOh0e75EmM=;
        b=gUb1ar3FA9jIQMgMFmjoB3CAfUSSsRO80YQAz8kSE0/QxXF22l8G4cCH7+e3V9zWd9zsHC
        9KOxqbaOTi7Wg0ECmL7Mf6yTX3ef7Q16Ets7EAqEHk7FjNoU2+xZkHltPHY/SrVDuBGAYx
        gmCU/fYxr4rLwbIYERL6/MCIdDCo7vw=
Content-Language: en-US
In-Reply-To: <20221220151415.856093-1-neelx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Daniel Vacek <neelx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 12/20/22 10:14, Daniel Vacek wrote:
> cpuset_rwsem is a static variable. It's initialized at build time and so
> there's no need for explicit runtime init leaking one percpu int.
>
> Signed-off-by: Daniel Vacek <neelx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>   kernel/cgroup/cpuset.c | 2 --
>   1 file changed, 2 deletions(-)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index a29c0b13706bb..87fe410361b3d 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -3281,8 +3281,6 @@ struct cgroup_subsys cpuset_cgrp_subsys = {
>   
>   int __init cpuset_init(void)
>   {
> -	BUG_ON(percpu_init_rwsem(&cpuset_rwsem));
> -
>   	BUG_ON(!alloc_cpumask_var(&top_cpuset.cpus_allowed, GFP_KERNEL));
>   	BUG_ON(!alloc_cpumask_var(&top_cpuset.effective_cpus, GFP_KERNEL));
>   	BUG_ON(!zalloc_cpumask_var(&top_cpuset.subparts_cpus, GFP_KERNEL));

It will be clearer if you mention that DEFINE_STATIC_PERCPU_RWSEM() is 
used to set up cpuset_rwsem at build time. Other than that, the patch 
looks good to me.

Cheers,
Longman

