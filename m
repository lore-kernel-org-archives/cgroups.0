From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 00/40] Memory allocation profiling
Date: Wed, 3 May 2023 08:40:07 -1000
Message-ID: <ZFKqh5Dh93UULdse@slm.duckdns.org>
References: <20230501165450.15352-1-surenb@google.com>
 <ZFIMaflxeHS3uR/A@dhcp22.suse.cz>
 <ZFIOfb6/jHwLqg6M@moria.home.lan>
 <ZFISlX+mSx4QJDK6@dhcp22.suse.cz>
 <ZFIVtB8JyKk0ddA5@moria.home.lan>
 <ZFKNZZwC8EUbOLMv@slm.duckdns.org>
 <20230503180726.GA196054@cmpxchg.org>
 <ZFKlrP7nLn93iIRf@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683139209; x=1685731209;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sQ2ADeO1XgOmj5DxbzjpzikYpUTn+B695qqaLQsTl4A=;
        b=FAsEakodIYGZZ49hzhHq8Do+4wt23WK6jVIu98FKgEcC2IC28Yv1qcpIguYdAHmL41
         K6QXYVXYY9e0ydYBW/QaYBQ4kV1sgRKD0Z8m7VqP9eoT6OyuI2TEKLTHxSnuPoZ0/P86
         Ak//1N2uQgFgtt5vHB1OZ1Yr9lZGqpMPiXmn0PLHivzD9gD6C3pgBiZeck/EvcUad+D9
         AIqIEi6ySYiJEa/rjzcr1BnwS0cO5uVLCgZHYd00/2Qp62J0+g0bDyAUjzMrqC8es9RR
         PvNP8hKoKyN1VyTkZlWwEOSIbNVu+bisxPnpdL40o9ZuYAjxbUCiGJrKy44Q/i6wCbvS
         6MJg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ZFKlrP7nLn93iIRf-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Kent Overstreet <kent.overstreet-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, liam.howlett-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ldufour-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, masahiroy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, nathan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pasha.tatashin-2EmBfe737+LQT0dZR+AlfA@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dhowells@r

On Wed, May 03, 2023 at 08:19:24AM -1000, Tejun Heo wrote:
> > Taking a step back though, given the multitude of allocation sites in
> > the kernel, it's a bit odd that the only accounting we do is the tiny
> > fraction of voluntary vmstat/meminfo reporting. We try to cover the
> > biggest consumers with this of course, but it's always going to be
> > incomplete and is maintenance overhead too. There are on average
> > several gigabytes in unknown memory (total - known vmstats) on our
> > machines. It's difficult to detect regressions easily. And it's per
> > definition the unexpected cornercases that are the trickiest to track
> > down. So it might be doable with BPF, but it does feel like the kernel
> > should do a better job of tracking out of the box and without
> > requiring too much plumbing and somewhat fragile kernel allocation API
> > tracking and probing from userspace.
> 
> Yeah, easy / default visibility argument does make sense to me.

So, a bit of addition here. If this is the thrust, the debugfs part seems
rather redundant, right? That's trivially obtainable with tracing / bpf and
in a more flexible and performant manner. Also, are we happy with recording
just single depth for persistent tracking?

Thanks.

-- 
tejun
