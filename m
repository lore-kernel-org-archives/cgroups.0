From: Ivan Teterevkov <ivan.teterevkov@nutanix.com>
Subject: [RFC] memcg: fix default behaviour of non-overridden memcg.swappiness
Date: Thu, 19 Mar 2020 17:38:30 +0000
Message-ID: <BL0PR02MB560170CD4D4245D4B89BC22EE9F40@BL0PR02MB5601.namprd02.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : cc : subject
 : date : message-id : content-type : content-transfer-encoding :
 mime-version; s=proofpoint20171006;
 bh=95/m89MwlSGPpZAOIrtExHR4t9kE7xbWEJqvlYC0Qho=;
 b=rv/e7p3y0sBAg/PYaEpFZ6sWIIOfIl9urt4AmZS+74xb+kq58VFJLCAhdGGGVG8vgoOb
 /YAZR3vd0ChPvIdMboVKBQt8TwKv2llCvMZ8cMXhgtX0e5PMjhmZV5IqZtmMlDftDxdm
 tcDu0BIXt++sKDoqLxoqOCdzJD96MEPXCK0J3qqL+TAOnNXSpM503/ltvnitfyLZXzNa
 gvz4v9tcgH4OgYIw2EydJOr//WqgwqFUctp9xj/nUE5ddwLGPgEfb5udaeFr8yXC1oux
 D/boKrofDl/kP79so6EBGqb1FPjFFhX+yvS5S7rLprj1iiFEJbLEPvIl2NaLMZcs4Nj7 eg== 
Content-Language: en-US
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: 
Cc: "rientjes@google.com" <rientjes@google.com>, "willy@infradead.org" <willy@infradead.org>, "vbabka@suse.cz" <vbabka@suse.cz>, "tj@kernel.org" <tj@kernel.org>, "lizefan@huawei.com" <lizefan@huawei.com>, "hannes@cmpxchg.org" <hannes@cmpxchg.org>, "corbet@lwn.net" <corbet@lwn.net>, "mhocko@kernel.org" <mhocko@kernel.org>, "vdavydov.dev@gmail.com" <vdavydov.dev@gmail.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "guro@fb.com" <guro@fb.com>, "shakeelb@google.com" <shakeelb@google.com>, "chris@chrisdown.name" <chris@chrisdown.name>, "yang.shi@linux.alibaba.com" <yang.shi@linux.alibaba.com>, Ivan Teterevkov <ivan.teterevkov@nutanix.com>, "tglx@linutronix.de" <tglx@linutronix.de>, "minchan@kernel.org" <minchan@kernel.org>, "ying.huang@intel.com" <yin>

This patch tries to resolve uncertainty around the memcg.swappiness when
it's not overridden by the user: shall there be the latest vm_swappiness
or the value captured at the moment when the cgroup was created?

I'm sitting on the fence with regards to this patch because cgroup v1 is
considered legacy nowadays and the semantics of "swappiness" is already
overwhelmed. However, the patch might be considered as a "fix" because
looking at the documentation [1] one might have the impression that it's
the latest /proc/sys/vm/swappiness value that should be found in the
memcg.swappiness unless it's overridden or inherited from a cgroup where
it was overridden when the given cgroup was created.

Also, shall this magic -1 be exposed to the user? I think it's a "no",
but what if the user wants to un-override the memcg.swappiness...

What do you reckon?

[1] https://www.kernel.org/doc/html/latest/admin-guide/cgroup-v1/memory.htm=
l#swappiness

-------------------------------- %< --------------------------------

This patch makes the memcg with the non-overridden swappiness
use the latest value found in /proc/sys/vm/swappiness instead
of one captured at the time when the memcg was created.

Signed-off-by: Ivan Teterevkov <ivan.teterevkov@nutanix.com>
---
 Documentation/admin-guide/cgroup-v1/memory.rst |  7 +++++--
 include/linux/memcontrol.h                     | 15 +++++++++++++++
 include/linux/swap.h                           |  4 ++++
 mm/memcontrol.c                                |  4 +++-
 4 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v1/memory.rst b/Documentation=
/admin-guide/cgroup-v1/memory.rst
index 0ae4f564c2d6..ccb4046c0aa3 100644
--- a/Documentation/admin-guide/cgroup-v1/memory.rst
+++ b/Documentation/admin-guide/cgroup-v1/memory.rst
@@ -610,8 +610,11 @@ Note:
 5.3 swappiness
 --------------
=20
-Overrides /proc/sys/vm/swappiness for the particular group. The tunable
-in the root cgroup corresponds to the global swappiness setting.
+Overrides /proc/sys/vm/swappiness for the particular cgroup. The overridde=
n
+memory.swappiness in the non-root cgroup is inherited by new child cgroups=
.
+The tunable in the root cgroup corresponds to the global swappiness settin=
g;
+changes made there are also applied to the non-overridden memory.swappines=
s
+of the non-root cgroups.
=20
 Please note that unlike during the global reclaim, limit reclaim
 enforces that 0 swappiness really prevents from any swapping even if
diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index a7a0a1a5c8d5..b5d69648be88 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -240,7 +240,22 @@ struct mem_cgroup {
 	bool		oom_lock;
 	int		under_oom;
=20
+	/*
+	 * Overrides the global vm_swappiness, unless there's a special case:
+	 *
+	 * - The swappiness in the root cgroup always corresponds to the global
+	 *   vm_swappiness and the value below is ignored.
+	 *
+	 * - The default value -1 means the cgroup uses the global
+	 *   vm_swappiness.
+	 *
+	 * - The value 0 prevents any swapping in the cgroup.
+	 *
+	 * Otherwise, any integer from 1 to 100 overrides the vm_swappiness
+	 * and is inherited by new child cgroups.
+	 */
 	int	swappiness;
+
 	/* OOM-Killer disable */
 	int		oom_kill_disable;
=20
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 1e99f7ac1d7e..d4c65ebcae61 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -636,6 +636,10 @@ static inline int mem_cgroup_swappiness(struct mem_cgr=
oup *memcg)
 	if (mem_cgroup_disabled() || mem_cgroup_is_root(memcg))
 		return vm_swappiness;
=20
+	/* Not overridden? */
+	if (memcg->swappiness =3D=3D -1)
+		return vm_swappiness;
+
 	return memcg->swappiness;
 }
 #else
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 2058b8da18db..a95a7df46442 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4980,8 +4980,10 @@ mem_cgroup_css_alloc(struct cgroup_subsys_state *par=
ent_css)
 	memcg->high =3D PAGE_COUNTER_MAX;
 	memcg->soft_limit =3D PAGE_COUNTER_MAX;
 	if (parent) {
-		memcg->swappiness =3D mem_cgroup_swappiness(parent);
+		memcg->swappiness =3D parent->swappiness;
 		memcg->oom_kill_disable =3D parent->oom_kill_disable;
+	} else {
+		memcg->swappiness =3D -1;
 	}
 	if (parent && parent->use_hierarchy) {
 		memcg->use_hierarchy =3D true;
--=20
2.25.0

