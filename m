From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2] mm/memcg: Fix incorrect flushing of lruvec data in obj_stock
Date: Mon, 2 Aug 2021 07:39:41 -0700
Message-ID: <CALvZod51JYXv0Vzo-JhsFF1K9SsSXqJCGtEedXtfQAYQAN_5jQ@mail.gmail.com>
References: <20210802143834.30578-1-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=z1m6pfpC9rsy4GSyHGxYSdhbpeh3oHqT/0d9aZ8K278=;
        b=fdtPnMBtsMGDTdvX2QBuR6NOVYxQwCHecY1QbSOcjAf9TiIs9eCkCzVwMMO+3YRlEY
         GvRyLN1BM+Wj0CjkHDuV3TS7ZKAv19LReq4O5Ou7P4B0mdbRU1EzTTm1C4y1wgZ7yNtr
         +a46F67dQVEAFtzb8DFx420SXHHckE63pTNxmo0Jb/sqX8aRt7aQShh59oLaFTf8v7ZA
         x5wUBgStITrUg/h47Gg3mo5tlbUFVVzXMkeKeEMSQDumsJcSrKx/HO0rE5ADto6FW+KP
         2Mirl0FPCWyv9eytyN5VvtI0xyPxR9GbsZr7pxM+HmkERO+QO3uNUx8VN70c7/i8lXzW
         z0JA==
In-Reply-To: <20210802143834.30578-1-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Vlastimil Babka <vbabka@suse.cz>, Roman Gushchin <guro@fb.com>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Muchun Song <songmuchun@bytedance.com>, Alex Shi <alex.shi@linux.alibaba.com>, Chris Down <chris@chrisdown.name>, Yafang Shao <laoar.shao@gmail.com>, Wei Yang <richard.weiyang@gmail.com>, Masayoshi Mizuma <msys.mizuma@gmail.com>, Xing Zhengjun <zhengjun.xing@linu>

On Mon, Aug 2, 2021 at 7:38 AM Waiman Long <longman@redhat.com> wrote:
>
> When mod_objcg_state() is called with a pgdat that is different from
> that in the obj_stock, the old lruvec data cached in obj_stock are
> flushed out. Unfortunately, they were flushed to the new pgdat and
> so the data go to the wrong node. This will screw up the slab data
> reported in /sys/devices/system/node/node*/meminfo.
>
> Fix that by flushing the data to the cached pgdat instead.
>
> Fixes: 68ac5b3c8db2 ("mm/memcg: cache vmstat data in percpu memcg_stock_pcp")
> Signed-off-by: Waiman Long <longman@redhat.com>
> Acked-by: Michal Hocko <mhocko@suse.com>

Reviewed-by: Shakeel Butt <shakeelb@google.com>
