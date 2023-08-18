From: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: [PATCH 3/4] mm: Fix clean_record_shared_mapping_range kernel-doc
Date: Fri, 18 Aug 2023 21:06:29 +0100
Message-ID: <20230818200630.2719595-4-willy@infradead.org>
References: <20230818200630.2719595-1-willy@infradead.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=vsBXmbIBGjgL8OAsP8lhIU5HpuKdHOAcVbKVff35yq0=; b=rkSXXrRqZSDngZsXaXS1lbcvKi
        QcxZl8fRtvl2u5og3DaZCgWwOd8wNJiUmPuNozZFhK4Rp2yqmIrBH6RtwP++DppbgOZSGlhwnIezt
        e1vasqNE2W4aZU+QTDwKwQiw25UEVta9LR0f40lR26wYW8zzUOaRhROTU2QP+RCM811qjbWcygzK2
        7Vuyv70yxpieq2E6NKpJanmkNqbcKLdBa6fsqSwE7FViFyinr4zEmkSFCp68hihuKk5XIqq9+GNHL
        fGl5oRgErGTMT2HUat8VgevjzrG6L30Rgiwy1OXl6ZCChibpTt3+MbcOEm7yqywAdIuemdd9xrcze
        90jN3SXw==;
In-Reply-To: <20230818200630.2719595-1-willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Mike Rapoport <rppt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Turn the a), b) into an unordered ReST list and remove the unnecessary
'Note:' prefix.

Signed-off-by: Matthew Wilcox (Oracle) <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
---
 mm/mapping_dirty_helpers.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/mm/mapping_dirty_helpers.c b/mm/mapping_dirty_helpers.c
index a26dd8bcfcdb..2f8829b3541a 100644
--- a/mm/mapping_dirty_helpers.c
+++ b/mm/mapping_dirty_helpers.c
@@ -288,13 +288,14 @@ EXPORT_SYMBOL_GPL(wp_shared_mapping_range);
  * @end: Pointer to the number of the last set bit in @bitmap.
  * none set. The value is modified as new bits are set by the function.
  *
- * Note: When this function returns there is no guarantee that a CPU has
+ * When this function returns there is no guarantee that a CPU has
  * not already dirtied new ptes. However it will not clean any ptes not
  * reported in the bitmap. The guarantees are as follows:
- * a) All ptes dirty when the function starts executing will end up recorded
- *    in the bitmap.
- * b) All ptes dirtied after that will either remain dirty, be recorded in the
- *    bitmap or both.
+ *
+ * * All ptes dirty when the function starts executing will end up recorded
+ *   in the bitmap.
+ * * All ptes dirtied after that will either remain dirty, be recorded in the
+ *   bitmap or both.
  *
  * If a caller needs to make sure all dirty ptes are picked up and none
  * additional are added, it first needs to write-protect the address-space
-- 
2.40.1

