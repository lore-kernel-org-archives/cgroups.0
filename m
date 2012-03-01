From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH -V2 7/9] memcg: track resource index in cftype private
Date: Thu,  1 Mar 2012 14:46:18 +0530
Message-ID: <1330593380-1361-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1330593380-1361-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1330593380-1361-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm@kvack.org, mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com, dhillf@gmail.com, aarcange@redhat.com, mhocko@suse.cz, akpm@linux-foundation.org, hannes@cmpxchg.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>

This helps in using same memcg callbacks for non reclaim resource
control files.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 mm/memcontrol.c |   27 +++++++++++++++++++++------
 1 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index b00d028..25bc5f7 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -365,9 +365,14 @@ enum charge_type {
 #define _MEM			(0)
 #define _MEMSWAP		(1)
 #define _OOM_TYPE		(2)
-#define MEMFILE_PRIVATE(x, val)	(((x) << 16) | (val))
-#define MEMFILE_TYPE(val)	(((val) >> 16) & 0xffff)
-#define MEMFILE_ATTR(val)	((val) & 0xffff)
+#define _MEMNORCL		(3)
+
+/*  0 ... val ...16.... x...24...idx...32*/
+#define __MEMFILE_PRIVATE(idx, x, val)	(((idx) << 24) | ((x) << 16) | (val))
+#define MEMFILE_PRIVATE(x, val)		__MEMFILE_PRIVATE(0, x, val)
+#define MEMFILE_TYPE(val)		(((val) >> 16) & 0xff)
+#define MEMFILE_IDX(val)		(((val) >> 24) & 0xff)
+#define MEMFILE_ATTR(val)		((val) & 0xffff)
 /* Used for OOM nofiier */
 #define OOM_CONTROL		(0)
 
@@ -3834,7 +3839,7 @@ static u64 mem_cgroup_read(struct cgroup *cont, struct cftype *cft)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cont);
 	u64 val;
-	int type, name;
+	int type, name, idx;
 
 	type = MEMFILE_TYPE(cft->private);
 	name = MEMFILE_ATTR(cft->private);
@@ -3851,6 +3856,10 @@ static u64 mem_cgroup_read(struct cgroup *cont, struct cftype *cft)
 		else
 			val = res_counter_read_u64(&memcg->memsw, name);
 		break;
+	case _MEMNORCL:
+		idx = MEMFILE_IDX(cft->private);
+		val = res_counter_read_u64(&memcg->no_rcl_res[idx], name);
+		break;
 	default:
 		BUG();
 		break;
@@ -3883,7 +3892,10 @@ static int mem_cgroup_write(struct cgroup *cont, struct cftype *cft,
 			break;
 		if (type == _MEM)
 			ret = mem_cgroup_resize_limit(memcg, val);
-		else
+		else if (type == _MEMNORCL) {
+			int idx = MEMFILE_IDX(cft->private);
+			ret = res_counter_set_limit(&memcg->no_rcl_res[idx], val);
+		} else
 			ret = mem_cgroup_resize_memsw_limit(memcg, val);
 		break;
 	case RES_SOFT_LIMIT:
@@ -3947,7 +3959,10 @@ static int mem_cgroup_reset(struct cgroup *cont, unsigned int event)
 	case RES_MAX_USAGE:
 		if (type == _MEM)
 			res_counter_reset_max(&memcg->res);
-		else
+		else if (type == _MEMNORCL) {
+			int idx = MEMFILE_IDX(event);
+			res_counter_reset_max(&memcg->no_rcl_res[idx]);
+		} else
 			res_counter_reset_max(&memcg->memsw);
 		break;
 	case RES_FAILCNT:
-- 
1.7.9

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
