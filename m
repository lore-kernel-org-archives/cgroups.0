From: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper size
Date: Wed, 10 May 2023 17:07:22 +0200
Message-ID: <CANn89i+J+ciJGPkWAFKDwhzJERFJr9_2Or=ehpwSTYO14qzHmA@mail.gmail.com>
References: <20230508020801.10702-1-cathy.zhang@intel.com> <20230508020801.10702-2-cathy.zhang@intel.com>
 <3887b08ac0e55e27a24d2f66afcfff1961ed9b13.camel@redhat.com>
 <CH3PR11MB73459006FCE3887E1EA3B82FFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CH3PR11MB73456D792EC6E7614E2EF14DFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89iL6Ckuu9vOEvc7A9CBLGuh-EpbwFRxRAchV-6VFyhTUpg@mail.gmail.com>
 <CH3PR11MB73458BB403D537CFA96FD8DDFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89iJvpgXTwGEiXAkFwY3j3RqVhNzJ_6_zmuRb4w7rUA_8Ug@mail.gmail.com>
 <CALvZod6JRuWHftDcH0uw00v=yi_6BKspGCkDA4AbmzLHaLi2Fg@mail.gmail.com>
 <CH3PR11MB7345ABB947E183AFB7C18322FC779@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89i+9rQcGey+AJyhR02pTTBNhWN+P78e4a8knfC9F5sx0hQ@mail.gmail.com> <CH3PR11MB73455A98A232920B322C3976FC779@CH3PR11MB7345.namprd11.prod.outlook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683731255; x=1686323255;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+TNYqcSs6PC6BWjv/cKNCEBTiGNlpvDG9qZWo/NwWgk=;
        b=VHa+zJPx3Vz6wytMa3SIhZzYfgU2/Niwh71tnoKAYIeWA2H5epFTFhHSQvFN43kk6B
         cFDZen9tkH7p0WZnnrOzwIENa38J8Y14PbDUEwOakn8Oj0yZBW9fs6jWD/rDzE/vB43V
         Qz1d1XAKURN9MomiGhS9L4fJncNHQsNIPFngC2R0ThLp3yRrL/r6pOGWoH0IgAa/XqMm
         CVNitkcf2R+0SqHeNhSZUmYJ8hLSdPSSfbH8jGOIcZpl6IWOPynuR1hReNmhPg5z0teg
         5Ktw1dOsG4oFDuFWcd42P5fNifriJTDIeKvlkgfQQq0BmKMypIUJTRWWVWw1yJyVBdFh
         vP7g==
In-Reply-To: <CH3PR11MB73455A98A232920B322C3976FC779-WQKEFoXy4NEXvLLfv6NhPJPPoyLQLiKMvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: "Zhang, Cathy" <cathy.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Brandeburg, Jesse" <jesse.brandeburg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Srinivas, Suresh" <suresh.srinivas-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Chen, Tim C" <tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "You, Lizhen" <lizhen.you-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, May 10, 2023 at 3:54=E2=80=AFPM Zhang, Cathy <cathy.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org=
> wrote:
>
>
>
> > -----Original Message-----
> > From: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > Sent: Wednesday, May 10, 2023 7:25 PM
> > To: Zhang, Cathy <cathy.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>; Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>;
> > Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>; Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>;
> > davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org; kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; Brandeburg, Jesse
> > <jesse.brandeburg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; Srinivas, Suresh
> > <suresh.srinivas-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; Chen, Tim C <tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; You,
> > Lizhen <lizhen.you-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org;
> > netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a p=
roper
> > size
> >
> > On Wed, May 10, 2023 at 1:11=E2=80=AFPM Zhang, Cathy <cathy.zhang@intel=
.com>
> > wrote:
> > >
> > > Hi Shakeel, Eric and all,
> > >
> > > How about adding memory pressure checking in sk_mem_uncharge() to
> > > decide if keep part of memory or not, which can help avoid the issue
> > > you fixed and the problem we find on the system with more CPUs.
> > >
> > > The code draft is like this:
> > >
> > > static inline void sk_mem_uncharge(struct sock *sk, int size) {
> > >         int reclaimable;
> > >         int reclaim_threshold =3D SK_RECLAIM_THRESHOLD;
> > >
> > >         if (!sk_has_account(sk))
> > >                 return;
> > >         sk->sk_forward_alloc +=3D size;
> > >
> > >         if (mem_cgroup_sockets_enabled && sk->sk_memcg &&
> > >             mem_cgroup_under_socket_pressure(sk->sk_memcg)) {
> > >                 sk_mem_reclaim(sk);
> > >                 return;
> > >         }
> > >
> > >         reclaimable =3D sk->sk_forward_alloc -
> > > sk_unused_reserved_mem(sk);
> > >
> > >         if (reclaimable > reclaim_threshold) {
> > >                 reclaimable -=3D reclaim_threshold;
> > >                 __sk_mem_reclaim(sk, reclaimable);
> > >         }
> > > }
> > >
> > > I've run a test with the new code, the result looks good, it does not
> > > introduce latency, RPS is the same.
> > >
> >
> > It will not work for sockets that are idle, after a burst.
> > If we restore per socket caches, we will need a shrinker.
> > Trust me, we do not want that kind of big hammer, crushing latencies.
> >
> > Have you tried to increase batch sizes ?
>
> I jus picked up 256 and 1024 for a try, but no help, the overhead still e=
xists.

