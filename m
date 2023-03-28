From: Yosry Ahmed <yosryahmed@google.com>
Subject: [PATCH v1 9/9] memcg: do not modify rstat tree for zero updates
Date: Tue, 28 Mar 2023 06:16:38 +0000
Message-ID: <20230328061638.203420-10-yosryahmed@google.com>
References: <20230328061638.203420-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679984218;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Vy8wz9BoJKucmcMBXvIGPOuITeThi///HtllaZbgtCo=;
        b=G3C3U8FV5xO4vsplclhU9+4PkBH686vIIIrQFFquICu8//oGn5xL/Tmt4VNVE1HnMt
         hORJK4mB81itHhGs1+plTWPpHn6PXb4UvAXp2In5M38sRtIYXUydb86gW9UCcwU8NUMK
         AKSJULzbSmJ/Zh8xR8z20CA4EuuFhupmK6yUb7XM0dWX+orGZyC4roBLz+bFSVl/SrGz
         jDFcau8INkey+e5jkuXnym7vXagjhy1slym0NeO+iUEtBeJGIjBlnt29eYQhaZCdCsb9
         TItPIolnMlslNIl39r9v4yrb91hLywelng+1GUeMlXmGbk+u0V1YHrp34uG87/cMCuf4
         DKLw==
In-Reply-To: <20230328061638.203420-1-yosryahmed@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>

In some situations, we may end up calling memcg_rstat_updated() with a
value of 0, which means the stat was not actually updated. An example is
if we fail to reclaim any pages in shrink_folio_list().

Do not add the cgroup to the rstat updated tree in this case, to avoid
unnecessarily flushing it.

Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
---
 mm/memcontrol.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 0c0e74188e90..828e670e721a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -618,6 +618,9 @@ static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val)
 {
 	unsigned int x;
 
+	if (!val)
+		return;
+
 	cgroup_rstat_updated(memcg->css.cgroup, smp_processor_id());
 
 	x = __this_cpu_add_return(stats_updates, abs(val));
-- 
2.40.0.348.gf938b09366-goog

