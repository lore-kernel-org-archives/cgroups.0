From: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 00/40] Memory allocation profiling
Date: Wed, 3 May 2023 12:41:08 -0700
Message-ID: <CAJuCfpEPkCJZO2svT-GfmpJ+V-jSLyFDKM_atnqPVRBKtzgtnQ@mail.gmail.com>
References: <ZFIMaflxeHS3uR/A@dhcp22.suse.cz> <ZFIOfb6/jHwLqg6M@moria.home.lan>
 <ZFISlX+mSx4QJDK6@dhcp22.suse.cz> <ZFIVtB8JyKk0ddA5@moria.home.lan>
 <ZFKNZZwC8EUbOLMv@slm.duckdns.org> <20230503180726.GA196054@cmpxchg.org>
 <ZFKlrP7nLn93iIRf@slm.duckdns.org> <ZFKqh5Dh93UULdse@slm.duckdns.org>
 <ZFKubD/lq7oB4svV@moria.home.lan> <ZFKu6zWA00AzArMF@slm.duckdns.org> <ZFKxcfqkUQ60zBB_@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-modules-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683142881; x=1685734881;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7eRiiP2JCtlxvX+BHzTjXxhFfE3xb3L5Tko5xVivHIc=;
        b=njnY9/ZTWcA0YQLoTf3TUMfGQMs6qBR8x/WiO3YJ4m2rgzn9gPgiVmWeEd3meHgQOd
         veIE13lp/BEBibiOOZUNO+WD2iQQwInbq0mORyd3+wLWSUTFkhmbMs6fl3Tqmd3D0D5p
         V+y4b3/jKL+G7UEO8JQopzaWcrHdBR+imlq/VrwTOp1569eYFHFfi9pD7I53OyaoPSYd
         tj72nQLogAXIm5Pv95noTQ1YRpRrtHa+Dymto/1ndku51s0fuH/R0nkRvqq+7WbyeTBe
         or08gvlkQ55RtNC4M9pq8YNpCVr1Dsrvti1RMiJ42Ynp3MHUq3DPU/4MOuwmbk5VuygM
         Oy2w==
In-Reply-To: <ZFKxcfqkUQ60zBB_-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1254"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Kent Overstreet <kent.overstreet-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, vbabka-AlSwsSmVLrQ@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, dave-h16yJtLeMjHk1uMJSBkQmQ@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, liam.howlett-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, void-gq6j2QGBifHby3iVrkZq2A@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ldufour-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org, catalin.marinas-5wv7dgnIgG8@public.gmane.org, will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, peterx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, masahiroy-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, nathan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dennis-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, paulmck-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, pasha.tatashin-2EmBfe737+LQT0dZR+AlfA@public.gmane.org, yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

On Wed, May 3, 2023 at 12:09=E2=80=AFPM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> On Wed, May 03, 2023 at 08:58:51AM -1000, Tejun Heo wrote:
> > On Wed, May 03, 2023 at 02:56:44PM -0400, Kent Overstreet wrote:
> > > On Wed, May 03, 2023 at 08:40:07AM -1000, Tejun Heo wrote:
> > > > > Yeah, easy / default visibility argument does make sense to me.
> > > >
> > > > So, a bit of addition here. If this is the thrust, the debugfs part=
 seems
> > > > rather redundant, right? That's trivially obtainable with tracing /=
 bpf and
> > > > in a more flexible and performant manner. Also, are we happy with r=
ecording
> > > > just single depth for persistent tracking?

IIUC, by single depth you mean no call stack capturing?
If so, that's the idea behind the context capture feature so that we
can enable it on specific allocations only after we determine there is
something interesting there. So, with low-cost persistent tracking we
can determine the suspects and then pay some more to investigate those
suspects in more detail.

> > >
> > > Not sure what you're envisioning?
> > >
> > > I'd consider the debugfs interface pretty integral; it's much more
> > > discoverable for users, and it's hardly any code out of the whole
> > > patchset.
> >
> > You can do the same thing with a bpftrace one liner tho. That's rather
> > difficult to beat.

debugfs seemed like a natural choice for such information. If another
interface is more appropriate I'm happy to explore that.

>
> Ah, shit, I'm an idiot. Sorry. I thought allocations was under /proc and
> allocations.ctx under debugfs. I meant allocations.ctx is redundant.

Do you mean that we could display allocation context in
debugfs/allocations file (for the allocations which we explicitly
enabled context capturing)?

>
> Thanks.
>
> --
> tejun
