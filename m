From: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/2] cgroup/rstat: check updated_next only for root
Date: Sat, 25 Dec 2021 00:09:32 +0000
Message-ID: <20211225000932.7253-2-richard.weiyang@gmail.com>
References: <20211225000932.7253-1-richard.weiyang@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=//AViHdrOkDwbr9ESPP9D2TYL4WUSf1TSQKhaGcWJOs=;
        b=Ja/D3/ZnRALj1OtqXz6jKBTHUXDL+cBRBD9mdyU4YWX2JcI6BasWZ3eqUvwrqzV9CN
         ktlduhuv0yuX3x3rBjlMrChHQQuv2a4lbAY1IXzKLhpNm2vvVkfBCvC/4waVtB27CH2M
         +d1EPxi4bDJ6Wj2EQzEMazj4SBJI/kreutAor2Fw5+4yIpv4E6v+exUKj6fQN4dbWtZK
         lJOByPTXrHCxK/33YWF4U+2MeHRvREY+dG9f51N07WvpwImbSRamgY/R5NvdMwwM7KH4
         7OP6RCD7VraAEmc20FmYNAE9CkbGc2CGUdZuu5XcOhF+a9ED2YqS92oMJZlQ4SdLcdaq
         o19Q==
In-Reply-To: <20211225000932.7253-1-richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

After commit dc26532aed0a ("cgroup: rstat: punt root-level optimization to
individual controllers"), each rstat on updated_children list has its
->updated_next not NULL.

This means we can remove the check on ->updated_next, if we make sure
the subtree from @root is on list, which could be done by checking
updated_next for root.

Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 kernel/cgroup/rstat.c | 46 +++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 24 deletions(-)

diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index a9d344e0521d..a00875375f7d 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -88,6 +88,7 @@ static struct cgroup *cgroup_rstat_cpu_pop_updated(struct cgroup *pos,
 						   struct cgroup *root, int cpu)
 {
 	struct cgroup_rstat_cpu *rstatc;
+	struct cgroup *parent;
 
 	if (pos == root)
 		return NULL;
@@ -96,9 +97,12 @@ static struct cgroup *cgroup_rstat_cpu_pop_updated(struct cgroup *pos,
 	 * We're gonna walk down to the first leaf and visit/remove it.  We
 	 * can pick whatever unvisited node as the starting point.
 	 */
-	if (!pos)
+	if (!pos) {
 		pos = root;
-	else
+		// return NULL if this subtree is not on-list
+		if (!cgroup_rstat_cpu(pos, cpu)->updated_next)
+			return NULL;
+	} else
 		pos = cgroup_parent(pos);
 
 	/* walk down to the first leaf */
@@ -115,31 +119,25 @@ static struct cgroup *cgroup_rstat_cpu_pop_updated(struct cgroup *pos,
 	 * However, due to the way we traverse, @pos will be the first
 	 * child in most cases. The only exception is @root.
 	 */
-	if (rstatc->updated_next) {
-		struct cgroup *parent = cgroup_parent(pos);
-
-		if (parent) {
-			struct cgroup_rstat_cpu *prstatc;
-			struct cgroup **nextp;
-
-			prstatc = cgroup_rstat_cpu(parent, cpu);
-			nextp = &prstatc->updated_children;
-			while (*nextp != pos) {
-				struct cgroup_rstat_cpu *nrstatc;
-
-				nrstatc = cgroup_rstat_cpu(*nextp, cpu);
-				WARN_ON_ONCE(*nextp == parent);
-				nextp = &nrstatc->updated_next;
-			}
-			*nextp = rstatc->updated_next;
-		}
+	parent = cgroup_parent(pos);
+	if (parent) {
+		struct cgroup_rstat_cpu *prstatc;
+		struct cgroup **nextp;
 
-		rstatc->updated_next = NULL;
-		return pos;
+		prstatc = cgroup_rstat_cpu(parent, cpu);
+		nextp = &prstatc->updated_children;
+		while (*nextp != pos) {
+			struct cgroup_rstat_cpu *nrstatc;
+
+			nrstatc = cgroup_rstat_cpu(*nextp, cpu);
+			WARN_ON_ONCE(*nextp == parent);
+			nextp = &nrstatc->updated_next;
+		}
+		*nextp = rstatc->updated_next;
 	}
 
-	/* only happens for @root */
-	return NULL;
+	rstatc->updated_next = NULL;
+	return pos;
 }
 
 /* see cgroup_rstat_flush() */
-- 
2.33.1

