From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 04/14] device_cgroup: remove direct access to
 cgroup->children
Date: Wed, 14 May 2014 14:52:54 +0200
Message-ID: <20140514125254.GA30376@mail.hallyn.com>
References: <1399671091-23867-1-git-send-email-tj@kernel.org>
 <1399671091-23867-5-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1399671091-23867-5-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

Quoting Tejun Heo (tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org):
> Currently, devcg::has_children() directly tests cgroup->children for
> list emptiness.  The field is not a published field and scheduled to
> go away.  In addition, the test isn't strictly correct as devcg should
> only care about children which are visible to userland.
> 
> This patch converts has_children() to use css_next_child() instead.
> The subtle incorrectness is noted and will be dealt with later.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

Acked-by: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

> ---
>  security/device_cgroup.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/security/device_cgroup.c b/security/device_cgroup.c
> index 3116015..75b4b18 100644
> --- a/security/device_cgroup.c
> +++ b/security/device_cgroup.c
> @@ -477,9 +477,17 @@ static int propagate_exception(struct dev_cgroup *devcg_root,
>  
>  static inline bool has_children(struct dev_cgroup *devcgroup)
>  {
> -	struct cgroup *cgrp = devcgroup->css.cgroup;
> +	bool ret;
>  
> -	return !list_empty(&cgrp->children);
> +	/*
> +	 * FIXME: There may be lingering offline csses and this function
> +	 * may return %true when there isn't any userland-visible child
> +	 * which is incorrect for our purposes.
> +	 */
> +	rcu_read_lock();
> +	ret = css_next_child(NULL, &devcgroup->css);
> +	rcu_read_unlock();
> +	return ret;
>  }
>  
>  /*
> -- 
> 1.9.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
