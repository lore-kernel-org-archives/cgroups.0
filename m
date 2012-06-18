From: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] mm/memcg: add unlikely to mercg->move_charge_at_immigrate
Date: Mon, 18 Jun 2012 21:10:21 +0800
Message-ID: <1340025022-7272-1-git-send-email-liwp.linux@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer;
        bh=cvh+5MBpYBHsPoqdJjQ41Bl8ey1g9wIyPbXLGHU+QgA=;
        b=xmMD8x5bL/pTJmhYFJjhrLTwsJhYUsmSOccG2YUt9jnxSLZcbX6Brm7vGvfTCUMRtQ
         R3YYdKEqiTOMZwMDSigb7Y0RtfOrUO9L3CzuEtNtE6KfbkTTtBmlsTkS1HMR9ELT6ZQX
         c/UelcWAZahgtPubMU22B3J6N5vpq2Emim37v9Wm2B0EpOCgiUMwF3gyvQFfMbJln0rk
         T62iQaGCsHJA9dE8Oqd6XnuJ4hQlGba7UAUom65y3tg+m1A1w4fpS5j2gbOED6cHp+Pw
         jbKRCSIVHZzREmDXdyJohGY1QyIBV/yszqlDRpxId0meRA6QKICfoHeND43xQPKaj191
         YPVQ==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Gavin Shan <shangw-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

From: Wanpeng Li <liwp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

move_charge_at_immigrate feature is disabled by default. Charges
are moved only when you move mm->owner and it also add additional
overhead.

Signed-off-by: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a9c3d01..795a00f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5316,7 +5316,7 @@ static int mem_cgroup_can_attach(struct cgroup *cgroup,
 	int ret = 0;
 	struct mem_cgroup *memcg = mem_cgroup_from_cont(cgroup);
 
-	if (memcg->move_charge_at_immigrate) {
+	if (unlikely(memcg->move_charge_at_immigrate)) {
 		struct mm_struct *mm;
 		struct mem_cgroup *from = mem_cgroup_from_task(p);
 
-- 
1.7.9.5
