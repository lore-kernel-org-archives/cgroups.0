From: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>
Subject: Re: legacy mode
Date: Thu, 27 Aug 2015 16:23:26 -0500
Message-ID: <20150827212326.GA5019@mail.hallyn.com>
References: <20150827202137.GA4221@mail.hallyn.com>
 <20150827202722.GH26785@mtj.duckdns.org>
 <20150827204500.GA4447@mail.hallyn.com>
 <20150827204825.GI26785@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150827204825.GI26785-qYNAdHglDFBN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Aug 27, 2015 at 04:48:25PM -0400, Tejun Heo wrote:
> Hello, Serge.
> 
> On Thu, Aug 27, 2015 at 03:45:00PM -0500, Serge E. Hallyn wrote:
> > > If the legacy userspace doesn't do any resource control, the leaf rule
> > > restriction doesn't apply anyway, so nothing to worry about.
> > 
> > My main use case is nested lxc, presumably with systemd inside some of
> > the nested containers, so this would definately be an issue.
> 
> W/o controllers in the nested environment, it should be fine.  W/
> controllers, I don't think this is going to fly.  I don't think trying
> to bridge the two versions is a healthy direction in the long term.

That's unfortunate as it suggests that lxcfs is the only way around
this problem :(
