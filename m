From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 9/9] devcg: propagate local changes down the
 hierarchy
Date: Sat, 2 Feb 2013 16:13:41 +0000
Message-ID: <20130202161341.GA11284@mail.hallyn.com>
References: <20130130171101.060853036@napanee.usersys.redhat.com>
 <20130130171102.390708521@napanee.usersys.redhat.com>
 <20130131043839.GA14726@mail.hallyn.com>
 <20130201190958.GP17632@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130201190958.GP17632-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

Quoting Aristeu Rozanski (aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org):
> devcg: propagate local changes down the hierarchy
> 
> This patch makes all changes propagate down in hierarchy respecting when
> possible local configurations.
> 
> Behavior changes will clean up exceptions in all the children except when the
> parent changes the behavior from allow to deny and the child's behavior was
> already deny, in which case the local exceptions will be reused. The inverse
> is not possible: you can't have a parent with behavior deny and a child with
> behavior accept.
> 
> New exceptions allowing additional access to devices won't be propagated, but
> it'll be possible to add an exception to access all of part of the newly
> allowed device(s).
> 
> New exceptions disallowing access to devices will be propagated down and the
> local group's exceptions will be revalidated for the new situation.
> Example:
>       A
>      / \
>         B
> 
>     group        behavior          exceptions
>     A            allow             "b 8:* rwm", "c 116:1 rw"
>     B            deny              "c 1:3 rwm", "c 116:2 rwm", "b 3:* rwm"
> 
> If a new exception is added to group A:
> 	# echo "c 116:* r" > A/devices.deny
> it'll propagate down and after revalidating B's local exceptions, the exception
> "c 116:2 rwm" will be removed.
> 
> In case parent behavior or exceptions change and local settings are not
> allowed anymore, they'll be deleted.
> 
> v5: fixed issues pointed by Serge Hallyn
> - updated documentation
> - not propagating when an exception is written to devices.allow
> - when propagating a new behavior, clean the local exceptions list if they're
>   for a different behavior
> 
> v4:
> - separated function to walk the tree and collect valid propagation targets
> 
> v3:
> - update documentation
> - move css_online/css_offline changes to a new patch
> - use cgroup_for_each_descendant_pre() instead of own descendant walk
> - move exception_copy rework to a separared patch
> - move exception_clean rework to a separated patch
> 
> v2:
> - instead of keeping the local settings that won't apply anymore, remove them
> 
> Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> Signed-off-by: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> ---
>  Documentation/cgroups/devices.txt |   67 ++++++++++++
>  security/device_cgroup.c          |  196 ++++++++++++++++++++++++++++++++++++--
>  2 files changed, 257 insertions(+), 6 deletions(-)
> 
> --- github.orig/security/device_cgroup.c	2013-01-31 10:15:22.458209721 -0500
> +++ github/security/device_cgroup.c	2013-02-01 14:09:04.067917557 -0500
> @@ -60,6 +60,9 @@ struct dev_cgroup {
>  		struct list_head exceptions;
>  		enum devcg_behavior behavior;
>  	} local;
> +
> +	/* temporary list for pending propagation operations */
> +	struct list_head propagate_pending;
>  };
>  
>  static inline struct dev_cgroup *css_to_devcgroup(struct cgroup_subsys_state *s)
> @@ -241,6 +244,11 @@ static void dev_exception_clean_all(stru
>  	__dev_exception_clean_all(dev_cgroup);
>  }
>  
> +static inline bool is_devcg_online(const struct dev_cgroup *devcg)
> +{
> +	return (devcg->behavior != DEVCG_DEFAULT_NONE);
> +}
> +
>  /**
>   * devcgroup_online - initializes devcgroup's behavior and exceptions based on
>   * 		      parent's
> @@ -292,6 +300,7 @@ static struct cgroup_subsys_state *devcg
>  		return ERR_PTR(-ENOMEM);
>  	INIT_LIST_HEAD(&dev_cgroup->exceptions);
>  	INIT_LIST_HEAD(&dev_cgroup->local.exceptions);
> +	INIT_LIST_HEAD(&dev_cgroup->propagate_pending);
>  	dev_cgroup->local.behavior = DEVCG_DEFAULT_NONE;
>  	dev_cgroup->behavior = DEVCG_DEFAULT_NONE;
>  	parent_cgroup = cgroup->parent;
> @@ -471,6 +480,163 @@ static inline int may_allow_all(struct d
>  	return parent->behavior == DEVCG_DEFAULT_ALLOW;
>  }
>  
> +/**
> + * revalidate_exceptions - walks through the exception list and revalidates
> + *			     the exceptions based on parents' behavior and
> + *			     exceptions. Called with devcgroup_mutex held.
> + * @devcg: cgroup which exceptions will be checked
> + *
> + * returns: 0 in success, -ENOMEM in case of out of memory
> + *
> + * This is one of the two key functions for hierarchy implementation.
> + * This function is responsible for re-evaluating all the cgroup's locally
> + * set exceptions due to a parent's behavior or exception change.
> + * Refer to Documentation/cgroups/devices.txt for more details.
> + */
> +static int revalidate_exceptions(struct dev_cgroup *devcg)
> +{
> +	struct dev_exception_item *ex;
> +	struct list_head *this, *tmp;
> +
> +	list_for_each_safe(this, tmp, &devcg->local.exceptions) {
> +		ex = container_of(this, struct dev_exception_item, list);
> +		if (parent_has_perm(devcg, ex)) {
> +			if (dev_exception_copy(&devcg->exceptions, ex))
> +				goto error;
> +		} else
> +			__dev_exception_rm(&devcg->local.exceptions, ex);
> +	}
> +	return 0;
> +
> +error:
> +	dev_exception_clean(&devcg->exceptions);
> +	return -ENOMEM;
> +}
> +
> +/**
> + * get_online_devcg - walks the cgroup tree and fills a list with the online
> + * 		      groups
> + * @root: cgroup used as starting point
> + * @online: list that will be filled with online groups
> + *
> + * Must be called with devcgroup_mutex held. Grabs RCU lock.
> + * Because devcgroup_mutex is held, no devcg will become online or offline
> + * during the tree walk (see devcgroup_online, devcgroup_offline)
> + * A separated list is needed because propagate_behavior() and
> + * propagate_exception() need to allocate memory and can block.
> + */
> +static void get_online_devcg(struct cgroup *root, struct list_head *online)
> +{
> +	struct cgroup *pos;
> +	struct dev_cgroup *devcg;
> +
> +	lockdep_assert_held(&devcgroup_mutex);
> +
> +	rcu_read_lock();
> +	cgroup_for_each_descendant_pre(pos, root) {
> +		devcg = cgroup_to_devcgroup(pos);
> +		if (is_devcg_online(devcg))
> +			list_add_tail(&devcg->propagate_pending, online);
> +	}
> +	rcu_read_unlock();
> +}
> +
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
> +		rc = dev_exceptions_copy(&devcg->exceptions, &parent->exceptions);

