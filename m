From: Kent Overstreet <kent.overstreet-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH 00/40] Memory allocation profiling
Date: Wed, 3 May 2023 04:05:08 -0400
Message-ID: <ZFIVtB8JyKk0ddA5@moria.home.lan>
References: <20230501165450.15352-1-surenb@google.com>
 <ZFIMaflxeHS3uR/A@dhcp22.suse.cz>
 <ZFIOfb6/jHwLqg6M@moria.home.lan>
 <ZFISlX+mSx4QJDK6@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-modules-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1683101119;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Af+2O/2Jo9IC9XECoO60Ibec+DnzA9yRBnuv4Bp8O9Y=;
        b=rqHkCee1X71Oj3G6VysOrsK/rdJHy9B0yyXfZMJ4T4TWGYp3bKIJl27dUenlhtN0eAw3EY
        9wtRJDXX0Vxp+Xc6ZM2YYwJwQELwnDdfgbU2buAGO1Vb841r/qxmb4h0I2pylWL1m2aZFQ
        DMBUFXd/kgyZZl04aMULTG8rjWs+sv0=
Content-Disposition: inline
In-Reply-To: <ZFISlX+mSx4QJDK6-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, liam.howlett-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ldufour-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, masahiroy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, nathan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pasha.tatashin-2EmBfe737+LQT0dZR+AlfA@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, andreyknvl-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

On Wed, May 03, 2023 at 09:51:49AM +0200, Michal Hocko wrote:
> Your answers have shown your insight into tracing is very limited. I
> have a clear recollection there were many suggestions on how to get what
> you need and willingness to help out. Repeating your previous position
> will not help much to be honest with you.

Please enlighten us, oh wise one.

> > > - It has been brought up that this is duplicating functionality already
> > >   available via existing tracing infrastructure. You should make it very
> > >   clear why that is not suitable for the job
> > 
> > Tracing people _claimed_ this, but never demonstrated it.
> 
> The burden is on you and Suren. You are proposing the implement an
> alternative tracing infrastructure.

No, we're still waiting on the tracing people to _demonstrate_, not
claim, that this is at all possible in a comparable way with tracing. 

It's not on us to make your argument for you, and before making
accusations about honesty you should try to be more honest yourself.

The expectations you're trying to level have never been the norm in the
kernel community, sorry. When there's a technical argument about the
best way to do something, _code wins_ and we've got working code to do
something that hasn't been possible previously.

There's absolutely no rule that "tracing has to be the one and only tool
for kernel visibility".

I'm considering the tracing discussion closed until someone in the
pro-tracing camp shows something new.

> > > - We already have page_owner infrastructure that provides allocation
> > >   tracking data. Why it cannot be used/extended?
> > 
> > Page owner is also very high overhead,
> 
> Is there any data to prove that claim? I would be really surprised that
> page_owner would give higher overhead than page tagging with profiling
> enabled (there is an allocation for each allocation request!!!). We can
> discuss the bare bone page tagging comparision to page_owner because of
> the full stack unwinding but is that overhead really prohibitively costly?
> Can we reduce that by trimming the unwinder information?

Honestly, this isn't terribly relevant, because as noted before page
owner is limited to just page allocations.

> 
> > and the output is not very user
> > friendly (tracking full call stack means many related overhead gets
> > split, not generally what you want), and it doesn't cover slab.
> 
> Is this something we cannot do anything about? Have you explored any
> potential ways?
> 
> > This tracks _all_ memory allocations - slab, page, vmalloc, percpu.

Michel, the discussions with you seem to perpetually go in circles; it's
clear you're negative on the patchset, you keep raising the same
objections while refusing to concede a single point.

I believe I've answered enough, so I'll leave off further discussions
with you.
