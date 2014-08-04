From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [patch 3/4] mm: memcontrol: add memory.max to default hierarchy
Date: Mon,  4 Aug 2014 17:14:56 -0400
Message-ID: <1407186897-21048-4-git-send-email-hannes@cmpxchg.org>
References: <1407186897-21048-1-git-send-email-hannes@cmpxchg.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org; s=zene;
	h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From; bh=mVK94gmYPFknyQgg3J1pGPuQrEkK9pTvly2e17FNsgE=;
	b=POgM416Z86Bf4yR7KVEmZWw3uq1cZ9DUTyU+gLETW1JGih62ql4c0rru+aJ/8EIopAtK/AUo70mkO+kZpNZi+vwqi7zgvC5Om9J26R/OVyPRMhlZaOUFkMGvuM0vIYrvmMNVhb4SugqMSbH3ky+Ym09zag8Xxunvq4MDezeTPyA=;
In-Reply-To: <1407186897-21048-1-git-send-email-hannes@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, Tejun Heo <tj@kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

There are cases where a strict upper limit on a memcg is required, for
example, when containers are rented out and interference between them
can not be tolerated.

Provide memory.max, a limit that can not be breached and will trigger
group-internal OOM killing once page reclaim can no longer enforce it.

This can be combined with the high limit, to create a window in which
allocating tasks are throttled to approach the strict maximum limit
gracefully and with opportunity for the user or admin to intervene.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 Documentation/cgroups/unified-hierarchy.txt |  4 ++++
 mm/memcontrol.c                             | 35 +++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

diff --git a/Documentation/cgroups/unified-hierarchy.txt b/Documentation/cgroups/unified-hierarchy.txt
index fd4f7f6847f6..6c52c926810f 100644
--- a/Documentation/cgroups/unified-hierarchy.txt
+++ b/Documentation/cgroups/unified-hierarchy.txt
@@ -334,6 +334,10 @@ supported and the interface files "release_agent" and
 - memory.usage_in_bytes is renamed to memory.current to be in line
   with the new naming scheme
 
+- memory.max provides a hard upper limit as a last-resort backup to
+  memory.high for situations with aggressive isolation requirements.
+
+
 5. Planned Changes
 
 5-1. CAP for resource control
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 5a64fa96c08a..461834c86b94 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6306,6 +6306,36 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
 	return nbytes;
 }
 
+static u64 memory_max_read(struct cgroup_subsys_state *css,
+			   struct cftype *cft)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
+
+	return res_counter_read_u64(&memcg->res, RES_LIMIT);
+}
+
+static ssize_t memory_max_write(struct kernfs_open_file *of,
+				char *buf, size_t nbytes, loff_t off)
+{
+	struct mem_cgroup *memcg = mem_cgroup_from_css(of_css(of));
+	u64 max;
+	int ret;
+
+	if (mem_cgroup_is_root(memcg))
+		return -EINVAL;
+
+	buf = strim(buf);
+	ret = res_counter_memparse_write_strategy(buf, &max);
+	if (ret)
+		return ret;
+
+	ret = mem_cgroup_resize_limit(memcg, max);
+	if (ret)
+		return ret;
+
+	return nbytes;
+}
+
 static struct cftype memory_files[] = {
 	{
 		.name = "current",
@@ -6316,6 +6346,11 @@ static struct cftype memory_files[] = {
 		.read_u64 = memory_high_read,
 		.write = memory_high_write,
 	},
+	{
+		.name = "max",
+		.read_u64 = memory_max_read,
+		.write = memory_max_write,
+	},
 };
 
 struct cgroup_subsys memory_cgrp_subsys = {
-- 
2.0.3

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
