From: Abel Wu <wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: [PATCH 1/3] mm/mempolicy: apply cpuset limits to tasks using default policy
Date: Thu, 22 Apr 2021 17:06:06 +0800
Message-ID: <20210422090608.7160-2-wuyun.abel@bytedance.com>
References: <20210422090608.7160-1-wuyun.abel@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZTf4VDhB+vsAlWiKaTvh+bcNfZdV5PiIE39ZO2UyLSc=;
        b=QKA0xpPzIE5m7ObGgIH4Ww862+GJtKlZgxONOym/4benb+hChVs1lThp8lwEvL6DZx
         gS1BnKHW2MgjI3Lqh5503JGP4B0YVGJFdTsikNoUyTXVN116heU7bqRphUrvPGj92oKd
         +u5PUlbGn7/JrtSL9OtxLTP32nBbFwhlhOx4HU414jrOF5HheHVeODie6K4UMF1xs22x
         1CBrFHKGf5P2fQHjAKP1nUFeiSwN9yC7eLv+/vTZUzLUSaD2Hd9Io2IVjr+e60skyXih
         6kNpW9gEiD1qkbAycdjVN/M0wr2e+UqQWumISWzgQUrI+Hf7bbUsUK9udCeOsfxOK0LO
         WP/Q==
In-Reply-To: <20210422090608.7160-1-wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

The nodemasks of non-default policies (pol->v) are calculated within
the restriction of task->mems_allowed, while default policies are not.
This may lead to improper results of mpol_misplaced(), since it can
return a target node outside of current->mems_allowed for tasks using
default policies. Although this is not a bug because migrating pages
to that out-of-cpuset node will fail eventually due to sanity checks
in page allocation, it still would be better to avoid such useless
efforts.

This patch also changes the behavior of autoNUMA a bit by showing
a tendency to move pages inside mems_allowed for tasks using default
policies, which is good for memory isolation.

Signed-off-by: Abel Wu <wuyun.abel-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
---
 mm/mempolicy.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index d79fa299b70c..e0ae6997bbfb 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -2516,7 +2516,10 @@ int mpol_misplaced(struct page *page, struct vm_area_struct *vma, unsigned long
 
 	/* Migrate the page towards the node whose CPU is referencing it */
 	if (pol->flags & MPOL_F_MORON) {
-		polnid = thisnid;
+		if (node_isset(thisnid, cpuset_current_mems_allowed))
+			polnid = thisnid;
+		else
+			polnid = node_random(&cpuset_current_mems_allowed);
 
 		if (!should_numa_migrate_memory(current, page, curnid, thiscpu))
 			goto out;
-- 
2.31.1

