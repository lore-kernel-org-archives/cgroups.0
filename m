From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 3/4] device_cgroup: make may_access() stronger
Date: Thu, 24 Jan 2013 14:13:27 -0800
Message-ID: <20130124221327.GX2373@mtj.dyndns.org>
References: <20130124194957.198022148@napanee.usersys.redhat.com>
 <20130124194957.663514303@napanee.usersys.redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=sIEwtZ0+Bj87pDCZHooYlGbt2KCxx4xd6jHgmDiQpNw=;
        b=bgYVSqJ0CwVkg/s3/ifBdjfwQ4XVAx8MF3veQlXSziKSRbylgCVDLEak4+HElRSwKO
         7feUWlbUKbrisD44ph82lfbVCucA8oqgBWgsUBo5robYvxcyj/KUBBInvY92NSPj8W42
         c4rGteVM+eySzfhngVsmFf+mgzykM7dSpuRg7O3P+veLGcqGLguIteRI/wKQtC01K2tU
         yE7CmSCaYSwjHAh6EWCIZa0i02V84lhWBQGApnrJUEMzZHBboMb4G4EokZ/++4+UPrlE
         SmHZPsFWF83oL9pUJhPqrYQoLuciFKq434Q/eghwGm/y2fecVpPXLVtBScxMTizX9eIY
         GBbg==
Content-Disposition: inline
In-Reply-To: <20130124194957.663514303-cd6kKtb6gxi3M6m420IelR/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

Hello,

On Thu, Jan 24, 2013 at 02:50:00PM -0500, aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org wrote:
> In order to revalidate local exceptions for the hierarchy change propagation,
> make may_access() stronger.

It would be nice to explain what "stronger" actually means.

> --- github.orig/security/device_cgroup.c	2013-01-24 10:40:46.384253615 -0500
> +++ github/security/device_cgroup.c	2013-01-24 10:41:07.513567697 -0500
> @@ -353,13 +353,15 @@ 	return 0;
>   *		won't have more privileges than its parent or to
>   *		verify if a certain access is allowed.
>   * @dev_cgroup: dev cgroup to be tested against
> + * @behavior: behavior of the exception

Should come after @refex?

>   * @refex: new exception
>   */
> -static int may_access(struct dev_cgroup *dev_cgroup,
> -		      struct dev_exception_item *refex)
> +static bool may_access(struct dev_cgroup *dev_cgroup,
> +		       struct dev_exception_item *refex,
> +		       enum devcg_behavior behavior)
>  {
>  	struct dev_exception_item *ex;
> -	bool match = false;
> +	int match = false;
>  
>  	rcu_lockdep_assert(rcu_read_lock_held() ||
>  			   lockdep_is_held(&devcgroup_mutex),
> @@ -380,18 +382,28 @@ 		if (ex->minor != ~0 && ex->minor != re
>  		break;
>  	}
>  
> -	/*
> -	 * In two cases we'll consider this new exception valid:
> -	 * - the dev cgroup has its default policy to allow + exception list:
> -	 *   the new exception should *not* match any of the exceptions
> -	 *   (behavior == DEVCG_DEFAULT_ALLOW, !match)
> -	 * - the dev cgroup has its default policy to deny + exception list:
> -	 *   the new exception *should* match the exceptions
> -	 *   (behavior == DEVCG_DEFAULT_DENY, match)
> -	 */
> -	if ((dev_cgroup->behavior == DEVCG_DEFAULT_DENY) == match)
> -		return 1;
> -	return 0;
> +	if (dev_cgroup->behavior == DEVCG_DEFAULT_ALLOW) {
> +		if (behavior == DEVCG_DEFAULT_ALLOW) {
> +			/* the exception will deny access to certain devices */
> +			return true;
> +		} else {
> +			/* the exception will allow access to certain devices */
> +			if (match)
> +				/*
> +				 * a new exception allowing access shouldn't
> +				 * match an parent's exception
> +				 */
> +				return false;
> +			return true;
> +		}
> +	} else {
> +		/* only behavior == DEVCG_DEFAULT_DENY allowed here */
> +		if (match)
> +			/* parent has an exception that matches the proposed */
> +			return true;
> +		else
> +			return false;

It would be nice if there were a separate patch to decompress the
logic separate from adding new logic.

Thanks.

-- 
tejun
