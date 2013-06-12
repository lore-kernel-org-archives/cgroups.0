From: Glauber Costa <glommer@gmail.com>
Subject: [PATCH] memcg: make cache index determination more robust
Date: Wed, 12 Jun 2013 16:43:28 -0400
Message-ID: <1371069808-1172-1-git-send-email-glommer@openvz.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer;
        bh=sWli9Q5x6gfnEpetn1H2b2y1HURYsEHyXFopC0F85rY=;
        b=dE1G1iw2g2iTggHbGPM05Cz8mcCpRixNXYhl4PguOeJWD+troVRSVCbhfCEMfBHViY
         CnamGs6bePKT166CBX28UfaXEM7sESKTnsOTBqd+vsx7xFZ43osM2Pk2A/gGFHYdWvCf
         pu6xHxxB6sXO5gLw+pn3ZwWpiNZAdfRJCNtjt7rP1g4ICewtCvZBE1oBpMZA/tP14IWY
         Eh/lUu8YRRjEDA9Ld7XG/v5PSyGHyBoTXWXepYFGhW0frlc3a7l9g30cMFvaE9Y81T/6
         FyToWqmQo+9RCbaSeM6FLdkGgfie4GPjAXY3BPmEb5e8rxM4x2LunMVm8XgGnLbhQhNZ
         Mg4w==
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, Glauber Costa <glommer@openvz.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

I caught myself doing something like the following outside memcg core:

	memcg_id = -1;
	if (memcg && memcg_kmem_is_active(memcg))
		memcg_id = memcg_cache_id(memcg);

to be able to handle all possible memcgs in a sane manner. In particular, the
root cache will have kmemcg_id = -1 (just because we don't call memcg_kmem_init
to the root cache since it is not limitable). We have always coped with that by
making sure we sanitize which cache is passed to memcg_cache_id. Although this
example is given for root, what we really need to know is whether or not a
cache is kmem active.

But outside the memcg core testing for root, for instance, is not trivial since
we don't export mem_cgroup_is_root. I ended up realizing that this tests really
belong inside memcg_cache_id. This patch moves the tests inside memcg_cache_id
and make sure it always return a meaningful value.

Signed-off-by: Glauber Costa <glommer@openvz.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
---
 mm/memcontrol.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2e851f4..749f7a4 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3081,7 +3081,9 @@ void memcg_cache_list_add(struct mem_cgroup *memcg, struct kmem_cache *cachep)
  */
 int memcg_cache_id(struct mem_cgroup *memcg)
 {
-	return memcg ? memcg->kmemcg_id : -1;
+	if (!memcg || !memcg_kmem_is_active(memcg))
+		return -1;
+	return memcg->kmemcg_id;
 }
 
 /*
-- 
1.8.1.4

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
