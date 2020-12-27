From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/2] mm: memcg: fix memcg file_dirty numa stat
Date: Sun, 27 Dec 2020 10:13:09 -0800
Message-ID: <20201227181310.3235210-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=xnWBSJPhozInRwppdn26D5arQOhyJfW1ESk6fdr40LY=;
        b=Dq/IHpw1gtGkzq5FLK/NHtIAnUq2oqWzMLwgYRvTVAfZpIRHDmLWc65E2hDSOJ2FXh
         wPPxoEBceQFulXVt8Vkej4uoC8IFNalCxyyZG2Z7Qhz4gMg9MjB2j2vvyDmnCWSUv/KJ
         bvhWE+tL7sJQ5JFIxJARhcjnAvEhFXS2Xk64bHkw/yW1OYQ2B8QGUu12/bNGdjiUrSmr
         IcqmBZn6jf8NNp0HcFxJZ7bvCPQMK8Ib3OsxbmRmKujlxbO22gilrOILbjnF3HUgUkkk
         UR/SmyQjJIcLSdUqFIkHJ6pYPkCUBDjqJlYTB6h27QJEuz/rhV/E9KLlWMpI9cUSi+JC
         +Jtw==
Sender: "shakeelb via sendgmr" <shakeelb-rSQFlI6iZjOvss2yl3NHrPyj43VRqXoZVpNB7YpNyf8@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Naoya Horiguchi <n-horiguchi-PaJj6Psr51x8UrSeD/g0lQ@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "Kirill A . Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

The kernel updates the per-node NR_FILE_DIRTY stats on page migration
but not the memcg numa stats. That was not an issue until recently the
commit 5f9a4f4a7096 ("mm: memcontrol: add the missing numa_stat interface
for cgroup v2") exposed numa stats for the memcg. So fixing the
file_dirty per-memcg numa stat.

Fixes: 5f9a4f4a7096 ("mm: memcontrol: add the missing numa_stat interface for cgroup v2")
Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
---
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

