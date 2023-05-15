From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a proper size
Date: Sun, 14 May 2023 21:13:20 -0700
Message-ID: <CALvZod7n2yHU8PMn5b39w6E+NhLtBynDKfo1GEfXaa64_tqMWQ@mail.gmail.com>
References: <CH3PR11MB7345DBA6F79282169AAFE9E0FC759@CH3PR11MB7345.namprd11.prod.outlook.com>
 <20230512171702.923725-1-shakeelb@google.com> <CH3PR11MB7345035086C1661BF5352E6EFC789@CH3PR11MB7345.namprd11.prod.outlook.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <netdev+bounces-2477-gl-netdev-2=m.gmane-mx.org@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684124011; x=1686716011;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YStTJgpJxghtuoBZk87RzSQY/v+lqurPQ0sgyIhp1Ps=;
        b=7SCyQfiTw4tckZw3oxtRgm3S34UkIVRMsMkishGxaYF42kqIOh9pOrwcNY8jsGk2+X
         ViLkd+/8VsMrSaCScA6bvCPgpEshi1LK7YjW8cvAueeSF9E194mlh9pFfiPVe68yO34P
         BXiEtC4ThZO5lrRoIy4NpWgOET9HuSbGTUwXM5hGC82mJxfcdWoorRGZ9oy9+XjtnH+A
         uQrmk5y1LopWW9xCt17bquSWitNv9qWhbLYwLzFJAnYh4LH1n3RyKQUWnzfO8/Ev1Is0
         JoUlKgdNqD1Wk2xHBUs/wKI3btKgUzNhwAuS5oFVszmlzYoHGwa8nU/79RCx/EgnhX3E
         sBNg==
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
In-Reply-To: <CH3PR11MB7345035086C1661BF5352E6EFC789@CH3PR11MB7345.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="windows-1252"
To: "Zhang, Cathy" <cathy.zhang@intel.com>
Cc: Eric Dumazet <edumazet@google.com>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>, "davem@davemloft.net" <davem@davemloft.net>, "kuba@kernel.org" <kuba@kernel.org>, "Brandeburg, Jesse" <jesse.brandeburg@intel.com>, "Srinivas, Suresh" <suresh.srinivas@intel.com>, "Chen, Tim C" <tim.c.chen@intel.com>, "You, Lizhen" <lizhen.you@intel.com>, "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>

On Sun, May 14, 2023 at 8:46=E2=80=AFPM Zhang, Cathy <cathy.zhang@intel.com=
> wrote:
>
>
>
> > -----Original Message-----
> > From: Shakeel Butt <shakeelb@google.com>
> > Sent: Saturday, May 13, 2023 1:17 AM
> > To: Zhang, Cathy <cathy.zhang@intel.com>
> > Cc: Shakeel Butt <shakeelb@google.com>; Eric Dumazet
> > <edumazet@google.com>; Linux MM <linux-mm@kvack.org>; Cgroups
> > <cgroups@vger.kernel.org>; Paolo Abeni <pabeni@redhat.com>;
> > davem@davemloft.net; kuba@kernel.org; Brandeburg@google.com;
> > Brandeburg, Jesse <jesse.brandeburg@intel.com>; Srinivas, Suresh
> > <suresh.srinivas@intel.com>; Chen, Tim C <tim.c.chen@intel.com>; You,
> > Lizhen <lizhen.you@intel.com>; eric.dumazet@gmail.com;
> > netdev@vger.kernel.org
> > Subject: Re: [PATCH net-next 1/2] net: Keep sk->sk_forward_alloc as a p=
roper
> > size
> >
> > On Fri, May 12, 2023 at 05:51:40AM +0000, Zhang, Cathy wrote:
> > >
> > >
> > [...]
> > > >
> > > > Thanks a lot. This tells us that one or both of following scenarios
> > > > are
> > > > happening:
> > > >
> > > > 1. In the softirq recv path, the kernel is processing packets from
> > > > multiple memcgs.
> > > >
> > > > 2. The process running on the CPU belongs to memcg which is
> > > > different from the memcgs whose packets are being received on that =
CPU.
> > >
> > > Thanks for sharing the points, Shakeel! Is there any trace records yo=
u
> > > want to collect?
> > >
> >
> > Can you please try the following patch and see if there is any improvem=
ent?
>
> Hi Shakeel,
>
> Try the following patch, the data of 'perf top' from system wide indicate=
s that
> the overhead of page_counter_cancel is dropped from 15.52% to 4.82%.
>
> Without patch:
>     15.52%  [kernel]            [k] page_counter_cancel
>     12.30%  [kernel]            [k] page_counter_try_charge
>     11.97%  [kernel]            [k] try_charge_memcg
>
> With patch:
>     10.63%  [kernel]            [k] page_counter_try_charge
>      9.49%  [kernel]            [k] try_charge_memcg
>      4.82%  [kernel]            [k] page_counter_cancel
>
> The patch is applied on the latest net-next/main:
> befcc1fce564 ("sfc: fix use-after-free in efx_tc_flower_record_encap_matc=
h()")
>

Thanks a lot Cathy for testing. Do you see any performance improvement
for the memcached benchmark with the patch?

