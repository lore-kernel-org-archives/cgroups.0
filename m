From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 1/6] device_cgroup: add "behavior" in dev_cgroup
 structure
Date: Wed, 5 Sep 2012 03:00:25 +0000
Message-ID: <20120905030025.GA13310@mail.hallyn.com>
References: <20120904143419.892872876@napanee.usersys.redhat.com>
 <20120904143420.234142640@napanee.usersys.redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120904143420.234142640-cd6kKtb6gxi3M6m420IelR/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Quoting Aristeu Rozanski (aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org):
> behavior will determine if the default policy is to deny all device access
> unless for the ones in the exception list.
> 
> This variable will be used in the next patches to convert device_cgroup
> internally into a default policy + rules.
> 
> v2:
> - renamed deny_all to behavior
> 
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Cc: James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>
> Cc: Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
> Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

Acked-by: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

> Signed-off-by: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> ---
>  security/device_cgroup.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> Index: github/security/device_cgroup.c
> ===================================================================
> --- github.orig/security/device_cgroup.c	2012-08-21 09:49:38.698415513 -0400
> +++ github/security/device_cgroup.c	2012-08-21 10:50:34.650810797 -0400
> @@ -42,6 +42,10 @@
>  struct dev_cgroup {
>  	struct cgroup_subsys_state css;
>  	struct list_head whitelist;
> +	enum {
> +		DEVCG_DEFAULT_ALLOW,
> +		DEVCG_DEFAULT_DENY,
> +	} behavior;
>  };
>  
>  static inline struct dev_cgroup *css_to_devcgroup(struct cgroup_subsys_state *s)
> @@ -178,12 +182,14 @@
>  		wh->minor = wh->major = ~0;
>  		wh->type = DEV_ALL;
>  		wh->access = ACC_MASK;
> +		dev_cgroup->behavior = DEVCG_DEFAULT_ALLOW;
>  		list_add(&wh->list, &dev_cgroup->whitelist);
>  	} else {
>  		parent_dev_cgroup = cgroup_to_devcgroup(parent_cgroup);
>  		mutex_lock(&devcgroup_mutex);
>  		ret = dev_whitelist_copy(&dev_cgroup->whitelist,
>  				&parent_dev_cgroup->whitelist);
> +		dev_cgroup->behavior = parent_dev_cgroup->behavior;
>  		mutex_unlock(&devcgroup_mutex);
>  		if (ret) {
>  			kfree(dev_cgroup);
> @@ -409,9 +415,11 @@
>  	case DEVCG_ALLOW:
>  		if (!parent_has_perm(devcgroup, &wh))
>  			return -EPERM;
> +		devcgroup->behavior = DEVCG_DEFAULT_ALLOW;
>  		return dev_whitelist_add(devcgroup, &wh);
>  	case DEVCG_DENY:
>  		dev_whitelist_rm(devcgroup, &wh);
> +		devcgroup->behavior = DEVCG_DEFAULT_DENY;
>  		break;
>  	default:
>  		return -EINVAL;
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
