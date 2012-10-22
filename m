From: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: Re: [PATCH 3/4] device_cgroup: stop using simple_strtoul()
Date: Mon, 22 Oct 2012 11:14:54 -0500
Message-ID: <20121022161454.GC23199@sergelap>
References: <20121022134536.172969567@napanee.usersys.redhat.com>
 <20121022134537.125748392@napanee.usersys.redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121022134537.125748392-cd6kKtb6gxi3M6m420IelR/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Jiri Slaby <jslaby-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Quoting Aristeu Rozanski (aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org):
> This patch converts the code to use kstrtou32() instead of simple_strtoul()
> which is deprecated. The real size of the variables are u32, so use kstrtou32
> instead of kstrtoul
> 
> 
> Cc: Dave Jones <davej-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
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
> ---
>  security/device_cgroup.c |   28 ++++++++++++++++++++++------
>  1 file changed, 22 insertions(+), 6 deletions(-)
> 
> --- github.orig/security/device_cgroup.c	2012-10-19 16:35:46.366102913 -0400
> +++ github/security/device_cgroup.c	2012-10-19 16:35:50.801229331 -0400
> @@ -361,8 +361,8 @@ static int devcgroup_update_access(struc
>  				   int filetype, const char *buffer)
>  {
>  	const char *b;
> -	char *endp;
> -	int count;
> +	char temp[12];		/* 11 + 1 characters needed for a u32 */
> +	int count, rc;
>  	struct dev_exception_item ex;
>  
>  	if (!capable(CAP_SYS_ADMIN))
> @@ -405,8 +405,16 @@ 		return 0;
>  		ex.major = ~0;
>  		b++;
>  	} else if (isdigit(*b)) {
> -		ex.major = simple_strtoul(b, &endp, 10);
> -		b = endp;
> +		memset(temp, 0, sizeof(temp));
> +		for (count = 0; count < sizeof(temp) - 1; count++) {
> +			temp[count] = *b;
> +			b++;
> +			if (!isdigit(*b))
> +				break;
> +		}
> +		rc = kstrtou32(temp, 10, &ex.major);
> +		if (rc)
> +			return -EINVAL;
>  	} else {
>  		return -EINVAL;
>  	}
> @@ -419,8 +427,16 @@ 		ex.major = simple_strtoul(b, &endp, 10
>  		ex.minor = ~0;
>  		b++;
>  	} else if (isdigit(*b)) {
> -		ex.minor = simple_strtoul(b, &endp, 10);
> -		b = endp;
> +		memset(temp, 0, sizeof(temp));
> +		for (count = 0; count < sizeof(temp) - 1; count++) {
> +			temp[count] = *b;
> +			b++;
> +			if (!isdigit(*b))
> +				break;
> +		}
> +		rc = kstrtou32(temp, 10, &ex.minor);
> +		if (rc)
> +			return -EINVAL;
>  	} else {
>  		return -EINVAL;
>  	}
> 
