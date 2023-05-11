From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper size
Date: Thu, 11 May 2023 10:10:28 -0700
Message-ID: <CALvZod5sbwXYqPZavojs1cvspxZv1iFHBG8=LQGNodinLXVL=w@mail.gmail.com>
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
 <CANn89i+J+ciJGPkWAFKDwhzJERFJr9_2Or=ehpwSTYO14qzHmA@mail.gmail.com>
 <CH3PR11MB734502756F495CB9C520494FFC779@CH3PR11MB7345.namprd11.prod.outlook.com>
 <CALvZod4n+Kwa1sOV9jxiEMTUoO7MaCGWz=wT3MHOuj4t-+9S6Q@mail.gmail.com>
 <CH3PR11MB73454C44EC8BCD43685BCB58FC749@CH3PR11MB7345.namprd11.prod.outlook.com>
 <IA0PR11MB7355E486112E922AA6095CCCFC749@IA0PR11MB7355.namprd11.prod.outlook.com>
 <CANn89iJbAGnZd42SVZEYWFLYVbmHM3p2UDawUKxUBhVDH5A2=A@mail.gmail.com>
 <IA0PR11MB73557DEAB912737FD61D2873FC749@IA0PR11MB7355.namprd11.prod.outlook.com>
 <CALvZod7Y+SxiopRBXOf1HoDKO=Xh8CNPfgz3Etd4XOq5BPc5Ag@mail.gmail.com> <CANn89iKoB2hn8QKBw+8faL4MWZ1ByDW8T9UHyS9G-8c11mWdOw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683825039; x=1686417039;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DKdPt1RaUkWe8+eoJAPYnUVWfgFKro3FnMuByj1EFEU=;
        b=nMaXyqypHxPLcxqTJyoCXYG5PeO32ubse8ArHPkY7RDeIj41LN5gMmyL7Ac6dVzFZ7
         ZYsaygJet/Hh0cPTxWS+w/TorbpHNOudoOCWWvZYZnP7YjntjqS2vG64aKUfM9l7X+FF
         szXnzl+jFkr+JYMupJ3DNTQHVvGEygGe/nzzvC3TnnfYnfbGVzKYI+ZYmr6YtCTY7dv/
         xP2Nkwrzf9OcT4F1SVRzG9y5DNHc+Ym1rdaz3WmyeOF+N68nDo8FWm5t2BEEgjwBEkqw
         BfyFN6ArnSBxwav+9BJ9XVHl2wCN5uN9vTchbBWjiZdITpYpyhiYpvWcAnK75GYRAy6A
         t6sQ==
In-Reply-To: <CANn89iKoB2hn8QKBw+8faL4MWZ1ByDW8T9UHyS9G-8c11mWdOw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: "Zhang, Cathy" <cathy.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Brandeburg, Jesse" <jesse.brandeburg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Srinivas, Suresh" <suresh.srinivas-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Chen, Tim C" <tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "You, Lizhen" <lizhen.you-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, May 11, 2023 at 9:35=E2=80=AFAM Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> =
wrote:
>
[...]
>
> The suspect part is really:
>
> >      8.98%  mc-worker        [kernel.vmlinux]          [k] page_counter=
_cancel
> >             |
> >              --8.97%--page_counter_cancel
> >                        |
> >                         --8.97%--page_counter_uncharge
> >                                   drain_stock
> >                                   __refill_stock
> >                                   refill_stock
> >                                   |
> >                                    --8.91%--try_charge_memcg
> >                                              mem_cgroup_charge_skmem
> >                                              |
> >                                               --8.91%--__sk_mem_raise_a=
llocated
> >                                                         __sk_mem_schedu=
le
>
> Shakeel, networking has a per-cpu cache, of +/- 1MB.
>
> Even with asymmetric alloc/free, this would mean that a 100Gbit NIC
> would require something like 25,000
> operations on the shared cache line per second.
>
> Hardly an issue I think.
>
> memcg does not seem to have an equivalent strategy ?

memcg has +256KiB per-cpu cache (note the absence of '-'). However it
seems like Cathy already tested with 4MiB (1024 page batch) which is
comparable to networking per-cpu cache (i.e. 2MiB window) and still
see the issue. Additionally this is a single machine test (no NIC),
so, I am kind of contemplating between (1) this is not real world
workload and thus ignore or (2) implement asymmetric charge/uncharge
strategy for memcg.
