From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 7/9] devcg: split single exception copy from
 dev_exceptions_copy()
Date: Wed, 30 Jan 2013 20:42:40 +0000
Message-ID: <20130130204240.GE8507@mail.hallyn.com>
References: <20130130171101.060853036@napanee.usersys.redhat.com>
 <20130130171102.108794435@napanee.usersys.redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130130171102.108794435-cd6kKtb6gxi3M6m420IelR/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

Quoting aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org (aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org):
> This patch is in preparation for hierarchy support
> 
> This patch doesn't introduce any functional changes.
> 
> Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

Acked-by: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

> Signed-off-by: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> ---
>  security/device_cgroup.c |   18 ++++++++++++++----
>  1 file changed, 14 insertions(+), 4 deletions(-)
> 
> --- github.orig/security/device_cgroup.c	2013-01-29 11:49:16.076677425 -0500
> +++ github/security/device_cgroup.c	2013-01-29 11:49:16.374681863 -0500
> @@ -89,20 +89,30 @@ static int devcgroup_can_attach(struct c
>  	return 0;
>  }
>  
> +static int dev_exception_copy(struct list_head *dest,
> +			      struct dev_exception_item *ex)
> +{
> +	struct dev_exception_item *new;
> +
> +	new = kmemdup(ex, sizeof(*ex), GFP_KERNEL);
> +	if (!new)
> +		return -ENOMEM;
> +	list_add_tail(&new->list, dest);
> +	return 0;
> +}
> +
>  /*
>   * called under devcgroup_mutex
>   */
>  static int dev_exceptions_copy(struct list_head *dest, struct list_head *orig)
>  {
> -	struct dev_exception_item *ex, *tmp, *new;
> +	struct dev_exception_item *ex, *tmp;
>  
>  	lockdep_assert_held(&devcgroup_mutex);
>  
>  	list_for_each_entry(ex, orig, list) {
> -		new = kmemdup(ex, sizeof(*ex), GFP_KERNEL);
> -		if (!new)
> +		if (dev_exception_copy(dest, ex))
>  			goto free_and_exit;
> -		list_add_tail(&new->list, dest);
>  	}
>  
>  	return 0;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
