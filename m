From: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/40] Memory allocation profiling
Date: Wed, 3 May 2023 13:14:57 -0700
Message-ID: <CAJuCfpE4YD_BumqFf2-NC8KS9D+kq0s_o4gRyWAH-WK4SgqUbA@mail.gmail.com>
References: <ZFIVtB8JyKk0ddA5@moria.home.lan> <ZFKNZZwC8EUbOLMv@slm.duckdns.org>
 <20230503180726.GA196054@cmpxchg.org> <ZFKlrP7nLn93iIRf@slm.duckdns.org>
 <ZFKqh5Dh93UULdse@slm.duckdns.org> <ZFKubD/lq7oB4svV@moria.home.lan>
 <ZFKu6zWA00AzArMF@slm.duckdns.org> <ZFKxcfqkUQ60zBB_@slm.duckdns.org>
 <CAJuCfpEPkCJZO2svT-GfmpJ+V-jSLyFDKM_atnqPVRBKtzgtnQ@mail.gmail.com>
 <ZFK6pwOelIlhV8Bm@slm.duckdns.org> <ZFK9XMSzOBxIFOHm@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683144920; x=1685736920;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fJv5xHBTJjNv/pix2rgh9sMW7sCnrk66nOy29HPAlus=;
        b=UCO8xAxPQELEnJ5Z/+6POOiyN0vC8Y3LS4oWyDMuhEhZvFzcfiun+ebWGPwrO+pD6P
         oaWSGqmefHbl5lAEiPf5lmUVnYEfPjsrvltc8OpHClJDRLqR0c6JCt2K4/o8XHiKCVdf
         J53ZnSfM4WQ/BqrKp+eVl6M1p/n6Qe+G3n50PB19Uzdxt6cKRczUS8ApWupvLyGowGSr
         nGY8DkG6nB+Z74vkrN7ka4kE+r+AVY9ut3CcNzBfOZ5eIHL+qS/vkhlLgZTTLFk7Q8GU
         5cYkPlXWlkK/9gZow1krRfzsVVYIijdz+900Nl7CuaPdx5c8WOD0aSivErWELXWkx49V
         I4sg==
In-Reply-To: <ZFK9XMSzOBxIFOHm-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1254"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Kent Overstreet <kent.overstreet-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, liam.howlett-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ldufour-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, masahiroy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, nathan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pasha.tatashin-2EmBfe737+LQT0dZR+AlfA@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

On Wed, May 3, 2023 at 1:00=E2=80=AFPM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> Hello,
>
> On Wed, May 03, 2023 at 09:48:55AM -1000, Tejun Heo wrote:
> > > If so, that's the idea behind the context capture feature so that we
> > > can enable it on specific allocations only after we determine there i=
s
> > > something interesting there. So, with low-cost persistent tracking we
> > > can determine the suspects and then pay some more to investigate thos=
e
> > > suspects in more detail.
> >
> > Yeah, I was wondering whether it'd be useful to have that configurable =
so
> > that it'd be possible for a user to say "I'm okay with the cost, please
> > track more context per allocation". Given that tracking the immediate c=
aller
> > is already a huge improvement and narrowing it down from there using
> > existing tools shouldn't be that difficult, I don't think this is a blo=
cker
> > in any way. It just bothers me a bit that the code is structured so tha=
t
> > source line is the main abstraction.
>
> Another related question. So, the reason for macro'ing stuff is needed is
> because you want to print the line directly from kernel, right?

The main reason is because we want to inject a code tag at the
location of the call. If we have a code tag injected at every
allocation call, then finding the allocation counter (code tag) to
operate takes no time.

> Is that
> really necessary? Values from __builtin_return_address() can easily be
> printed out as function+offset from kernel which already gives most of th=
e
> necessary information for triaging and mapping that back to source line f=
rom
> userspace isn't difficult. Wouldn't using __builtin_return_address() make
> the whole thing a lot simpler?

If we do that we have to associate that address with the allocation
counter at runtime on the first allocation and look it up on all
following allocations. That introduces the overhead which we are
trying to avoid by using macros.

>
> Thanks.
>
> --
> tejun
