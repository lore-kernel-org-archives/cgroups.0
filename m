From: Kent Overstreet <kent.overstreet-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH 00/40] Memory allocation profiling
Date: Wed, 3 May 2023 05:54:43 -0400
Message-ID: <ZFIvY5p1UAXxHw9s@moria.home.lan>
References: <20230501165450.15352-1-surenb@google.com>
 <ZFIMaflxeHS3uR/A@dhcp22.suse.cz>
 <ZFIOfb6/jHwLqg6M@moria.home.lan>
 <ZFISlX+mSx4QJDK6@dhcp22.suse.cz>
 <20230503115051.30b8a97f@meshulam.tesarici.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1683107695;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Jg445jwECvvRmiCScPtVAaWcZXXyMj8rYmSMQmAKTHE=;
        b=lCllcENijvyC1ebNj7URRaDdhwEZW7RyfvbYg1fVUeO79bulTkt3RjYJG2jVCHzwR7Pc3x
        HUxyBBuo+xgNeAXZgmwQd3P2gPgxlM+XgMIkSt4fwh5HjNr9tfDeILYa8rca8iOp4VrOxy
        Ufos0rVn5Brx5c1dPWhOO5ah3BGV4Lc=
Content-Disposition: inline
In-Reply-To: <20230503115051.30b8a97f-TD/jYOLh/Qr2G+KSGY6Hrl+YFMdMcpeZ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Petr =?utf-8?B?VGVzYcWZw61r?= <petr-hIRrMMry8ebtwjQa/ONI9g@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, liam.howlett-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ldufour-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, masahiroy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, nathan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pasha.tatashin-2EmBfe737+LQT0dZR+AlfA@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

On Wed, May 03, 2023 at 11:50:51AM +0200, Petr Tesařík wrote:
> On Wed, 3 May 2023 09:51:49 +0200
> Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote:
> 
> > On Wed 03-05-23 03:34:21, Kent Overstreet wrote:
> >[...]
> > > We've made this as clean and simple as posssible: a single new macro
> > > invocation per allocation function, no calling convention changes (that
> > > would indeed have been a lot of churn!)  
> > 
> > That doesn't really make the concern any less relevant. I believe you
> > and Suren have made a great effort to reduce the churn as much as
> > possible but looking at the diffstat the code changes are clearly there
> > and you have to convince the rest of the community that this maintenance
> > overhead is really worth it.
> 
> I believe this is the crucial point.
> 
> I have my own concerns about the use of preprocessor macros, which goes
> against the basic idea of a code tagging framework (patch 13/40).
> AFAICS the CODE_TAG_INIT macro must be expanded on the same source code
> line as the tagged code, which makes it hard to use without further
> macros (unless you want to make the source code unreadable beyond
> imagination). That's why all allocation functions must be converted to
> macros.
> 
> If anyone ever wants to use this code tagging framework for something
> else, they will also have to convert relevant functions to macros,
> slowly changing the kernel to a minefield where local identifiers,
> struct, union and enum tags, field names and labels must avoid name
> conflict with a tagged function. For now, I have to remember that
> alloc_pages is forbidden, but the list may grow.

No, we've got other code tagging applications (that have already been
posted!) and they don't "convert functions to macros" in the way this
patchset does - they do introduce new macros, but as new identifiers,
which we do all the time.

This was simply the least churny way to hook memory allocations.
