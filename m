From: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH] device_cgroup: fix unchecked cgroup parent usage
Date: Wed, 31 Oct 2012 18:21:01 +0100
Message-ID: <20121031172101.GC20848@serge-ThinkPad-X130e>
References: <20121031160430.GD14789@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121031160430.GD14789-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Quoting Aristeu Rozanski (aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org):
> In 4cef7299b4786879a3e113e84084a72b24590c5b the cgroup parent usage is
> unchecked. root will not have a parent and trying to use
> device.{allow,deny} will cause problems. For some reason my stressing
> scripts didn't test the root directory so I didn't catch it on my
> regular tests.
> 
> Andrew, Tejun, this patch needs to make Linus tree ASAP or a revert for
> 4cef7299b4786879a3e113e84084a72b24590c5b.
> 
> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Cc: James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>
> Cc: Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
> Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

Acked-by: Serge E. Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

> Cc: Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>
> Signed-off-by: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> --- github.orig/security/device_cgroup.c	2012-10-26 17:18:01.739366780 -0400
> +++ github/security/device_cgroup.c	2012-10-29 10:03:33.221918003 -0400
> @@ -352,6 +352,8 @@
>   */
>  static inline int may_allow_all(struct dev_cgroup *parent)
>  {
> +	if (!parent)
> +		return 1;
>  	return parent->behavior == DEVCG_DEFAULT_ALLOW;
>  }
>  
> @@ -376,11 +378,14 @@
>  	int count, rc;
>  	struct dev_exception_item ex;
>  	struct cgroup *p = devcgroup->css.cgroup;
> -	struct dev_cgroup *parent = cgroup_to_devcgroup(p->parent);
> +	struct dev_cgroup *parent = NULL;
>  
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EPERM;
>  
> +	if (p->parent)
> +		parent = cgroup_to_devcgroup(p->parent);
> +
>  	memset(&ex, 0, sizeof(ex));
>  	b = buffer;
>  
> @@ -391,11 +396,14 @@
>  			if (!may_allow_all(parent))
>  				return -EPERM;
>  			dev_exception_clean(devcgroup);
> +			devcgroup->behavior = DEVCG_DEFAULT_ALLOW;
> +			if (!parent)
> +				break;
> +
>  			rc = dev_exceptions_copy(&devcgroup->exceptions,
>  						 &parent->exceptions);
>  			if (rc)
>  				return rc;
> -			devcgroup->behavior = DEVCG_DEFAULT_ALLOW;
>  			break;
>  		case DEVCG_DENY:
>  			dev_exception_clean(devcgroup);
