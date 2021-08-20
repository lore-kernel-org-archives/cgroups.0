From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 1/2] mm: unexport folio_memcg_{,un}lock
Date: Fri, 20 Aug 2021 11:58:14 +0200
Message-ID: <20210820095815.445392-2-hch@lst.de>
References: <20210820095815.445392-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=OeK3I+1l0xomijoHvRqsdYXTySAGsZIzhVjcZsSq7U0=; b=Zr3DitrUpEOFcENF3OtghGRMLi
        kSUsgxxHghHOEjCYGgRPXlA0lGc838SHvugAnpoCt9BGKLn8a9GKOb3w5SEniekSW4MniHzDudrMq
        FOM0PxBd4/+2W7NQdVAEQb38Z5mJThI9xEIn/j6EdEKjhfh3G+/Vga5+wjgTWtn0qdbVOUJx+TVE/
        9c0JEFuHSbGtKTzjmYvP2YD2j3Emx3fJA849JqG1QmIQIzDxKAcoNWFcNYt17VJrIOODWOBe9vfDb
        7M61rDO+x9gTFoWQhuRgIse2pGdxFHyW9VNIkOBCHZWXDZDW7/FTeSKhAJQrTjRkWNwYqt7ew8BP4
        Bqpg/Mbw==;
In-Reply-To: <20210820095815.445392-1-hch-jcswGhMUV9g@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

These are only used in built-in core mm code.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 mm/memcontrol.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 45a160894a035..4cb4349065931 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2014,7 +2014,6 @@ void folio_memcg_lock(struct folio *folio)
 	memcg->move_lock_task = current;
 	memcg->move_lock_flags = flags;
 }
-EXPORT_SYMBOL(folio_memcg_lock);
 
 void lock_page_memcg(struct page *page)
 {
@@ -2048,7 +2047,6 @@ void folio_memcg_unlock(struct folio *folio)
 {
 	__folio_memcg_unlock(folio_memcg(folio));
 }
-EXPORT_SYMBOL(folio_memcg_unlock);
 
 void unlock_page_memcg(struct page *page)
 {
-- 
2.30.2

