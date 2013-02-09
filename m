From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 9/9] devcg: propagate local changes down the
 hierarchy
Date: Sat, 9 Feb 2013 03:53:57 +0000
Message-ID: <20130209035357.GA31122@mail.hallyn.com>
References: <20130130171101.060853036@napanee.usersys.redhat.com>
 <20130130171102.390708521@napanee.usersys.redhat.com>
 <20130131043839.GA14726@mail.hallyn.com>
 <20130205183646.GT17632@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130205183646.GT17632-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

Quoting Aristeu Rozanski (aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org):

Thanks, Aristeu.  I'm sorry it feels like I'm just trying to give you a
hard time, I'm really not :)

I do feel like you're really close.  At the same time this is so subtle
and complicated that I wonder if there must not be a simpler way,
perhaps a small change in assumptions that would help do away with a lot
of this.  It's not just about the iterations you're having to do, but
more about how subtle it still all feels, suggesting it will be hard to
prevent regressions as it gets maintained.

(But maybe I'm wrong about that)

Anyway, I really appreciate all the work you're doing on this.

After you reply to my questions below, if there are no further changes
I'd like to take one more long look at the whole thing before acking.

> +/**
> + * propagate_behavior - propagates a change in the behavior down in hierarchy
> + * @devcg_root: device cgroup that changed behavior
> + *
> + * returns: 0 in case of success, != 0 in case of error
> + *
> + * This is one of the two key functions for hierarchy implementation.
> + * All cgroup's children recursively will have the behavior changed and
> + * exceptions copied from the parent then its local behavior and exceptions
> + * re-evaluated and applied if they're still allowed.  Refer to
> + * Documentation/cgroups/devices.txt for more details.
> + */
> +static int propagate_behavior(struct dev_cgroup *devcg_root)
> +{
> +	struct cgroup *root = devcg_root->css.cgroup;
> +	struct dev_cgroup *parent, *devcg, *tmp;
> +	int rc = 0;
> +	LIST_HEAD(pending);
> +
> +	get_online_devcg(root, &pending);
> +
> +	list_for_each_entry_safe(devcg, tmp, &pending, propagate_pending) {
> +		parent = cgroup_to_devcgroup(devcg->css.cgroup->parent);
> +
> +		/* first copy parent's state */
> +		devcg->behavior = parent->behavior;
> +		dev_exception_clean(&devcg->exceptions);
> +
> +		if (devcg->local.behavior == DEVCG_DEFAULT_DENY &&
> +		    devcg->behavior == DEVCG_DEFAULT_ALLOW) {
> +			/*
> +			 * the only case when the local exceptions
> +			 * will be reused
> +			 */
> +			devcg->behavior = DEVCG_DEFAULT_DENY;
> +			rc = revalidate_local_exceptions(devcg);
> +		} else {

So, what if parent A and child B are both deny, then parent A switches
to allow, then parent A switches back to deny?  You'll be dropping B's
local exceptions, is that what you want?  (Maybe it is, I'm not sure)

> +			dev_exception_clean(&devcg->local.exceptions);
> +			devcg->local.behavior = DEVCG_DEFAULT_NONE;
> +
> +			/* just copy the parent's exceptions over */
> +			rc = dev_exceptions_copy(&devcg->exceptions,
> +						 &parent->exceptions);
> +			if (rc)
> +				devcg->behavior = DEVCG_DEFAULT_DENY;
> +		}
> +		if (rc)
> +			break;
> +		list_del_init(&devcg->propagate_pending);
> +	}
> +
> +	return rc;
> +}
> +
> +/**
> + * propagate_exception - propagates a new exception to the children
> + * @devcg_root: device cgroup that added a new exception
> + * @ex: new exception to be propagated
> + *
> + * returns: 0 in case of success, != 0 in case of error
> + */
> +static int propagate_exception(struct dev_cgroup *devcg_root,
> +			       struct dev_exception_item *ex)
> +{
> +	struct cgroup *root = devcg_root->css.cgroup;
> +	struct dev_cgroup *devcg, *parent, *tmp;
> +	int rc = 0;
> +	LIST_HEAD(pending);
> +
> +	get_online_devcg(root, &pending);
> +
> +	list_for_each_entry_safe(devcg, tmp, &pending, propagate_pending) {
> +		parent = cgroup_to_devcgroup(devcg->css.cgroup->parent);
> +
> +		/*
> +		 * in case both root's behavior and devcg is allow, a new
> +		 * restriction means adding to the exception list
> +		 */
> +		if (devcg_root->behavior == DEVCG_DEFAULT_ALLOW &&
> +		    devcg->behavior == DEVCG_DEFAULT_ALLOW) {
> +			rc = dev_exception_add(devcg, ex);
> +			if (rc)
> +				break;
> +		} else {
> +			/*
> +			 * in the other possible cases:
> +			 * root's behavior: allow, devcg's: deny
> +			 * root's behavior: deny, devcg's: deny
> +			 * the exception will be removed
> +			 */
> +			dev_exception_rm(devcg, ex);
> +		}
> +		revalidate_active_exceptions(devcg);

this looks good.

> +
> +		list_del_init(&devcg->propagate_pending);
> +	}
> +	return rc;
> +}
> +
>  /*
>   * Modify the exception list using allow/deny rules.
>   * CAP_SYS_ADMIN is needed for this.  It's at least separate from CAP_MKNOD
> @@ -510,16 +708,21 @@ 	memset(&ex, 0, sizeof(ex));
>  			if (!may_allow_all(parent))
>  				return -EPERM;
>  			dev_exception_clean_all(devcgroup);
> -			if (parent)
> +			if (parent) {
>  				rc = dev_exceptions_copy(&devcgroup->exceptions,
>  							 &parent->exceptions);
> +				if (rc)
> +					break;
> +			}
>  			devcgroup->behavior = DEVCG_DEFAULT_ALLOW;
>  			devcgroup->local.behavior = DEVCG_DEFAULT_ALLOW;
> +			rc = propagate_behavior(devcgroup);
>  			break;
>  		case DEVCG_DENY:
>  			dev_exception_clean_all(devcgroup);
>  			devcgroup->behavior = DEVCG_DEFAULT_DENY;
>  			devcgroup->local.behavior = DEVCG_DEFAULT_DENY;
> +			rc = propagate_behavior(devcgroup);
>  			break;
>  		default:
>  			rc = -EINVAL;
> @@ -612,7 +815,11 @@ 		case '\0':
>  			dev_exception_rm(devcgroup, &ex);
>  			return 0;
>  		}
> -		return dev_exception_add(devcgroup, &ex);
> +		rc = dev_exception_add(devcgroup, &ex);
> +		if (!rc)
> +			/* if a local behavior wasn't explicitely choosen, pick it */
> +			devcgroup->local.behavior = devcgroup->behavior;
> +		break;
>  	case DEVCG_DENY:
>  		/*
>  		 * If the default policy is to deny by default, try to remove
> @@ -621,13 +828,22 @@ 			return 0;
>  		 */
>  		if (devcgroup->behavior == DEVCG_DEFAULT_DENY) {
>  			dev_exception_rm(devcgroup, &ex);
> -			return 0;
> +			rc = propagate_exception(devcgroup, &ex);

Note that this is a case where we made a change to the cgroups
exceptions, but do not set the cgroup's local behavior explicitly.
That's important bc we have parent A and child B, where child B
made a change, but when child A changes its behavior, child B's
behavior will be changed as well despite having made local changes.

I assume you were thinking that local.behavior gets set if a
local.exception gets added, not if a devcg->exception gets removed
with no change to local.exceptions.

While the reasoning may be clear looking at it from this level,
I think that as an admin configuring cgroups on a system, the
rules about when the behavior change to A are propagated to B
will seem random.

(Or, it may just be an oversight and you meant to set local.behavior
here? :)

Oh, that brings up another point,

in the two cases where you do dev_exception_rm(devcgroup, &ex)
instead of dev_exception_add(devcgroup, &ex), should that
action be recorded locally somehow, so it can be reproduced
after a parent behavior change?

-serge
