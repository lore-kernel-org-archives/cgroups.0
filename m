From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] mm: memcg: use rstat for non-hierarchical stats
Date: Wed, 26 Jul 2023 08:23:28 -0700
Message-ID: <CAJD7tkb6SmCDLDSCciPfXGK7Z_zyr4vh_XKvhysL6pci88WjKw@mail.gmail.com>
References: <20230726002904.655377-1-yosryahmed@google.com>
 <20230726002904.655377-2-yosryahmed@google.com> <ZMCBzUH7qIdc3Y2X@P9FQF9L96D>
 <CAJD7tkZDpni+VM61i-jUgvn=TkZ5CySotTmUAFQPwMSjDfOEWQ@mail.gmail.com> <20230726152055.GC1365610@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1690385045; x=1690989845;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=58XKjPnpcFetGx5j3YOj8ywrrvgND/+/csGew57bsKg=;
        b=OlqpMj+GOS6ZN29CPLOgmWPUTKJLvmKWzkTTSdYpl46AgLMkxw8fOF+mtvOAo6uKGw
         BU1mIXEbmud8kylbCkDkljLAe+cEFLqct3ZmildAwKoGHvviUlWbWr+Y0MvgAvdo0GCm
         IFWkLuTqknhFTwZsZU80GeZNh1HZKFFYudgvxei7dSa6G8pi7JG4cbAdq9DX7RjhOjIS
         8OKqAgPf23lAp6Z9r1I32Xl2sCvNHyxhfmhDHLByuBwju6fPvKtB8zl9D9phh8q/TsPS
         duXmA+dpyypvPqf7Uk44/0skEuLF0fYkSrd0i9D/anETUf4RnkyPK3vyujElRaqdoAaN
         7q2g==
In-Reply-To: <20230726152055.GC1365610-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Wed, Jul 26, 2023 at 8:20=E2=80=AFAM Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org=
> wrote:
>
> On Tue, Jul 25, 2023 at 07:20:02PM -0700, Yosry Ahmed wrote:
> > On Tue, Jul 25, 2023 at 7:15=E2=80=AFPM Roman Gushchin <roman.gushchin@=
linux.dev> wrote:
> > >
> > > On Wed, Jul 26, 2023 at 12:29:04AM +0000, Yosry Ahmed wrote:
> > > > Currently, memcg uses rstat to maintain hierarchical stats. Counter=
s are
> > > > maintained for hierarchical stats at each memcg. Rstat tracks which
> > > > cgroups have updates on which cpus to keep those counters fresh on =
the
> > > > read-side.
> > > >
> > > > For non-hierarchical stats, we do not maintain counters. Instead, t=
he
> > >                                                 global?
> >
> > Do you mean "we do not maintain global counters"? I think "global" is
> > confusing, because it can be thought of as all cpus or as including
> > the subtree (as opposed to local for non-hierarchical stats).
>
> "global" seems fine to me, I don't think it's ambiguous in the direct
> comparison with per-cpu counts.
>
> Alternatively, rephrase the whole thing? Something like:
>
> "Non-hierarchical stats are currently not covered by rstat. Their
> per-cpu counters are summed up on every read, which is expensive."

Rephrasing sounds good to me.

I will send a v3 with the correct commit log and collected Acks to
make Andrew's life easier.
