From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v6 51/99] btrfs: Convert page cache to XArray
Date: Wed, 17 Jan 2018 12:21:15 -0800
Message-ID: <20180117202203.19756-52-willy@infradead.org>
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
 bh=rB/9t7LpOsmVd4X3ijI5CeNPcYs8VhDGc9cOiAuygfo=; b=E9Zg6qvbBqzYTKgAdsz9yGst8p
 zEY02Cwz23UwEsfA4tNDVDPaYscQQcjWbySqgXcV0HvVaodHGjmtXgwvosr10WA1nOPv0I/+UtW3r
 kBkOwtn/b7sj9VZqyxnqd2o7T3VqLF1CAOOu94DadR53GEDVRpxoNgYYuGFlHYwCUam4=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=rB/9t7LpOsmVd4X3ijI5CeNPcYs8VhDGc9cOiAuygfo=; b=cnmuJH+dK91BIR7Rm5NhzY8aH/
 dCrcFeuLGBPlAV3A1NFKAAkWr9rOlENqWWrYn1BMOmALuiGQFMPsZGHgGLIdWe0Q0ONOiI1P1QO0f
 U8E9dYeHWTUlcyUCYaHYDsST3Qo9vC5V2GvvbA5Qep+OjwQPqfiCOFJlu8ixUecHe1G0=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=rB/9t7LpOsmVd4X3ijI5CeNPcYs8VhDGc9cOiAuygfo=; b=nYdfM7Ngt8utei/uwOebucx00
 mhbfplibf5FCEEQNveX+9pj9rb3tZqGfl11edPp8MHACdYG6u5LSwAPP9wONt3k+bmcQRHPjUwM3U
 MeYQwlhbjfZYpAu+wcsUsC3H1h7Bb3XPi9tcbk5Qbw5FNVDfzU2/uyZlYraAs7rdlPgZYcZGk+SIR
 +YYA43sMz5p+S6lX/K3ynu0ej18LUTh9YNaIK1qvt5DKcvNT1WEKdEdolACKIpvmWhasKEdXcFUtt
 bCfqu4bjPofEs7Z1G21cMZp6oSvp7EqWS3Fp8hTnJo3yUAhbXf0FF6a7IW3KpcQNZYsFxeARmDqo5
 YghmPQU9g==;
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

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 fs/btrfs/compression.c | 4 +---
 fs/btrfs/extent_io.c   | 6 ++----
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index e687d06cd97c..4174b166e235 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -449,9 +449,7 @@ static noinline int add_ra_bio_pages(struct inode *inode,
 		if (pg_index > end_index)
 			break;
 
-		rcu_read_lock();
-		page = radix_tree_lookup(&mapping->pages, pg_index);
-		rcu_read_unlock();
+		page = xa_load(&mapping->pages, pg_index);
 		if (page && !xa_is_value(page)) {
 			misses++;
 			if (misses > 4)
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 4301cbf4e31f..fd5e9d887328 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -5197,11 +5197,9 @@ void clear_extent_buffer_dirty(struct extent_buffer *eb)
 
 		clear_page_dirty_for_io(page);
 		xa_lock_irq(&page->mapping->pages);
-		if (!PageDirty(page)) {
-			radix_tree_tag_clear(&page->mapping->pages,
-						page_index(page),
+		if (!PageDirty(page))
+			__xa_clear_tag(&page->mapping->pages, page_index(page),
 						PAGECACHE_TAG_DIRTY);
-		}
 		xa_unlock_irq(&page->mapping->pages);
 		ClearPageError(page);
 		unlock_page(page);
-- 
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
