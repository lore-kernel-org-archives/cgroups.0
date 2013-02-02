From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 9/9] devcg: propagate local changes down the
 hierarchy
Date: Sat, 2 Feb 2013 16:20:52 +0000
Message-ID: <20130202162052.GB11284@mail.hallyn.com>
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
> +/**
> + * propagate_exception - propagates a new exception to the children
> + * @devcg_root: device cgroup that added a new exception
> + *
> + * returns: 0 in case of success, != 0 in case of error
> + */
> +static int propagate_exception(struct dev_cgroup *devcg_root)
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
> +		dev_exception_clean(&devcg->exceptions);
> +		if (devcg->behavior == parent->behavior) {
> +			rc = dev_exceptions_copy(&devcg->exceptions, &parent->exceptions);

Let's say parent A and child B both have DEFAULT_DENY, with a set of let's
say 5 whitelist exceptions.  Now the parent adds two more whitelist
exceptions.  As you say, we don't propagate those.

Now the parent removes one of it's whitelist exceptions.
devcgroup_update_access() calls dev_exception_rm() followed by
propagate_exception(), which comes here and copies the parent's
whitelist - including the two new whitelist rules - to the
child.

-serge
