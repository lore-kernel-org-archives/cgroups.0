From: Serge Hallyn <serge.hallyn@ubuntu.com>
Subject: Re: [PATCH] device_cgroup: check if exception removal is allowed
Date: Mon, 28 Apr 2014 20:30:03 +0000
Message-ID: <20140428203002.GA26218@ubuntumail>
References: <20140424193254.GR29214@redhat.com>
Mime-Version: 1.0
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140424193254.GR29214@redhat.com>
Sender: stable-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aristeu Rozanski <aris@redhat.com>
Cc: cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>, Serge Hallyn <serge.hallyn@canonical.com>, Li Zefan <lizefan@huawei.com>, stable@vger.kernel.org

Quoting Aristeu Rozanski (aris@redhat.com):
> In a scenario when the child cgroup is trying to remove an exception
> which will effectively add more access rights, verify if the parent's
> rules allow it.
> 
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Serge Hallyn <serge.hallyn@canonical.com>
> Cc: Li Zefan <lizefan@huawei.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Aristeu Rozanski <arozansk@redhat.com>

Thanks, this looks good.  (Though I'm going based on the comment of
match_exception_partial() in the comment cleanup patch, as the tree
I'm looking at doesn't yet have that fn;  still, looks good)

Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>

> ---
>  security/device_cgroup.c |   36 +++++++++++++++++++++++++++++++++---
>  1 files changed, 33 insertions(+), 3 deletions(-)
> 
> diff --git a/security/device_cgroup.c b/security/device_cgroup.c
> index b9048dc..abbe0b2 100644
> --- a/security/device_cgroup.c
> +++ b/security/device_cgroup.c
> @@ -463,6 +463,32 @@ static int parent_has_perm(struct dev_cgroup *childcg,
>  	return verify_new_ex(parent, ex, childcg->behavior);
>  }
>  
> +/*
> + * parent_allows_removal - check if the parent cgroup allows an exception to
> + *			   be removed
> + * @childcg: child cgroup from where the exception will be removed
> + * @ex: exception being removed
> + */
> +static bool parent_allows_removal(struct dev_cgroup *childcg,
> +				  struct dev_exception_item *ex)
> +{
> +	struct dev_cgroup *parent = css_to_devcgroup(css_parent(&childcg->css));
> +
> +	if (!parent)
> +		return true;
> +
> +	if (childcg->behavior == DEVCG_DEFAULT_DENY)
> +		/* It's always allowed to remove access to devices */
> +		return true;
> +
> +	/*
> +	 * Make sure you're not removing part or a whole exception existing in
> +	 * the parent cgroup
> +	 */
> +	return !match_exception_partial(&parent->exceptions, ex->type,
> +					ex->major, ex->minor, ex->access);
> +}
> +
>  /**
>   * may_allow_all - checks if it's possible to change the behavior to
>   *		   allow based on parent's rules.
> @@ -698,17 +724,21 @@ static int devcgroup_update_access(struct dev_cgroup *devcgroup,
>  
>  	switch (filetype) {
>  	case DEVCG_ALLOW:
> -		if (!parent_has_perm(devcgroup, &ex))
> -			return -EPERM;
>  		/*
>  		 * If the default policy is to allow by default, try to remove
>  		 * an matching exception instead. And be silent about it: we
>  		 * don't want to break compatibility
>  		 */
>  		if (devcgroup->behavior == DEVCG_DEFAULT_ALLOW) {
> +			/* Check if the parent allows removing it first */
> +			if (!parent_allows_removal(devcgroup, &ex))
> +				return -EPERM;
>  			dev_exception_rm(devcgroup, &ex);
> -			return 0;
> +			break;
>  		}
> +
> +		if (!parent_has_perm(devcgroup, &ex))
> +			return -EPERM;
>  		rc = dev_exception_add(devcgroup, &ex);
>  		break;
>  	case DEVCG_DENY:
> -- 
> 1.7.1
> 
