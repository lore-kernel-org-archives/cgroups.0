From: Shakeel Butt <shakeelb@google.com>
Subject: [PATCH v2 1/3] mm: memcg: fix memcg file_dirty numa stat
Date: Fri,  8 Jan 2021 07:58:11 -0800
Message-ID: <20210108155813.2914586-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=TmS2aUSU9Nc+jbusxkpkx6bWx9vKLPLSx0ah1Mh9yyI=;
        b=MqO7QoO5t1t19B+AEl6h5z4tw+zU7KM6GwbNk/Mp1PFVGy9rfrtGYSbX/d9+eAzZhn
         85nVIeuPCcrIsHLF6pmDeiMskOl5gL8hrRpWLw2fiRK1XfHVrtlIhB3jtVuaOAuYAkX9
         y6PXWQyxwiovuUX4CqBWFUXWa2W+xhkln/xfwF05D6fSP6Ciqky7dTJuFFfn+UdmRkds
         KWeq7o1ESWlHIt80X8LW5vaHOnrLQeNZ4AhBLpgI54SeMWH/RtWLb2vuIH8DG7ux9OWT
         VZV7UjrCJGnJuc7mg18IjSCC1lMGzxZnMGNHFI+bg4cgIzRnzex0r+3is36+V51S9R/d
         SeWQ==
Sender: "shakeelb via sendgmr" <shakeelb@shakeelb.svl.corp.google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>, Yang Shi <shy828301@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Shakeel Butt <shakeelb@google.com>, Muchun Song <songmuchun@bytedance.com>, stable@vger.kernel.org

The kernel updates the per-node NR_FILE_DIRTY stats on page migration
but not the memcg numa stats. That was not an issue until recently the
commit 5f9a4f4a7096 ("mm: memcontrol: add the missing numa_stat interface
for cgroup v2") exposed numa stats for the memcg. So fixing the
file_dirty per-memcg numa stat.

Fixes: 5f9a4f4a7096 ("mm: memcontrol: add the missing numa_stat interface for cgroup v2")
Signed-off-by: Shakeel Butt <shakeelb@google.com>
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Yang Shi <shy828301@gmail.com>
Reviewed-by: Roman Gushchin <guro@fb.com>
Cc: <stable@vger.kernel.org>
---
Changes since v1:
- none

 mm/migrate.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index ee5e612b4cd8..613794f6a433 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -500,9 +500,9 @@ int migrate_page_move_mapping(struct address_space *mapping,
 			__inc_lruvec_state(new_lruvec, NR_SHMEM);
 		}
 		if (dirty && mapping_can_writeback(mapping)) {
-			__dec_node_state(oldzone->zone_pgdat, NR_FILE_DIRTY);
+			__dec_lruvec_state(old_lruvec, NR_FILE_DIRTY);
 			__dec_zone_state(oldzone, NR_ZONE_WRITE_PENDING);
-			__inc_node_state(newzone->zone_pgdat, NR_FILE_DIRTY);
+			__inc_lruvec_state(new_lruvec, NR_FILE_DIRTY);
 			__inc_zone_state(newzone, NR_ZONE_WRITE_PENDING);
 		}
 	}
-- 
2.29.2.729.g45daf8777d-goog

