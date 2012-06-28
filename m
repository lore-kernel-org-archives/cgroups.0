From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 6/7] memcg: add per cgroup writeback pages accounting
Date: Thu, 28 Jun 2012 19:06:02 +0800
Message-ID: <1340881562-5900-1-git-send-email-handai.szj@taobao.com>
References: <1340880885-5427-1-git-send-email-handai.szj@taobao.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        bh=AqLTcrK+il38/zOhsSI6zRdWzp3gZ5JohkMgZLhsz3k=;
        b=0fJUMRcl2pcby/DdQz/pGCVqcurbkcC7fkFE6AVeBby6TSZ+FQ/b7EEv1w48EZ10m8
         n4fe2k4rL1lXvULpOvITMNbJgcOY1w3A+CziGFaHPOl3ausqRFwZ4IfVHGtn5rT3ZNhj
         U4T9lEM803N4w7YPiRteHdLjsAgTxEhwPE/497ab8gNH7zBU+nJcRIl3MQqBzoNsmvaO
         XkenzDDF5L3DPH42Q1IIgyDBZrqJwDD5/8qJeqok4cc/vskP+zg0sYJRBsIu6z2zaBz1
         7Syz1FdhhX1YQ5ZGeooy4/VfmpD4cAw/46FtTgLiP2fDfbaZ1xBbdfyjHyRwCIsr1khY
         F0eA==
In-Reply-To: <1340880885-5427-1-git-send-email-handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

From: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

Similar to dirty page, we add per cgroup writeback pages accounting. The lock
rule still is:
	mem_cgroup_begin_update_page_stat()
	modify page WRITEBACK stat
	mem_cgroup_update_page_stat()
	mem_cgroup_end_update_page_stat()

There're two writeback interface to modify: test_clear/set_page_writeback.

Signed-off-by: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
---
 include/linux/memcontrol.h |    1 +
 mm/memcontrol.c            |    5 +++++
 mm/page-writeback.c        |   12 ++++++++++++
 3 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index ad37b59..9193d93 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -39,6 +39,7 @@ enum mem_cgroup_stat_index {
 	MEM_CGROUP_STAT_FILE_MAPPED,  /* # of pages charged as file rss */
 	MEM_CGROUP_STAT_SWAP, /* # of pages, swapped out */
 	MEM_CGROUP_STAT_FILE_DIRTY,  /* # of dirty pages in page cache */
+	MEM_CGROUP_STAT_FILE_WRITEBACK,  /* # of pages under writeback */
 	MEM_CGROUP_STAT_NSTATS,
 };
 
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 90e2946..8493119 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -83,6 +83,7 @@ static const char * const mem_cgroup_stat_names[] = {
 	"mapped_file",
 	"swap",
 	"dirty",
+	"writeback",
 };
 
 enum mem_cgroup_events_index {
@@ -2604,6 +2605,10 @@ static int mem_cgroup_move_account(struct page *page,
 		mem_cgroup_move_account_page_stat(from, to,
 				MEM_CGROUP_STAT_FILE_DIRTY);
 
+	if (PageWriteback(page))
+		mem_cgroup_move_account_page_stat(from, to,
+				MEM_CGROUP_STAT_FILE_WRITEBACK);
+
 	mem_cgroup_charge_statistics(from, anon, -nr_pages);
 
 	/* caller should have done css_get */
diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index e79a2f7..7398836 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1981,6 +1981,7 @@ EXPORT_SYMBOL(account_page_dirtied);
  */
 void account_page_writeback(struct page *page)
 {
+	mem_cgroup_inc_page_stat(page, MEM_CGROUP_STAT_FILE_WRITEBACK);
 	inc_zone_page_state(page, NR_WRITEBACK);
 }
 EXPORT_SYMBOL(account_page_writeback);
@@ -2214,7 +2215,10 @@ int test_clear_page_writeback(struct page *page)
 {
 	struct address_space *mapping = page_mapping(page);
 	int ret;
+	bool locked;
+	unsigned long flags;
 
+	mem_cgroup_begin_update_page_stat(page, &locked, &flags);
 	if (mapping) {
 		struct backing_dev_info *bdi = mapping->backing_dev_info;
 		unsigned long flags;
@@ -2235,9 +2239,12 @@ int test_clear_page_writeback(struct page *page)
 		ret = TestClearPageWriteback(page);
 	}
 	if (ret) {
+		mem_cgroup_dec_page_stat(page, MEM_CGROUP_STAT_FILE_WRITEBACK);
 		dec_zone_page_state(page, NR_WRITEBACK);
 		inc_zone_page_state(page, NR_WRITTEN);
 	}
+
+	mem_cgroup_end_update_page_stat(page, &locked, &flags);
 	return ret;
 }
 
@@ -2245,7 +2252,10 @@ int test_set_page_writeback(struct page *page)
 {
 	struct address_space *mapping = page_mapping(page);
 	int ret;
+	bool locked;
+	unsigned long flags;
 
+	mem_cgroup_begin_update_page_stat(page, &locked, &flags);
 	if (mapping) {
 		struct backing_dev_info *bdi = mapping->backing_dev_info;
 		unsigned long flags;
@@ -2272,6 +2282,8 @@ int test_set_page_writeback(struct page *page)
 	}
 	if (!ret)
 		account_page_writeback(page);
+
+	mem_cgroup_end_update_page_stat(page, &locked, &flags);
 	return ret;
 
 }
-- 
1.7.1
