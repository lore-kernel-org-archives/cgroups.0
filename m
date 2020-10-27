From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: [PATCH 4/5] mm: memcg/slab: Fix root memcg vmstats
Date: Tue, 27 Oct 2020 16:02:55 +0800
Message-ID: <20201027080256.76497-5-songmuchun@bytedance.com>
References: <20201027080256.76497-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=LN3286O1QAMAK+WN2hg/G+SRa6WlZWbQzoibyYb4wWo=;
        b=PJog1NMte5d9AcJQ2N25yRGouMltF5NBzhqBTv5dYQmj59PEpXsswhsrU0LQ+VWVfn
         aLdhc9z+7+C3pAXFkSsi/4lSgs4MYKwF7uVxVl+NsaEQOQzS04XB6RLzkTkl9RkPB0Oq
         SkIb23JF1hsg16qTRBKdvWjTQabtx+3Q9R5e4k+VNRf43+TfAiWbkEICxD3t3+7NB7p7
         L8yLqDncE2eSZPNsDjZSHXJ2Wv2O3UCu1Gk29TEbivdr3CCZBt8Zstueo74xQ/0viaBY
         EDV9Pv6BY3iPIabSdepfkGEm9H2JQlMqBjsX0yyAsdIyNWdN466cnPESkPb7kZHS7hKf
         LJSQ==
In-Reply-To: <20201027080256.76497-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, guro-b10kYP2dOMg@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org, christian.brauner-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, esyr-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, areber-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, elver-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

If we reparent the slab objects to the root memcg, when we free
the slab object, we need to update the per-memcg vmstats to keep
it correct for the root memcg. Now this at least affects the vmstat
of NR_KERNEL_STACK_KB for !CONFIG_VMAP_STACK when the thread stack
size is smaller than the PAGE_SIZE.

Fixes: ec9f02384f60 ("mm: workingset: fix vmstat counters for shadow nodes")
Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
---
 mm/memcontrol.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 22b4fb941b54..70345b15b150 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -875,8 +875,13 @@ void __mod_lruvec_kmem_state(void *p, enum node_stat_item idx, int val)
 	rcu_read_lock();
 	memcg = mem_cgroup_from_obj(p);
 
-	/* Untracked pages have no memcg, no lruvec. Update only the node */
-	if (!memcg || memcg == root_mem_cgroup) {
+	/*
+	 * Untracked pages have no memcg, no lruvec. Update only the
+	 * node. If we reparent the slab objects to the root memcg,
+	 * when we free the slab object, we need to update the per-memcg
+	 * vmstats to keep it correct for the root memcg.
+	 */
+	if (!memcg) {
 		__mod_node_page_state(pgdat, idx, val);
 	} else {
 		lruvec = mem_cgroup_lruvec(memcg, pgdat);
-- 
2.20.1

