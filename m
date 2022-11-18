From: "Aneesh Kumar K.V" <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
Subject: [PATCH] mm/cgroup/reclaim: Fix dirty pages throttling on cgroup v1
Date: Fri, 18 Nov 2022 12:36:03 +0530
Message-ID: <20221118070603.84081-1-aneesh.kumar@linux.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=from : to : cc : subject
 : date : message-id : mime-version : content-transfer-encoding; s=pp1;
 bh=N4KdvjMJHC5x6ymTMDf532HEFw4KhYB9MxBma68Whaw=;
 b=K5qeR2rkczKSqUDb9c6M3vsH+9E2EUIt61DQ32yuEHhRtOf/FNttWepddKFc17VfBdmV
 K9XtCesE74O3wcO/nb0vAfcDZDRce6d+vaesm0Mfk2hTEw0vjvSYIWUIgbwLgrj0Mpxr
 +chs28agSzM96IR44JniRCXZnPyfulB50j6dpQWn91VljgL/ganHvslFll6ommP/ZZSH
 tU4kUexLPZZISQF41cuk7VY4/NDCaPkjvoF5Xgt8/Qf/MsJd3Ac0nQC9d0utUZMYxL7B
 ADPPZukB0CUSnEk3JxH73vYslTLy+m74uT0YR8Et7Oskc7zpLnjp35t4v0fir8ky4keM xA== 
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Aneesh Kumar K.V" <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>, stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org

balance_dirty_pages doesn't do the required dirty throttling on cgroupv1. See
commit 9badce000e2c ("cgroup, writeback: don't enable cgroup writeback on
traditional hierarchies"). Instead, the kernel depends on writeback throttling
in shrink_folio_list to achieve the same goal. With large memory systems, the
flusher may not be able to writeback quickly enough such that we will start
finding pages in the shrink_folio_list already in writeback. Hence for cgroupv1
let's do a reclaim throttle after waking up the flusher.

The below test which used to fail on a 256GB system completes till the
the file system is full with this change.

root@lp2:/sys/fs/cgroup/memory# mkdir test
root@lp2:/sys/fs/cgroup/memory# cd test/
root@lp2:/sys/fs/cgroup/memory/test# echo 120M > memory.limit_in_bytes
root@lp2:/sys/fs/cgroup/memory/test# echo $$ > tasks
root@lp2:/sys/fs/cgroup/memory/test# dd if=/dev/zero of=/home/kvaneesh/test bs=1M
Killed

Cc: <stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Suggested-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
---
 mm/vmscan.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 04d8b88e5216..388022c5ef2b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -2514,8 +2514,20 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 	 * the flushers simply cannot keep up with the allocation
 	 * rate. Nudge the flusher threads in case they are asleep.
 	 */
-	if (stat.nr_unqueued_dirty == nr_taken)
+	if (stat.nr_unqueued_dirty == nr_taken) {
 		wakeup_flusher_threads(WB_REASON_VMSCAN);
+		/*
+		 * For cgroupv1 dirty throttling is achieved by waking up
+		 * the kernel flusher here and later waiting on folios
+		 * which are in writeback to finish (see shrink_folio_list()).
+		 *
+		 * Flusher may not be able to issue writeback quickly
+		 * enough for cgroupv1 writeback throttling to work
+		 * on a large system.
+		 */
+		if (!writeback_throttling_sane(sc))
+			reclaim_throttle(pgdat, VMSCAN_THROTTLE_WRITEBACK);
+	}
 
 	sc->nr.dirty += stat.nr_dirty;
 	sc->nr.congested += stat.nr_congested;
-- 
2.38.1

