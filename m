From: Aaron Tomlin <atomlin-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: no need to explicitly init a global
 static variable
Date: Tue, 20 Dec 2022 17:32:35 +0000
Message-ID: <20221220173235.t7vq7mdbimwjijyx@ava.usersys.com>
References: <20221220151415.856093-1-neelx@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671557559;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LpJLDJC3PZt1IAsqj5WBTZVH7ZAYMCqMmIX34DLaBOI=;
        b=ViJw5gmDUkzF2Qdz4y5NgZoScCyOjn//qB78L9zfbjwdXVJdI8eTcRkC2UwYrKF2cMbwaA
        DgW97KsRdU2KVh++XxzCmbd2HX0cknFiZMWVYjZ9bVW8J2xJXO8GS4t6+wB/f80JzSYkok
        BJUcKaBdoPlmMGzX0BWTRiwoVLbA/9o=
Content-Disposition: inline
In-Reply-To: <20221220151415.856093-1-neelx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Daniel Vacek <neelx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, atomlin-OvwSCxsgXNNBDgjK7y7TUQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue 2022-12-20 16:14 +0100, Daniel Vacek wrote:
> cpuset_rwsem is a static variable. It's initialized at build time and so
> there's no need for explicit runtime init leaking one percpu int.
> 
> Signed-off-by: Daniel Vacek <neelx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  kernel/cgroup/cpuset.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> index a29c0b13706bb..87fe410361b3d 100644
> --- a/kernel/cgroup/cpuset.c
> +++ b/kernel/cgroup/cpuset.c
> @@ -3281,8 +3281,6 @@ struct cgroup_subsys cpuset_cgrp_subsys = {
>  
>  int __init cpuset_init(void)
>  {
> -	BUG_ON(percpu_init_rwsem(&cpuset_rwsem));
> -
>  	BUG_ON(!alloc_cpumask_var(&top_cpuset.cpus_allowed, GFP_KERNEL));
>  	BUG_ON(!alloc_cpumask_var(&top_cpuset.effective_cpus, GFP_KERNEL));
>  	BUG_ON(!zalloc_cpumask_var(&top_cpuset.subparts_cpus, GFP_KERNEL));
> -- 
> 2.38.1

Good catch.

Reviewed-by: Aaron Tomlin <atomlin-OvwSCxsgXNNBDgjK7y7TUQ@public.gmane.org>

-- 
Aaron Tomlin

