From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 1/9] device_cgroup: prepare exception list handling
 functions for two lists
Date: Wed, 30 Jan 2013 17:41:40 +0000
Message-ID: <20130130174140.GA6411@mail.hallyn.com>
References: <20130129190759.117458287@napanee.usersys.redhat.com>
 <20130129190759.321644928@napanee.usersys.redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130129190759.321644928-cd6kKtb6gxi3M6m420IelR/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

Quoting aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org (aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org):
> In the following patches, device_cgroup structure will have two sets of
> behavior and exceptions list (actual one, another with the local settings)
> so rework the functions to use exception list, not a device_cgroup.
> 
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

Hi,

near as I can tell this is identical to the one I acked on Nov 20?

Acked-by: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

> Signed-off-by: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> ---
>  security/device_cgroup.c |   18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> --- github.orig/security/device_cgroup.c	2013-01-29 11:48:50.603298122 -0500
> +++ github/security/device_cgroup.c	2013-01-29 11:49:14.739657516 -0500
> @@ -104,7 +104,7 @@ free_and_exit:
>  /*
>   * called under devcgroup_mutex
>   */
> -static int dev_exception_add(struct dev_cgroup *dev_cgroup,
> +static int dev_exception_add(struct list_head *exceptions,
>  			     struct dev_exception_item *ex)
>  {
>  	struct dev_exception_item *excopy, *walk;
> @@ -115,7 +115,7 @@ static int dev_exception_add(struct dev_
>  	if (!excopy)
>  		return -ENOMEM;
>  
> -	list_for_each_entry(walk, &dev_cgroup->exceptions, list) {
> +	list_for_each_entry(walk, exceptions, list) {
>  		if (walk->type != ex->type)
>  			continue;
>  		if (walk->major != ex->major)
> @@ -129,21 +129,21 @@ static int dev_exception_add(struct dev_
>  	}
>  
>  	if (excopy != NULL)
> -		list_add_tail_rcu(&excopy->list, &dev_cgroup->exceptions);
> +		list_add_tail_rcu(&excopy->list, exceptions);
>  	return 0;
>  }
>  
>  /*
>   * called under devcgroup_mutex
>   */
> -static void dev_exception_rm(struct dev_cgroup *dev_cgroup,
> +static void dev_exception_rm(struct list_head *exceptions,
>  			     struct dev_exception_item *ex)
>  {
>  	struct dev_exception_item *walk, *tmp;
>  
>  	lockdep_assert_held(&devcgroup_mutex);
>  
> -	list_for_each_entry_safe(walk, tmp, &dev_cgroup->exceptions, list) {
> +	list_for_each_entry_safe(walk, tmp, exceptions, list) {
>  		if (walk->type != ex->type)
>  			continue;
>  		if (walk->major != ex->major)
> @@ -514,10 +514,10 @@ 		case '\0':
>  		 * don't want to break compatibility
>  		 */
>  		if (devcgroup->behavior == DEVCG_DEFAULT_ALLOW) {
> -			dev_exception_rm(devcgroup, &ex);
> +			dev_exception_rm(&devcgroup->exceptions, &ex);
>  			return 0;
>  		}
> -		return dev_exception_add(devcgroup, &ex);
> +		return dev_exception_add(&devcgroup->exceptions, &ex);
>  	case DEVCG_DENY:
>  		/*
>  		 * If the default policy is to deny by default, try to remove
> @@ -525,10 +525,10 @@ 			return 0;
>  		 * don't want to break compatibility
>  		 */
>  		if (devcgroup->behavior == DEVCG_DEFAULT_DENY) {
> -			dev_exception_rm(devcgroup, &ex);
> +			dev_exception_rm(&devcgroup->exceptions, &ex);
>  			return 0;
>  		}
> -		return dev_exception_add(devcgroup, &ex);
> +		return dev_exception_add(&devcgroup->exceptions, &ex);
>  	default:
>  		return -EINVAL;
>  	}
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
