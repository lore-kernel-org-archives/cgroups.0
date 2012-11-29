From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/5] device_cgroup: prepare exception list handling
 functions for two lists
Date: Thu, 29 Nov 2012 19:07:51 +0000
Message-ID: <20121129190751.GB26104@mail.hallyn.com>
References: <20121127193501.255267751@napanee.usersys.redhat.com>
 <20121127193502.078661224@napanee.usersys.redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121127193502.078661224-cd6kKtb6gxi3M6m420IelR/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Quoting Aristeu Rozanski (aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org):
> In the following patches, device_cgroup structure will have two sets of
> behavior and exceptions list (actual one, another with the local settings)
> so rework the functions to use exception list, not a device_cgroup.
> 
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

Acked-by: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

> Signed-off-by: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> ---
>  security/device_cgroup.c |   18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
> 
> Index: github/security/device_cgroup.c
> ===================================================================
> --- github.orig/security/device_cgroup.c	2012-11-26 17:13:55.972206330 -0500
> +++ github/security/device_cgroup.c	2012-11-27 11:58:28.025841706 -0500
> @@ -104,7 +104,7 @@
>  /*
>   * called under devcgroup_mutex
>   */
> -static int dev_exception_add(struct dev_cgroup *dev_cgroup,
> +static int dev_exception_add(struct list_head *exceptions,
>  			     struct dev_exception_item *ex)
>  {
>  	struct dev_exception_item *excopy, *walk;
> @@ -115,7 +115,7 @@
>  	if (!excopy)
>  		return -ENOMEM;
>  
> -	list_for_each_entry(walk, &dev_cgroup->exceptions, list) {
> +	list_for_each_entry(walk, exceptions, list) {
>  		if (walk->type != ex->type)
>  			continue;
>  		if (walk->major != ex->major)
> @@ -129,21 +129,21 @@
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
> @@ -513,10 +513,10 @@
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
> @@ -524,10 +524,10 @@
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
