From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 3/9] memcg: do not flush stats in irq context
Date: Tue, 28 Mar 2023 22:16:38 +0000
Message-ID: <20230328221644.803272-4-yosryahmed@google.com>
References: <20230328221644.803272-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680041816;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=/WDDqk1nTT7D9mKcEzqzCjbueo/E6L9K7q/9wjNO8LY=;
        b=TcS0DaK7zSX/dgbsp92dhBvU1YXIfJw7DU8Bxymw385Iypv0i9ByV9836BmH3XGIri
         GA3G9Ah6/ynKVVXAJLor7BukC88mhb5FcK9F0N2UppuVbKofnYFrmwIOVN2419Sgn/T3
         Leo2J62N2CQ7p4vQ5tLG3l0ISmiaqnyiPoXjgBX2M4RYA1wXrmenFymFmJXjeUJkODde
         IPUO/XjdrDDGWWgE3vWyhfVxnLq+1UNPnYiIQva9A9S4iya4Iw/wc2ln/EZk6xTcIXjg
         k22ctJfIxPj6HJVEsaVfFSF1/WN3feXNcAQlYcNsdD7yhK296UbpIQqZDQ1X1PAq/IZq
         ToQw==
In-Reply-To: <20230328221644.803272-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Currently, the only context in which we can invoke an rstat flush from
irq context is through mem_cgroup_usage() on the root memcg when called
from memcg_check_events(). An rstat flush is an expensive operation that
should not be done in irq context, so do not flush stats and use the
stale stats in this case.

Arguably, usage threshold events are not reliable on the root memcg
anyway since its usage is ill-defined.

Suggested-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Suggested-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Acked-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 mm/memcontrol.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c3b6aae78901..ff39f78f962e 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3669,7 +3669,21 @@ static unsigned long mem_cgroup_usage(struct mem_cgroup *memcg, bool swap)
 	unsigned long val;
 
 	if (mem_cgroup_is_root(memcg)) {
-		mem_cgroup_flush_stats();
+		/*
+		 * We can reach here from irq context through:
+		 * uncharge_batch()
+		 * |--memcg_check_events()
+		 *    |--mem_cgroup_threshold()
+		 *       |--__mem_cgroup_threshold()
+		 *          |--mem_cgroup_usage
+		 *
+		 * rstat flushing is an expensive operation that should not be
+		 * done from irq context; use stale stats in this case.
+		 * Arguably, usage threshold events are not reliable on the root
+		 * memcg anyway since its usage is ill-defined.
+		 */
+		if (in_task())
+			mem_cgroup_flush_stats();
 		val = memcg_page_state(memcg, NR_FILE_PAGES) +
 			memcg_page_state(memcg, NR_ANON_MAPPED);
 		if (swap)
-- 
2.40.0.348.gf938b09366-goog

