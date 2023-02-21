From: Matthew Chae <matthew.chae-VrBV9hrLPhE@public.gmane.org>
Subject: [PATCH] mm/memcontrol: add memory.peak in cgroup root
Date: Tue, 21 Feb 2023 15:34:20 +0100
Message-ID: <20230221143421.10385-1-matthew.chae@axis.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; q=dns/txt; s=axis-central1; t=1676990067;
  x=1708526067;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=e0/vm795K+DdiwKlFn5UN5He4cprPggTB4iadCKSttU=;
  b=c2aVEOSHIXeNdSzupVDL/Xc8tvIdiY1iEPB3wD22nysxQuqzPzWvAFkk
   EtUY/zqyaVQcV85IbbrRn0YaUIfhGxuSdMBgHbjkz0vg8A4oKfeTF5uVe
   iU1wbH4cRw0Xsk7biuXS0+p9yndMzFK0KAXqfstNh1Mgk0WIi/FCwsxL8
   p6IyDUbqdIUAPpUa5dlcScQtobaf8nirsBro/83t4tGcZAX9B4tbbLJ0z
   sApuKgesbLzq3pBghWxuahjG9JYBYY+2JNcSlfspPU2GzBbBhRmUTKnaC
   1d1/Ozk/DziluuEgMpM+PtdZiC46C1xpBm4HANq0t+sca0F+xs71ADfCh
   w==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: kernel-VrBV9hrLPhE@public.gmane.org, christopher.wong-VrBV9hrLPhE@public.gmane.org, Matthew Chae <matthew.chae-VrBV9hrLPhE@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

The kernel currently doesn't provide any method to show the overall
system's peak memory usage recorded. Instead, only each slice's peak
memory usage recorded except for cgroup root is shown through each
memory.peak.

Each slice might consume their peak memory at different time. This is
stored at memory.peak in each own slice. The sum of every memory.peak
doesn't mean the total system's peak memory usage recorded. The sum at
certain point without having a peak memory usage in their slice can have
the largest value.

       time |  slice1  |  slice2  |   sum
      =======================================
        t1  |    50    |   200    |   250
      ---------------------------------------
        t2  |   150    |   150    |   300
      ---------------------------------------
        t3  |   180    |    20    |   200
      ---------------------------------------
        t4  |    80    |    20    |   100

memory.peak value of slice1 is 180 and memory.peak value of slice2 is 200.
Only these information are provided through memory.peak value from each
slice without providing the overall system's peak memory usage. The total
sum of these two value is 380, but this doesn't represent the real peak
memory usage of the overall system. The peak value what we want to get is
shown in t2 as 300, which doesn't have any biggest number even in one
slice. Therefore the proper way to show the system's overall peak memory
usage recorded needs to be provided.

Hence, expose memory.peak in the cgrop root in order to allow this.

Co-developed-by: Christopher Wong <christopher.wong-VrBV9hrLPhE@public.gmane.org>
Signed-off-by: Christopher Wong <christopher.wong-VrBV9hrLPhE@public.gmane.org>
Signed-off-by: Matthew Chae <matthew.chae-VrBV9hrLPhE@public.gmane.org>
---
 mm/memcontrol.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 73afff8062f9..974fc044a7e7 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6646,7 +6646,6 @@ static struct cftype memory_files[] = {
 	},
 	{
 		.name = "peak",
-		.flags = CFTYPE_NOT_ON_ROOT,
 		.read_u64 = memory_peak_read,
 	},
 	{
-- 
2.20.1

