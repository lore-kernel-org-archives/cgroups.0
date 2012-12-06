From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 3/5] device_cgroup: keep track of local group settings
Date: Thu, 6 Dec 2012 04:31:30 +0000
Message-ID: <20121206043130.GA22792@mail.hallyn.com>
References: <20121127193501.255267751@napanee.usersys.redhat.com>
 <20121127193502.482004744@napanee.usersys.redhat.com>
 <20121129192945.GD26104@mail.hallyn.com>
 <20121129195942.GW32112@redhat.com>
 <20121129202608.GA26716@mail.hallyn.com>
 <20121129223111.GZ32112@redhat.com>
 <20121203180125.GA30637@mail.hallyn.com>
 <20121203190657.GD32112@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121203190657.GD32112-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Quoting Aristeu Rozanski (aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org):
> On Mon, Dec 03, 2012 at 06:01:25PM +0000, Serge E. Hallyn wrote:
> > First, generally, I don't think 'allows' added to parent should be 
> > automatically propagated to descendents.
> 
> that's what I think too and what I tried to do
> 
> > In devcgroup_update_access: (around line 625)
> > 	there is a period of time where cgroup members have
> > 	default allow without the parent's exceptions.
> 
> true, will fix that one and look for more cases
> 
> > propagate_behavior (line 505):
> > 	1. doesn't follow the same ordering as devcgroup_update_access(), in
> > 	particular cleaning exceptions before setting behavior.
> 
> I see, will update that
> 
> > 	2. When changing a parent from deny to allow, I don't think children
> > 	should be updated.
> 
> I disagree on this one. since there'll be local preferences, it'll try
> to revalidate them everytime there's a change. so, for example, an
> exception that might not be possible now, will be possible when its
> parent changes in a way that allows that.

My concern is just practical - if I've started a bunch of containers,
and another admin decides to make a change to the root devices cgroup,
I don't want the container's device accesses now changing.

Maybe that's better solved by having all of userspace sit in /system
while containers and vms sit under /lxc and /libvirt...

-serge
