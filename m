From: Qian Cai <cai@lca.pw>
Subject: [PATCH -next] mm/vmscan: fix an undefined behavior for zone id
Date: Fri,  8 Nov 2019 15:44:07 -0500
Message-ID: <20191108204407.1435-1-cai@lca.pw>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+x5g1UVg7HX2xGAQ0OJa7E0znsv6MEg8H6qRGEA46KQ=;
        b=rKeQu1ZisiH1z4nG/Spx3Hk5NI7OH7ghWVVE4sJnGjupBFTUb0/cXDmc9WqVGLNgsG
         9xiS6GWqUeOvlke3Xd8+2imV2vlrx4dxiG5s7/4la0ZDYNCrhcC084LahTpo0+lwN85G
         K5U6U0mLGthyDy/l6qk4yji+GJEmXY4OaFD527GpqiJy/F83NKDgRM6+NiD9xiaeOa2S
         JOTXb6/dyb+AcZipK9q1SMW/PGTQ+KV0XtGZB9Nfs/u/0wSc+Sl7Bg1VfBkVE16Qtp7O
         saY+Ml0JLyAYbZiW/eX2UOIVkAcpv2AQ0O+WSAzhRvqUjpyNVq9oJR6OUGdkXzeWlk7w
         eYeQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: akpm@linux-foundation.org
Cc: mhocko@suse.com, hannes@cmpxchg.org, guro@fb.com, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Qian Cai <cai@lca.pw>

The -next commit "mm: vmscan: simplify lruvec_lru_size()" [1] introduced
an undefined behavior as zone_idx could equal to MAX_NR_ZONES, and then
zid is then out of range.

[ 5399.483257] LTP: starting mtest01w (mtest01 -p80 -w)
[ 5400.245051] ================================================================================
[ 5400.255784] UBSAN: Undefined behaviour in ./include/linux/memcontrol.h:536:26
[ 5400.265235] index 5 is out of range for type 'long unsigned int [5][5]'
[ 5400.273925] CPU: 28 PID: 455 Comm: kswapd7 Tainted: G        W         5.4.0-rc6-next-20191108 #3
[ 5400.285461] Hardware name: HPE ProLiant DL385 Gen10/ProLiant DL385 Gen10, BIOS A40 07/10/2019
[ 5400.295784] Call Trace:
[ 5400.299483]  dump_stack+0x7a/0xaa
[ 5400.304052]  ubsan_epilogue+0x9/0x26
[ 5400.309180]  __ubsan_handle_out_of_bounds.cold.13+0x2b/0x36
[ 5400.316192]  inactive_list_is_low+0x8bb/0x9f0
[ 5400.321952]  balance_pgdat+0x252/0x7d0
[ 5400.327006]  kswapd+0x251/0x590
[ 5400.331725]  ? finish_wait+0x90/0x90
[ 5400.336574]  kthread+0x12a/0x140
[ 5400.341102]  ? balance_pgdat+0x7d0/0x7d0
[ 5400.346330]  ? kthread_create_worker_on_cpu+0x70/0x70
[ 5400.352810]  ret_from_fork+0x27/0x50

[1] https://lore.kernel.org/linux-mm/20191022144803.302233-2-hannes@cmpxchg.org/

Signed-off-by: Qian Cai <cai@lca.pw>
---
 mm/vmscan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index d97985262dda..9485b80d6b5b 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -317,7 +317,7 @@ unsigned long lruvec_lru_size(struct lruvec *lruvec, enum lru_list lru, int zone
 	unsigned long size = 0;
 	int zid;
 
-	for (zid = 0; zid <= zone_idx; zid++) {
+	for (zid = 0; zid < zone_idx; zid++) {
 		struct zone *zone = &lruvec_pgdat(lruvec)->node_zones[zid];
 
 		if (!managed_zone(zone))
-- 
2.21.0 (Apple Git-122.2)

