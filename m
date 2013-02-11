From: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v6 9/9] devcg: propagate local changes down the hierarchy
Date: Mon, 11 Feb 2013 09:30:22 -0500
Message-ID: <20130211143022.GE30962@redhat.com>
References: <20130130171101.060853036@napanee.usersys.redhat.com>
 <20130130171102.390708521@napanee.usersys.redhat.com>
 <20130131043839.GA14726@mail.hallyn.com>
 <20130205183646.GT17632@redhat.com>
 <20130209035357.GA31122@mail.hallyn.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130209035357.GA31122-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

On Sat, Feb 09, 2013 at 03:53:57AM +0000, Serge E. Hallyn wrote:
> Quoting Aristeu Rozanski (aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org):
> 
> Thanks, Aristeu.  I'm sorry it feels like I'm just trying to give you a
> hard time, I'm really not :)

no worries on that, it's important this is done right and I appreciate
your reviews.

> I do feel like you're really close.  At the same time this is so subtle
> and complicated that I wonder if there must not be a simpler way,
> perhaps a small change in assumptions that would help do away with a lot
> of this.  It's not just about the iterations you're having to do, but
> more about how subtle it still all feels, suggesting it will be hard to
> prevent regressions as it gets maintained.

what could make it simpler is simply drop the notion of local settings:
if it's changed locally, just check if it's allowed and do it.
propagation simply will mirror the parent cgroup. But other than that, I
don't see any easier way.

> (But maybe I'm wrong about that)
> 
> Anyway, I really appreciate all the work you're doing on this.
> 
> After you reply to my questions below, if there are no further changes
> I'd like to take one more long look at the whole thing before acking.
> 
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
> > +
> > +		if (devcg->local.behavior == DEVCG_DEFAULT_DENY &&
> > +		    devcg->behavior == DEVCG_DEFAULT_ALLOW) {
> > +			/*
> > +			 * the only case when the local exceptions
> > +			 * will be reused
> > +			 */
> > +			devcg->behavior = DEVCG_DEFAULT_DENY;
> > +			rc = revalidate_local_exceptions(devcg);
> > +		} else {
> 
> So, what if parent A and child B are both deny, then parent A switches
> to allow, then parent A switches back to deny?  You'll be dropping B's
> local exceptions, is that what you want?  (Maybe it is, I'm not sure)

so, doing the two steps slowly:
1) parent changes to ALLOW: B gets to keep deny because it's a local
   setting and it's allowed. revalidate_local_exceptions() will probably
   keep all the local exceptions since parent's change to ALLOW will
   reset its exception list; so any exception to DENY in B will be
   allowed.
1.1) parent gets new exceptions (or not): some of the local exceptions
     in B might be dropped since they'll not be allowed anymore
2) parent changes to DENY: B keeps DENY but ends up indirectly losing
   all its local exceptions anyway because parent's behavior change will
   also clear all exceptions and will deny everything.

the whole idea is to never a child should have access to more devices than
its parent.

> > @@ -621,13 +828,22 @@ 			return 0;
> >  		 */
> >  		if (devcgroup->behavior == DEVCG_DEFAULT_DENY) {
> >  			dev_exception_rm(devcgroup, &ex);
> > -			return 0;
> > +			rc = propagate_exception(devcgroup, &ex);
> 
> Note that this is a case where we made a change to the cgroups
> exceptions, but do not set the cgroup's local behavior explicitly.
> That's important bc we have parent A and child B, where child B
> made a change, but when child A changes its behavior, child B's
> behavior will be changed as well despite having made local changes.
> 
> I assume you were thinking that local.behavior gets set if a
> local.exception gets added, not if a devcg->exception gets removed
> with no change to local.exceptions.

that is correct. the idea of setting local.behavior is to make sure
local.exceptions are interpreted correctly: are they exceptions to
DENY or ALLOW?

> While the reasoning may be clear looking at it from this level,
> I think that as an admin configuring cgroups on a system, the
> rules about when the behavior change to A are propagated to B
> will seem random.
> 
> (Or, it may just be an oversight and you meant to set local.behavior
> here? :)
> 
> Oh, that brings up another point,
> 
> in the two cases where you do dev_exception_rm(devcgroup, &ex)
> instead of dev_exception_add(devcgroup, &ex), should that
> action be recorded locally somehow, so it can be reproduced
> after a parent behavior change?

that makes sense. not sure how to do that though. will think in
something.

-- 
Aristeu
