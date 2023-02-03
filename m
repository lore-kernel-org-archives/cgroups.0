From: Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/2] sched/isolation: Add cpu_is_isolated() API
Date: Sat,  4 Feb 2023 00:24:09 +0100
Message-ID: <20230203232409.163847-3-frederic@kernel.org>
References: <20230203232409.163847-1-frederic@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675466663;
        bh=p1w/s0O5n3VSeOMpM1vDKAz+K6RPGrIp6QpaiUCAbUc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BuCrVsu7EsqwcuHwg7AUSbKZd6w6kULIQHrvnJZdUFECtU5/XPaHlkkcxjMPEhLga
         KVzT7ESVrOE/BZJQFfSitLQe2lUzquK9cVIp2Iw3xIk+Iozoq0lPn/0/CP26maBNXy
         kJnaR8PUUKkTPEFx3+exk8co1JIx29PdVQ8zDWpvfr1ct+VQB2f3sNJJSC6tHoXyz7
         8u1AQd75R/OsWTxVL8XsPr0NtOj6elD8dcH+8S2k8+fk6jFIliCOej9sZNkuh0C6sE
         ds9hl+PCcLXgThtlugAUMHXnxGzGqkv4iUizOyXVr0YqhP3pgTHk/zCI9g5lYKWSRU
         iewsp3xAyNdkA==
In-Reply-To: <20230203232409.163847-1-frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Leonardo <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

Provide this new API to check if a CPU has been isolated either through
isolcpus= or nohz_full= kernel parameter.

It aims at avoiding kernel load deemed to be safely spared on CPUs
running sensitive workload that can't bear any disturbance, such as
pcp cache draining.

Suggested-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Signed-off-by: Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 include/linux/sched/isolation.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/include/linux/sched/isolation.h b/include/linux/sched/isolation.h
index b645cc81fe01..088672f08469 100644
--- a/include/linux/sched/isolation.h
+++ b/include/linux/sched/isolation.h
@@ -53,4 +53,10 @@ static inline bool housekeeping_cpu(int cpu, enum hk_type type)
 	return true;
 }
 
+static inline bool cpu_is_isolated(int cpu)
+{
+	return !housekeeping_test_cpu(cpu, HK_TYPE_DOMAIN) ||
+		 !housekeeping_test_cpu(cpu, HK_TYPE_KERNEL_NOISE);
+}
+
 #endif /* _LINUX_SCHED_ISOLATION_H */
-- 
2.34.1

