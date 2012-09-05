From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 2/6] device_cgroup: introduce dev_whitelist_clean()
Date: Wed, 5 Sep 2012 03:03:47 +0000
Message-ID: <20120905030347.GB13310@mail.hallyn.com>
References: <20120904143419.892872876@napanee.usersys.redhat.com>
 <20120904143420.546524755@napanee.usersys.redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120904143420.546524755-cd6kKtb6gxi3M6m420IelR/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Quoting Aristeu Rozanski (aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org):
> This function cleans all the items in a whitelist and will be used by the next
> patches.
> 
> v2:
> - no changes
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
>  security/device_cgroup.c |   22 +++++++++++++++++-----
>  1 file changed, 17 insertions(+), 5 deletions(-)
> 
> Index: github/security/device_cgroup.c
> ===================================================================
> --- github.orig/security/device_cgroup.c	2012-08-21 10:50:34.650810797 -0400
> +++ github/security/device_cgroup.c	2012-08-21 10:50:37.526892088 -0400
> @@ -157,6 +157,22 @@
>  	}
>  }
>  
> +/**
> + * dev_whitelist_clean - frees all entries of the whitelist
> + * @dev_cgroup: dev_cgroup with the whitelist to be cleaned
> + *
> + * called under devcgroup_mutex
> + */
> +static void dev_whitelist_clean(struct dev_cgroup *dev_cgroup)
> +{
> +	struct dev_whitelist_item *wh, *tmp;
> +
> +	list_for_each_entry_safe(wh, tmp, &dev_cgroup->whitelist, list) {
> +		list_del(&wh->list);
> +		kfree(wh);
> +	}
> +}
> +
>  /*
>   * called from kernel/cgroup.c with cgroup_lock() held.
>   */
> @@ -203,13 +219,9 @@
>  static void devcgroup_destroy(struct cgroup *cgroup)
>  {
>  	struct dev_cgroup *dev_cgroup;
> -	struct dev_whitelist_item *wh, *tmp;
>  
>  	dev_cgroup = cgroup_to_devcgroup(cgroup);
> -	list_for_each_entry_safe(wh, tmp, &dev_cgroup->whitelist, list) {
> -		list_del(&wh->list);
> -		kfree(wh);
> -	}
> +	dev_whitelist_clean(dev_cgroup);
>  	kfree(dev_cgroup);
>  }
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
