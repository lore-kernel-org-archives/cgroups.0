From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH v4] mm/memcg: try harder to decrease
 [memory,memsw].limit_in_bytes
Date: Mon, 15 Jan 2018 13:46:52 +0100
Message-ID: <20180115124652.GB22473@dhcp22.suse.cz>
References: <20180109152622.31ca558acb0cc25a1b14f38c@linux-foundation.org>
 <20180110124317.28887-1-aryabinin@virtuozzo.com>
 <20180111104239.GZ1732@dhcp22.suse.cz>
 <4a8f667d-c2ae-e3df-00fd-edc01afe19e1@virtuozzo.com>
 <20180111124629.GA1732@dhcp22.suse.cz>
 <ce885a69-67af-5f4c-1116-9f6803fb45ee@virtuozzo.com>
 <20180111162947.GG1732@dhcp22.suse.cz>
 <560a77b5-02d7-cbae-35f3-0b20a1c384c2@virtuozzo.com>
 <20180112122405.GK1732@dhcp22.suse.cz>
 <7d1b5bfb-f602-8cf4-2de6-dd186484e55c@virtuozzo.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <7d1b5bfb-f602-8cf4-2de6-dd186484e55c@virtuozzo.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Shakeel Butt <shakeelb@google.com>

On Mon 15-01-18 15:30:59, Andrey Ryabinin wrote:
> 
> 
> On 01/12/2018 03:24 PM, Michal Hocko wrote:
> > On Fri 12-01-18 00:59:38, Andrey Ryabinin wrote:
> >> On 01/11/2018 07:29 PM, Michal Hocko wrote:
> > [...]
> >>> I do not think so. Consider that this reclaim races with other
> >>> reclaimers. Now you are reclaiming a large chunk so you might end up
> >>> reclaiming more than necessary. SWAP_CLUSTER_MAX would reduce the over
> >>> reclaim to be negligible.
> >>>
> >>
> >> I did consider this. And I think, I already explained that sort of race in previous email.
> >> Whether "Task B" is really a task in cgroup or it's actually a bunch of reclaimers,
> >> doesn't matter. That doesn't change anything.
> > 
> > I would _really_ prefer two patches here. The first one removing the
> > hard coded reclaim count. That thing is just dubious at best. If you
> > _really_ think that the higher reclaim target is meaningfull then make
> > it a separate patch. I am not conviced but I will not nack it it either.
> > But it will make our life much easier if my over reclaim concern is
> > right and we will need to revert it. Conceptually those two changes are
> > independent anywa.
> > 
> 
> Ok, fair point. But what about livelock than? Don't you think that we should
> go back to something like in V1 patch to prevent it?

I am not sure what do you mean by the livelock here.

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
