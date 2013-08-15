From: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/4] devcg: Store local settings for each device cgroup
Date: Thu, 15 Aug 2013 16:48:04 -0400
Message-ID: <20130815204804.GO7878@redhat.com>
References: <1376580854-30929-1-git-send-email-aris@redhat.com>
 <20130815195941.GA10977@mtj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20130815195941.GA10977-9pTldWuhBndy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Lennart Poettering <mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org>

Hi Tejun,
On Thu, Aug 15, 2013 at 03:59:41PM -0400, Tejun Heo wrote:
> On Thu, Aug 15, 2013 at 11:34:10AM -0400, aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org wrote:
> > With this patchset, the 'b 1:5 r' exception will be kept and whenever possible
> > (more specifically when the parent gets access to more devices) it'll be
> > re-evaluated and applied if allowed. In this specific case, since it's allowed
> > again, the exception 'b 1:5 r' will be reapplied to B.
> 
> So, while this patchset is headed in the right direction, some stuff
> still bothers me.
> 
> * The configurations are finicky and complex.  There are many ways to
>   configure it and some may fail depending on some conditions.  I
>   really wish it were a lot simpler, at least when sane_behavior.

The ways it can fail is based on parent's permission. Yes, it's complex,
but part of it was based on decisions taken to make the code simpler.
For example: one thing left out from the last patchset was propagating
access to new devices: let's say you add an exception to a behavior deny
cgroup, it'd not be propagated down.

I'd prefer just top down changes. Parent allows X? cgroup allows X
unless local rule says otherwise.

> * Using separate propagation paths for allows and denys feels a bit
>   weird.  Can't config just update local config and always propagate
>   the change downwards?

That was a design decision back then. It might be doable to keep the
same way it is by simply not adding extra access to devices in cgroups
when propagating an exception like that. But that will only make both
paths call the same function, not really any different.

> When sane_behavior, can't we have something like the following?
> 
> * Setting local config is not affected by what ancestors or
>   descendants are doing.  It just sets local config and triggers
>   propagation and never fails (except for things like alloc failure).

That could be done but would certanly break the interface. Perhaps a
good time to introduce a newer interface that can mirror the
behavior/exception model to userspace?

> * Config defaults to allow-all unconfigured and there are only two
>   modes - allow-all or allow-only-listed with an easy way to flip
>   between the two and clear the list, which lists either specific
>   maj:min or maj.

That would get rid of the 'allow all but with some exceptions' model
which is useful in cases such when you just don't want scsi devices to be
written, but pretty much everything else is ok. Wonder how many people
would miss it?

-- 
Aristeu
