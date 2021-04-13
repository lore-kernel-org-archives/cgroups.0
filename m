From: Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>
Subject: [PATCH 2/2] cgroup2: cpuset: Always allow setting empty cpuset
Date: Tue, 13 Apr 2021 11:02:35 +0200
Message-ID: <20210413090235.1903026-3-odin@uged.al>
References: <20210413090235.1903026-1-odin@uged.al>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=uged.al; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=SY4sqotEknC2i6pL+rlRoKqg/a1bJa4Vth62OIkfAoQ=;
        b=uxWTujCWfNBeN/O4X+ntEhKXR936PgNw8iSl4QEH+vCqE24dWezDXJ5p7WmD0nifNV
         13RPIgq8FCe5WiqzrGG9mYC+LTWfv854+V1guX2HA8czTlmwab74maIxGVos9YgK4qpp
         x6NKH75ghp5ZDs2sadWAAR67QY73AS+aI80VF8xuQyio4XnAG/0R44OutaPx04sJttVd
         Vu58VEnVDbO06/xTZsRk6fKVx2pZ7ZoQ/NjQct93M59xTtIK3naz7iG0+kuCVuIbv6nn
         2l4dGWfbawnrcCHrKNIYRNTAMVc+CoyD3I27q7JqsED7dvLrA8hKdCdmdARfnDR1WS/e
         kfeg==
In-Reply-To: <20210413090235.1903026-1-odin-RObV4cXtwVA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>

Due to how cpuset works in v2, there is no need to disallow setting an
empty cpuset when tasks are attached. In v2, the effective cpuset of a
cgroup is the intersection between the effective value of the parent and
the cpuset.cpus value of the cgroup, with a fallback to the effective
parent value in case the intersection is an empty set.

Allowing this will make it easier to move the cpuset of a nested cgroup
hierarchy where multiple cgroup use the cpuset.cpus, since the current
solution is to manually update the cpuset of each cgroup when doing this,
causing it be quite complex to change. It also makes it possible to
disable cpuset for a populated cgroup (or one of its ancestors), without
having to manually write the effective value into cpuset.cpus.

This also applies in a similar manner on cpuset.mems.

Signed-off-by: Odin Ugedal <odin-RObV4cXtwVA@public.gmane.org>
---
 kernel/cgroup/cpuset.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index f543c4c6084a..33a55d461ec3 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -609,11 +609,12 @@ static int validate_change(struct cpuset *cur, struct cpuset *trial)
 	}
 
 	/*
-	 * Cpusets with tasks - existing or newly being attached - can't
-	 * be changed to have empty cpus_allowed or mems_allowed.
+	 * On legacy hierarchy, cpusets with tasks - existing or newly being
+	 * attached - can't be changed to have empty cpus_allowed or
+	 * mems_allowed.
 	 */
 	ret = -ENOSPC;
-	if ((cgroup_is_populated(cur->css.cgroup) || cur->attach_in_progress)) {
+	if (!is_in_v2_mode() && (cgroup_is_populated(cur->css.cgroup) || cur->attach_in_progress)) {
 		if (!cpumask_empty(cur->cpus_allowed) &&
 		    cpumask_empty(trial->cpus_allowed))
 			goto out;
-- 
2.31.0

