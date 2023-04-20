From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH mm-unstable RFC 5/5] cgroup: remove cgroup_rstat_flush_atomic()
Date: Thu, 20 Apr 2023 13:19:46 -0700
Message-ID: <CAJD7tkZkPsBi2RH2b2WXZn=Q+uQJY5-+-MaPnrrNfZcjXo+xhA@mail.gmail.com>
References: <20230403220337.443510-1-yosryahmed@google.com>
 <20230403220337.443510-6-yosryahmed@google.com> <CALvZod79Au=Fw9MTW7fP0P7KwQQ_NUiKgRHsNUFnv9v61pKnZA@mail.gmail.com>
 <ZEGXHvEPsfORq36_@slm.duckdns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682022023; x=1684614023;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gG2Ql85L6iDQ8KDJtvyVB1US8rf766mBBw7kP/giR5M=;
        b=QAXp3RObgIJpNM6iA+LUaWs2XmoxP0ETyPn/Hb7hsyUsoITvm+q1rB3PzE6Mw/ofni
         ULxOJ87mYAgAGSCd3rekbSsk8DyQtNXFtFQKX4c/KlTgtFoi+yknLHSR2BFFuZOSunKq
         vBK7hVVH0rH87rWoaKvGR/8SG3U1jq4nukkkvYzR31hv46lsUWafURYe+lWJOzKqHdYR
         ZAcEjfCDqzAYgzB/a6n/luU94tpPH/nhhW4mPeWcH3Mz/nBvuqPerlcHlTs5HgcrAnuP
         vOri0/ZN87/rTD24tM0uo61TQtf23tLNmshMmIQgAi6qQbai3wi9w5y14dyzB74qxq9+
         Oyog==
In-Reply-To: <ZEGXHvEPsfORq36_@slm.duckdns.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Tejun Heo <tj@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <songmuchun@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

On Thu, Apr 20, 2023 at 12:48=E2=80=AFPM Tejun Heo <tj@kernel.org> wrote:
>
> On Thu, Apr 20, 2023 at 12:40:24PM -0700, Shakeel Butt wrote:
> > +Tejun
> >
> >
> > On Mon, Apr 3, 2023 at 3:03=E2=80=AFPM Yosry Ahmed <yosryahmed@google.c=
om> wrote:
> > >
> > > Previous patches removed the only caller of cgroup_rstat_flush_atomic=
().
> > > Remove the function and simplify the code.
> >
> >
> > I would say let cgroup maintainers decide this and this patch can be
> > decoupled from the series.
>
> Looks fine to me but yeah please cc me on the whole series from the next
> round.


Thanks for taking a look, I don't know how I missed CC'ing you on this
RFC. If I have to guess, my initial draft did not have this patch, so
I did not include you or linux-cgroups, then I added this patch. Sorry
for that :)

>
>
> Thanks.
>
> --
> tejun
