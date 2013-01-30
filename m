From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 6/9] devcg: use css_online and css_offline
Date: Wed, 30 Jan 2013 20:40:07 +0000
Message-ID: <20130130204007.GD8507@mail.hallyn.com>
References: <20130130171101.060853036@napanee.usersys.redhat.com>
 <20130130171101.947461296@napanee.usersys.redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130130171101.947461296-cd6kKtb6gxi3M6m420IelR/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

Quoting aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org (aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org):
> Allocate resources and change behavior only when online. This is needed in
> order to determine if a node is suitable for hierarchy propagation or if it's
> being removed.
> 
> Locking:
> Both functions take devcgroup_mutex to make changes to device_cgroup structure.
> Hierarchy propagation will also take devcgroup_mutex before walking the
> tree while walking the tree itself is protected by rcu lock.
> 
> Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

Acked-by: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

> Signed-off-by: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> ---
>  security/device_cgroup.c |   59 +++++++++++++++++++++++++++++++++--------------
>  1 file changed, 42 insertions(+), 17 deletions(-)
> 
> --- github.orig/security/device_cgroup.c	2013-01-30 09:00:09.435351867 -0500
> +++ github/security/device_cgroup.c	2013-01-30 09:09:12.572464122 -0500
> @@ -230,14 +230,51 @@ static void dev_exception_clean(struct d
>  	__dev_exception_clean(dev_cgroup);
>  }
>  
> +/**
> + * devcgroup_online - initializes devcgroup's behavior and exceptions based on
> + * 		      parent's
> + * @cgroup: cgroup getting online
> + * returns 0 in case of success, error code otherwise
> + */
> +static int devcgroup_online(struct cgroup *cgroup)
> +{
> +	struct dev_cgroup *dev_cgroup, *parent_dev_cgroup = NULL;
> +	int ret = 0;
> +
> +	mutex_lock(&devcgroup_mutex);
> +	dev_cgroup = cgroup_to_devcgroup(cgroup);
> +	if (cgroup->parent)
> +		parent_dev_cgroup = cgroup_to_devcgroup(cgroup->parent);
> +
> +	if (parent_dev_cgroup == NULL)
> +		dev_cgroup->behavior = DEVCG_DEFAULT_ALLOW;
> +	else {
> +		ret = dev_exceptions_copy(&dev_cgroup->exceptions,
> +					  &parent_dev_cgroup->exceptions);
> +		if (!ret)
> +			dev_cgroup->behavior = parent_dev_cgroup->behavior;
> +	}
> +	mutex_unlock(&devcgroup_mutex);
> +
> +	return ret;
> +}
> +
> +static void devcgroup_offline(struct cgroup *cgroup)
> +{
> +	struct dev_cgroup *dev_cgroup = cgroup_to_devcgroup(cgroup);
> +
> +	mutex_lock(&devcgroup_mutex);
> +	dev_cgroup->behavior = DEVCG_DEFAULT_NONE;
> +	mutex_unlock(&devcgroup_mutex);
> +}
> +
>  /*
>   * called from kernel/cgroup.c with cgroup_lock() held.
>   */
>  static struct cgroup_subsys_state *devcgroup_css_alloc(struct cgroup *cgroup)
>  {
> -	struct dev_cgroup *dev_cgroup, *parent_dev_cgroup;
> +	struct dev_cgroup *dev_cgroup;
>  	struct cgroup *parent_cgroup;
> -	int ret;
>  
>  	dev_cgroup = kzalloc(sizeof(*dev_cgroup), GFP_KERNEL);
>  	if (!dev_cgroup)
> @@ -245,23 +282,9 @@ static struct cgroup_subsys_state *devcg
>  	INIT_LIST_HEAD(&dev_cgroup->exceptions);
>  	INIT_LIST_HEAD(&dev_cgroup->local.exceptions);
>  	dev_cgroup->local.behavior = DEVCG_DEFAULT_NONE;
> +	dev_cgroup->behavior = DEVCG_DEFAULT_NONE;
>  	parent_cgroup = cgroup->parent;
>  
> -	if (parent_cgroup == NULL)
> -		dev_cgroup->behavior = DEVCG_DEFAULT_ALLOW;
> -	else {
> -		parent_dev_cgroup = cgroup_to_devcgroup(parent_cgroup);
> -		mutex_lock(&devcgroup_mutex);
> -		ret = dev_exceptions_copy(&dev_cgroup->exceptions,
> -					  &parent_dev_cgroup->exceptions);
> -		dev_cgroup->behavior = parent_dev_cgroup->behavior;
> -		mutex_unlock(&devcgroup_mutex);
> -		if (ret) {
> -			kfree(dev_cgroup);
> -			return ERR_PTR(ret);
> -		}
> -	}
> -
>  	return &dev_cgroup->css;
>  }
>  
> @@ -635,6 +658,8 @@ struct cgroup_subsys devices_subsys = {
>  	.can_attach = devcgroup_can_attach,
>  	.css_alloc = devcgroup_css_alloc,
>  	.css_free = devcgroup_css_free,
> +	.css_online = devcgroup_online,
> +	.css_offline = devcgroup_offline,
>  	.subsys_id = devices_subsys_id,
>  	.base_cftypes = dev_cgroup_files,
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
