From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH 01/40] lib/string_helpers: Drop space in
 string_get_size's output
Date: Wed, 03 May 2023 08:15:42 -0400
Message-ID: <8f3ab2a3091d7e2d1c3f593a335b03f3dcbebc89.camel@HansenPartnership.com>
References: <20230501165450.15352-1-surenb@google.com>
         <20230501165450.15352-2-surenb@google.com>
         <ouuidemyregstrijempvhv357ggp4tgnv6cijhasnungsovokm@jkgvyuyw2fti>
         <ZFAUj+Q+hP7cWs4w@moria.home.lan>
         <b6b472b65b76e95bb4c7fc7eac1ee296fdbb64fd.camel@HansenPartnership.com>
         <ZFCA2FF+9MI8LI5i@moria.home.lan>
         <2f5ebe8a9ce8471906a85ef092c1e50cfd7ddecd.camel@HansenPartnership.com>
         <20230502225016.GJ2155823@dread.disaster.area>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-modules-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1683116150;
        bh=VDKmAp+D+K8DEGYmTk7RY6tTKuk1qCgpkelWg/ywlAg=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=PlkG5v+bL2k1SR6S+xTcurYCQMY1gqlm0glsK3Tehy9JLi4tipUL2h0fY91Ww/VO3
         xDO5VLDNlSvr1ssHxu7B/uhx43c8VdCE70ZP8rGdKM8n07MK0plgjoj7x5eBJNKiLf
         ZQX0hxl/XubtAQyr+oR+xbN/Fjm9fwU7RWvy5GrI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1683116149;
        bh=VDKmAp+D+K8DEGYmTk7RY6tTKuk1qCgpkelWg/ywlAg=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=J6HQpG+VrJ9szCbazPDOCSIgT+5ut4XwqZK3Dc0MdxaQliyHK3p1NrakhT8ZMCjIK
         DNU+c0q6UaQjTZWPcZArAplMwU8UXy5bNs7sVcjLlrCYF64EO/PeWZtKPIX4uqlfWh
         7xj+nhVGXEVTMTaNQqx/bgBI26AK0f9jPuO3roXU=
In-Reply-To: <20230502225016.GJ2155823-pA1nmv6sEBkOM8BvhN4Z8vybgvtCy99p@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Dave Chinner <david-FqsqvQoI3Ljby3iVrkZq2A@public.gmane.org>
Cc: Kent Overstreet <kent.overstreet-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, liam.howlett-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ldufour-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, masahiroy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, nathan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pasha.tatashin-2EmBfe737+LQT0dZR+AlfA@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dhowells@redhat.c

On Wed, 2023-05-03 at 08:50 +1000, Dave Chinner wrote:
> On Tue, May 02, 2023 at 07:42:59AM -0400, James Bottomley wrote:
> > On Mon, 2023-05-01 at 23:17 -0400, Kent Overstreet wrote:
> > > On Mon, May 01, 2023 at 10:22:18PM -0400, James Bottomley wrote:
> > > > It is not used just for debug.  It's used all over the kernel
> > > > for printing out device sizes.  The output mostly goes to the
> > > > kernel print buffer, so it's anyone's guess as to what, if any,
> > > > tools are parsing it, but the concern about breaking log
> > > > parsers seems to be a valid one.
> > > 
> > > Ok, there is sd_print_capacity() - but who in their right mind
> > > would be trying to scrape device sizes, in human readable units,
> > 
> > If you bother to google "kernel log parser", you'll discover it's
> > quite an active area which supports a load of company business
> > models.
> 
> That doesn't mean log messages are unchangable ABI. Indeed, we had
> the whole "printk_index_emit()" addition recently to create
> an external index of printk message formats for such applications to
> use. [*]

I didn't say they were.
> 
> > >  from log messages when it's available in sysfs/procfs (actually,
> > > is it in sysfs? if not, that's an oversight) in more reasonable
> > > units?
> > 
> > It's not in sysfs, no.  As aren't a lot of things, which is why log
> > parsing for system monitoring is big business.
> 
> And that big business is why printk_index_emit() exists to allow
> them to easily determine how log messages change format and come and
> go across different kernel versions.
> 
> > > Correct me if I'm wrong, but I've yet to hear about kernel log
> > > messages being consider a stable interface, and this seems a bit
> > > out there.
> > 
> > It might not be listed as stable, but when it's known there's a
> > large ecosystem out there consuming it we shouldn't break it just
> > because you feel like it.
> 
> But we've solved this problem already, yes?

Well, yes; since it's a simple bit of extra thought and a couple of
lines addition not to afflict everyone with the change, that's the
simplest course.  It also gets us out of arguing about whether the
space reads better and is SI consistent.

> If the userspace applications are not using the kernel printk format
> index to detect such changes between kernel version, then they
> should be. This makes trivial issues like whether we have a space or
> not between units is completely irrelevant because the entry in the
> printk format index for the log output we emit will match whatever
> is output by the kernel....

Just because we have better tools to fix a problem when it happens
doesn't mean we should actively cause the problem when its easily
avoidable.  In the same way we shouldn't drive less carefully just
because cars are built safer today.

James

