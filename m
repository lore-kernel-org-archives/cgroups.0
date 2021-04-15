From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 3/5] mm/memcg: Cache vmstat data in percpu
 memcg_stock_pcp
Date: Thu, 15 Apr 2021 12:50:28 -0400
Message-ID: <YHhu1BOMj1Ip+sb3@cmpxchg.org>
References: <20210414012027.5352-1-longman@redhat.com>
 <20210414012027.5352-4-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=72rB8XajCzG79dd5/kOjH7uMhYOH+DU3KMVLgxLTyr4=;
        b=gQvCER62Mwi5oOStzJNE1BKisdCON4w0Nn2typ/ZyS1Ny50cGwhUj9pvaveb3tS9/E
         X9MNmWLkyS9uXvaumY/gMJXf8m+jhaGuAOeFRcXV9DF8WLtqNDnuki4CHTcmCgRQMWgX
         f3zALOJ57RB3qV+eTAbSEx+AutfxwtoDwjoqIzk3Ei4QXWsD8M6LRgg7wGL0LaXyLiho
         344kPvBWK4+RhlgZtEs+mK5xUlqQSffYOatYybZyyx8/RhSHJFzmxMaNddavPBPrHsDA
         /hVrZaxPiv8rCR4j8LjKGwsmpreZVSW5yhnbx6wRts3LHecG1e3eyeL0/fLAEoHvRqxV
         hZrw==
Content-Disposition: inline
In-Reply-To: <20210414012027.5352-4-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Vlastimil Babka <vbabka@suse.cz>, Roman Gushchin <guro@fb.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>, Muchun Song <songmuchun@bytedance.com>, Alex Shi <alex.shi@linux.alibaba.com>, Chris Down <chris@chrisdown.name>, Yafang Shao <laoar.shao@gmail.com>, Wei Yang <richard.weiyang@gmail.com>, Masayoshi Mizuma <msys.mizuma@gmail.com>, Xing Zhengjun <zhengjun.xing@linux.intel.com>

On Tue, Apr 13, 2021 at 09:20:25PM -0400, Waiman Long wrote:
> Before the new slab memory controller with per object byte charging,
> charging and vmstat data update happen only when new slab pages are
> allocated or freed. Now they are done with every kmem_cache_alloc()
> and kmem_cache_free(). This causes additional overhead for workloads
> that generate a lot of alloc and free calls.
> 
> The memcg_stock_pcp is used to cache byte charge for a specific
> obj_cgroup to reduce that overhead. To further reducing it, this patch
> makes the vmstat data cached in the memcg_stock_pcp structure as well
> until it accumulates a page size worth of update or when other cached
> data change.
> 
> On a 2-socket Cascade Lake server with instrumentation enabled and this
> patch applied, it was found that about 17% (946796 out of 5515184) of the
> time when __mod_obj_stock_state() is called leads to an actual call to
> mod_objcg_state() after initial boot. When doing parallel kernel build,
> the figure was about 16% (21894614 out of 139780628). So caching the
> vmstat data reduces the number of calls to mod_objcg_state() by more
> than 80%.

Right, but mod_objcg_state() is itself already percpu-cached. What's
the benefit of avoiding calls to it with another percpu cache?
