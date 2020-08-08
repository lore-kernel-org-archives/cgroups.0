From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH] mm/memcg: remove useless check on page->mem_cgroup
Date: Sat, 8 Aug 2020 14:43:06 -0700
Message-ID: <20200808214306.GA1409287@carbon.dhcp.thefacebook.com>
References: <1596166480-22814-1-git-send-email-alex.shi@linux.alibaba.com>
 <20200731151655.GB491801@cmpxchg.org>
 <9338716f-ca0e-057f-8d94-03e2b3f70281@linux.alibaba.com>
 <20200803081815.GD5174@dhcp22.suse.cz>
 <bd61e672-b997-c4cd-2047-fca9dc11cc4c@linux.alibaba.com>
 <92dd8e68-8095-72c5-0144-2a084e4d5993@linux.alibaba.com>
 <5622ef68-5e70-d1a9-d1be-b45411b6be5c@linux.alibaba.com>
 <4740bac1-72f6-a640-ab6a-a8801e68c27a@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type :
 content-transfer-encoding : in-reply-to : mime-version; s=facebook;
 bh=shnf3XUgsWxS5mb56nP4OtfUtcLVG0fBIS33PQJ7Yxs=;
 b=J7G/GPP/vEc6PNiadBQK7JaBSYjB6uEZyIFj9QlTkcJMoj96aS62Wu90YrFAS7SUUrOe
 UQsumHCHMs3YhiRAAH8w9eWRLgYphFy5tJP4pXwO1vQx/7ahPYWG+wWMUGSF8gtDILFE
 pTEt514/4GgXz6Koo6C8/iZyK79yB38CTqw= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector2-fb-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=shnf3XUgsWxS5mb56nP4OtfUtcLVG0fBIS33PQJ7Yxs=;
 b=SkKAmV3wTQNoFBzbF9n/Y1HlbhVvxJ8FB7lOB4plKtLB28KPffMqzyx6HFV/e5kCeBMlSP8GwtbKQJb+NV7XLWhzXWYLX1jZFWdXfjU/gXh3ZL8VtaKPBMM4OPCOzhDf4AGh1K4J0SC7deAetmoxdLArSNPXYxuZljcNhjOl4wE=
Content-Disposition: inline
In-Reply-To: <4740bac1-72f6-a640-ab6a-a8801e68c27a@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Sat, Aug 08, 2020 at 09:22:29PM +0800, Alex Shi wrote:
> 
> 
> 在 2020/8/5 下午9:02, Alex Shi 写道:
> > 
> > 
> > 在 2020/8/5 下午8:28, Alex Shi 写道:
> >> The last patch has a problem on define. this version could fix it.
> >>
> >> BTW, I see some !memcg happens when MEMCG compilered but disabled by cgroup_disable
> >>
> >>
> >> [   94.657666] ---[ end trace f1f34bfc3b32ed2f ]---
> >> [   95.138995] anon flags: 0x5005b48008000d(locked|uptodate|dirty|swapbacked)
> >> [   95.146220] raw: 005005b48008000d dead000000000100 dead000000000122 ffff8897c7c76ad1
> >> [   95.154549] raw: 0000000000000022 0000000000000000 0000000200000000 0000000000000000
> >> [   95.162876] page dumped because: VM_WARN_ON_ONCE_PAGE(!memcg)
> >>
> >>
> > 
> > The following patch may helpful.
> 
> Any comments for the 2 patches?
> 
> Thanks
> Alex
> 
> > 
> > From 8bfb26a2e37e08dc61d20212bcfa5812a367ba94 Mon Sep 17 00:00:00 2001
> > From: Alex Shi <alex.shi@linux.alibaba.com>
> > Date: Wed, 5 Aug 2020 20:32:12 +0800
> > Subject: [PATCH] mm/memcg: don't try charge swap if memcg disabled
> > 
> > If we disabled memcg by cgroup_disable=memory, the swap charges are
> > still called. Let's return from the funcs earlier and keep WARN_ON
> > monitor.
> > 
> > Signed-off-by: Alex Shi <alex.shi@linux.alibaba.com>
> > Cc: Johannes Weiner <hannes@cmpxchg.org>
> > Cc: Michal Hocko <mhocko@kernel.org>
> > Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: cgroups@vger.kernel.org
> > Cc: linux-mm@kvack.org
> > Cc: linux-kernel@vger.kernel.org
> > ---
> >  mm/memcontrol.c | 6 ++++++
> >  1 file changed, 6 insertions(+)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index cb07a48d53aa..65f2b42d25af 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -7163,6 +7163,9 @@ void mem_cgroup_swapout(struct page *page, swp_entry_t entry)
> >  	VM_BUG_ON_PAGE(PageLRU(page), page);
> >  	VM_BUG_ON_PAGE(page_count(page), page);
> >  
> > +	if (mem_cgroup_disabled())
> > +		return;
> > +
> >  	if (cgroup_subsys_on_dfl(memory_cgrp_subsys))
> >  		return;
> >  
> > @@ -7228,6 +7231,9 @@ int mem_cgroup_try_charge_swap(struct page *page, swp_entry_t entry)
> >  	struct mem_cgroup *memcg;
> >  	unsigned short oldid;
> >  
> > +	if (mem_cgroup_disabled())
> > +		return 0;
> > +
> >  	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys))
> >  		return 0;
> >  
> > 


Hi Alex,

this patch looks good to me. Please, feel free to add
Reviewed-by: Roman Gushchin <guro@fb.com>

What's the second patch?

Thanks!

