From: Shakeel Butt <shakeelb@google.com>
Subject: [PATCH v2 3/3] memcg: increase MEMCG_CHARGE_BATCH to 64
Date: Thu, 25 Aug 2022 00:05:06 +0000
Message-ID: <20220825000506.239406-4-shakeelb@google.com>
References: <20220825000506.239406-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=3ANOEI0BBXDszhHsMjNjVkJxW2dSCbobxCznkiQMg0M=;
        b=M8tSmqMgyZLVy2Ldt7OEwatTGNnYnfDpQ69BuMQNcXOyVDB1zOG1S5rA/96I/PJKxE
         4+npbWP3pWJ08Qbrxcia+8i6j7Gu69xnnOJNpGf1qEh/CTh6F27WQ4nVQLW4A9J5Lhh9
         wZHGTsioVx7toZiUJ8cHixmiZOFP7E6zdyNZLONxSLuMdImMycE2Fyt+XuqZ+8IhLHsR
         C6dFsjW4r02bqFmtyRS3Kq6G3VP5sgtlfNBMT7ztQEx6AL13xu9pwUVXfdMd6YEAnByA
         YGozttZzHIvY64hF0IBSZ5RbI4tZvRxI5hd9vrRa+K0+Wr8X++i6Jrnvoe/mNBWb+0ko
         v09Q==
In-Reply-To: <20220825000506.239406-1-shakeelb@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <songmuchun@bytedance.com>
Cc: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>, Eric Dumazet <edumazet@google.com>, Soheil Hassas Yeganeh <soheil@google.com>, Feng Tang <feng.tang@intel.com>, Oliver Sang <oliver.sang@intel.com>, Andrew Morton <akpm@linux-foundation.org>, lkp@lists.01.org, cgroups@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org, Shakeel Butt <shakeelb@google.com>

For several years, MEMCG_CHARGE_BATCH was kept at 32 but with bigger
machines and the network intensive workloads requiring througput in
Gbps, 32 is too small and makes the memcg charging path a bottleneck.
For now, increase it to 64 for easy acceptance to 6.0. We will need to
revisit this in future for ever increasing demand of higher performance.

Please note that the memcg charge path drain the per-cpu memcg charge
stock, so there should not be any oom behavior change. Though it does
have impact on rstat flushing and high limit reclaim backoff.

To evaluate the impact of this optimization, on a 72 CPUs machine, we
ran the following workload in a three level of cgroup hierarchy.

 $ netserver -6
 # 36 instances of netperf with following params
 $ netperf -6 -H ::1 -l 60 -t TCP_SENDFILE -- -m 10K

Results (average throughput of netperf):
Without (6.0-rc1)       10482.7 Mbps
With patch              17064.7 Mbps (62.7% improvement)

With the patch, the throughput improved by 62.7%.

Signed-off-by: Shakeel Butt <shakeelb@google.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Reviewed-by: Feng Tang <feng.tang@intel.com>
Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
---
Changes since v1:
- Updated commit message

 include/linux/memcontrol.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 4d31ce55b1c0..70ae91188e16 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -354,10 +354,11 @@ struct mem_cgroup {
 };
 
 /*
- * size of first charge trial. "32" comes from vmscan.c's magic value.
- * TODO: maybe necessary to use big numbers in big irons.
+ * size of first charge trial.
+ * TODO: maybe necessary to use big numbers in big irons or dynamic based of the
+ * workload.
  */
-#define MEMCG_CHARGE_BATCH 32U
+#define MEMCG_CHARGE_BATCH 64U
 
 extern struct mem_cgroup *root_mem_cgroup;
 
-- 
2.37.1.595.g718a3a8f04-goog

