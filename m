From: Sha Zhengju <handai.szj@gmail.com>
Subject: [PATCH V5 2/8] fs/ceph: vfs __set_page_dirty_nobuffers interface instead of doing it inside filesystem
Date: Thu,  1 Aug 2013 19:51:32 +0800
Message-ID: <1375357892-10188-1-git-send-email-handai.szj@taobao.com>
References: <1375357402-9811-1-git-send-email-handai.szj@taobao.com>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        bh=EmNsr2BDIFuRxAv6ZuizEGJcG8jsn4T5uopZ46pI9cg=;
        b=eo2JpTo+1No6Ufk3x8cptntoNnNdImbPpXzulo2/Qj380V4iqOJtfCbhhR/FHeYZUG
         X1xzDuzkSYA/7wYNEU461WyxxyhjpEt84Wshcd+qH5n0NVPi3GnwFjYwHGy9nddkn/o/
         6zw7jiDCp2P45sQu6EdykowJSuzCewMcyAcVEkMATQJSAxZ5ADwDyNBtrHSyY6t+9fqK
         rHW99O/lOspyHNHszUf271V8+6UYkTqu87qNoN0sTkBvO84QsF0xvf0pPg/q3Bo663+0
         1q5BAgKCxk5Mj7+hju5kJfdRoJoPKzCas0ynq2qNziLThfHtI0u8iZLHaz8JqEjhjjN9
         hjMw==
In-Reply-To: <1375357402-9811-1-git-send-email-handai.szj@taobao.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org
Cc: sage@inktank.com, mhocko@suse.cz, kamezawa.hiroyu@jp.fujitsu.com, glommer@gmail.com, gthelen@google.com, fengguang.wu@intel.com, akpm@linux-foundation.org, Sha Zhengju <handai.szj@taobao.com>

From: Sha Zhengju <handai.szj@taobao.com>

Following we will begin to add memcg dirty page accounting around __set_page_dirty_
{buffers,nobuffers} in vfs layer, so we'd better use vfs interface to avoid exporting
those details to filesystems.

Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
---
 fs/ceph/addr.c |   13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 3e68ac1..1445bf1 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -76,7 +76,7 @@ static int ceph_set_page_dirty(struct page *page)
 	if (unlikely(!mapping))
 		return !TestSetPageDirty(page);
 
-	if (TestSetPageDirty(page)) {
+	if (!__set_page_dirty_nobuffers(page)) {
 		dout("%p set_page_dirty %p idx %lu -- already dirty\n",
 		     mapping->host, page, page->index);
 		return 0;
@@ -107,14 +107,7 @@ static int ceph_set_page_dirty(struct page *page)
 	     snapc, snapc->seq, snapc->num_snaps);
 	spin_unlock(&ci->i_ceph_lock);
 
-	/* now adjust page */
-	spin_lock_irq(&mapping->tree_lock);
 	if (page->mapping) {	/* Race with truncate? */
-		WARN_ON_ONCE(!PageUptodate(page));
-		account_page_dirtied(page, page->mapping);
-		radix_tree_tag_set(&mapping->page_tree,
-				page_index(page), PAGECACHE_TAG_DIRTY);
-
 		/*
 		 * Reference snap context in page->private.  Also set
 		 * PagePrivate so that we get invalidatepage callback.
@@ -126,14 +119,10 @@ static int ceph_set_page_dirty(struct page *page)
 		undo = 1;
 	}
 
-	spin_unlock_irq(&mapping->tree_lock);
-
 	if (undo)
 		/* whoops, we failed to dirty the page */
 		ceph_put_wrbuffer_cap_refs(ci, 1, snapc);
 
-	__mark_inode_dirty(mapping->host, I_DIRTY_PAGES);
-
 	BUG_ON(!PageDirty(page));
 	return 1;
 }
-- 
1.7.9.5

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