This makes no sense at all.

I suspect a plain bug in mm/memcontrol.c

I will let mm experts work on this.

>
> >
> > Any kind of cache (even per-cpu) might need some adjustment when core
> > count or expected traffic is increasing.
> > This was somehow hinted in
> > commit 1813e51eece0ad6f4aacaeb738e7cced46feb470
> > Author: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > Date:   Thu Aug 25 00:05:06 2022 +0000
> >
> >     memcg: increase MEMCG_CHARGE_BATCH to 64
> >
> >
> >
> > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h in=
dex
> > 222d7370134c73e59fdbdf598ed8d66897dbbf1d..0418229d30c25d114132a1e
> > d46ac01358cf21424
> > 100644
> > --- a/include/linux/memcontrol.h
> > +++ b/include/linux/memcontrol.h
> > @@ -334,7 +334,7 @@ struct mem_cgroup {
> >   * TODO: maybe necessary to use big numbers in big irons or dynamic ba=
sed
> > of the
> >   * workload.
> >   */
> > -#define MEMCG_CHARGE_BATCH 64U
> > +#define MEMCG_CHARGE_BATCH 128U
> >
> >  extern struct mem_cgroup *root_mem_cgroup;
> >
> > diff --git a/include/net/sock.h b/include/net/sock.h index
> > 656ea89f60ff90d600d16f40302000db64057c64..82f6a288be650f886b207e6a
> > 5e62a1d5dda808b0
> > 100644
> > --- a/include/net/sock.h
> > +++ b/include/net/sock.h
> > @@ -1433,8 +1433,8 @@ sk_memory_allocated(const struct sock *sk)
> >         return proto_memory_allocated(sk->sk_prot);
> >  }
> >
> > -/* 1 MB per cpu, in page units */
> > -#define SK_MEMORY_PCPU_RESERVE (1 << (20 - PAGE_SHIFT))
> > +/* 2 MB per cpu, in page units */
> > +#define SK_MEMORY_PCPU_RESERVE (1 << (21 - PAGE_SHIFT))
> >
> >  static inline void
> >  sk_memory_allocated_add(struct sock *sk, int amt)
> >
> >
> >
> >
> >
> >
> > > > -----Original Message-----
> > > > From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > > > Sent: Wednesday, May 10, 2023 12:10 AM
> > > > To: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>; Linux MM <linux-
> > > > mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>; Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
> > > > Cc: Zhang, Cathy <cathy.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; Paolo Abeni
> > > > <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>; davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org; kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org;
> > > > Brandeburg, Jesse <jesse.brandeburg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; Srinivas, Suresh
> > > > <suresh.srinivas-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; Chen, Tim C <tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>;
> > > > You, Lizhen <lizhen.you-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org;
> > > > netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > > Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as
> > > > a proper size
> > > >
> > > > +linux-mm & cgroup
> > > >
> > > > Thread: https://lore.kernel.org/all/20230508020801.10702-1-
> > > > cathy.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/
> > > >
> > > > On Tue, May 9, 2023 at 8:43=E2=80=AFAM Eric Dumazet <edumazet@googl=
e.com>
> > > > wrote:
> > > > >
> > > > [...]
> > > > > Some mm experts should chime in, this is not a networking issue.
> > > >
> > > > Most of the MM folks are busy in LSFMM this week. I will take a loo=
k
> > > > at this soon.
