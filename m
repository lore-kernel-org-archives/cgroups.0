From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.0 133/262] cgroup, rstat: Don't flush subtree root unless necessary
Date: Wed, 27 Mar 2019 13:59:48 -0400
Message-ID: <20190327180158.10245-133-sashal@kernel.org>
References: <20190327180158.10245-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1553709959;
        bh=pylpkBLNcCZBLgMSDbploWxJ69hWPZeS0H5eeVswZy0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T+Mejj2lrNbtgd5j/iaQ/kU1D54sTpO+YpP53CSU/0Ep+sQLRxbWU/TOhcHbdegSv
         H8HbQlNHJFLktHktOYMzHZfQqDJiUwQsnFPfRgWZhVGML8bf1s8jj60KcgDJpjM8Fh
         6GVuZbIWXtxbNsqd6ZgCz6TYGSSsIgbRFNTO5TiM=
In-Reply-To: <20190327180158.10245-1-sashal@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>, cgroups@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

[ Upstream commit b4ff1b44bcd384d22fcbac6ebaf9cc0d33debe50 ]

cgroup_rstat_cpu_pop_updated() is used to traverse the updated cgroups
on flush.  While it was only visiting updated ones in the subtree, it
was visiting @root unconditionally.  We can easily check whether @root
is updated or not by looking at its ->updated_next just as with the
cgroups in the subtree.

* Remove the unnecessary cgroup_parent() test.  The system root cgroup
  is never updated and thus its ->updated_next is always NULL.  No
  need to test whether cgroup_parent() exists in addition to
  ->updated_next.

* Terminate traverse if ->updated_next is NULL.  This can only happen
  for subtree @root and there's no reason to visit it if it's not
  marked updated.

This reduces cpu consumption when reading a lot of rstat backed files.
In a micro benchmark reading stat from ~1600 cgroups, the sys time was
lowered by >40%.

Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/rstat.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index d503d1a9007c..bb95a35e8c2d 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -87,7 +87,6 @@ static struct cgroup *cgroup_rstat_cpu_pop_updated(struct cgroup *pos,
 						   struct cgroup *root, int cpu)
 {
 	struct cgroup_rstat_cpu *rstatc;
-	struct cgroup *parent;
 
 	if (pos == root)
 		return NULL;
@@ -115,8 +114,8 @@ static struct cgroup *cgroup_rstat_cpu_pop_updated(struct cgroup *pos,
 	 * However, due to the way we traverse, @pos will be the first
 	 * child in most cases. The only exception is @root.
 	 */
-	parent = cgroup_parent(pos);
-	if (parent && rstatc->updated_next) {
+	if (rstatc->updated_next) {
+		struct cgroup *parent = cgroup_parent(pos);
 		struct cgroup_rstat_cpu *prstatc = cgroup_rstat_cpu(parent, cpu);
 		struct cgroup_rstat_cpu *nrstatc;
 		struct cgroup **nextp;
@@ -140,9 +139,12 @@ static struct cgroup *cgroup_rstat_cpu_pop_updated(struct cgroup *pos,
 		 * updated stat.
 		 */
 		smp_mb();
+
+		return pos;
 	}
 
-	return pos;
+	/* only happens for @root */
+	return NULL;
 }
 
 /* see cgroup_rstat_flush() */
-- 
2.19.1

