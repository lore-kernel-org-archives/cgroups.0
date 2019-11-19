From: Alex Shi <alex.shi@linux.alibaba.com>
Subject: Re: [PATCH v3 3/7] mm/lru: replace pgdat lru_lock with lruvec lock
Date: Tue, 19 Nov 2019 18:08:04 +0800
Message-ID: <fc4716ae-a49e-68f0-98da-9318ff1f4138@linux.alibaba.com>
References: <1573874106-23802-1-git-send-email-alex.shi@linux.alibaba.com>
 <1573874106-23802-4-git-send-email-alex.shi@linux.alibaba.com>
 <CALvZod7oUmUCk96ATrRwYvrROFNqL1gPGt7fy949M8TMwCQrWA@mail.gmail.com>
 <3f179d84-85e2-bace-2dbc-e77f73883c71@linux.alibaba.com>
 <20191118123138.GL20752@bombadil.infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20191118123138.GL20752@bombadil.infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Matthew Wilcox <willy@infradead.org>
Cc: Shakeel Butt <shakeelb@google.com>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mgorman@techsingularity.net>, Tejun Heo <tj@kernel.org>, Hugh Dickins <hughd@google.com>, Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, Daniel Jordan <daniel.m.jordan@oracle.com>, Yang Shi <yang.shi@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Roman Gushchin <guro@fb.com>, Chris Down <chris@chrisdown.name>, Thomas Gleixner <tglx@linutronix.de>, Vlastimil Babka <vbabka@suse.cz>, Qian Cai <cai@lca.pw>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Kirill A. Shute



在 2019/11/18 下午8:31, Matthew Wilcox 写道:
>> Thanks for comments, Shakeel.
>>
>> lruvec lifetime is same as memcg, which allocted in mem_cgroup_alloc()->alloc_mem_cgroup_per_node_info()
>> I have read Hugh's patchset, even not every lines. But what's point of you here?
> I believe Shakeel's point is that here:
> 
> struct lruvec *mem_cgroup_page_lruvec(struct page *page, struct pglist_data *pgdat)
> {
> ...
>         memcg = page->mem_cgroup;
> 
> there is nothing pinning the memcg, and it could be freed before
> dereferencing memcg->nodeinfo in mem_cgroup_page_nodeinfo().

That's right! I will send the fix patches for review. 
Thanks a lot!
