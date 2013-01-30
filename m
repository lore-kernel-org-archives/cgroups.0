From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 4/9] devcg: expand may_access() logic
Date: Wed, 30 Jan 2013 20:09:20 +0000
Message-ID: <20130130200920.GB8507@mail.hallyn.com>
References: <20130130171101.060853036@napanee.usersys.redhat.com>
 <20130130171101.690972553@napanee.usersys.redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130130171101.690972553-cd6kKtb6gxi3M6m420IelR/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

Quoting aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org (aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org):
> In order to make the next patch more clear, expand may_access() logic.
> 
> v2: may_access() returns bool now
> 
> Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

Acked-by: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

> Signed-off-by: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> ---
>  security/device_cgroup.c |   21 ++++++++++++---------
>  1 file changed, 12 insertions(+), 9 deletions(-)
> 
> --- github.orig/security/device_cgroup.c	2013-01-30 08:56:29.532063723 -0500
> +++ github/security/device_cgroup.c	2013-01-30 08:58:02.934460404 -0500
> @@ -355,8 +355,8 @@ 	return 0;
>   * @dev_cgroup: dev cgroup to be tested against
>   * @refex: new exception
>   */
> -static int may_access(struct dev_cgroup *dev_cgroup,
> -		      struct dev_exception_item *refex)
> +static bool may_access(struct dev_cgroup *dev_cgroup,
> +		       struct dev_exception_item *refex)
>  {
>  	struct dev_exception_item *ex;
>  	bool match = false;
> @@ -382,16 +382,19 @@ 		if (ex->minor != ~0 && ex->minor != re
>  
>  	/*
>  	 * In two cases we'll consider this new exception valid:
> -	 * - the dev cgroup has its default policy to allow + exception list:
> -	 *   the new exception should *not* match any of the exceptions
> -	 *   (behavior == DEVCG_DEFAULT_ALLOW, !match)
>  	 * - the dev cgroup has its default policy to deny + exception list:
>  	 *   the new exception *should* match the exceptions
> -	 *   (behavior == DEVCG_DEFAULT_DENY, match)
> +	 * - the dev cgroup has its default policy to allow + exception list:
> +	 *   the new exception should *not* match any of the exceptions
>  	 */
> -	if ((dev_cgroup->behavior == DEVCG_DEFAULT_DENY) == match)
> -		return 1;
> -	return 0;
> +	if (dev_cgroup->behavior == DEVCG_DEFAULT_DENY) {
> +		if (match)
> +			return true;
> +	} else {
> +		if (!match)
> +			return true;
> +	}
> +	return false;
>  }
>  
>  /*
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
