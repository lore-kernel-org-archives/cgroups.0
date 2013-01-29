From: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 1/9] device_cgroup: prepare exception list handling
 functions for two lists
Date: Tue, 29 Jan 2013 14:45:14 -0500
Message-ID: <20130129194514.GW17632@redhat.com>
References: <20130129190759.117458287@napanee.usersys.redhat.com>
 <20130129190759.321644928@napanee.usersys.redhat.com>
 <20130129194155.GB6824@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130129194155.GB6824-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

On Tue, Jan 29, 2013 at 11:41:55AM -0800, Tejun Heo wrote:
> On Tue, Jan 29, 2013 at 02:08:00PM -0500, aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org wrote:
> > In the following patches, device_cgroup structure will have two sets of
> > behavior and exceptions list (actual one, another with the local settings)
> > so rework the functions to use exception list, not a device_cgroup.
> > 
> > Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > Cc: Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
> > Signed-off-by: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> 
> Acked-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> 
> Can you please keep acks across postings?  That makes it a bit easier
> for reviewers.

sure, will do it in the future submissions.

-- 
Aristeu
