From: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 9/9] devcg: propagate local changes down the hierarchy
Date: Tue, 29 Jan 2013 15:50:47 -0500
Message-ID: <20130129205047.GZ17632@redhat.com>
References: <20130129190759.117458287@napanee.usersys.redhat.com>
 <20130129190800.590181489@napanee.usersys.redhat.com>
 <20130129203500.GK6824@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130129203500.GK6824-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

On Tue, Jan 29, 2013 at 12:35:00PM -0800, Tejun Heo wrote:
> Generally looks good to me although I haven't really delved into the
> behavior (you're gonna be there for the fallouts, right?).  Just some
> minor comments.

yes, I'll.

> > +static int propagate_behavior(struct dev_cgroup *devcg_root)
> > +{
> > +	struct cgroup *root = devcg_root->css.cgroup, *pos;
> > +	struct dev_cgroup *parent, *devcg, *tmp;
> > +	int rc = 0;
> > +	LIST_HEAD(pending);
> > +
> > +	rcu_read_lock();
> > +	cgroup_for_each_descendant_pre(pos, root) {
> > +		devcg = cgroup_to_devcgroup(pos);
> > +		if (is_devcg_online(devcg))
> > +			list_add_tail(&devcg->propagate_pending, &pending);
> > +	}
> > +	rcu_read_unlock();
> 
> I think it could be a good idea to factor out the above and document
> what's going on and why.

ok, will fix the missing bits based on your comments and resubmit.

-- 
Aristeu
