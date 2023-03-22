From: Florian Schmidt <flosch-8cO4VLV/4DJBDgjK7y7TUQ@public.gmane.org>
Subject: [RFC] memcg v1: provide read access to memory.pressure_level
Date: Wed, 22 Mar 2023 14:25:25 +0000
Message-ID: <20230322142525.162469-1-flosch@nutanix.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com; h=from : to : cc :
 subject : date : message-id : content-transfer-encoding : content-type :
 mime-version; s=proofpoint20171006;
 bh=WIFKt/lwj22OXSfQjLXjeXNCFoPB1NUDKCJV0aNbMc0=;
 b=F3BjvSyFNQV3IsMSO4q+lTG90j9RhpO8pPEcKmBIC9ZfSJZ7QKPpsgn2azAOv5vgU95l
 ZylBp9X0kck0I+4N8n/DGot8k27qv6SJ7hFRoBpHIXV5rKgrxUJOdObcgMDMQ2dYMEmE
 I6nYheDT2nvNxyLNNWBhltZ420mWaOwQqC1V5iSn8lzmuGaIFE6JzLliUftAj30HIvpc
 D5E7H6JUzlQ4cZYBLTNJjh+rNcUlsKneH3fmOF3poSJgatA7GN1D9DhnwJQZV9byoh6+
 gIBUIbY34crtqsKGY9vQ/T701MAsrPcfSnOcfIAgGosXWUiMPzXvQ0mo9l2wx/BrkpUr dg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nutanix.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WIFKt/lwj22OXSfQjLXjeXNCFoPB1NUDKCJV0aNbMc0=;
 b=lzSO3/GY7oO9kV+QxwvigMmMN70C+fshsKjUY8rqDvezOR3a2S6Ud3hU68zxM4DrXUCxTZ2tJlyFBn8E0c5CU2qH90rDqOevYaYZwVHpYrKL/NOgcPYu397rLCe2VTrl47dJrHRWa/5TK18KD0MhbVrwu0A6cfLE13HrVWglZmjiYv5AtTGMaC65/M33k3Op3JQwQ5ThcXTMWPZwLx1LWCWxOh5pHlQDKth5Ducj+o7cS8qKTIKiUzx0Qj1i1uUmSOOnhWk2pbwmr1TkErUVOfgGpuyd3YBXrnCXIsXoRPKoU1UFis2ygSdeAjPMHTL119sPYMAfO27fjUAKMIl2WQ==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Florian Schmidt <flosch-8cO4VLV/4DJBDgjK7y7TUQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

cgroups v1 has a unique way of setting up memory pressure notifications:
the user opens "memory.pressure_level" of the cgroup they want to
monitor for pressure, then open "cgroup.event_control" and write the fd
(among other things) to that file. memory.pressure_level has no other
use, specifically it does not support any read or write operations.
Consequently, no handlers are provided, and the file ends up with
permissions 000. However, to actually use the mechanism, the subscribing
user must have read access to the file and open the fd for reading, see
memcg_write_event_control().

This is all fine as long as the subscribing process runs as root and is
otherwise unconfined by further restrictions. However, if you add strict
access controls such as selinux, the permission bits will be enforced,
and opening memory.pressure_level for reading will fail, preventing the
process from subscribing, even as root.

There are several ways around this issue, but adding a dummy read
handler seems like the least invasive to me. I'd be interested to hear:
(a) do you think there is a less invasive way? Alternatively, we could
    add a flag in cftype in include/linux/cgroup-defs.h, but that seems
    more invasive for what is a legacy interface.
(b) would you be interested to take this patch, or is it too niche a fix
    for a legacy subsystem?
---
 mm/memcontrol.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 5abffe6f8389..e48c749d9724 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3734,6 +3734,16 @@ static u64 mem_cgroup_read_u64(struct cgroup_subsys_state *css,
 	}
 }
 
+/*
+ * This function doesn't do anything useful. Its only job is to provide a read
+ * handler so that the file gets read permissions when it's created.
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

