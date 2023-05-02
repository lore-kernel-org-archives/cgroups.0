From: Kent Overstreet <kent.overstreet-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH 01/40] lib/string_helpers: Drop space in
 string_get_size's output
Date: Mon, 1 May 2023 23:17:44 -0400
Message-ID: <ZFCA2FF+9MI8LI5i@moria.home.lan>
References: <20230501165450.15352-1-surenb@google.com>
 <20230501165450.15352-2-surenb@google.com>
 <ouuidemyregstrijempvhv357ggp4tgnv6cijhasnungsovokm@jkgvyuyw2fti>
 <ZFAUj+Q+hP7cWs4w@moria.home.lan>
 <b6b472b65b76e95bb4c7fc7eac1ee296fdbb64fd.camel@HansenPartnership.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1682997481;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NNVXUMOZeoGpfLU/g3IFEb1hzaUHRqGWiLOTQQBIzYs=;
        b=L9EjkbdltRch9MgagDXpSmI/SQ+kmTNwjzD2kEN8waOF/RCt31vTo+jIgPhW0KLguu62G7
        jZKDOwsdNq/VcE+v4jYF6hx3mSb878eUweleN/RRxaVLz4V86Oi14XqlhSq7SRWchtaboC
        hzokkApB+A0wqzQja9W/cxeTQjw0qp4=
Content-Disposition: inline
In-Reply-To: <b6b472b65b76e95bb4c7fc7eac1ee296fdbb64fd.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, liam.howlett-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ldufour-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, masahiroy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, nathan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pasha.tatashin-2EmBfe737+LQT0dZR+AlfA@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, andreyknvl-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, k

On Mon, May 01, 2023 at 10:22:18PM -0400, James Bottomley wrote:
> It is not used just for debug.  It's used all over the kernel for
> printing out device sizes.  The output mostly goes to the kernel print
> buffer, so it's anyone's guess as to what, if any, tools are parsing
> it, but the concern about breaking log parsers seems to be a valid one.

Ok, there is sd_print_capacity() - but who in their right mind would be
trying to scrape device sizes, in human readable units, from log
messages when it's available in sysfs/procfs (actually, is it in sysfs?
if not, that's an oversight) in more reasonable units?

Correct me if I'm wrong, but I've yet to hear about kernel log messages
being consider a stable interface, and this seems a bit out there.

But, you did write the code :)

> > If someone raises a specific objection we'll do something different,
> > otherwise I think standardizing on what userspace tooling already
> > parses is a good idea.
> 
> If you want to omit the space, why not simply add your own variant?  A
> string_get_size_nospace() which would use most of the body of this one
> as a helper function but give its own snprintf format string at the
> end.  It's only a couple of lines longer as a patch and has the bonus
> that it definitely wouldn't break anything by altering an existing
> output.

I'm happy to do that - I just wanted to post this version first to see
if we can avoid the fragmentation and do a bit of standardizing with
how everything else seems to do that.
