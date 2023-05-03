From: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/40] Memory allocation profiling
Date: Wed, 3 May 2023 13:08:40 -0700
Message-ID: <CAJuCfpG4TmRpT5iU7bJmKcjW2Tghstdo1b=qEG=tDsmtJQYuWA@mail.gmail.com>
References: <ZFISlX+mSx4QJDK6@dhcp22.suse.cz> <ZFIVtB8JyKk0ddA5@moria.home.lan>
 <ZFKNZZwC8EUbOLMv@slm.duckdns.org> <20230503180726.GA196054@cmpxchg.org>
 <ZFKlrP7nLn93iIRf@slm.duckdns.org> <ZFKqh5Dh93UULdse@slm.duckdns.org>
 <ZFKubD/lq7oB4svV@moria.home.lan> <ZFKu6zWA00AzArMF@slm.duckdns.org>
 <ZFKxcfqkUQ60zBB_@slm.duckdns.org> <CAJuCfpEPkCJZO2svT-GfmpJ+V-jSLyFDKM_atnqPVRBKtzgtnQ@mail.gmail.com>
 <ZFK6pwOelIlhV8Bm@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-modules-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683144532; x=1685736532;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uaEl0+ttAfDVYkQkgOF9inVIlQxPo4MAHa3r5TcHPqs=;
        b=ZBFmhNUtx4spDPZ2Tc+ao7Umap1oUxGgS6L35zoiaIlLMa3sbvfe1yyzPgLcae3Fty
         gA+quo34T7AKstKRwlQ7/Ft2WrnkU+rEhs/+hqpbEUBx2dmlPORy4QLjme1jFVo6xrFm
         5ILD7V5NtcxuXC6YpDb35KI9Z72miAAGUfujh1KI5hzn6IQVZLP/6kKOSaDUuTufQ8Ku
         q+1OYE8Cg6APTP1NiSWm7QBLpXw9UsuF2OAhdSzB2PChvOsgj7ZoUWNOcF4i8/Nlqo2k
         4O1C3AV8COhnBUUJ7YqqIWrgXPcexM0yzg0bdV03LGdXCG1g+DB8aKT153Xkp0dZ7AtK
         Zo3g==
In-Reply-To: <ZFK6pwOelIlhV8Bm-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Kent Overstreet <kent.overstreet-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, liam.howlett-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ldufour-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, masahiroy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, nathan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pasha.tatashin-2EmBfe737+LQT0dZR+AlfA@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

On Wed, May 3, 2023 at 12:49=E2=80=AFPM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> Hello,
>
> On Wed, May 03, 2023 at 12:41:08PM -0700, Suren Baghdasaryan wrote:
> > On Wed, May 3, 2023 at 12:09=E2=80=AFPM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote=
:
> > >
> > > On Wed, May 03, 2023 at 08:58:51AM -1000, Tejun Heo wrote:
> > > > On Wed, May 03, 2023 at 02:56:44PM -0400, Kent Overstreet wrote:
> > > > > On Wed, May 03, 2023 at 08:40:07AM -1000, Tejun Heo wrote:
> > > > > > > Yeah, easy / default visibility argument does make sense to m=
e.
> > > > > >
> > > > > > So, a bit of addition here. If this is the thrust, the debugfs =
part seems
> > > > > > rather redundant, right? That's trivially obtainable with traci=
ng / bpf and
> > > > > > in a more flexible and performant manner. Also, are we happy wi=
th recording
> > > > > > just single depth for persistent tracking?
> >
> > IIUC, by single depth you mean no call stack capturing?
>
> Yes.
>
> > If so, that's the idea behind the context capture feature so that we
> > can enable it on specific allocations only after we determine there is
> > something interesting there. So, with low-cost persistent tracking we
> > can determine the suspects and then pay some more to investigate those
> > suspects in more detail.
>
> Yeah, I was wondering whether it'd be useful to have that configurable so
> that it'd be possible for a user to say "I'm okay with the cost, please
> track more context per allocation".

I assume by "more context per allocation" you mean for a specific
allocation, not for all allocations.
So, in a sense you are asking if the context capture feature can be
dropped from this series and implemented using some other means. Is
that right?

> Given that tracking the immediate caller
> is already a huge improvement and narrowing it down from there using
> existing tools shouldn't be that difficult, I don't think this is a block=
er
> in any way. It just bothers me a bit that the code is structured so that
> source line is the main abstraction.
>
> > > > > Not sure what you're envisioning?
> > > > >
> > > > > I'd consider the debugfs interface pretty integral; it's much mor=
e
> > > > > discoverable for users, and it's hardly any code out of the whole
> > > > > patchset.
> > > >
> > > > You can do the same thing with a bpftrace one liner tho. That's rat=
her
> > > > difficult to beat.
> >
> > debugfs seemed like a natural choice for such information. If another
> > interface is more appropriate I'm happy to explore that.
> >
> > >
> > > Ah, shit, I'm an idiot. Sorry. I thought allocations was under /proc =
and
> > > allocations.ctx under debugfs. I meant allocations.ctx is redundant.
> >
> > Do you mean that we could display allocation context in
> > debugfs/allocations file (for the allocations which we explicitly
> > enabled context capturing)?
>
> Sorry about the fumbled communication. Here's what I mean:
>
> * Improving memory allocation visibility makes sense to me. To me, a more
>   natural place for that feels like /proc/allocations next to other memor=
y
>   info files rather than under debugfs.

TBH I would love that if this approach is acceptable.

>
> * The default visibility provided by "allocations" provides something whi=
ch
>   is more difficult or at least cumbersome to obtain using existing traci=
ng
>   tools. However, what's provided by "allocations.ctx" can be trivially
>   obtained using kprobe and BPF and seems redundant.

Hmm. That might be a good way forward. Since context capture has
already high performance overhead, maybe choosing not the most
performant but more generic solution is the right answer here. I'll
need to think about it some more but thanks for the idea!

>
> Thanks.
>
> --
> tejun
