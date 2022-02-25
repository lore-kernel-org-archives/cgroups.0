From: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
Subject: [PATCH] mm/memcg: Add missing counter index which are not update in
 interrupt.
Date: Fri, 25 Feb 2022 16:17:39 +0100
Message-ID: <YhjzE/8LgbULbj/C@linutronix.de>
References: <20220221182540.380526-1-bigeasy@linutronix.de>
 <20220221182540.380526-4-bigeasy@linutronix.de>
 <CALvZod7DfxHp+_NenW+NY81WN_Li4kEx4rDodb2vKhpC==sd5g@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1645802261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GRb+2qkiHEDDH9G/1JIbbgHYgu3fgWeEbLACig+UXdw=;
        b=3e7V0WReYycn9LxQofAy75Lu5aJjUV05vI3xjU35qX617bvbJFPUySzgha8//QWe+WlP7P
        TA/BMh1L+E4KS7erjIHkV309iIaqc44dAxwd4ZDExGolClsVazc1llmE9ZoaXg4LxZoK+4
        K49cZ4I40yT6pJZuZchklnlVIySURo9+CIDlqiimZjDW3GjuE1t2wU7EvF6N9bjWqGZZYN
        hBnmSQh6k6wYK7/ALRCH/HMphkeuHwlqmoUmdI3Dec6rct4YVA9QKzcUuz50AouBLtI1Dk
        r0w+ca/70Xq5A7/hcgz7uK838cEOtqzxb5HzUvCl45esaVIVJJne1ydI8RRWEQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1645802261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=GRb+2qkiHEDDH9G/1JIbbgHYgu3fgWeEbLACig+UXdw=;
        b=tJIMaiB2JC3x804scY7JWnnQ0clm3NPSoZFdAxtMbTytHV83aV66p9NXIHhXgcH8dmq1gS
        BaWejrTh4lCo14BA==
Content-Disposition: inline
In-Reply-To: <CALvZod7DfxHp+_NenW+NY81WN_Li4kEx4rDodb2vKhpC==sd5g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>

Shakeel Butt reported that I missed a few counters which are not updated
in-interrupt context and therefore disabling preemption is fine.

Please fold into:
     "Protect per-CPU counter by disabling preemption on PREEMPT_RT"

Signed-off-by: Sebastian Andrzej Siewior <bigeasy-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>
---
 mm/memcontrol.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 9c29b1a0e6bec..7883e2f2af3e8 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -743,10 +743,17 @@ void __mod_memcg_lruvec_state(struct lruvec *lruvec, enum node_stat_item idx,
 	 */
 	__memcg_stats_lock();
 	if (IS_ENABLED(CONFIG_DEBUG_VM)) {
-		if (idx == NR_ANON_MAPPED || idx == NR_FILE_MAPPED)
+		switch (idx) {
+		case NR_ANON_MAPPED:
+		case NR_FILE_MAPPED:
+		case NR_ANON_THPS:
+		case NR_SHMEM_PMDMAPPED:
+		case NR_FILE_PMDMAPPED:
 			WARN_ON_ONCE(!in_task());
-		else
+			break;
+		default:
 			WARN_ON_ONCE(!irqs_disabled());
+		}
 	}
 
 	/* Update memcg */
-- 
2.35.1

