From: Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>
Subject: Re: [PATCH 1/3] nitpick: make simple functions inline
Date: Wed, 14 Dec 2011 09:09:25 +0800
Message-ID: <4EE7F745.3040508@cn.fujitsu.com>
References: <1323614738-7405-1-git-send-email-glommer@parallels.com> <1323614738-7405-3-git-send-email-glommer@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1323614738-7405-3-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jbottomley-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

22:45, Glauber Costa wrote:
> Those are quite simple bit-testing functions that are
> only used within this file. Not reason for them not to
> be inline.
> 

It's better to leave the optimization decision to gcc.

And I've confirmed they are inlined by gcc in my box.

(btw, please add "cgroup" prefix to the patch subject line)

> Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
> ---
>  kernel/cgroup.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index d9d5648..e4b9d3c 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -241,12 +241,12 @@ static int cgroup_is_releasable(const struct cgroup *cgrp)
>  	return (cgrp->flags & bits) == bits;
>  }
>  
> -static int notify_on_release(const struct cgroup *cgrp)
> +static inline int notify_on_release(const struct cgroup *cgrp)
>  {
>  	return test_bit(CGRP_NOTIFY_ON_RELEASE, &cgrp->flags);
>  }
>  
> -static int clone_children(const struct cgroup *cgrp)
> +static inline int clone_children(const struct cgroup *cgrp)
>  {
>  	return test_bit(CGRP_CLONE_CHILDREN, &cgrp->flags);
>  }
--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
