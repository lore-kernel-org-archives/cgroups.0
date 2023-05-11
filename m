From: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper size
Date: Thu, 11 May 2023 09:50:30 +0200
Message-ID: <CANn89iJbAGnZd42SVZEYWFLYVbmHM3p2UDawUKxUBhVDH5A2=A@mail.gmail.com>
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
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683791443; x=1686383443;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ybwF8qJFWAbvIvu+SC1YZHKFpjOW6AAAy4k7z/ztuq8=;
        b=TpTvOo69AQQX6ckCLnMGs2C1Ya6+FtQsvhiEZukT0WOHLPa07jBGET3X+nbAMr1oII
         R527Pl+B48yYnKtX27XeGJfugo+z5bSUH/sqfd0dIjeUa2XBeE4EFu2rts/BQl3iVIHv
         zqBO4Z1XEHk40zwW6plDhl55btXvYaBAbhZBcW+ElbgJjm1k8mQoq42qjt14t2ZS4HNz
         zVt5v/M/buMkXDJYdtgaXtOOYZDXh4FaSoDQTV5QSDy5hstp+KI+/WouYOz7vbw6Jjxb
         bqYabyihtnyc6iqaudJsjdtgibb89uBOxRZNM3ODJMMgZSAsSYA8FuO80G5H2zzEAbwR
         9l4A==
In-Reply-To: <IA0PR11MB7355E486112E922AA6095CCCFC749-py0Qfd72Ncwkr2bXB6wcV5PPoyLQLiKMvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: "Zhang, Cathy" <cathy.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Paolo Abeni <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, "kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Brandeburg, Jesse" <jesse.brandeburg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Srinivas, Suresh" <suresh.srinivas-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Chen, Tim C" <tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "You, Lizhen" <lizhen.you-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, May 11, 2023 at 9:00=E2=80=AFAM Zhang, Cathy <cathy.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org=
> wrote:
>
>
>
> > -----Original Message-----
> > From: Zhang, Cathy
> > Sent: Thursday, May 11, 2023 8:53 AM
> > To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > Cc: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>; Linux MM <linux-
> > mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>; Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>; Paolo Abeni
> > <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>; davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org; kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org;
> > Brandeburg, Jesse <jesse.brandeburg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; Srinivas, Suresh
> > <suresh.srinivas-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; Chen, Tim C <tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; You,
> > Lizhen <Lizhen.You-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org;
> > netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Subject: RE: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a p=
roper
> > size
> >
> >
> >
> > > -----Original Message-----
> > > From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> > > Sent: Thursday, May 11, 2023 3:00 AM
> > > To: Zhang, Cathy <cathy.zhang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > Cc: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>; Linux MM <linux-
> > > mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>; Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>; Paolo Abeni
> > > <pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>; davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org; kuba-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org;
> > Brandeburg,
> > > Jesse <jesse.brandeburg-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; Srinivas, Suresh
> > > <suresh.srinivas-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; Chen, Tim C <tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; You,
> > > Lizhen <lizhen.you-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org;
> > > netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a
> > > proper size
> > >
> > > On Wed, May 10, 2023 at 9:09=E2=80=AFAM Zhang, Cathy <cathy.zhang@int=
el.com>
> > > wrote:
> > > >
> > > >
> > > [...]
> > > > > > >
> > > > > > > Have you tried to increase batch sizes ?
> > > > > >
> > > > > > I jus picked up 256 and 1024 for a try, but no help, the
> > > > > > overhead still
> > > exists.
> > > > >
> > > > > This makes no sense at all.
> > > >
> > > > Eric,
> > > >
> > > > I added a pr_info in try_charge_memcg() to print nr_pages if
> > > > nr_pages
> > > > >=3D MEMCG_CHARGE_BATCH, except it prints 64 during the initializat=
ion
> > > > of instances, there is no other output during the running. That
> > > > means nr_pages is not over 64, I guess that might be the reason why
> > > > to increase MEMCG_CHARGE_BATCH doesn't affect this case.
> > > >
> > >
> > > I am assuming you increased MEMCG_CHARGE_BATCH to 256 and 1024
> > but
> > > that did not help. To me that just means there is a different
> > > bottleneck in the memcg charging codepath. Can you please share the
> > > perf profile? Please note that memcg charging does a lot of other
> > > things as well like updating memcg stats and checking (and enforcing)
> > > memory.high even if you have not set memory.high.
> >
> > Thanks Shakeel! I will check more details on what you mentioned. We use
> > "sudo perf top -p $(docker inspect -f '{{.State.Pid}}' memcached_2)" to
> > monitor one of those instances, and also use "sudo perf top" to check t=
he
> > overhead from system wide.
>
> Here is the annotate output of perf top for the three memcg hot paths:
>
> Showing cycles for page_counter_try_charge
>   Events  Pcnt (>=3D5%)
>  Percent |      Source code & Disassembly of elf for cycles (543288 sampl=
es, percent: local period)
> -------------------------------------------------------------------------=
--------------------------
>     0.00 :   ffffffff8141388d:       mov    %r12,%rax
>    76.82 :   ffffffff81413890:       lock xadd %rax,(%rbx)
>    22.10 :   ffffffff81413895:       lea    (%r12,%rax,1),%r15
>
>
> Showing cycles for page_counter_cancel
>   Events  Pcnt (>=3D5%)
>  Percent |      Source code & Disassembly of elf for cycles (1004744 samp=
les, percent: local period)
> -------------------------------------------------------------------------=
---------------------------
>          : 160              return i + xadd(&v->counter, i);
>    77.42 :   ffffffff81413759:       lock xadd %rax,(%rdi)
>    22.34 :   ffffffff8141375e:       sub    %rsi,%rax
>
>
> Showing cycles for try_charge_memcg
>   Events  Pcnt (>=3D5%)
>  Percent |      Source code & Disassembly of elf for cycles (256531 sampl=
es, percent: local period)
> -------------------------------------------------------------------------=
--------------------------
>          : 22               return __READ_ONCE((v)->counter);
>    77.53 :   ffffffff8141df86:       mov    0x100(%r13),%rdx
>          : 2826             READ_ONCE(memcg->memory.high);
>    19.45 :   ffffffff8141df8d:       mov    0x190(%r13),%rcx

This is rephrasing the info you gave earlier ?

  16.77%  [kernel]            [k] page_counter_try_charge
    16.56%  [kernel]            [k] page_counter_cancel
    15.65%  [kernel]            [k] try_charge_memcg

What matters here is a call graph.

perf record -a -g sleep 5 # While the test is running
perf report --no-children --stdio

What precise kernel are you using btw ?
