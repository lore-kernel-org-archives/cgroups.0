From: Mukesh Ojha <quic_mojha-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: no need to explicitly init a global static
 variable
Date: Wed, 21 Dec 2022 11:49:55 +0530
Message-ID: <f4c63e18-9666-b1db-8474-ea32da9daccb@quicinc.com>
References: <20221220151415.856093-1-neelx@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=quicinc.com; h=message-id : date :
 mime-version : subject : to : cc : references : from : in-reply-to :
 content-type : content-transfer-encoding; s=qcppdkim1;
 bh=bmZs5x1Uo0vIxNOpNufK8v9HsHBzoKzBVIakLqwAiFU=;
 b=hum+6+XmnsXTqdDSRzsYZmKoYTEYe7oMOOaQePpnNXk1EkNJ9zYfOtXtBrc5O0WPLJpH
 FgeTcclUWHyeAjj7ls4jDN/2j8kN5B/BoeDIauXR+oXF8hwLBQ7+3hjBZlGBkycxxbKY
 PWn996zcSTiWwryNWYshbt6yBUPIKJ+szAa+e2jVyJcqsV6NZEZH+ZxAmwXJw0hGEL05
 O2YuwkPtOdr5hy+AdquKUiRDtTUti6hMPT5N13ZG9fSUUngDLTUtjgcN5AKGySLEuLBl
 SEeGryXXUUnajvbJ4coOiOyK3HI9FPOFG09YFqSEwFgvzSxkcOMBANtRUs4jvPjEQC1B XA== 
Content-Language: en-US
In-Reply-To: <20221220151415.856093-1-neelx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Daniel Vacek <neelx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

On 12/20/2022 8:44 PM, Daniel Vacek wrote:
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

Acked-by: Mukesh Ojha <quic_mojha-jfJNa2p1gH1BDgjK7y7TUQ@public.gmane.org>

-Mukesh
