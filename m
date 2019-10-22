From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 1/2] mm: memcontrol: remove dead code from memory_max_write()
Date: Tue, 22 Oct 2019 16:15:17 -0400
Message-ID: <20191022201518.341216-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=/6k43Ins8ShDUccC1LdBvMXrfhZMN86K2kUQuaiv7Mo=;
        b=G6GQH0AR0jPSft2ppe6Krr/rZ5GlNjjcDjh8uq21Mch7IOkfMJPJ6y8CGYHqjeZnRv
         Z82dyGlkUmpnrQUBDNlEbomTWJFZjTonGAtP+KWs1/C1lYr5lpWixX5fS4x8g1/pnjaI
         l+2sZb8+h8PVY95WqVGA2Z3wHkTZ5GJmzwN6p8slt1PJfa3X9acHSQ9TwJh6O9hoz8yK
         QoDS9inHtGfOdYETaFcmImy68omaIjrSwXUv00ynL3dDOGxlMHQeZN4xH1DKUj15Seb/
         4B+CZLYcbnEkE5LYhr+FWPasz/NfM9n5wmSZzFIvbKNULO+4fsvtj9SnmUeuv1klLi0C
         eunw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

When the reclaim loop in memory_max_write() is ^C'd or similar, we set
err to -EINTR. But we don't return err. Once the limit is set, we
always return success (nbytes). Delete the dead code.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 055975b0b3a3..ff90d4e7df37 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6122,10 +6122,8 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
 		if (nr_pages <= max)
 			break;
 
-		if (signal_pending(current)) {
-			err = -EINTR;
+		if (signal_pending(current))
 			break;
-		}
 
 		if (!drained) {
 			drain_all_stock(memcg);
-- 
2.23.0

