From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: add explicit cast and comment for return type
 conversion
Date: Sun, 24 May 2015 16:35:28 -0400
Message-ID: <20150524203528.GB7099@htj.duckdns.org>
References: <1432472872-3578-1-git-send-email-hofrat@osadl.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=6YBkdT24bPxDWONh93YlvSE3F0K6x8peDEwOAVKi9x8=;
        b=OB5m7uJgIg56hTGqjvTkQUqwen1zfIm0S1X1kwg4EO+pEPZBhQ4+bYZjKFwpJWMjd7
         Fsx3L3kaSsnd8AeXUcQmJNfh7SKzcoNxrfnj5SV+Fzvy0oumWMG5JVSZB8yw4Pvjqs/N
         CmskU1bEv1j+LzZWzbsVhO/LAXLZ8KLOpj372DaRsjEVincDKYYrM3cmZPlF3/KnptqB
         xnwIjyWemktNvo/nklwErbfk6D3wf/3wSldNYP4lGMUwQq4OGkjDW3wyCf3+innuWDk8
         hvO7VhorB9/SQNsHfNbIGs1IGkC8rog7+QuZ4r/QCVnk/8X9yqXSfryuvVcT+74zKImU
         IQMA==
Content-Disposition: inline
In-Reply-To: <1432472872-3578-1-git-send-email-hofrat-Q945KHDl0DbYtjvyW6yDsg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Nicholas Mc Guire <hofrat-Q945KHDl0DbYtjvyW6yDsg@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Sun, May 24, 2015 at 03:07:52PM +0200, Nicholas Mc Guire wrote:
> Type-checking coccinelle spatches are being used to locate type mismatches
> between function signatures and return values in this case this produced:
> ./kernel/cgroup.c:2525 WARNING: return of wrong type
> 	ssize_t != size_t, 
> 
> Returning unsigned types converted to a signed type can be problematic
> but in this case the size_t is <= PATH_MAX which is less than ulong/2 so
> the conversion is safe - to make static code checking happy this is 
> resolved by an explicit cast and appropriate comment.
> 
> Patch was compile tested with x86_64_defconfig (implies CONFIG_CGROUPS=y)
> 
> Patch is against 4.1-rc4 (localversion-next is -next-20150522)
> 
> Signed-off-by: Nicholas Mc Guire <hofrat-Q945KHDl0DbYtjvyW6yDsg@public.gmane.org>
> ---
> 
> Not sure if "cleanups" like this are acceptable - in this case I did not
> find any better way to make static code checkers happy though.
> 
>  kernel/cgroup.c |    6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index b91177f..04de621 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -2523,7 +2523,11 @@ static ssize_t cgroup_release_agent_write(struct kernfs_open_file *of,
>  		sizeof(cgrp->root->release_agent_path));
>  	spin_unlock(&release_agent_path_lock);
>  	cgroup_kn_unlock(of->kn);
> -	return nbytes;
> +
> +	/* the path of the release notifier is <= PATH_MAX
> +	 * so "downsizing" to signed long is safe here
> +	 */
> +	return (ssize_t)nbytes;

idk, does this actually help anything?  This isn't different from any
other implicit type casts.  Are we gonna convert all downward implicit
casts to be explicit?

Thanks.

-- 
tejun
