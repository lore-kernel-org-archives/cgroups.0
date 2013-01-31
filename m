From: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 9/9] devcg: propagate local changes down the hierarchy
Date: Thu, 31 Jan 2013 17:00:37 -0500
Message-ID: <20130131220036.GN17632@redhat.com>
References: <20130130171101.060853036@napanee.usersys.redhat.com>
 <20130130171102.390708521@napanee.usersys.redhat.com>
 <20130131041932.GB14576@mail.hallyn.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130131041932.GB14576-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

On Thu, Jan 31, 2013 at 04:19:32AM +0000, Serge E. Hallyn wrote:
> Quoting aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org (aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org):
> > +/**
> > + * propagate_behavior - propagates a change in the behavior down in hierarchy
> > + * @devcg_root: device cgroup that changed behavior
> > + *
> > + * returns: 0 in case of success, != 0 in case of error
> > + *
> > + * This is one of the two key functions for hierarchy implementation.
> > + * All cgroup's children recursively will have the behavior changed and
> > + * exceptions copied from the parent then its local behavior and exceptions
> > + * re-evaluated and applied if they're still allowed.  Refer to
> > + * Documentation/cgroups/devices.txt for more details.
> > + */
> > +static int propagate_behavior(struct dev_cgroup *devcg_root)
> > +{
> > +	struct cgroup *root = devcg_root->css.cgroup;
> > +	struct dev_cgroup *parent, *devcg, *tmp;
> > +	int rc = 0;
> > +	LIST_HEAD(pending);
> > +
> > +	get_online_devcg(root, &pending);
> > +
> > +	list_for_each_entry_safe(devcg, tmp, &pending, propagate_pending) {
> > +		parent = cgroup_to_devcgroup(devcg->css.cgroup->parent);
> > +
> > +		/* first copy parent's state */
> > +		devcg->behavior = parent->behavior;
> > +		dev_exception_clean(&devcg->exceptions);
> > +		rc = dev_exceptions_copy(&devcg->exceptions, &parent->exceptions);
> > +		if (rc) {
> > +			devcg->behavior = DEVCG_DEFAULT_DENY;
> > +			break;
> > +		}
> > +
> > +		if (devcg->local.behavior == DEVCG_DEFAULT_DENY &&
> > +		    devcg->behavior == DEVCG_DEFAULT_ALLOW) {
> > +			devcg->behavior = DEVCG_DEFAULT_DENY;
> > +		}
> 
> I think you might need another special case here.  If A and it's
> child B are both ALLOW, and A switches to DENY, then if I read this
> right B will be switched to DENY, but its local->exceptions will
> not be cleared.  They won't be immediately applied, so at first it's
> ok.  But if B then adds an exception, what happens?  It'll call
> revalidate_exceptions on the full old list plus new exception.  If
> any exceptions aren't allowed by the parent then it won't be applied,
> but it's possible that it is allowed in the parent but (its sense
> now being inverted from blacklist to whitelist) not intended to be
> allowed in the child.  But there will be nothing to stop it.
> 
> So do you need
> 
> 	if (devcg->local.behavior == DEVCG_DEFAULT_ALLOW &&
> 		devcg->behavior == DEVCG_DEFAULT_DENY) {
> 		dev_exception_clean(&devcg->local.exceptions);
> 	}
> 
> here?
> 
> > +		if (devcg->local.behavior == devcg->behavior)
> > +			rc = revalidate_exceptions(devcg);

I think:
		else
			dev_exception_clean(&devcg->local.exceptions);

here instead

-- 
Aristeu
