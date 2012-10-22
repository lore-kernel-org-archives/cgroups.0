From: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH 4/4] device_cgroup: add proper checking when changing
 default behavior
Date: Mon, 22 Oct 2012 11:16:10 -0500
Message-ID: <20121022161610.GD23199@sergelap>
References: <20121022134536.172969567@napanee.usersys.redhat.com>
 <20121022134537.447117744@napanee.usersys.redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121022134537.447117744-cd6kKtb6gxi3M6m420IelR/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Quoting Aristeu Rozanski (aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org):
> Before changing a group's default behavior to ALLOW, we must check if its
> parent's behavior is also ALLOW.
> 
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> Cc: James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>
> Cc: Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
> Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

Acked-by: Serge E. Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

Thanks, Aristeu.

> Cc: Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>
> Signed-off-by: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> ---
>  security/device_cgroup.c |   19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
> 
> --- github.orig/security/device_cgroup.c	2012-10-19 16:36:50.135790476 -0400
> +++ github/security/device_cgroup.c	2012-10-19 16:48:50.710978125 -0400
> @@ -344,6 +344,17 @@ static int parent_has_perm(struct dev_cg
>  	return may_access(parent, ex);
>  }
>  
> +/**
> + * may_allow_all - checks if it's possible to change the behavior to
> + *		   allow based on parent's rules.
> + * @parent: device cgroup's parent
> + * returns: != 0 in case it's allowed, 0 otherwise
> + */
> +static inline int may_allow_all(struct dev_cgroup *parent)
> +{
> +	return parent->behavior == DEVCG_DEFAULT_ALLOW;
> +}
> +
>  /*
>   * Modify the exception list using allow/deny rules.
>   * CAP_SYS_ADMIN is needed for this.  It's at least separate from CAP_MKNOD
> @@ -364,6 +375,8 @@ static int devcgroup_update_access(struc
>  	char temp[12];		/* 11 + 1 characters needed for a u32 */
>  	int count, rc;
>  	struct dev_exception_item ex;
> +	struct cgroup *p = devcgroup->css.cgroup;
> +	struct dev_cgroup *parent = cgroup_to_devcgroup(p->parent);
>  
>  	if (!capable(CAP_SYS_ADMIN))
>  		return -EPERM;
> @@ -375,9 +388,13 @@ 	memset(&ex, 0, sizeof(ex));
>  	case 'a':
>  		switch (filetype) {
>  		case DEVCG_ALLOW:
> -			if (!parent_has_perm(devcgroup, &ex))
> +			if (!may_allow_all(parent))
>  				return -EPERM;
>  			dev_exception_clean(devcgroup);
> +			rc = dev_exceptions_copy(&devcgroup->exceptions,
> +						 &parent->exceptions);
> +			if (rc)
> +				return rc;
>  			devcgroup->behavior = DEVCG_DEFAULT_ALLOW;
>  			break;
>  		case DEVCG_DENY:
> 
