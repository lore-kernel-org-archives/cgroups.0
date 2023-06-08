From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: Fix comment in cpuset_hotplug_workfn
Date: Thu, 8 Jun 2023 08:22:06 -0400
Message-ID: <7ff8c948-c5e2-ac5b-6633-8583b8cb75fe@redhat.com>
References: <20230608085439.27501-1-suhua.tanke@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686226932;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=j6zJ80tFIxXTVHRh/16qEQREsJv1j4C9vyoJ2KH4/8c=;
        b=AW9y+DCNh3q94I6r9c5PCL5+kN95gM/aV5bzFbXxVOo/z2qQEA3mvXLUhXGmh8db0ftOD0
        rUR+9xrkvrts/cnHbtmgZuJvrCvHGFMulV6ss+mGf7RHuUU4NK2itzP10AwMK8V6g80Rg2
        hq0expNu4UwczQykeKbH/v8c1fxRXi8=
Content-Language: en-US
In-Reply-To: <20230608085439.27501-1-suhua.tanke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: suhua <suhua.tanke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 6/8/23 04:54, suhua wrote:
> "synchronize cpus_allowed to cpu_active_mask"
> -> "synchronize cpu_active_mask to cpus_allowed"
>
> Signed-off-by: suhua <suhua.tanke-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> ---
>   kernel/cgroup/cpuset.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index b0aee733b92b..4810d29e2d63 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -3739,7 +3739,7 @@ static void cpuset_hotplug_workfn(struct work_struct *work)
>   	if (!cpus_updated && top_cpuset.nr_subparts_cpus)
>   		cpus_updated = true;
>   
> -	/* synchronize cpus_allowed to cpu_active_mask */
> +	/* synchronize cpu_active_mask to cpus_allowed */
>   	if (cpus_updated) {
>   		spin_lock_irq(&callback_lock);
>   		if (!on_dfl)

The comment is a bit outdated. The synchronization is only meant for 
cgroup v1, but it is correct in this regard. We are matching 
cpus_allowed of top_cpuset to cpu_active_mask, not the other way around.

Cheers,
Longman

