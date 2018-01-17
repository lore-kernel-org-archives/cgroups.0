From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v6 92/99] f2fs: Convert pids radix tree to XArray
Date: Wed, 17 Jan 2018 12:21:56 -0800
Message-ID: <20180117202203.19756-93-willy@infradead.org>
References: <20180117202203.19756-1-willy@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=sourceforge.net; s=x; h=References:In-Reply-To:Message-Id:Date:Subject:Cc:
 To:From:Sender:Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:
 Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
 Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
 List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=nDbSNQtY3I32d6R0AQMGtIlXjATZUM/TBTgCd5AKpiA=; b=jTtqPwaNfV1cWMgQ1Q6WgdaYrp
 +lH1z4aIyH7PrtFBBRjs07ViZJJ6kxTPlPqRv47Pbumn5uXfNqNa+8geMm5WMhkEeteuWpJwt/X4P
 huX9dH0EX37I19rx9ZsmEmcXnCTKOhbhrU2zSp6gaVaE42tN7hVA4gYC5GPTkv8NY5zU=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=nDbSNQtY3I32d6R0AQMGtIlXjATZUM/TBTgCd5AKpiA=; b=SzKbkaPtpnwkgJqh6yWWNEUfWT
 OeqpsaaLNOgZgAZknTGHwyXtSOU4oNQX51Jct3sLKKXLTVLf0l7RjHhRjB0bmr5bY7Fmd0zKorf+q
 V8nE5NC3O7xbmrgCHDitOVXlmqHCjXd7Zoji86uvOIAeUN8sJB8I9J0jXLkwlSePqf2s=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=nDbSNQtY3I32d6R0AQMGtIlXjATZUM/TBTgCd5AKpiA=; b=MN4v26tzHiZB6R+Hk3zmusuUY
 +pu9Srd/sL/BJ9P7ObG+bnphV3pKEOIN5kdRFQlqAMn6h8C4nraM0Y9PCd84Co2v/5IERdFERb+S3
 a7dgBBcUZleKdvb3DgUQIePAyqtpKqAiz2S1jgRnnWJJbJXlNc1z/9p3paUVBPJQs4bDnTFTOjBpD
 hN4nQ+zEPxMchcDMWHSobhw92MeC9ynbdhCLVaAE3PRRMQ5N02pdpG5be+cCnAq4sKrZcOKCh3hUZ
 Gxde4v9fSJE3ufVQErRwh1nKfNHo5TkBV0OqpqArJ7/eQLnPaJMGAkxeyarYWWZ37kQUD0YSBIiZk
 zRa7DnlrA==;
In-Reply-To: <20180117202203.19756-1-willy@infradead.org>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>, 
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-kernel@vger.kernel.org
Cc: linux-s390@vger.kernel.org, David Howells <dhowells@redhat.com>, linux-nilfs@vger.kernel.org, Matthew Wilcox <mawilcox@microsoft.com>, linux-sh@vger.kernel.org, intel-gfx@lists.freedesktop.org, linux-usb@vger.kernel.org, linux-remoteproc@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org, linux-mm@kvack.org, iommu@lists.linux-foundation.org, Stefano Stabellini <sstabellini@kernel.org>, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, Bjorn Andersson <bjorn.andersson@linaro.org>, linux-btrfs@vger.kernel.org

From: Matthew Wilcox <mawilcox@microsoft.com>

