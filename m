From: Chingbin Li <liqb365-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] cgroup: align each value to its column name in /proc/cgroups
 file
Date: Sun, 23 Apr 2023 21:42:15 +0800
Message-ID: <TYCP286MB233532036CE9F1D67ECAB422E9669@TYCP286MB2335.JPNP286.PROD.OUTLOOK.COM>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hotmail.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dIBSi2pbn/GRsxaRiGPiV2kaV11LquoEHWqjt1iHLeQ=;
 b=KJ+gjWmdBo+1rb8raBF74OKTBvVq54chIy+o3AAaSZm4cZQNp/8XKN6hw8HFlVzdZ9g+L3NSc1GQtk1CijIjTvHuGDJUjzXuL0hhUVlR1/OoxvWN/GKOjrJwKlrpqGYT6c1gEKHeY+aj17nmQ99cLrvrW3/CC22I0Ymy/uvshA56Y+l0le8thNR8srtoEiCxvQXvoRTZBQCyigJrmH3ydBnUkln0uskAqUitxFFmbxSnOrIG2p+b/oyPDXKx+o4bpHpPmbcpNlR20eldWfLOptTVJlveJDWB5sQc1fi0RRh+k+D2VqIL6ZjPa0v5/o2yki0STevkWEOCrCTBdBKbUg==
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Currently, the /proc/cgroups infomation looks messy:

/ # cat /proc/cgroups
#subsys_name	hierarchy	num_cgroups	enabled
cpuset	0	1	1
cpu	0	1	1
cpuacct	0	1	1
blkio	0	1	1
memory	0	1	1
devices	0	1	1
freezer	0	1	1
perf_event	0	1	1
hugetlb	0	1	1
pids	0	1	1

This tiny modification makes the information looks better:

/ # cat /proc/cgroups
#subsys_name	 hierarchy	num_cgroups	enabled
      cpuset	         0	          1	      1
         cpu	         0	          1	      1
     cpuacct	         0	          1	      1
       blkio	         0	          1	      1
      memory	         0	          1	      1
     devices	         0	          1	      1
     freezer	         0	          1	      1
  perf_event	         0	          1	      1
     hugetlb	         0	          1	      1
        pids	         0	          1	      1

Changes:

   Summary for each column:

   Column name   | Column name length        Max value length      |	  Max
   --------------------------------------------------------------------------------
  #subsys_name	 |      12		      10 (perf_event)      |	   12
     hierarchy	 |       9		      10 (INT_MAX) 	   |	   10
   num_cgroups	 |      11		      10 (INT_MAX) 	   |	   11
       enabled 	 |       7		       1 (bool value)      |	    7
   --------------------------------------------------------------------------------
   Unit: Character

   We use the max length values as the length for each column.

   Besides, insert a white space to 'seq_puts' statement:

   seq_puts(m, "subsys_name\t hierarchy\tnum_cgroups\tenabled\n");
			     ^

   The purpose is to make the 'hierarchy' column name has the same length as it's possible
   max value.

Signed-off-by: Chingbin Li <liqb365-PkbjNfxxIARBDgjK7y7TUQ@public.gmane.org>
---
 kernel/cgroup/cgroup-v1.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 52bb5a74a23b..dbce2e950aa0 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -670,14 +670,14 @@ int proc_cgroupstats_show(struct seq_file *m, void *v)
 	struct cgroup_subsys *ss;
 	int i;

-	seq_puts(m, "#subsys_name\thierarchy\tnum_cgroups\tenabled\n");
+	seq_puts(m, "#subsys_name\t hierarchy\tnum_cgroups\tenabled\n");
 	/*
 	 * Grab the subsystems state racily. No need to add avenue to
 	 * cgroup_mutex contention.
 	 */

 	for_each_subsys(ss, i)
-		seq_printf(m, "%s\t%d\t%d\t%d\n",
+		seq_printf(m, "%12s\t%10d\t%11d\t%7d\n",
 			   ss->legacy_name, ss->root->hierarchy_id,
 			   atomic_read(&ss->root->nr_cgrps),
 			   cgroup_ssid_enabled(i));
