From: Sha Zhengju <handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH V3 2/8] Make TestSetPageDirty and dirty page accounting in one func
Date: Wed, 26 Dec 2012 01:22:36 +0800
Message-ID: <1356456156-14535-1-git-send-email-handai.szj@taobao.com>
References: <1356455919-14445-1-git-send-email-handai.szj@taobao.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        bh=hKYysaZGr2QNhRsRl0lOjrr+w+5LWmu6YyWzm6+SKJA=;
        b=gzUT04k8Tw7jpeZ6EdhIL8DRGZx+XB2J4LWsUc69n8YWQAjBMlzXTL9nrNZXa4I5yV
         0bPjWZydE19ghX7H6Ui0NeilK7Y5GSk+ZawcGJMb0yUvNy2vLzc4geVxDwXkNm0h2xG6
         HEJR4d8kPIbmyADcxdy2JVh7UjGq3ygZkrETdNSBHlrXe+mfQ1qPZeVSw6X11jKsXHtB
         NdaNHTC7LRkFc6x6UPrb0RnmMBzd5fL/KyWYQsGBJHvvIIbhwrAGE7u3Oi/bVR2C8zZx
         CFd+ScUa2D1+40boxoCQMSSHpyZPXEiDwV9PkEUhX6B4dLIeMvEcKewQpnAN9ibgXxUy
         UsrA==
In-Reply-To: <1356455919-14445-1-git-send-email-handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dchinner-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, mhocko-AlSwsSmVLrQ@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org, Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

From: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>

Commit a8e7d49a(Fix race in create_empty_buffers() vs __set_page_dirty_buffers())
extracts TestSetPageDirty from __set_page_dirty and is far away from
account_page_dirtied. But it's better to make the two operations in one single
function to keep modular. So in order to avoid the potential race mentioned in
commit a8e7d49a, we can hold private_lock until __set_page_dirty completes.
There's no deadlock between ->private_lock and ->tree_lock after confirmation.
It's a prepare patch for following memcg dirty page accounting patches.


Here is some test numbers that before/after this patch:
Test steps(Mem-4g, ext4):
drop_cache; sync
fio (ioengine=sync/write/buffered/bs=4k/size=1g/numjobs=2/group_reporting/thread)

We test it for 10 times and get the average numbers:
Before:
write: io=2048.0MB, bw=254117KB/s, iops=63528.9 , runt=  8279msec
lat (usec): min=1 , max=742361 , avg=30.918, stdev=1601.02
After:
write: io=2048.0MB, bw=254044KB/s, iops=63510.3 , runt=  8274.4msec
lat (usec): min=1 , max=856333 , avg=31.043, stdev=1769.32

Note that the impact is little(<1%).


Signed-off-by: Sha Zhengju <handai.szj-3b8fjiQLQpfQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
---
 fs/buffer.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index c017a2d..3b032b9 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -609,9 +609,15 @@ EXPORT_SYMBOL(mark_buffer_dirty_inode);
  * If warn is true, then emit a warning if the page is not uptodate and has
  * not been truncated.
  */
-static void __set_page_dirty(struct page *page,
+static int __set_page_dirty(struct page *page,
 		struct address_space *mapping, int warn)
 {
+	if (unlikely(!mapping))
+		return !TestSetPageDirty(page);
+
+	if (TestSetPageDirty(page))
+		return 0;
+
 	spin_lock_irq(&mapping->tree_lock);
 	if (page->mapping) {	/* Race with truncate? */
 		WARN_ON_ONCE(warn && !PageUptodate(page));
@@ -621,6 +627,8 @@ static void __set_page_dirty(struct page *page,
 	}
 	spin_unlock_irq(&mapping->tree_lock);
 	__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
+
+	return 1;
 }
 
 /*
@@ -666,11 +674,9 @@ int __set_page_dirty_buffers(struct page *page)
 			bh = bh->b_this_page;
 		} while (bh != head);
 	}
-	newly_dirty = !TestSetPageDirty(page);
+	newly_dirty = __set_page_dirty(page, mapping, 1);
 	spin_unlock(&mapping->private_lock);
 
-	if (newly_dirty)
-		__set_page_dirty(page, mapping, 1);
 	return newly_dirty;
 }
 EXPORT_SYMBOL(__set_page_dirty_buffers);
@@ -1125,14 +1131,8 @@ void mark_buffer_dirty(struct buffer_head *bh)
 			return;
 	}
 
-	if (!test_set_buffer_dirty(bh)) {
-		struct page *page = bh->b_page;
-		if (!TestSetPageDirty(page)) {
-			struct address_space *mapping = page_mapping(page);
-			if (mapping)
-				__set_page_dirty(page, mapping, 0);
-		}
-	}
+	if (!test_set_buffer_dirty(bh))
+		__set_page_dirty(bh->b_page, page_mapping(bh->b_page), 0);
 }
 EXPORT_SYMBOL(mark_buffer_dirty);
 
-- 
1.7.9.5
