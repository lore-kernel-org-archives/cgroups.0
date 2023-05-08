From: Kent Overstreet <kent.overstreet-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH 00/40] Memory allocation profiling
Date: Mon, 8 May 2023 16:48:27 -0400
Message-ID: <ZFlgG02A87qPNIn1@moria.home.lan>
References: <20230501165450.15352-1-surenb@google.com>
 <ZFIMaflxeHS3uR/A@dhcp22.suse.cz>
 <CAJuCfpHxbYFxDENYFfnggh1D8ot4s493PQX0C7kD-JLvixC-Vg@mail.gmail.com>
 <ZFN1yswCd9wRgYPR@dhcp22.suse.cz>
 <ZFfd99w9vFTftB8D@moria.home.lan>
 <20230508175206.7dc3f87c@meshulam.tesarici.cz>
 <ZFkb1p80vq19rieI@moria.home.lan>
 <20230508180913.6a018b21@meshulam.tesarici.cz>
 <ZFkjRBCExpXfI+O5@moria.home.lan>
 <20230508205939.0b5b485c@meshulam.tesarici.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1683578919;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T9yUrg/v5raybQi2xKwTXiJDyugUh7KFNSbnsbVf1ko=;
        b=JlOqRkPdzk5AJhxPMwu8AlexUvrKA9kXRniMs6KXFAxkkCykU6KjHBDIF+g4xO4yC/3Xao
        +RuScEMByhVbOYP7Nl+Ojs+6ZTV4KDzSfRqi3slN82Zdtt1OUgviKekasieY9DgexpymM2
        tFWfTgTgTslrvfQsG/FcZTuRpfPmr6I=
Content-Disposition: inline
In-Reply-To: <20230508205939.0b5b485c-TD/jYOLh/Qr2G+KSGY6Hrl+YFMdMcpeZ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Petr =?utf-8?B?VGVzYcWZw61r?= <petr-hIRrMMry8ebtwjQa/ONI9g@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, liam.howlett-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ldufour-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, masahiroy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, nathan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pasha.tatashin-2EmBfe737+LQT0dZR+AlfA@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

On Mon, May 08, 2023 at 08:59:39PM +0200, Petr Tesařík wrote:
> On Mon, 8 May 2023 12:28:52 -0400
> Kent Overstreet <kent.overstreet-fxUVXftIFDnyG1zEObXtfA@public.gmane.org> wrote:
> 
> > On Mon, May 08, 2023 at 06:09:13PM +0200, Petr Tesařík wrote:
> > > Sure, although AFAIK the index does not cover all possible config
> > > options (so non-x86 arch code is often forgotten). However, that's the
> > > less important part.
> > > 
> > > What do you do if you need to hook something that does conflict with an
> > > existing identifier?  
> > 
> > As already happens in this patchset, rename the other identifier.
> > 
> > But this is C, we avoid these kinds of conflicts already because the
> > language has no namespacing
> 
> This statement is not accurate, but I agree there's not much. Refer to
> section 6.2.3 of ISO/IEC9899:2018 (Name spaces of identifiers).
> 
> More importantly, macros also interfere with identifier scoping, e.g.
> you cannot even have a local variable with the same name as a macro.
> That's why I dislike macros so much.

Shadowing a global identifier like that would at best be considered poor
style, so I don't see this as a major downside.

> But since there's no clear policy regarding macros in the kernel, I'm
> merely showing a downside; it's perfectly fine to write kernel code
> like this as long as the maintainers agree that the limitation is
> acceptable and outweighed by the benefits.

Macros do have lots of tricky downsides, but in general we're not shy
about using them for things that can't be done otherwise; see
wait_event(), all of tracing...

I think we could in general do a job of making the macros _themselves_
more managable, when writing things that need to be macros I'll often
have just the wrapper as a macro and write the bulk as inline functions.
See the generic radix tree code for example.

Reflection is a major use case for macros, and the underlying mechanism
here - code tagging - is something worth talking about more, since it's
codifying something that's been done ad-hoc in the kernel for a long
time and something we hope to refactor other existing code to use,
including tracing - I've got a patch already written to convert the
dynamic debug code to code tagging; it's a nice -200 loc cleanup.

Regarding the alloc_hooks() macro itself specifically, I've got more
plans for it. I have another patch series after this one that implements
code tagging based fault injection, which is _far_ more ergonomic to use
than our existing fault injection capabilities (and this matters! Fault
injection is a really important tool for getting good test coverage, but
tools that are a pain in the ass to use don't get used) - and with the
alloc_hooks() macro already in place, we'll be able to turn _every
individual memory allocation callsite_ into a distinct, individually
selectable fault injection point - which is something our existing fault
injection framework attempts at but doesn't really manage.

If we can get this in, it'll make it really easy to write unit tests
that iterate over every memory allocation site in a given module,
individually telling them to fail, run a workload until they hit, and
verify that the code path being tested was executed. It'll nicely
complement the fuzz testing capabilities that we've been working on,
particularly in filesystem land.
