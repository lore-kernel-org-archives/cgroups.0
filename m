From: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 9/9] devcg: propagate local changes down the hierarchy
Date: Mon, 4 Feb 2013 10:03:07 -0500
Message-ID: <20130204150307.GQ17632@redhat.com>
References: <20130130171101.060853036@napanee.usersys.redhat.com>
 <20130130171102.390708521@napanee.usersys.redhat.com>
 <20130131043839.GA14726@mail.hallyn.com>
 <20130201190958.GP17632@redhat.com>
 <20130202161341.GA11284@mail.hallyn.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130202161341.GA11284-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

On Sat, Feb 02, 2013 at 04:13:41PM +0000, Serge E. Hallyn wrote:
> Quoting Aristeu Rozanski (aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org):
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
> 
> You may not want to do this if parent->behavior == DENY and
> devcg->local.behavior == ALLOW.  You'll end up with matches
> in may_access() in the child, where you assume that if
> devcg->behavior != ALLOW it is DENY.
> 
> Now maybe that *was* your intent, but if so then I think you're
> better off explicitly changing the child to DENY below.  (See my
> related question below)

hm, could go either way. if the local behavior is allowed and it's
different, clearing the local list should be enough.

but yes, you're right, the way it is now is wrong.

> > +		if (devcg->local.behavior == devcg->behavior) {
> > +			rc = revalidate_exceptions(devcg);
> > +		} else {
> > +			dev_exception_clean(&devcg->local.exceptions);
> > +			/*
> > +			 * if the local behavior couldn't be applied,
> > +			 * reset it
> > +			 */
> > +			devcg->local.behavior = DEVCG_DEFAULT_NONE;
> 
> So the only way this will happen is if the parent and child were
> originally both ALLOW, and the parent switches to DENY.

hm, no. it could also happen if it was deny/deny. if a new exception is
written in the child (consider that the parent just had a new exception
written) it'll change automatically local.behavior to
DEVCG_DEFAULT_DENY.

> Now in general I'd discourage starting containers in ALLOW mode
> at all, but I think if someone does so, then changes the host to
> DENY, the container should not be blindly switched to having no
> access.  Now as I say the way you have the code it will actually
> behave a bit like a DENY...
> 
> Really I don't know what the right thing to do is.  The best I can
> come up with is a big fat syslog warning, and keep the child as
> ALLOW with exactly its original set of exceptions.

hm, if you do that you're breaking the hierarchy and this patchset is
useless :)

> What you're doing iiuc is switching them to DENY behavior (but refusing
> future exception additions) with a copy of the parent's rules.

hm, no. I think you misunderstood "local.behavior = DEVCG_DEFAULT_NONE".
This means "there's no local preference for behavior". local.* are just
the local preferences that need to be revalidated everytime something is
propagated. Or did you mean something else?

-- 
Aristeu
