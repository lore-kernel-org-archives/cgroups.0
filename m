From: Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: Re: [PATCH v3 2/2] mm, memcg: Decouple e{low,min} state mutations
 from protection checks
Date: Fri, 22 May 2020 21:22:13 +0530
Message-ID: <CA+G9fYtmpjunUetTmf2yquB1rwZA+nnWOiueWbAMx483c0wUvQ@mail.gmail.com>
References: <20200505084127.12923-1-laoar.shao@gmail.com> <20200505084127.12923-3-laoar.shao@gmail.com>
 <CA+G9fYseWc_7yq0M5Onju_HxbFid6DbuuaEFf-KUpqfxdF-QTg@mail.gmail.com> <CALOAHbBTt1pMo0kwheWqPfU7RTXcDHWJ-x8=5mpw327uiy2qzA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pzV3LzaWpLqEQz7xrfeZadAQqncDoc1EoDALXRQg684=;
        b=ecrd2p+Z0xMZv/rR6DTAk5eHxnu75cCVZpIkVUiOxAmcn/uGpQ76fe/RdYBKnDGcNn
         usKsFYHUfc8IJCeFK9TCnwsZJ4fFoXwPZi38YsnLumjKeWClT6zb2dBkvWdrh8TjMOI9
         8TtgdhQPEeNYdC3iQygERG3JLD9kJoFmJI7kU+y+UnuA8f/PWrbFeKevQIHrjaYjxt4U
         MmfN3Pife0Kp4EFyVi4c5qQrGPrdhfTRwHqE6Oj/xmUdmr8EnwGhaaScT9eN7b9A2E5R
         Zh3t5sJfRGMtIsUynAxujcjs1et1BKPZDN3OKbUGTRtl+OxOximszArRCkFy9E5vnuGQ
         FETQ==
In-Reply-To: <CALOAHbBTt1pMo0kwheWqPfU7RTXcDHWJ-x8=5mpw327uiy2qzA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yafang Shao <laoar.shao@gmail.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Down <chris@chrisdown.name>, Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <guro@fb.com>, linux-mm <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, lkft-triage@lists.linaro.org

On Fri, 22 May 2020 at 17:49, Yafang Shao <laoar.shao@gmail.com> wrote:
>
> On Fri, May 22, 2020 at 7:01 PM Naresh Kamboju
> <naresh.kamboju@linaro.org> wrote:
> >
> > On Tue, 5 May 2020 at 14:12, Yafang Shao <laoar.shao@gmail.com> wrote:
> > >
> > > From: Chris Down <chris@chrisdown.name>
> > >
> > > mem_cgroup_protected currently is both used to set effective low and min
> > > and return a mem_cgroup_protection based on the result.  As a user, this
> > > can be a little unexpected: it appears to be a simple predicate function,
> > > if not for the big warning in the comment above about the order in which
> > > it must be executed.
> > >
> > > This change makes it so that we separate the state mutations from the
> > > actual protection checks, which makes it more obvious where we need to be
> > > careful mutating internal state, and where we are simply checking and
> > > don't need to worry about that.
> >
> > This patch is causing oom-killer while running mkfs -t ext4 on i386 kernel
> > running on x86_64 machine version linux-next 5.7.0-rc6-next-20200521.
> >
>
> Hi Narash,
>
> Thanks for your report.
> My suggestion to the issue found by you is reverting this bad commit.

Thanks for giving details on this problem.
I am not sure who will propose reverting this patch on the linux-next tree.
Please add Reported-by if it is sane.

>
> As I have explained earlier in another mail thread [1] that the usage
> around memcg->{emin, elow} is very buggy.
> We shouldn't use memcg->{emin, elow} in the reclaim context directly,
> because  these two values can be modified by many reclaimers, so the
> good usage of it is storing the protection value into the
> scan_control. IOW, different reclaimers have different protection.
> But unfortunately my suggestion is ignored.
>
> We can set them to 0 before using them to workaround the issue found
> by you, but the fact is that we will introduce a new issue once we fix
> an old issue.
>
> [1]. https://lore.kernel.org/linux-mm/20200425152418.28388-1-laoar.shao@gmail.com/


- Naresh
