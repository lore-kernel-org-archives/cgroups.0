From: Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] cgroup: cleanup the format of /proc/cgroups
Date: Sun, 21 Aug 2022 15:34:46 +0800
Message-ID: <20220821073446.92669-1-feng.tang@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661067254; x=1692603254;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=O6fFd+1PtGhiYQl5WIAchCwfjiLwvujhPK8p2OjYqOA=;
  b=JcBA/w0JJFA9GNjqoSoSSPhfuwEOuK+3rv+/R3SK62TD2Q2b222EBSKx
   I27sBSgL0jExB/TdosDM5ZytELE//XMOozdTs9ni6/keqyh7JBywojTCq
   amPsa1c5MBHdZBjcehb3kV0DsSogzHkCrbUaC5DfnuwP6n5qtwePTVrK0
   3AGA3GJMdhqbt2VuKzUSBLxx2LVQLFtJ2Yb696MH+zIiMh5TE6uLhrII7
   +qdZWResLRxVUkZh5x5IxLifOLbJ7Yt6ZbN9Xng2tBLGO3o+lmQbBvRU/
   iYxqnLUEx1yjlv90XiY0Jgg1bD9DMWVQ1JMZCUbR4aEOFUm57dc63ecib
   A==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Currrent /proc/cgroup output is like:

  #subsys_name	hierarchy	num_cgroups	enabled
  cpuset	6	1	1
  cpu	4	7	1
  cpuacct	4	7	1
  blkio	8	7	1
  memory	9	7	1
  ...

Add some indentation to make it more readable without any functional
change:

  #subsys_name         hierarchy        num_cgroups      enabled
  cpuset               8                1                1
  cpu                  4                7                1
  cpuacct              4                7                1
  blkio                2                7                1
  memory               5                7                1
  ...

Signed-off-by: Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 kernel/cgroup/cgroup-v1.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 2ade21b54dc4..e370ce3afdad 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -670,14 +670,20 @@ int proc_cgroupstats_show(struct seq_file *m, void *v)
 	struct cgroup_subsys *ss;
 	int i;
 
-	seq_puts(m, "#subsys_name\thierarchy\tnum_cgroups\tenabled\n");
+	seq_printf(m, "%-20s %-16s %-16s %-16s\n",
+			"#subsys_name",
+			"hierarchy",
+			"num_cgroups",
+			"enabled"
+			);
+
 	/*
 	 * Grab the subsystems state racily. No need to add avenue to
 	 * cgroup_mutex contention.
 	 */
 
 	for_each_subsys(ss, i)
-		seq_printf(m, "%s\t%d\t%d\t%d\n",
+		seq_printf(m, "%-20s %-16d %-16d %-16d\n",
 			   ss->legacy_name, ss->root->hierarchy_id,
 			   atomic_read(&ss->root->nr_cgrps),
 			   cgroup_ssid_enabled(i));
-- 
2.27.0

