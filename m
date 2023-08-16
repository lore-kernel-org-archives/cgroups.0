From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] mm: memcg: provide accurate stats for userspace reads
Date: Tue, 15 Aug 2023 17:29:03 -0700
Message-ID: <CAJD7tkaUzhvZPohpo1F8TUKRPuXH7bjDeg9VCzN2CbywQbRutQ@mail.gmail.com>
References: <CAJD7tkYZxjAHrodVDK=wmz-sULJrq2VhC_5ecRP7T-KiaOcTuw@mail.gmail.com>
 <CALvZod46Cz_=5UgiyAKM+VgKyk=KJCqDqXu91=9uHy7-2wk53g@mail.gmail.com>
 <CAJD7tkY-ezyYebvcs=8Z_zrw2UVW8jf2WvP1G8tu2rT=2sMnAA@mail.gmail.com>
 <CALvZod5fH9xu_+6x85K38f63GfKGWD1LqtD2R4d09xmDtLB7ew@mail.gmail.com>
 <ZNdEaw2nktq1NfmH@dhcp22.suse.cz> <CAJD7tkaFHgc3eN1K1wYsQFWMLu4+Frf9DJ-5HOja2nC20Es9Dw@mail.gmail.com>
 <ZNrDWqfjXtAYhnvT@slm.duckdns.org> <CAJD7tkYBFz-gZ2QsHxUMT=t0KNXs66S-zzMPebadHx9zaG0Q3w@mail.gmail.com>
 <ZNrITZVTf2EILRJq@slm.duckdns.org> <CAJD7tkaXwoF-faApweAmm7Db7jAuS3EO7hVvdyVtqW_rE+T9Vg@mail.gmail.com>
 <ZNrLO5PAEZw4yjI9@slm.duckdns.org> <CAJD7tkYgCySTX28zK9GZiWwsabR4nv7M2hQ57y12si-fqtv7zg@mail.gmail.com>
 <CALvZod6KRxiDzrppCgx+=SHg2+96nFE5crwXCKwe9PZbWM_6cQ@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1692145780; x=1692750580;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Cf96gEUuffZ5bugLPGNyrmA+1QjENgh5PWJjdIlY5k8=;
        b=Roa+zIv+mNU/NtciKeNsOa6uM75uCp+S0VtC8PYEb+ILU6Z2WoUMzfAiQer5N5DYfa
         0d7dDd1UyioRCzkGgdkIHUDv3RjUiWIzB1V3ou7d64b0bTzbcOhCrHsbRQsd9dl8h7IY
         axTFam5oPj7T1b09AEAmcI4/Coq6t0G4v0qmyH0BkN9oLhrpmds+rLaJNjcyQ3XMhDvl
         dZvzpFARC/WYs+JeQyofxaP46UVf9VdGfXHNdgdichb3HG0Z03ZvIQSnwBeAoHG7dqo5
         yY+Gksx+Dpsq/QyXNfQnwd51qr2HPA1Eohy7B5ID7ZOKuk4GuXOEbH19knKLmtxt3lIZ
         WrIg==
In-Reply-To: <CALvZod6KRxiDzrppCgx+=SHg2+96nFE5crwXCKwe9PZbWM_6cQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ivan Babrou <ivan-lDpJ742SOEtZroRs9YW3xA@public.gmane.org>

On Tue, Aug 15, 2023 at 5:23=E2=80=AFPM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> =
wrote:
>
> +Ivan
>
> On Mon, Aug 14, 2023 at 5:51=E2=80=AFPM Yosry Ahmed <yosryahmed-hpIqsD4AKldhl2p70BpVqQ@public.gmane.org=
m> wrote:
> >
> > On Mon, Aug 14, 2023 at 5:48=E2=80=AFPM Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote=
:
> > >
> > > Hello,
> > >
> > > On Mon, Aug 14, 2023 at 05:39:15PM -0700, Yosry Ahmed wrote:
> > > > I believe dropping unified flushing, if possible of course, may fix
> > > > both problems.
> > >
> > > Yeah, flushing the whole tree for every stat read will push up the bi=
g O
> > > complexity of the operation. It shouldn't be too bad because only wha=
t's
> > > updated since the last read will need flushing but if you have a real=
ly big
> > > machine with a lot of constantly active cgroups, you're still gonna f=
eel it.
> > > So, yeah, drop that and switch the global lock to mutex and we should=
 all be
> > > good?
> >
> > I hope so, but I am not sure.
> >
> > The unified flushing was added initially to mitigate a thundering herd
> > problem from concurrent in-kernel flushers (e.g. concurrent reclaims),
> > but back then flushing was atomic so we had to keep the spinlock held
> > for a long time. I think it should be better now, but I am hoping
> > Shakeel will chime in since he added the unified flushing originally.
> >
> > We also need to agree on what to do about stats_flushing_threshold and
> > flush_next_time since they're both global now (since all flushing is
> > global).
> >
>
> I thought we already reached the decision on how to proceed here. Let
> me summarize what I think we should do:
>
> 1. Completely remove the sync flush from stat files read from userspace.
> 2. Provide a separate way/interface to explicitly flush stats for
> users who want more accurate stats and can pay the cost. This is
> similar to the stat_refresh interface.
> 3. Keep the 2 sec periodic stats flusher.

I think this solution is suboptimal to be honest, I think we can do better.

With recent improvements to spinlocks/mutexes, and flushers becoming
sleepable, I think a better solution would be to remove unified
flushing and let everyone only flush the subtree they care about. Sync
flushing becomes much better (unless you're flushing root ofc), and
concurrent flushing wouldn't cause too many problems (ideally no
thundering herd, and rstat lock can be dropped at cpu boundaries in
cgroup_rstat_flush_locked()).

If we do this, stat reads can be much faster as Ivan demonstrated with
his patch that only flushes the cgroup being read, and we do not
sacrifice accuracy as we never skip flushing. We also do not need a
separate interface for explicit refresh.

In all cases, we need to keep the 2 sec periodic flusher. What we need
to figure out if we remove unified flushing is:

1. Handling stats_flush_threshold.
2. Handling flush_next_time.

Both of these are global now, and will need to be adapted to
non-unified non-global flushing.
