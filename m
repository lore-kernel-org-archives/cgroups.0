From: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH cgroup/for-4.6-ns] cgroup: fix and restructure error
 handling in copy_cgroup_ns()
Date: Mon, 29 Feb 2016 08:50:00 +0000
Message-ID: <20160229085000.GC26955@ubuntumail>
References: <20160217185811.GA3472@mwanda>
 <20160218164658.GD13177@mtj.duckdns.org>
 <20160218202112.GZ5273@mwanda>
 <20160218202650.GH13177@mtj.duckdns.org>
 <20160218212648.GA5273@mwanda>
 <20160228135933.GT3965@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160228135933.GT3965-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Quoting Tejun Heo (tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org):
> copy_cgroup_ns()'s error handling was broken and the attempt to fix it
> d22025570e2e ("cgroup: fix alloc_cgroup_ns() error handling in
> copy_cgroup_ns()") was broken too in that it ended up trying an
> ERR_PTR() value.
> 
> There's only one place where copy_cgroup_ns() needs to perform cleanup
> after failure.  Simplify and fix the error handling by removing the
> goto's.
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Reported-by: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

It certainly looks cleaner, thanks.

Acked-by: Serge E. Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

> ---
>  kernel/cgroup.c |   18 +++++-------------
>  1 file changed, 5 insertions(+), 13 deletions(-)
> 
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index d92d91a..2c88149 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -6058,9 +6058,8 @@ struct cgroup_namespace *copy_cgroup_ns(unsigned long flags,
>  					struct user_namespace *user_ns,
>  					struct cgroup_namespace *old_ns)
>  {
> -	struct cgroup_namespace *new_ns = NULL;
> -	struct css_set *cset = NULL;
> -	int err;
> +	struct cgroup_namespace *new_ns;
> +	struct css_set *cset;
>  
>  	BUG_ON(!old_ns);
>  
> @@ -6070,9 +6069,8 @@ struct cgroup_namespace *copy_cgroup_ns(unsigned long flags,
>  	}
>  
>  	/* Allow only sysadmin to create cgroup namespace. */
> -	err = -EPERM;
>  	if (!ns_capable(user_ns, CAP_SYS_ADMIN))
> -		goto err_out;
> +		return ERR_PTR(-EPERM);
>  
>  	mutex_lock(&cgroup_mutex);
>  	spin_lock_bh(&css_set_lock);
> @@ -6085,20 +6083,14 @@ struct cgroup_namespace *copy_cgroup_ns(unsigned long flags,
>  
>  	new_ns = alloc_cgroup_ns();
>  	if (IS_ERR(new_ns)) {
> -		err = PTR_ERR(new_ns);
> -		goto err_out;
> +		put_css_set(cset);
> +		return new_ns;
>  	}
>  
>  	new_ns->user_ns = get_user_ns(user_ns);
>  	new_ns->root_cset = cset;
>  
>  	return new_ns;
> -
> -err_out:
> -	if (cset)
> -		put_css_set(cset);
> -	kfree(new_ns);
> -	return ERR_PTR(err);
>  }
>  
>  static inline struct cgroup_namespace *to_cg_ns(struct ns_common *ns)
