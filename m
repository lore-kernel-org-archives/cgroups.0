From: Shakeel Butt <shakeelb@google.com>
Subject: [PATCH 3/3] memcg: increase MEMCG_CHARGE_BATCH to 64
Date: Mon, 22 Aug 2022 00:17:37 +0000
Message-ID: <20220822001737.4120417-4-shakeelb@google.com>
References: <20220822001737.4120417-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=DTW77A/Vjl+d5bcQDIprq1tGD6UgniZYOTpaR8iNZIc=;
        b=Dg9yytO9IkPtQr0hKr1opAsmaHFl6Ti0qmk9dgNkQKa6EeZnhuamJ8wFuDDpvnSucO
         3jnI66hn0RZluaprAxAC9vZCxkQXXdYA0KwOtMgEey7a9lQkqmoQ767sSys3ES+TUduk
         8r9futG6QW922rVpAUoBuyvHCBDkXpj6Z6uIr5bt4pi4JjwABrXPfF7E2R9JF1EvrU3W
         3HTuZx9jrCVbRGBo1EjBv/Hu+VbfEktqbj+TpV4cjusZQtsDY5OAzcQ1W3tgUYcjFPCH
         ebqBDDU8/54Qiztpi0pJPbzqNXn5hxGVXBNshftViCKjFt6eCv7LnIrPsIrM9eVLCdKl
         WwwQ==
In-Reply-To: <20220822001737.4120417-1-shakeelb@google.com>
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
stock, so there should not be any oom behavior change.

To evaluate the impact of this optimization, on a 72 CPUs machine, we
ran the following workload in a three level of cgroup hierarchy with top
level having min and low setup appropriately. More specifically
memory.min equal to size of netperf binary and memory.low double of
that.

 $ netserver -6
 # 36 instances of netperf with following params
 $ netperf -6 -H ::1 -l 60 -t TCP_SENDFILE -- -m 10K

Results (average throughput of netperf):
Without (6.0-rc1)       10482.7 Mbps
With patch              17064.7 Mbps (62.7% improvement)

With the patch, the throughput improved by 62.7%.

Signed-off-by: Shakeel Butt <shakeelb@google.com>
Reported-by: kernel test robot <oliver.sang@intel.com>
---
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

