From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH RFC] mm/memcontrol: reclaim severe usage over high limit
 in get_user_pages loop
Date: Fri, 2 Aug 2019 11:35:07 +0200
Message-ID: <20190802093507.GF6461@dhcp22.suse.cz>
References: <156431697805.3170.6377599347542228221.stgit@buzz>
 <20190729091738.GF9330@dhcp22.suse.cz>
 <3d6fc779-2081-ba4b-22cf-be701d617bb4@yandex-team.ru>
 <20190729103307.GG9330@dhcp22.suse.cz>
 <CAHbLzkrdj-O2uXwM8ujm90OcgjyR4nAiEbFtRGe7SOoY_fs=BA@mail.gmail.com>
 <20190729184850.GH9330@dhcp22.suse.cz>
 <CAHbLzkp9xFV2sE0TdKfWNRVcAwaYNKwDugRiBBoEKx6A_Hr3Jw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAHbLzkp9xFV2sE0TdKfWNRVcAwaYNKwDugRiBBoEKx6A_Hr3Jw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yang Shi <shy828301@gmail.com>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Linux MM <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, cgroups@vger.kernel.org, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>

On Thu 01-08-19 14:00:51, Yang Shi wrote:
> On Mon, Jul 29, 2019 at 11:48 AM Michal Hocko <mhocko@kernel.org> wrote:
> >
> > On Mon 29-07-19 10:28:43, Yang Shi wrote:
> > [...]
> > > I don't worry too much about scale since the scale issue is not unique
> > > to background reclaim, direct reclaim may run into the same problem.
> >
> > Just to clarify. By scaling problem I mean 1:1 kswapd thread to memcg.
> > You can have thousands of memcgs and I do not think we really do want
> > to create one kswapd for each. Once we have a kswapd thread pool then we
> > get into a tricky land where a determinism/fairness would be non trivial
> > to achieve. Direct reclaim, on the other hand is bound by the workload
> > itself.
> 
> Yes, I agree thread pool would introduce more latency than dedicated
> kswapd thread. But, it looks not that bad in our test. When memory
> allocation is fast, even though dedicated kswapd thread can't catch
> up. So, such background reclaim is best effort, not guaranteed.
> 
> I don't quite get what you mean about fairness. Do you mean they may
> spend excessive cpu time then cause other processes starvation? I
> think this could be mitigated by properly organizing and setting
> groups. But, I agree this is tricky.

No, I meant that the cost of reclaiming a unit of charges (e.g.
SWAP_CLUSTER_MAX) is not constant and depends on the state of the memory
on LRUs. Therefore any thread pool mechanism would lead to unfair
reclaim and non-deterministic behavior.

I can imagine a middle ground where the background reclaim would have to
be an opt-in feature and a dedicated kernel thread would be assigned to
the particular memcg (hierarchy).
-- 
Michal Hocko
SUSE Labs