The XArray API works out rather well for this user.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 fs/f2fs/super.c |  2 --
 fs/f2fs/trace.c | 60 ++++-----------------------------------------------------
 fs/f2fs/trace.h |  2 --
 3 files changed, 4 insertions(+), 60 deletions(-)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index 708155d9c2e4..d608edffe69e 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -2831,8 +2831,6 @@ static int __init init_f2fs_fs(void)
 {
 	int err;
 
-	f2fs_build_trace_ios();
-
 	err = init_inodecache();
 	if (err)
 		goto fail;
diff --git a/fs/f2fs/trace.c b/fs/f2fs/trace.c
index bccbbf2616d2..f316a42c547f 100644
--- a/fs/f2fs/trace.c
+++ b/fs/f2fs/trace.c
@@ -16,8 +16,7 @@
 #include "f2fs.h"
 #include "trace.h"
 
-static RADIX_TREE(pids, GFP_ATOMIC);
-static spinlock_t pids_lock;
+static DEFINE_XARRAY(pids);
 static struct last_io_info last_io;
 
 static inline void __print_last_io(void)
@@ -57,28 +56,13 @@ void f2fs_trace_pid(struct page *page)
 {
 	struct inode *inode = page->mapping->host;
 	pid_t pid = task_pid_nr(current);
-	void *p;
 
 	set_page_private(page, (unsigned long)pid);
 
-	if (radix_tree_preload(GFP_NOFS))
-		return;
-
-	spin_lock(&pids_lock);
-	p = radix_tree_lookup(&pids, pid);
-	if (p == current)
-		goto out;
-	if (p)
-		radix_tree_delete(&pids, pid);
-
-	f2fs_radix_tree_insert(&pids, pid, current);
-
-	trace_printk("%3x:%3x %4x %-16s\n",
+	if (xa_store(&pids, pid, current, GFP_NOFS) != current)
+		trace_printk("%3x:%3x %4x %-16s\n",
 			MAJOR(inode->i_sb->s_dev), MINOR(inode->i_sb->s_dev),
 			pid, current->comm);
-out:
-	spin_unlock(&pids_lock);
-	radix_tree_preload_end();
 }
 
 void f2fs_trace_ios(struct f2fs_io_info *fio, int flush)
@@ -120,43 +104,7 @@ void f2fs_trace_ios(struct f2fs_io_info *fio, int flush)
 	return;
 }
 
-void f2fs_build_trace_ios(void)
-{
-	spin_lock_init(&pids_lock);
-}
-
-#define PIDVEC_SIZE	128
-static unsigned int gang_lookup_pids(pid_t *results, unsigned long first_index,
-							unsigned int max_items)
-{
-	struct radix_tree_iter iter;
-	void **slot;
-	unsigned int ret = 0;
-
-	if (unlikely(!max_items))
-		return 0;
-
-	radix_tree_for_each_slot(slot, &pids, &iter, first_index) {
-		results[ret] = iter.index;
-		if (++ret == max_items)
-			break;
-	}
-	return ret;
-}
-
 void f2fs_destroy_trace_ios(void)
 {
-	pid_t pid[PIDVEC_SIZE];
-	pid_t next_pid = 0;
-	unsigned int found;
-
-	spin_lock(&pids_lock);
-	while ((found = gang_lookup_pids(pid, next_pid, PIDVEC_SIZE))) {
-		unsigned idx;
-
-		next_pid = pid[found - 1] + 1;
-		for (idx = 0; idx < found; idx++)
-			radix_tree_delete(&pids, pid[idx]);
-	}
-	spin_unlock(&pids_lock);
+	xa_destroy(&pids);
 }
diff --git a/fs/f2fs/trace.h b/fs/f2fs/trace.h
index 67db24ac1e85..157e4564e48b 100644
--- a/fs/f2fs/trace.h
+++ b/fs/f2fs/trace.h
@@ -34,12 +34,10 @@ struct last_io_info {
 
 extern void f2fs_trace_pid(struct page *);
 extern void f2fs_trace_ios(struct f2fs_io_info *, int);
-extern void f2fs_build_trace_ios(void);
 extern void f2fs_destroy_trace_ios(void);
 #else
 #define f2fs_trace_pid(p)
 #define f2fs_trace_ios(i, n)
-#define f2fs_build_trace_ios()
 #define f2fs_destroy_trace_ios()
 
 #endif
-- 
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
