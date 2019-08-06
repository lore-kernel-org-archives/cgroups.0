From: Yang Shi <shy828301@gmail.com>
Subject: Re: [PATCH RFC] mm/memcontrol: reclaim severe usage over high limit
 in get_user_pages loop
Date: Mon, 5 Aug 2019 20:28:40 -0700
Message-ID: <CAHbLzkpD+kawkR42mWpxvZHvSZNhYEsibiMYzx+3q0rTBS6L9g@mail.gmail.com>
References: <156431697805.3170.6377599347542228221.stgit@buzz>
 <20190729091738.GF9330@dhcp22.suse.cz> <3d6fc779-2081-ba4b-22cf-be701d617bb4@yandex-team.ru>
 <20190729103307.GG9330@dhcp22.suse.cz> <CAHbLzkrdj-O2uXwM8ujm90OcgjyR4nAiEbFtRGe7SOoY_fs=BA@mail.gmail.com>
 <20190729184850.GH9330@dhcp22.suse.cz> <CAHbLzkp9xFV2sE0TdKfWNRVcAwaYNKwDugRiBBoEKx6A_Hr3Jw@mail.gmail.com>
 <20190802093507.GF6461@dhcp22.suse.cz> <CAHbLzkrjh7KEvdfXackaVy8oW5CU=UaBucERffxcUorgq1vdoA@mail.gmail.com>
 <20190805143239.GS7597@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aoJs4+GZcrMW12maFhHxBWCjreCnZG8IIroKJ5Dk56w=;
        b=kPmJavQlKC0qoOuF78dkRk9X6JVlHFkwGK1peHZHj0UFVxLbLlTm/X+vuwLi6rDTmY
         aXayCcF6YYeKFgRSI6W+734GagJiaJfX8BHoIixitFMdY/4AsEYsSaLqxSWluMm4xaSE
         zA7OGuMlaprEKB+sr57Wibi7sFwTkSY3z2Me5Qe32x+F596HUdYRuJFkul4bFSQprW1q
         JrldsZuhof5957Q/xkny1ZgQ2FPbIB6s4K1Vc5E/R9BsiqIKmSkhL5Dd60a7+AyG0Mih
         9XtZ7rSBPguMqHF6magt/107WW1GNFKFxW1lzNzuAAIYzmWN5NHZb3YqFy8xH567gitR
         vi3A==
In-Reply-To: <20190805143239.GS7597@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Linux MM <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, cgroups@vger.kernel.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>

On Mon, Aug 5, 2019 at 7:32 AM Michal Hocko <mhocko@kernel.org> wrote:
>
> On Fri 02-08-19 11:56:28, Yang Shi wrote:
> > On Fri, Aug 2, 2019 at 2:35 AM Michal Hocko <mhocko@kernel.org> wrote:
> > >
> > > On Thu 01-08-19 14:00:51, Yang Shi wrote:
> > > > On Mon, Jul 29, 2019 at 11:48 AM Michal Hocko <mhocko@kernel.org> wrote:
> > > > >
> > > > > On Mon 29-07-19 10:28:43, Yang Shi wrote:
> > > > > [...]
> > > > > > I don't worry too much about scale since the scale issue is not unique
> > > > > > to background reclaim, direct reclaim may run into the same problem.
> > > > >
> > > > > Just to clarify. By scaling problem I mean 1:1 kswapd thread to memcg.
> > > > > You can have thousands of memcgs and I do not think we really do want
> > > > > to create one kswapd for each. Once we have a kswapd thread pool then we
> > > > > get into a tricky land where a determinism/fairness would be non trivial
> > > > > to achieve. Direct reclaim, on the other hand is bound by the workload
> > > > > itself.
> > > >
> > > > Yes, I agree thread pool would introduce more latency than dedicated
> > > > kswapd thread. But, it looks not that bad in our test. When memory
> > > > allocation is fast, even though dedicated kswapd thread can't catch
> > > > up. So, such background reclaim is best effort, not guaranteed.
> > > >
> > > > I don't quite get what you mean about fairness. Do you mean they may
> > > > spend excessive cpu time then cause other processes starvation? I
> > > > think this could be mitigated by properly organizing and setting
> > > > groups. But, I agree this is tricky.
> > >
> > > No, I meant that the cost of reclaiming a unit of charges (e.g.
> > > SWAP_CLUSTER_MAX) is not constant and depends on the state of the memory
> > > on LRUs. Therefore any thread pool mechanism would lead to unfair
> > > reclaim and non-deterministic behavior.
> >
> > Yes, the cost depends on the state of pages, but I still don't quite
> > understand what does "unfair" refer to in this context. Do you mean
> > some cgroups may reclaim much more than others?
>
> > Or the work may take too long so it can't not serve other cgroups in time?
>
> exactly.

Actually, I'm not very concerned by this. In our design each memcg has
its dedicated work (memcg->wmark_work), so the reclaim work for
different memcgs could be run in parallel since they are *different*
work in fact although they run the same function. And, We could queue
them to a dedicated unbound workqueue which may have maximum 512 or
scale with nr cpus active works. Although the system may have
thousands of online memcgs, I'm supposed it should be rare to have all
of them trigger reclaim at the same time.

> --
> Michal Hocko
> SUSE Labs
