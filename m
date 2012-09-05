From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 4/6] device_cgroup: stop using simple_strtoul()
Date: Wed, 5 Sep 2012 03:22:10 +0000
Message-ID: <20120905032209.GD13310@mail.hallyn.com>
References: <20120904143419.892872876@napanee.usersys.redhat.com>
 <20120904143421.144153057@napanee.usersys.redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20120904143421.144153057-cd6kKtb6gxi3M6m420IelR/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, James Morris <jmorris-gx6/JNMH7DfYtjvyW6yDsg@public.gmane.org>, Pavel Emelyanov <xemul-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Quoting Aristeu Rozanski (aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org):
> This patch converts the code to use kstrtou32() instead of simple_strtoul()
> which is deprecated. The real size of the variables are u32, so use kstrtou32
> instead of kstrtoul
> 
> Signed-off-by: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

phew, i'm afraid i'm not up on the latest 'best parsing techniques' 
but the end result looks correct (just not sure it's optimal).

Acked-by: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

> 
> ---
>  security/device_cgroup.c |   28 ++++++++++++++++++++++------
>  1 file changed, 22 insertions(+), 6 deletions(-)
> 
> Index: github/security/device_cgroup.c
> ===================================================================
> --- github.orig/security/device_cgroup.c	2012-08-21 10:51:05.751689805 -0400
> +++ github/security/device_cgroup.c	2012-08-21 10:51:15.015951623 -0400
> @@ -361,8 +361,8 @@
>  				   int filetype, const char *buffer)
>  {
>  	const char *b;
> -	char *endp;
> -	int count;
> +	char temp[12];		/* 11 + 1 characters needed for a u32 */
> +	int count, rc;
>  	struct dev_whitelist_item wh;
>  
>  	if (!capable(CAP_SYS_ADMIN))
> @@ -405,8 +405,16 @@
>  		wh.major = ~0;
>  		b++;
>  	} else if (isdigit(*b)) {
> -		wh.major = simple_strtoul(b, &endp, 10);
> -		b = endp;
> +		memset(temp, 0, sizeof(temp));
> +		for (count = 0; count < sizeof(temp) - 1; count++) {
> +			temp[count] = *b;
> +			b++;
> +			if (!isdigit(*b))
> +				break;
> +		}
> +		rc = kstrtou32(temp, 10, &wh.major);
> +		if (rc)
> +			return -EINVAL;
>  	} else {
>  		return -EINVAL;
>  	}
> @@ -419,8 +427,16 @@
>  		wh.minor = ~0;
>  		b++;
>  	} else if (isdigit(*b)) {
> -		wh.minor = simple_strtoul(b, &endp, 10);
> -		b = endp;
> +		memset(temp, 0, sizeof(temp));
> +		for (count = 0; count < sizeof(temp) - 1; count++) {
> +			temp[count] = *b;
> +			b++;
> +			if (!isdigit(*b))
> +				break;
> +		}
> +		rc = kstrtou32(temp, 10, &wh.minor);
> +		if (rc)
> +			return -EINVAL;
>  	} else {
>  		return -EINVAL;
>  	}
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
