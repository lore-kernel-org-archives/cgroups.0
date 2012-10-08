From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [REGRESSION] cgroup: notify_on_release may not be triggered in
 some cases
Date: Mon, 8 Oct 2012 14:11:12 +0800
Message-ID: <50726E80.4040204@huawei.com>
References: <20121004163716.64dae034dab9eafa2b6e6a8f@mxp.nes.nec.co.jp>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20121004163716.64dae034dab9eafa2b6e6a8f-YQH0OdQVrdy45+QrQBaojngSJqDPrsil@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Daisuke Nishimura <nishimura-YQH0OdQVrdy45+QrQBaojngSJqDPrsil@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ben Blum <bblum-OM76b2Iv3yLQjUSlxSEPGw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On 2012/10/4 15:37, Daisuke Nishimura wrote:
> notify_on_release must be triggered when the last process in a cgroup is
> move to another. But if the first(and only) process in a cgroup is moved to
> another, notify_on_release is not triggered.
> 
> 	# mkdir /cgroup/cpu/SRC
> 	# mkdir /cgroup/cpu/DST
> 	#
> 	# echo 1 >/cgroup/cpu/SRC/notify_on_release
> 	# echo 1 >/cgroup/cpu/DST/notify_on_release
> 	#
> 	# sleep 300 &
> 	[1] 8629
> 	#
> 	# echo 8629 >/cgroup/cpu/SRC/tasks
> 	# echo 8629 >/cgroup/cpu/DST/tasks
> 	-> notify_on_release for /SRC must be triggered at this point,
> 	   but it isn't.
> 
> This is because put_css_set() is called before setting CGRP_RELEASABLE
> in cgroup_task_migrate(), and is a regression introduce by the
> commit:74a1166d(cgroups: make procs file writable), which was merged
> into v3.0.
> 
> Cc: Ben Blum <bblum-OM76b2Iv3yLQjUSlxSEPGw@public.gmane.org>
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # v3.0.x and later
> Signed-off-by: Daisuke Nishimura <nishimura-YQH0OdQVrdy45+QrQBaojngSJqDPrsil@public.gmane.org>
> ---
> This patch is based on v3.6.
> 
>  kernel/cgroup.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 7981850..7d01182 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -1923,9 +1923,8 @@ static void cgroup_task_migrate(struct cgroup *cgrp, struct cgroup *oldcgrp,
>  	 * trading it for newcg is protected by cgroup_mutex, we're safe to drop
>  	 * it here; it will be freed under RCU.
>  	 */
> -	put_css_set(oldcg);
> -
>  	set_bit(CGRP_RELEASABLE, &oldcgrp->flags);
> +	put_css_set(oldcg);

Good catch. Also we might end up with invalid memory access! 

Acked-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

>  }
>  
>  /**
> 
