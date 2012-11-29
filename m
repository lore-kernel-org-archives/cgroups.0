From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/5] device_cgroup: keep track of local group settings
Date: Thu, 29 Nov 2012 20:26:08 +0000
Message-ID: <20121129202608.GA26716@mail.hallyn.com>
References: <20121127193501.255267751@napanee.usersys.redhat.com>
 <20121127193502.482004744@napanee.usersys.redhat.com>
 <20121129192945.GD26104@mail.hallyn.com>
 <20121129195942.GW32112@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121129195942.GW32112-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Quoting Aristeu Rozanski (aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org):
> On Thu, Nov 29, 2012 at 07:29:45PM +0000, Serge E. Hallyn wrote:
> > Quoting Aristeu Rozanski (aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org):
> > > In preparation for better hierarchy support, it's needed to retain the local
> > > settings in order to try to reapply them after a propagated change if they're
> > > still valid.
> > > 
> > > Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > > Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> > > Signed-off-by: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> > >  
> > > ---
> > >  security/device_cgroup.c |  108 ++++++++++++++++++++++++++++++++++-------------
> > >  1 file changed, 80 insertions(+), 28 deletions(-)
> > 
> > Hi,
> > 
> > thanks for doing this.  I've got one concern though.  I don't see
> > any place where devcgroup_create() was updated to create the
> > local exceptions list.  I think we need a guarantee that at
> 
> the local exceptions list is part of the dev_cgroup structure and it's
> initialized on the patch 'device_cgroup: keep track of local group
> setting':
> 
> @@ -190,6 +238,8 @@
>         if (!dev_cgroup)
>                 return ERR_PTR(-ENOMEM);
>         INIT_LIST_HEAD(&dev_cgroup->exceptions);
> +       INIT_LIST_HEAD(&dev_cgroup->local.exceptions);
> +       dev_cgroup->local.behavior = DEVCG_DEFAULT_NONE;
>         parent_cgroup = cgroup->parent;
> 
>         if (parent_cgroup == NULL)
> 
> > any time the local exceptions list will contain all the entries
> > contained in the cgroup->exceptions list.  Otherwise you cannot
> 
> hm, no. the local exceptions are meant to be used for stuff written
> locally. the devcgroup->exceptions list is the list in effect.
> 
> > use the exception_add() the way you do (or you can't use RCU),
> > since there could be a window between the successful addition
> > of a rule to cgroup->local.exceptions and the failed addition to
> > cgroup->exceptions, during which a task (since it won't need
> > the mutex for devcg_allow()) could exceed allowed permissions.
> >
> > It's possible I'm misunderstanding.  If you think that's the case
> > just kick me and I'll take a fresh look.
> 
> I see your point. it's indeed a problem. in dev_exception_add(), it
> needs to check for permissions before actually adding to
> devcgroup->exceptions.
> 
> > (Btw is there a git tree or gitweb view I could look at alongside
> > the patchset?)
> 
> I'll rebase the patchset along with a fix for this and resubmit with a
> link to the git repo.

Thanks, Aristeu!

-serge
