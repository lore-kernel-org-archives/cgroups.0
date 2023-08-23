From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v2] mm: vmscan: reclaim anon pages if there are swapcache
 pages
Date: Wed, 23 Aug 2023 15:12:41 +0200
Message-ID: <ZOYFydIp3q8BNrEa@dhcp22.suse.cz>
References: <20230822024901.2412520-1-liushixin2@huawei.com>
 <CAJD7tkZkYsopuqGH_Lo=kE4=HO33wmvK6mXhuq4p_KZ6pYuXtw@mail.gmail.com>
 <50c49baf-d04a-f1e3-0d0e-7bb8e22c3889@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1692796362; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Uz09CIFb4phUja5aPxrRB0e9q5bhxoa70nYLw9mLuHM=;
        b=jWTBefLrqe2p82kmhfsYvU/xVcAN6GLUbIIDYYcXdMJBReUCLsL7ElyotvzvcBfOpqzO/t
        1hb3KK7+IQXveL1TfELQbWLV8euLDx/p1JGmt5VU/+RbtQbaVs3R/7z0gQg2JU8KqWMciz
        7M+WaltLFLrP9qJqGJtUdr9uAG1bdzE=
Content-Disposition: inline
In-Reply-To: <50c49baf-d04a-f1e3-0d0e-7bb8e22c3889@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Liu Shixin <liushixin2@huawei.com>
Cc: Yosry Ahmed <yosryahmed@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, wangkefeng.wang@huawei.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org

On Wed 23-08-23 10:00:58, Liu Shixin wrote:
> 
> 
> On 2023/8/23 0:35, Yosry Ahmed wrote:
> > On Mon, Aug 21, 2023 at 6:54 PM Liu Shixin <liushixin2@huawei.com> wrote:
> >> When spaces of swap devices are exhausted, only file pages can be reclaimed.
> >> But there are still some swapcache pages in anon lru list. This can lead
> >> to a premature out-of-memory.
> >>
> >> This problem can be fixed by checking number of swapcache pages in
> >> can_reclaim_anon_pages(). For memcg v2, there are swapcache stat that can
> >> be used directly. For memcg v1, use total_swapcache_pages() instead, which
> >> may not accurate but can solve the problem.
> > Interesting find. I wonder if we really don't have any handling of
> > this situation.
> I have alreadly test this problem and can confirm that it is a real problem.
> With 9MB swap space and 10MB mem_cgroup limit，when allocate 15MB memory,
> there is a probability that OOM occurs.

Could you be more specific about the test and the oom report?

-- 
Michal Hocko
SUSE Labs
