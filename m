From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 2/9] devcg: reorder device exception functions
Date: Wed, 30 Jan 2013 19:44:48 +0000
Message-ID: <20130130194448.GA10238@mail.hallyn.com>
References: <20130130171101.060853036@napanee.usersys.redhat.com>
 <20130130171101.406627645@napanee.usersys.redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130130171101.406627645-cd6kKtb6gxi3M6m420IelR/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

Quoting aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org (aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org):
> In preparation for the next patch, reorder dev_exception_add() and
> dev_exception_rm().
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
>  security/device_cgroup.c |   44 ++++++++++++++++++++++----------------------
>  1 file changed, 22 insertions(+), 22 deletions(-)
> 
> --- github.orig/security/device_cgroup.c	2013-01-29 11:49:14.739657516 -0500
> +++ github/security/device_cgroup.c	2013-01-29 11:49:14.987661210 -0500
> @@ -104,18 +104,14 @@ free_and_exit:
>  /*
>   * called under devcgroup_mutex
>   */
> -static int dev_exception_add(struct list_head *exceptions,
> +static void dev_exception_rm(struct list_head *exceptions,
>  			     struct dev_exception_item *ex)
>  {
> -	struct dev_exception_item *excopy, *walk;
> +	struct dev_exception_item *walk, *tmp;
>  
>  	lockdep_assert_held(&devcgroup_mutex);
>  
> -	excopy = kmemdup(ex, sizeof(*ex), GFP_KERNEL);
> -	if (!excopy)
> -		return -ENOMEM;
> -
> -	list_for_each_entry(walk, exceptions, list) {
> +	list_for_each_entry_safe(walk, tmp, exceptions, list) {
>  		if (walk->type != ex->type)
>  			continue;
>  		if (walk->major != ex->major)
> @@ -123,27 +119,29 @@ static int dev_exception_add(struct list
>  		if (walk->minor != ex->minor)
>  			continue;
>  
> -		walk->access |= ex->access;
> -		kfree(excopy);
> -		excopy = NULL;
> +		walk->access &= ~ex->access;
> +		if (!walk->access) {
> +			list_del_rcu(&walk->list);
> +			kfree_rcu(walk, rcu);
> +		}
>  	}
> -
> -	if (excopy != NULL)
> -		list_add_tail_rcu(&excopy->list, exceptions);
> -	return 0;
>  }
>  
>  /*
>   * called under devcgroup_mutex
>   */
> -static void dev_exception_rm(struct list_head *exceptions,
> +static int dev_exception_add(struct list_head *exceptions,
>  			     struct dev_exception_item *ex)
>  {
> -	struct dev_exception_item *walk, *tmp;
> +	struct dev_exception_item *excopy, *walk;
>  
>  	lockdep_assert_held(&devcgroup_mutex);
>  
> -	list_for_each_entry_safe(walk, tmp, exceptions, list) {
> +	excopy = kmemdup(ex, sizeof(*ex), GFP_KERNEL);
> +	if (!excopy)
> +		return -ENOMEM;
> +
> +	list_for_each_entry(walk, exceptions, list) {
>  		if (walk->type != ex->type)
>  			continue;
>  		if (walk->major != ex->major)
> @@ -151,12 +149,14 @@ static void dev_exception_rm(struct list
>  		if (walk->minor != ex->minor)
>  			continue;
>  
> -		walk->access &= ~ex->access;
> -		if (!walk->access) {
> -			list_del_rcu(&walk->list);
> -			kfree_rcu(walk, rcu);
> -		}
> +		walk->access |= ex->access;
> +		kfree(excopy);
> +		excopy = NULL;
>  	}
> +
> +	if (excopy != NULL)
> +		list_add_tail_rcu(&excopy->list, exceptions);
> +	return 0;
>  }
>  
>  static void __dev_exception_clean(struct dev_cgroup *dev_cgroup)
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
