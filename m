From: Sha Zhengju <handai.szj@gmail.com>
Subject: [PATCH V4 2/6] fs/ceph: vfs __set_page_dirty_nobuffers interface instead of doing it inside filesystem
Date: Sat,  6 Jul 2013 01:26:24 +0800
Message-ID: <1373045184-27568-1-git-send-email-handai.szj@taobao.com>
References: <1373044710-27371-1-git-send-email-handai.szj@taobao.com>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        bh=/E0wcUeNuMmcUhbz6tKwCrm7MPjE1nF8NS2c2fDM9V4=;
        b=y/uDKV+EBGhyVsU8SbDvQ3A7JGLgCsAKCKbPDTAKfF7X+45TboyObLn1dgtZ0zEsS/
         7SKmGOWnMokP9PQref9uWQaI/V3N8Cg3g8A7vHcUvju2EVhau8FTcIgsAGW0o4nbAi3F
         ARgjTX3gqXLSJgVrEMOz0mLGZgDM2ugT3xYngfRxfTXljEbpfxNfKAJ8fZkHe6ZsqyTN
         eGTpA2c1XVxBjcAYv08rjk3etICmvIGtzGjU652zrumPJ3YAjyiQAIG7fAgoO0+zZuLd
         0Y2ECD1lxlJWKAM1DEemsLbGSzAo2+f7h+hOBtnJ/tKE9GzaYpASgsMriXBM6XkDazIw
         pYXA==
In-Reply-To: <1373044710-27371-1-git-send-email-handai.szj@taobao.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org
Cc: sage@inktank.com, mhocko@suse.cz, gthelen@google.com, kamezawa.hiroyu@jp.fujitsu.com, akpm@linux-foundation.org, fengguang.wu@intel.com, mgorman@suse.de, Sha Zhengju <handai.szj@taobao.com>

From: Sha Zhengju <handai.szj@taobao.com>

Following we will begin to add memcg dirty page accounting around __set_page_dirty_
{buffers,nobuffers} in vfs layer, so we'd better use vfs interface to avoid exporting
those details to filesystems.

Signed-off-by: Sha Zhengju <handai.szj@taobao.com>
cc: Sage Weil <sage@inktank.com>
cc: Michal Hocko <mhocko@suse.cz>
cc: Greg Thelen <gthelen@google.com>
cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>
cc: Fengguang Wu <fengguang.wu@intel.com>
cc: Mel Gorman <mgorman@suse.de>

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
