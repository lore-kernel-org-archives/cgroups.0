From: Kirill Tkhai <ktkhai@virtuozzo.com>
Subject: [PATCH] memcg: Remove memcg_cgroup::id from IDR on
 mem_cgroup_css_alloc() failure
Date: Thu, 12 Apr 2018 17:52:04 +0300
Message-ID: <152354470916.22460.14397070748001974638.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector1; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=VcqWop4mR/UeOmwyinIz+r0iXyOkNXPUvaMoOhprB3k=;
 b=Q/9hk4T5+N7tVh6U2fBuLuu29VBTtig2hAI4/1Plwu0lOeUYfbkLNjqu20Mrer4I6ne7zY6bjsMFH9beealwbXpaTSSUtRs0JKCG91axEM2yywQCbxCzx3G33pEcfKl+u+6fNP6wdn+7OdFkkh+GEw8VMm1873ZbCjiEnWRIrr0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

In case of memcg_online_kmem() fail, memcg_cgroup::id remains hashed
in mem_cgroup_idr even after memcg memory is freed. This leads to leak
of ID in mem_cgroup_idr.

This patch adds removing into mem_cgroup_css_alloc(), which fixes
the problem. For better readability, it adds generic helper, which
will be used in mem_cgroup_alloc() and mem_cgroup_id_put_many() too.

Fixes 73f576c04b94 "mm: memcontrol: fix cgroup creation failure after many small jobs"
Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
---
 mm/memcontrol.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3e7942c301a8..448db08d97a0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4263,6 +4263,14 @@ static struct cftype mem_cgroup_legacy_files[] = {
 
 static DEFINE_IDR(mem_cgroup_idr);
 
+static void mem_cgroup_id_remove(struct mem_cgroup *memcg)
+{
+	if (memcg->id.id > 0) {
+		idr_remove(&mem_cgroup_idr, memcg->id.id);
+		memcg->id.id = 0;
+	}
+}
+
 static void mem_cgroup_id_get_many(struct mem_cgroup *memcg, unsigned int n)
 {
 	VM_BUG_ON(atomic_read(&memcg->id.ref) <= 0);
@@ -4273,8 +4281,7 @@ static void mem_cgroup_id_put_many(struct mem_cgroup *memcg, unsigned int n)
 {
 	VM_BUG_ON(atomic_read(&memcg->id.ref) < n);
 	if (atomic_sub_and_test(n, &memcg->id.ref)) {
-		idr_remove(&mem_cgroup_idr, memcg->id.id);
-		memcg->id.id = 0;
+		mem_cgroup_id_remove(memcg);
 
 		/* Memcg ID pins CSS */
 		css_put(&memcg->css);
@@ -4411,8 +4418,7 @@ static struct mem_cgroup *mem_cgroup_alloc(void)
 	idr_replace(&mem_cgroup_idr, memcg, memcg->id.id);
 	return memcg;
 fail:
-	if (memcg->id.id > 0)
-		idr_remove(&mem_cgroup_idr, memcg->id.id);
+	mem_cgroup_id_remove(memcg);
 	__mem_cgroup_free(memcg);
 	return NULL;
 }
@@ -4471,6 +4477,7 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *parent_css)
 
 	return &memcg->css;
 fail:
+	mem_cgroup_id_remove(memcg);
 	mem_cgroup_free(memcg);
 	return ERR_PTR(-ENOMEM);
 }

