From: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/40] Memory allocation profiling
Date: Wed, 3 May 2023 20:33:28 -0700
Message-ID: <CAJuCfpGmc==xztXgiM+UUA5GGhxstB2r=yTjNUwSshaj5FpBFw@mail.gmail.com>
References: <20230503180726.GA196054@cmpxchg.org> <ZFKlrP7nLn93iIRf@slm.duckdns.org>
 <ZFKqh5Dh93UULdse@slm.duckdns.org> <ZFKubD/lq7oB4svV@moria.home.lan>
 <ZFKu6zWA00AzArMF@slm.duckdns.org> <ZFKxcfqkUQ60zBB_@slm.duckdns.org>
 <CAJuCfpEPkCJZO2svT-GfmpJ+V-jSLyFDKM_atnqPVRBKtzgtnQ@mail.gmail.com>
 <ZFK6pwOelIlhV8Bm@slm.duckdns.org> <ZFK9XMSzOBxIFOHm@slm.duckdns.org>
 <CAJuCfpE4YD_BumqFf2-NC8KS9D+kq0s_o4gRyWAH-WK4SgqUbA@mail.gmail.com> <ZFMXmj9ZhSe5wyaS@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-modules-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683171221; x=1685763221;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ezowVIfZ+j5q5fnHBXFJgjQgqAlO13MfPXw7qEM899U=;
        b=lL+P1HWGx+y87/s7tJ3yJEOlJ9xZakfyxCZ/vj2vLDVlNBtKFp5TryG8cJdaJpBcY3
         guIC/GIEBTyQZrHE6ZNHiQ86VI1OapFezm0uE0T+1OK+K4KYYfBBjtbLybxs4JzubUJ/
         YHIYmrIrkP5sV/C/lw2aAB2KyoF9ze882p2X7gtWbJ7Ck0EEAHwV0AOp5iYiKP9dpnkl
         JG4AkClQv8a9C8JNwybz3M08XO+E4JFF6RNOKRacmV8gTFgw1n0DajrnRmLfrbF5RGNA
         oAFHvA1e8eD3Al3/gqVbjERe8sD7tl0wTSvmn2cJLhru0NU5xErhL5P5WdguSe6A94ip
         wwkg==
In-Reply-To: <ZFMXmj9ZhSe5wyaS-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Kent Overstreet <kent.overstreet-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, liam.howlett-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ldufour-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, masahiroy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, nathan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pasha.tatashin-2EmBfe737+LQT0dZR+AlfA@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

On Wed, May 3, 2023 at 7:25=E2=80=AFPM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> Hello,
>
> On Wed, May 03, 2023 at 01:14:57PM -0700, Suren Baghdasaryan wrote:
> > On Wed, May 3, 2023 at 1:00=E2=80=AFPM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > > Another related question. So, the reason for macro'ing stuff is neede=
d is
> > > because you want to print the line directly from kernel, right?
> >
> > The main reason is because we want to inject a code tag at the
> > location of the call. If we have a code tag injected at every
> > allocation call, then finding the allocation counter (code tag) to
> > operate takes no time.
> >
> > > Is that
> > > really necessary? Values from __builtin_return_address() can easily b=
e
> > > printed out as function+offset from kernel which already gives most o=
f the
> > > necessary information for triaging and mapping that back to source li=
ne from
> > > userspace isn't difficult. Wouldn't using __builtin_return_address() =
make
> > > the whole thing a lot simpler?
> >
> > If we do that we have to associate that address with the allocation
> > counter at runtime on the first allocation and look it up on all
> > following allocations. That introduces the overhead which we are
> > trying to avoid by using macros.
>
> I see. I'm a bit skeptical about the performance angle given that the hot
> path can be probably made really cheap even with lookups. In most cases,
> it's just gonna be an extra pointer deref and a few more arithmetics. Tha=
t
> can show up in microbenchmarks but it's not gonna be much. The benefit of
> going that route would be the tracking thing being mostly self contained.

I'm in the process of rerunning the tests to compare the overhead on
the latest kernel but I don't expect that to be cheap compared to
kmalloc().

>
> That said, it's nice to not have to worry about allocating tracking slots
> and managing hash table, so no strong opinion.
>
> Thanks.
>
> --
> tejun
>
> --
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to kernel-team+unsubscribe-z5hGa2qSFaTowKkBSvOlow@public.gmane.org
>
