From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] mm: memcontrol: fix the return in mem_cgroup_margin
Date: Mon, 23 May 2016 14:06:20 +0200
Message-ID: <20160523120620.GP2278@dhcp22.suse.cz>
References: <1463556255-31892-1-git-send-email-roy.qing.li@gmail.com>
 <20160518073253.GC21654@dhcp22.suse.cz>
 <CAJFZqHwFtZa-Ec_0bie6ORTrgoW1kqGsq49-=ojsT-uyNUBhwg@mail.gmail.com>
 <20160523103758.GB7917@esperanza>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20160523103758.GB7917@esperanza>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li RongQing <roy.qing.li@gmail.com>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>

On Mon 23-05-16 13:37:58, Vladimir Davydov wrote:
> On Thu, May 19, 2016 at 09:44:53AM +0800, Li RongQing wrote:
> > On Wed, May 18, 2016 at 3:32 PM, Michal Hocko <mhocko@kernel.org> wrote:
> > > count should always be smaller than memsw.limit (this is a hard limit).
> > > Even if we have some temporary breach then the code should work as
> > > expected because margin is initialized to 0 and memsw.limit >= limit.
> > 
> > is it possible for this case? for example
> > 
> > memory count is 500, memory limit is 600; the margin is set to 100 firstly,
> > then check memory+swap limit, its count(1100) is bigger than its limit(1000),
> > then the margin 100 is returned wrongly.
> 
> I guess it is possible, because try_charge forces charging __GFP_NOFAIL
> allocations, which may result in memsw.limit excess. If we are below
> memory.limit and there's nothing to reclaim to reduce memsw.usage, we
> might end up looping in try_charge forever. I've never seen that happen
> in practice, but I still think the patch is worth applying.

You are right. I have completely missed a potential interaction with
__GFP_NOFAIL. We even do not seem to trigger the memcg OOM killer for
these requests to sort the situation out.

Can we have updated patch with all this useful information in the
changelog, please?

Thanks Vladimir!
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
