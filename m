From: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 13/14] device_cgroup: use css_has_online_children()
 instead of has_children()
Date: Tue, 13 May 2014 08:56:52 -0400
Message-ID: <20140513125652.GJ29214@redhat.com>
References: <1399671091-23867-1-git-send-email-tj@kernel.org>
 <1399671091-23867-14-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1399671091-23867-14-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>

On Fri, May 09, 2014 at 05:31:30PM -0400, Tejun Heo wrote:
> devcgroup_update_access() wants to know whether there are child
> cgroups which are online and visible to userland and has_children()
> may return false positive.  Replace it with css_has_online_children().
> 
> Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Cc: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
> ---
>  security/device_cgroup.c | 19 ++-----------------
>  1 file changed, 2 insertions(+), 17 deletions(-)
> 
> diff --git a/security/device_cgroup.c b/security/device_cgroup.c
> index 75b4b18..22de334 100644
> --- a/security/device_cgroup.c
> +++ b/security/device_cgroup.c
> @@ -475,21 +475,6 @@ static int propagate_exception(struct dev_cgroup *devcg_root,
>  	return rc;
>  }
>  
> -static inline bool has_children(struct dev_cgroup *devcgroup)
> -{
> -	bool ret;
> -
> -	/*
> -	 * FIXME: There may be lingering offline csses and this function
> -	 * may return %true when there isn't any userland-visible child
> -	 * which is incorrect for our purposes.
> -	 */
> -	rcu_read_lock();
> -	ret = css_next_child(NULL, &devcgroup->css);
> -	rcu_read_unlock();
> -	return ret;
> -}
> -
>  /*
>   * Modify the exception list using allow/deny rules.
>   * CAP_SYS_ADMIN is needed for this.  It's at least separate from CAP_MKNOD
> @@ -522,7 +507,7 @@ static int devcgroup_update_access(struct dev_cgroup *devcgroup,
>  	case 'a':
>  		switch (filetype) {
>  		case DEVCG_ALLOW:
> -			if (has_children(devcgroup))
> +			if (css_has_online_children(&devcgroup->css))
>  				return -EINVAL;
>  
>  			if (!may_allow_all(parent))
> @@ -538,7 +523,7 @@ static int devcgroup_update_access(struct dev_cgroup *devcgroup,
>  				return rc;
>  			break;
>  		case DEVCG_DENY:
> -			if (has_children(devcgroup))
> +			if (css_has_online_children(&devcgroup->css))
>  				return -EINVAL;
>  
>  			dev_exception_clean(devcgroup);

Acked-by: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

-- 
Aristeu
