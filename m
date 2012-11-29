From: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/5] device_cgroup: keep track of local group settings
Date: Thu, 29 Nov 2012 17:31:11 -0500
Message-ID: <20121129223111.GZ32112@redhat.com>
References: <20121127193501.255267751@napanee.usersys.redhat.com>
 <20121127193502.482004744@napanee.usersys.redhat.com>
 <20121129192945.GD26104@mail.hallyn.com>
 <20121129195942.GW32112@redhat.com>
 <20121129202608.GA26716@mail.hallyn.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121129202608.GA26716-7LNsyQBKDXoIagZqoN9o3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Nov 29, 2012 at 08:26:08PM +0000, Serge E. Hallyn wrote:
> Quoting Aristeu Rozanski (aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org):
> > I see your point. it's indeed a problem. in dev_exception_add(), it
> > needs to check for permissions before actually adding to
> > devcgroup->exceptions.

actually, checked again, it's done correctly. when adding an exception
that will allow extra device access (DEVCG_ALLOW), it does check it
before. It means that you can't add local exceptions unless at a certain
point of the time it was allowed to do so.

> > 
> > > (Btw is there a git tree or gitweb view I could look at alongside
> > > the patchset?)
> > 
> > I'll rebase the patchset along with a fix for this and resubmit with a
> > link to the git repo.

just pushed the same version to:
git://github.com/aristeu/linux-2.6.git

please use branch devcg_hiearchy_review

-- 
Aristeu