You may not want to do this if parent->behavior == DENY and
devcg->local.behavior == ALLOW.  You'll end up with matches
in may_access() in the child, where you assume that if
devcg->behavior != ALLOW it is DENY.

Now maybe that *was* your intent, but if so then I think you're
better off explicitly changing the child to DENY below.  (See my
related question below)

> +		if (rc) {
> +			devcg->behavior = DEVCG_DEFAULT_DENY;
> +			break;
> +		}
> +
> +		if (devcg->local.behavior == DEVCG_DEFAULT_DENY &&
> +		    devcg->behavior == DEVCG_DEFAULT_ALLOW) {
> +			devcg->behavior = DEVCG_DEFAULT_DENY;
> +		}
> +		if (devcg->local.behavior == devcg->behavior) {
> +			rc = revalidate_exceptions(devcg);
> +		} else {
> +			dev_exception_clean(&devcg->local.exceptions);
> +			/*
> +			 * if the local behavior couldn't be applied,
> +			 * reset it
> +			 */
> +			devcg->local.behavior = DEVCG_DEFAULT_NONE;

So the only way this will happen is if the parent and child were
originally both ALLOW, and the parent switches to DENY.

Now in general I'd discourage starting containers in ALLOW mode
at all, but I think if someone does so, then changes the host to
DENY, the container should not be blindly switched to having no
access.  Now as I say the way you have the code it will actually
behave a bit like a DENY...

Really I don't know what the right thing to do is.  The best I can
come up with is a big fat syslog warning, and keep the child as
ALLOW with exactly its original set of exceptions.

What you're doing iiuc is switching them to DENY behavior (but refusing
future exception additions) with a copy of the parent's rules.

-serge
