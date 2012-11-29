From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/5] device_cgroup: fix locking in devcgroup_destroy()
Date: Thu, 29 Nov 2012 19:06:26 +0000
Message-ID: <20121129190626.GA26104@mail.hallyn.com>
References: <20121127193501.255267751@napanee.usersys.redhat.com>
 <20121127193501.728193744@napanee.usersys.redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121127193501.728193744-cd6kKtb6gxi3M6m420IelR/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Quoting Aristeu Rozanski (aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org):
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

Acked-by: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

> Signed-off-by: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> ---
>  security/device_cgroup.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> Index: github/security/device_cgroup.c
> ===================================================================
> --- github.orig/security/device_cgroup.c	2012-11-26 17:13:54.008153189 -0500
> +++ github/security/device_cgroup.c	2012-11-27 11:58:43.574251075 -0500
> @@ -215,7 +215,11 @@
>  	struct dev_cgroup *dev_cgroup;
>  
>  	dev_cgroup = cgroup_to_devcgroup(cgroup);
> +
> +	mutex_lock(&devcgroup_mutex);
>  	dev_exception_clean(dev_cgroup);
> +	mutex_unlock(&devcgroup_mutex);
> +
>  	kfree(dev_cgroup);
>  }
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
