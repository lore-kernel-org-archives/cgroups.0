From: Florian Schmidt <flosch-8cO4VLV/4DJBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] memcg v1: provide read access to memory.pressure_level
Date: Tue,  4 Apr 2023 10:58:59 +0000
Message-ID: <20230404105900.2005-1-flosch@nutanix.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=proofpoint20171006;
 bh=nDcbGdE1LonX/7dDygW9Mav/W816HIVPNJEmJMGQL7M=;
 b=vNVmkqbhJzf2LKGR317lmJvtEKUp+K4CjmGfe6KT/RIXMg20nLbvGvD94LCcYf3muvlC
 rMcqE2osxBDBbhZQDtCmwafP6f8A437C0KURMFtbsXnBiDkzoJFT78KZCwRv6X9/2u5t
 rc8a0f8QDKx2mo/Xicxtnc0NncW/CDE+t2qchEqVlSM4hdvxIaldymWRDLEdTK5MDBWt
 2ARWcrOliqkSL/8jbbsw3Q0kXmOp+pt70zuCRXRMExc2UTXLrFvRMu8JwUalpclrLv+A
 RGaqCmn56D8XB0Ys+wyEAV8y3p4dqf1OmWz8e5dJgbhac5VjpQ+HzUFdbf79D+zK+Gnp +g== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nDcbGdE1LonX/7dDygW9Mav/W816HIVPNJEmJMGQL7M=;
 b=PP5Gg+KAFYWECxY1yS99iuel4K2PvvqTELJmZSnoDuLZJBbAQSr0cB50E/SIUIsZ613a0RJoGMxZB9qHhP88BediWefrST+iarssrgWNfRKBFJ1yRWrQpQVl2RGNQdZeGIJkkO8n8IzFAwA2ImqFgdvsYHdBo+RCZtt9cb1oFFcn+swcyRPFZrxuDDxBSVDGlRFuC783/Q+1VKq0olQTF0Cq2g7lAcmiku9eiqDnNnL0xYAtnIjoAYATQ7PHNLNmRt+OT4NYqDC1tQsCX3d868tsaR7PVZFxYK5ZsWJNf2cN/KmHu3GLCxMcenwZWqxyfNhU+BhpVDWMKpu2EVvAKA==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Florian Schmidt <flosch-8cO4VLV/4DJBDgjK7y7TUQ@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

cgroups v1 has a unique way of setting up memory pressure notifications:
the user opens "memory.pressure_level" of the cgroup they want to
monitor for pressure, then open "cgroup.event_control" and write the fd
(among other things) to that file. memory.pressure_level has no other
use, specifically it does not support any read or write operations.
Consequently, no handlers are provided, and cgroup_file_mode() sets the
permissions to 000. However, to actually use the mechanism, the
subscribing user must have read access to the file and open the fd for
reading, see memcg_write_event_control().

This is all fine as long as the subscribing process runs as root and is
otherwise unconfined by further restrictions. However, if you add strict
access controls such as selinux, the permission bits will be enforced,
and opening memory.pressure_level for reading will fail, preventing the
process from subscribing, even as root.

To work around this issue, introduce a dummy read handler. When
memory.pressure_level is created, cgroup_file_mode() will notice the
existence of a handler, and therefore add read permissions to the file.

Signed-off-by: Florian Schmidt <flosch-8cO4VLV/4DJBDgjK7y7TUQ@public.gmane.org>
Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
---
 mm/memcontrol.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 5abffe6f8389..1aa11e261570 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3734,6 +3734,16 @@ static u64 mem_cgroup_read_u64(struct cgroup_subsys_state *css,
 	}
 }
 
+/*
+ * This function doesn't do anything useful. Its only job is to provide a read
+ * handler for a file so that cgroup_file_mode() will add read permissions.
+ */
+static int mem_cgroup_dummy_seq_show(__always_unused struct seq_file *m,
+				     __always_unused void *v)
+{
+	return -EINVAL;
+}
+
 #ifdef CONFIG_MEMCG_KMEM
 static int memcg_online_kmem(struct mem_cgroup *memcg)
 {
@@ -5064,6 +5074,7 @@ static struct cftype mem_cgroup_legacy_files[] = {
 	},
 	{
 		.name = "pressure_level",
+		.seq_show = mem_cgroup_dummy_seq_show,
 	},
 #ifdef CONFIG_NUMA
 	{
-- 
2.32.0

