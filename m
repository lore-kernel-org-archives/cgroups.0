From: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 35/40] lib: implement context capture support for tagged allocations
Date: Fri, 5 May 2023 11:10:20 -0700
Message-ID: <CAJuCfpFOLyZKvtqHuukOZvegxGHVUcAtbh3Egt+01yZ9kcEAew@mail.gmail.com>
References: <20230501165450.15352-1-surenb@google.com> <20230501165450.15352-36-surenb@google.com>
 <ZFIPmnrSIdJ5yusM@dhcp22.suse.cz> <CAJuCfpGsvWupMbasqvwcMYsOOPxTQqi1ed5+=vyu-yoPQwwybg@mail.gmail.com>
 <ZFNoVfb+1W4NAh74@dhcp22.suse.cz> <CAJuCfpGUtw6cbjLsksGJKATZfTV0FEYRXwXT0pZV83XqQydBgg@mail.gmail.com>
 <ZFTA8xVzxWc345Ug@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683310232; x=1685902232;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QVZYG1JecNO86jzNV6C/AMNw6VQt+fJvqwCxq5mp/Nc=;
        b=JuehaV/RJK9Y4fUOdxkcZEuqDGAuEF/acJdDqJ45XbKARUoqq4czDg4ZH8mqWvQs0W
         C3cMUZ3VtCr6q/eI+6qJp58nulUMjZvQdZpvpUFXRdmOfRfhasZuNayk1xVHyGVy9Mwz
         ItoP45q/KUOjBJ5HUc+Vlm240zAnqes7cusDh4wsBFNSxkmDsbQVgr1QY7ENaCb2Pf+o
         stmyjKNibly7r3/lcAzIGX4ZSS4stgbgtYjMfq5c0cI/ZADNQtKt98fqV/f8MiQv11Tt
         rfeoXeDHmM1lnkcbyLTsW9UrOEazY/VwbfsLiL1Vyfp7oqXyyedjHeSP3hv1vKGbwqQn
         8juQ==
In-Reply-To: <ZFTA8xVzxWc345Ug-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, kent.overstreet-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, liam.howlett-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ldufour-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, masahiroy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, nathan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pasha.tatashin-2EmBfe737+LQT0dZR+AlfA@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, andreyknvl-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, keescook@chr

On Fri, May 5, 2023 at 1:40=E2=80=AFAM Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org> wrote=
:
>
> On Thu 04-05-23 09:22:07, Suren Baghdasaryan wrote:
> [...]
> > > But even then I really detest an additional allocation from this cont=
ext
> > > for every single allocation request. There GFP_NOWAIT allocation for
> > > steckdepot but that is at least cached and generally not allocating.
> > > This will allocate for every single allocation.
> >
> > A small correction here. alloc_tag_create_ctx() is used only for
> > allocations which we requested to capture the context. So, this last
> > sentence is true for allocations we specifically marked to capture the
> > context, not in general.
>
> Ohh, right. I have misunderstood that part. Slightly better, still
> potentially a scalability issue because hard to debug memory leaks
> usually use a generic caches (for kmalloc). So this might be still a lot
> of objects to track.

Yes, generally speaking, if a single code location is allocating very
frequently then enabling context capture for it will generate many
callstack buffers.

Your note about use of generic caches makes me think we still have a
small misunderstanding. We tag at the allocation call site, not based
on which cache is used. Two kmalloc calls from different code
locations will have unique codetags for each, so enabling context
capture for one would not result in context capturing for the other
one.

>
> > > There must be a better way.
> >
> > Yeah, agree, it would be good to avoid allocations in this path. Any
> > specific ideas on how to improve this? Pooling/caching perhaps? I
> > think kmem_cache does some of that already but maybe something else?
>
> The best I can come up with is a preallocated hash table to store
> references to stack depots with some additional data associated. The
> memory overhead could be still quite big but the hash tables could be
> resized lazily.

Ok, that seems like the continuation of you suggestion in another
thread to combine identical callstack traces. That's an excellent
idea! I think it would not be hard to implement. Thanks!

> --
> Michal Hocko
> SUSE Labs
