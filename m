From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/3] cgroupns: Only allow creation of hierarchies in the
 initial cgroup namespace
Date: Fri, 15 Jul 2016 11:39:26 -0500
Message-ID: <20160715163926.GA18849@mail.hallyn.com>
References: <87h9br4h80.fsf@x220.int.ebiederm.org>
 <87r3av32g1.fsf@x220.int.ebiederm.org>
 <20160715111659.GB3078@mtj.duckdns.org>
 <8760s72lu5.fsf@x220.int.ebiederm.org>
 <87h9br16b7.fsf@x220.int.ebiederm.org>
 <20160715120501.GF3078@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160715120501.GF3078-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, Aditya Kali <adityakali-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Quoting Tejun Heo (tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org):
> On Fri, Jul 15, 2016 at 06:36:44AM -0500, Eric W. Biederman wrote:
> > 
> > Unprivileged users can't use hierarchies if they create them as they do not
> > have privilieges to the root directory.
> > 
> > Which means the only thing a hiearchy created by an unprivileged user
> > is good for is expanding the number of cgroup links in every css_set,
> > which is a DOS attack.
> > 
> > We could allow hierarchies to be created in namespaces in the initial
> > user namespace.  Unfortunately there is only a single namespace for
> > the names of heirarchies, so that is likely to create more confusion
> > than not.
> > 
> > So do the simple thing and restrict hiearchy creation to the initial
> > cgroup namespace.
> > 
> > Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Fixes: a79a908fd2b0 ("cgroup: introduce cgroup namespaces")
> > Signed-off-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
> 
> Applied to cgroup/for-4.7-fixes.

Thanks, guys.
