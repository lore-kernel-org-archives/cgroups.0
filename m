From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [PATCH 1/2] mm: migrate: consolidate mem_cgroup_migrate() calls
Date: Thu,  4 Feb 2016 15:07:46 -0500
Message-ID: <1454616467-8994-1-git-send-email-hannes@cmpxchg.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Mateusz Guzik <mguzik-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sergey Senozhatsky <sergey.senozhatsky.work-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Rather than scattering mem_cgroup_migrate() calls all over the place,
have a single call from a safe place where every migration operation
eventually ends up in - migrate_page_copy().

Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Suggested-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 mm/migrate.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index 17db63b2dd36..90cbf7c65cac 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -331,8 +331,6 @@ int migrate_page_move_mapping(struct address_space *mapping,
 		if (PageSwapBacked(page))
 			SetPageSwapBacked(newpage);
 
-		mem_cgroup_migrate(page, newpage);
-
 		return MIGRATEPAGE_SUCCESS;
 	}
 
@@ -428,8 +426,6 @@ int migrate_page_move_mapping(struct address_space *mapping,
 	}
 	local_irq_enable();
 
-	mem_cgroup_migrate(page, newpage);
-
 	return MIGRATEPAGE_SUCCESS;
 }
 
@@ -471,8 +467,6 @@ int migrate_huge_page_move_mapping(struct address_space *mapping,
 
 	spin_unlock_irq(&mapping->tree_lock);
 
-	mem_cgroup_migrate(page, newpage);
-
 	return MIGRATEPAGE_SUCCESS;
 }
 
@@ -586,6 +580,8 @@ void migrate_page_copy(struct page *newpage, struct page *page)
 		end_page_writeback(newpage);
 
 	copy_page_owner(page, newpage);
+
+	mem_cgroup_migrate(page, newpage);
 }
 
 /************************************************************
@@ -1846,7 +1842,6 @@ fail_putback:
 	}
 
 	mlock_migrate_page(new_page, page);
-	mem_cgroup_migrate(page, new_page);
 	page_remove_rmap(page, true);
 	set_page_owner_migrate_reason(new_page, MR_NUMA_MISPLACED);
 
-- 
2.7.0
