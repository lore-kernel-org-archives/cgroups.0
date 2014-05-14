From: "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH 13/14] device_cgroup: use css_has_online_children()
 instead of has_children()
Date: Wed, 14 May 2014 14:53:05 +0200
Message-ID: <20140514125305.GB30376@mail.hallyn.com>
References: <1399671091-23867-1-git-send-email-tj@kernel.org>
 <1399671091-23867-14-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1399671091-23867-14-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, hannes@cmpxchg.org, Aristeu Rozanski <aris@redhat.com>, Serge Hallyn <serge.hallyn@ubuntu.com>

Quoting Tejun Heo (tj@kernel.org):
> devcgroup_update_access() wants to know whether there are child
> cgroups which are online and visible to userland and has_children()
> may return false positive.  Replace it with css_has_online_children().
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Aristeu Rozanski <aris@redhat.com>
> Cc: Serge Hallyn <serge.hallyn@ubuntu.com>

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

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
> -- 
> 1.9.0
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
