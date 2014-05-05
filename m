From: Serge Hallyn <serge.hallyn@ubuntu.com>
Subject: Re: [PATCH v3] device_cgroup: check if exception removal is allowed
Date: Mon, 5 May 2014 18:46:23 +0000
Message-ID: <20140505184623.GC6068@ubuntumail>
References: <20140424193254.GR29214@redhat.com>
 <20140502152930.GF10204@htj.dyndns.org>
 <20140505151431.GK29214@redhat.com>
 <20140505151621.GJ11231@htj.dyndns.org>
 <20140505151858.GL29214@redhat.com>
Mime-Version: 1.0
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140505151858.GL29214@redhat.com>
Sender: stable-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aristeu Rozanski <aris@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, Serge Hallyn <serge.hallyn@canonical.com>, Li Zefan <lizefan@huawei.com>, stable@vger.kernel.org

Quoting Aristeu Rozanski (aris@redhat.com):
> [PATCH v3 1/2] device_cgroup: check if exception removal is allowed
> 
> When the device cgroup hierarchy was introduced in
> 	bd2953ebbb53 - devcg: propagate local changes down the hierarchy
> 
> a specific case was overlooked. Consider the hierarchy bellow:
> 
> 	A	default policy: ALLOW, exceptions will deny access
> 	 \
> 	  B	default policy: ALLOW, exceptions will deny access
> 
> There's no need to verify when an new exception is added to B because
> in this case exceptions will deny access to further devices, which is
> always fine. Hierarchy in device cgroup only makes sure B won't have
> more access than A.
> 
> But when an exception is removed (by writing devices.allow), it isn't
> checked if the user is in fact removing an inherited exception from A,
> thus giving more access to B.
> 
> Example:
> 
> 	# echo 'a' >A/devices.allow
> 	# echo 'c 1:3 rw' >A/devices.deny
> 	# echo $$ >A/B/tasks
> 	# echo >/dev/null
> 	-bash: /dev/null: Operation not permitted
> 	# echo 'c 1:3 w' >A/B/devices.allow
> 	# echo >/dev/null
> 	#
> 
> This shouldn't be allowed and this patch fixes it by making sure to never allow
> exceptions in this case to be removed if the exception is partially or fully
> present on the parent.
> 
> v3: missing '*' in function description
> v2: improved log message and formatting fixes
> 
> Cc: cgroups@vger.kernel.org
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Serge Hallyn <serge.hallyn@canonical.com>

(stared at this for quite some time, looks good, thanks :)

Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>

> Cc: Li Zefan <lizefan@huawei.com>
> Cc: stable@vger.kernel.org
> Signed-off-by: Aristeu Rozanski <arozansk@redhat.com>
> ---
>  security/device_cgroup.c |   41 ++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 38 insertions(+), 3 deletions(-)
> 
> --- github.orig/security/device_cgroup.c	2014-05-05 10:42:39.588430715 -0400
> +++ github/security/device_cgroup.c	2014-05-05 11:17:35.408486409 -0400
> @@ -464,6 +464,37 @@ static int parent_has_perm(struct dev_cg
>  }
>  
>  /**
> + * parent_allows_removal - verify if it's ok to remove an exception
> + * @childcg: child cgroup from where the exception will be removed
> + * @ex: exception being removed
> + *
> + * When removing an exception in cgroups with default ALLOW policy, it must
> + * be checked if removing it will give the child cgroup more access than the
> + * parent.
> + *
> + * Return: true if it's ok to remove exception, false otherwise
> + */
> +static bool parent_allows_removal(struct dev_cgroup *childcg,
> +				  struct dev_exception_item *ex)
> +{
> +	struct dev_cgroup *parent = css_to_devcgroup(css_parent(&childcg->css));
> +
> +	if (!parent)
> +		return true;
> +
> +	/* It's always allowed to remove access to devices */
> +	if (childcg->behavior == DEVCG_DEFAULT_DENY)
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
> +/**
>   * may_allow_all - checks if it's possible to change the behavior to
>   *		   allow based on parent's rules.
>   * @parent: device cgroup's parent
> @@ -698,17 +729,21 @@ 		case '\0':
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
