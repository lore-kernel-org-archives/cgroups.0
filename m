From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper size
Date: Wed, 10 May 2023 12:00:02 -0700
Message-ID: <CALvZod4n+Kwa1sOV9jxiEMTUoO7MaCGWz=wT3MHOuj4t-+9S6Q@mail.gmail.com>
References: <20230508020801.10702-1-cathy.zhang@intel.com> <20230508020801.10702-2-cathy.zhang@intel.com>
 <3887b08ac0e55e27a24d2f66afcfff1961ed9b13.camel@redhat.com>
 <CH3PR11MB73459006FCE3887E1EA3B82FFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CH3PR11MB73456D792EC6E7614E2EF14DFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89iL6Ckuu9vOEvc7A9CBLGuh-EpbwFRxRAchV-6VFyhTUpg@mail.gmail.com>
 <CH3PR11MB73458BB403D537CFA96FD8DDFC769@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89iJvpgXTwGEiXAkFwY3j3RqVhNzJ_6_zmuRb4w7rUA_8Ug@mail.gmail.com>
 <CALvZod6JRuWHftDcH0uw00v=yi_6BKspGCkDA4AbmzLHaLi2Fg@mail.gmail.com>
 <CH3PR11MB7345ABB947E183AFB7C18322FC779@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89i+9rQcGey+AJyhR02pTTBNhWN+P78e4a8knfC9F5sx0hQ@mail.gmail.com>
 <CH3PR11MB73455A98A232920B322C3976FC779@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CANn89i+J+ciJGPkWAFKDwhzJERFJr9_2Or=ehpwSTYO14qzHmA@mail.gmail.com> <CH3PR11MB734502756F495CB9C520494FFC779@CH3PR11MB7345.namprd11.prod.outlook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683745214; x=1686337214;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xKsdgPcqj7KmYQZqWilT9rwcetEcIXv94yhUAf7G1sA=;
        b=BvJIvdH3Wybsgy9FE4pyTQfaOjRyNKOOtwD8AxKBkOLwQnEb8UA1Ez5R0nRn2CFFBL
         BXgoH7pw0kursav4wE2lwTrsKDnbBpwm7XG4ro5lrOuMCnNM9OqssguSNAUo7HbNaWwC
         j40w6tVnkluvyUchlgU8rYyRRcEQwmE3Zpnbh6RscDtfNz10rYG0KfpUKVd8wmoNZj9I
         vTdcpjPoxtgDsptCivj+6K0OgYH6Bcgllqe2Y3mDvoTxA67v54GNd+C7Q5M4TB3/70n0
         h5NlSITmtP1wgtX8LZtx21dkK0mPYkk0oTPqWfrXi9seT6ecC66ADSSg2marBGDzT/7q
         kIZg==
In-Reply-To: <CH3PR11MB734502756F495CB9C520494FFC779-WQKEFoXy4NEXvLLfv6NhPJPPoyLQLiKMvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: "Zhang, Cathy" <cathy.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Brandeburg, Jesse" <jesse.brandeburg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Srinivas, Suresh" <suresh.srinivas-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Chen, Tim C" <tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "You, Lizhen" <lizhen.you-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, May 10, 2023 at 9:09=E2=80=AFAM Zhang, Cathy <cathy.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org=
> wrote:
>
>
[...]
> > > >
> > > > Have you tried to increase batch sizes ?
> > >
> > > I jus picked up 256 and 1024 for a try, but no help, the overhead sti=
ll exists.
> >
> > This makes no sense at all.
>
> Eric,
>
> I added a pr_info in try_charge_memcg() to print nr_pages if
> nr_pages >=3D MEMCG_CHARGE_BATCH, except it prints 64 during the initiali=
zation
> of instances, there is no other output during the running. That means nr_=
pages is not
> over 64, I guess that might be the reason why to increase MEMCG_CHARGE_BA=
TCH
> doesn't affect this case.
>

I am assuming you increased MEMCG_CHARGE_BATCH to 256 and 1024 but
that did not help. To me that just means there is a different
bottleneck in the memcg charging codepath. Can you please share the
perf profile? Please note that memcg charging does a lot of other
things as well like updating memcg stats and checking (and enforcing)
memory.high even if you have not set memory.high.
