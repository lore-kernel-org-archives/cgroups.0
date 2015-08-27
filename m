From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: legacy mode
Date: Thu, 27 Aug 2015 15:45:00 -0500
Message-ID: <20150827204500.GA4447@mail.hallyn.com>
References: <20150827202137.GA4221@mail.hallyn.com>
 <20150827202722.GH26785@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150827202722.GH26785-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Aug 27, 2015 at 04:27:22PM -0400, Tejun Heo wrote:
> Hello,
> 
> On Thu, Aug 27, 2015 at 03:21:37PM -0500, Serge E. Hallyn wrote:
> > The problem this would solve is running older userspace (i.e. libvirt in
> > a container running an older distro) on a newer kernel which has unified
> > hierarchy mounted.
> 
> But the leaf restriction isn't the only change.  The interface files

That was an example.  It would also have to automatically enable
controllers in child cgroups, and I'm not sure what to do about
the tasks file.

> are different too and for some controllers the basic operation model
> is different, so I don't see how just adding .leaf would do much good.

Yeah and some of these may be a problem, but the problems I outlined
above are the ones which are *really* breaking old userspace.

Keeping in mind what I've seen most people use for containers, what I've
seen in the Documentation/cgroups/unified.txt file shouldn't be too terrible.
My last test was on 3.19.0-18-generic and I assume it gets worse, and
we'll need to proxy attempts at memory limit setting, for instance.

> If the legacy userspace doesn't do any resource control, the leaf rule
> restriction doesn't apply anyway, so nothing to worry about.

My main use case is nested lxc, presumably with systemd inside some of
the nested containers, so this would definately be an issue.

-serge
