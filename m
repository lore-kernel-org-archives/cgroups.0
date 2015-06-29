From: Nicholas Krause <xerofoify@gmail.com>
Subject: [PATCH] mm:Make the function alloc_mem_cgroup_per_zone_info bool
Date: Mon, 29 Jun 2015 10:13:53 -0400
Message-ID: <1435587233-27976-1-git-send-email-xerofoify@gmail.com>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=9Js1Y82/603o3+EeRhglrfanLkvqu49cGbVstPy79tU=;
        b=BFbpvZthkPf0D2/DNhthIQloT3YHGbulSJDLKew6WHW1Ipej2N4Cbp9bNqO1tO1Z9w
         O7leDfp1fCVAREqzkssccTcvizmUc+QrZtMgb5vSDFYXw0HIvrNskZ+QFBChjybxgYVT
         paSDWIYBFtjx+pnpar+GYngo0ZjIkn+OyYhV0z0kx3m2BK0zlbnsKKWP9a1qKq/O58DI
         4lzdg7jSrgxyY8ZlO7v11TZQN2sc0PoYUJgrkYADbksSQX3LS/PkmOObREYxVHgEeOCT
         4dqH4/4y9UD5JWA2bAGLXN00be2NlWYJMEgXOSTt2QYbkd3bnXXz3/u/mCBix83Rj1/W
         HsxQ==
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes@cmpxchg.org
Cc: mhocko@suse.cz, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

This makes the function alloc_mem_cgroup_per_zone_info have a
return type of bool now due to this particular function always
returning either one or zero as its return value.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 mm/memcontrol.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index acb93c5..35d86d2 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4425,7 +4425,7 @@ static struct cftype mem_cgroup_legacy_files[] = {
 	{ },	/* terminate */
 };
 
-static int alloc_mem_cgroup_per_zone_info(struct mem_cgroup *memcg, int node)
+static bool alloc_mem_cgroup_per_zone_info(struct mem_cgroup *memcg, int node)
 {
 	struct mem_cgroup_per_node *pn;
 	struct mem_cgroup_per_zone *mz;
@@ -4442,7 +4442,7 @@ static int alloc_mem_cgroup_per_zone_info(struct mem_cgroup *memcg, int node)
 		tmp = -1;
 	pn = kzalloc_node(sizeof(*pn), GFP_KERNEL, tmp);
 	if (!pn)
-		return 1;
+		return true;
 
 	for (zone = 0; zone < MAX_NR_ZONES; zone++) {
 		mz = &pn->zoneinfo[zone];
@@ -4452,7 +4452,7 @@ static int alloc_mem_cgroup_per_zone_info(struct mem_cgroup *memcg, int node)
 		mz->memcg = memcg;
 	}
 	memcg->nodeinfo[node] = pn;
-	return 0;
+	return false;
 }
 
 static void free_mem_cgroup_per_zone_info(struct mem_cgroup *memcg, int node)
-- 
2.1.4

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
