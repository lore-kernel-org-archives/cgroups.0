From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 6/8] mm: memcontrol: move kmem accounting code to
 CONFIG_MEMCG
Date: Thu, 10 Dec 2015 14:17:18 +0100
Message-ID: <20151210131718.GL19496@dhcp22.suse.cz>
References: <1449599665-18047-1-git-send-email-hannes@cmpxchg.org>
 <1449599665-18047-7-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1449599665-18047-7-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vladimir Davydov <vdavydov@virtuozzo.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Tue 08-12-15 13:34:23, Johannes Weiner wrote:
> The cgroup2 memory controller will account important in-kernel memory
> consumers per default. Move all necessary components to CONFIG_MEMCG.

Hmm, that bloats the kernel also for users who are not using cgroup2
and have CONFIG_MEMCG_KMEM disabled.

This is the situation before this patch
   text    data     bss     dec     hex filename
 521342   97516   44312  663170   a1e82 mm/built-in.o.kmem
 513349   96299   43960  653608   9f928 mm/built-in.o.nokmem

and after with CONFIG_MEMCG_KMEM=n

 521028   96556   44312  661896   a1988 mm/built-in.o

we are basically back to CONFIG_MEMCG_KMEM=y. This sounds like a wastage
to me. Do we really need this?

> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
[...]
-- 
Michal Hocko
SUSE Labs
