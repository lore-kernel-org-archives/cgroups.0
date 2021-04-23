From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH] memcg: enable accounting for pids in nested pid
 namespaces
Date: Thu, 22 Apr 2021 18:00:25 -0700
Message-ID: <YIIcKa/ANkQX07Nf@carbon>
References: <7b777e22-5b0d-7444-343d-92cbfae5f8b4@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=czRWEv8DAevHs/uHzIbfNz+74FqtNrYGOYxOol9fBdU=;
 b=ewd781BPnidm2V5HZ1S++zgHuRegx72S957wqqTigwDxLUVNETTJ4vD5P4x9Rj+Ma7kr
 cMEZL5E6P9oxxEgJ1ES+by2qKX8+uT9v2ydH92kgnKsmePcv0RsBVbu6nPckDPayK4W1
 ICho4RcOLTuw6XJhN/JHZE9D0t1PHIbr0Xo= 
Content-Disposition: inline
In-Reply-To: <7b777e22-5b0d-7444-343d-92cbfae5f8b4-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christian Brauner <christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>, Serge Hallyn <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>

On Thu, Apr 22, 2021 at 08:44:15AM +0300, Vasily Averin wrote:
> init_pid_ns.pid_cachep have enabled memcg accounting, though this
> setting was disabled for nested pid namespaces.
> 
> Signed-off-by: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
> ---
>  kernel/pid_namespace.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
> index 6cd6715..a46a372 100644
> --- a/kernel/pid_namespace.c
> +++ b/kernel/pid_namespace.c
> @@ -51,7 +51,8 @@ static struct kmem_cache *create_pid_cachep(unsigned int level)
>  	mutex_lock(&pid_caches_mutex);
>  	/* Name collision forces to do allocation under mutex. */
>  	if (!*pkc)
> -		*pkc = kmem_cache_create(name, len, 0, SLAB_HWCACHE_ALIGN, 0);
> +		*pkc = kmem_cache_create(name, len, 0,
> +					 SLAB_HWCACHE_ALIGN | SLAB_ACCOUNT, 0);
>  	mutex_unlock(&pid_caches_mutex);
>  	/* current can fail, but someone else can succeed. */
>  	return READ_ONCE(*pkc);
> -- 
> 1.8.3.1
> 

It looks good to me! It makes total sense to apply the same rules to the root
and non-root levels.

Acked-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

Btw, is there any reason why this patch is not included into the series?

Thanks!
