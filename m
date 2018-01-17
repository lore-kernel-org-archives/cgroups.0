From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v6 39/99] mm: Convert khugepaged_scan_shmem to
 XArray
Date: Wed, 17 Jan 2018 12:21:03 -0800
Message-ID: <20180117202203.19756-40-willy@infradead.org>
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
 bh=PaT37owr/YpSqtBMVCXpJsWlREI0zmsi77XgyaU2bpM=; b=M5sVFqxj7rZVbTlpL94dI9g6SH
 2x/CXZgF8plFO+l0ZTwIPEfRFdhbW58as7T9rjMsR0o3ZxdfkgOoQ27SVfAEg0BPBkwGzDEYv12Ib
 r6qCAIR4mC15azOPG36tgc2RgKiRHFfIAlXPBAV6G2Rka5r9+pR7z/OUHz17bajBDm/A=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=PaT37owr/YpSqtBMVCXpJsWlREI0zmsi77XgyaU2bpM=; b=m9aWbGRIWlInJRHZUYP5WuhxPD
 ZEG7ht9KH+K8UBeSdUdDxh12VcvyHfcWEleaydLh0kLk5GKXE+rNdEyYn8rfFQZPYIqFoivD1KIMP
 y22riD2KtuQhZIwMLB/ISJQKXcUflRqspS0L2dbDNZct5GKMq4Minn37ybrrAxZCPp1Q=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=PaT37owr/YpSqtBMVCXpJsWlREI0zmsi77XgyaU2bpM=; b=gs19MIY+hmfSvoMuPUJW+9WxI
 /rxRr3b8RXA1AwPVXVF0/YWSx7Z7Ma+2dlCKn4q+CIOgKBa5aIzbuKf3NN8WiCeijdEHzD0fcslgg
 pexAcpF9/RJvhSUEBm/jr8O+FPgLTuHqeLL4ouzH6zf8D4UipTEOAa1/um9GOfwa/v3u6xSzj8CF4
 5s1qX1WKK3RR96HKIuZjWOPvGBkIx2GrUdQWiOa3/tEG86ENcRr1kNUU4PYFP0VU2XbF143Zakoca
 qszcwBbqFI8nA8ULI60XjBuz61CVGt4F7fitDwDZX+htJIznwa8FV7OmE5XrKqvGSKGSoopIcSlg7
 PoDUVM5yA==;
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

Slightly shorter and easier to read code.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/khugepaged.c | 17 +++++------------
 1 file changed, 5 insertions(+), 12 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 9f49d0cd61c2..15f1b2d81a69 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1534,8 +1534,7 @@ static void khugepaged_scan_shmem(struct mm_struct *mm,
 		pgoff_t start, struct page **hpage)
 {
 	struct page *page = NULL;
-	struct radix_tree_iter iter;
-	void **slot;
+	XA_STATE(xas, &mapping->pages, start);
 	int present, swap;
 	int node = NUMA_NO_NODE;
 	int result = SCAN_SUCCEED;
@@ -1544,17 +1543,11 @@ static void khugepaged_scan_shmem(struct mm_struct *mm,
 	swap = 0;
 	memset(khugepaged_node_load, 0, sizeof(khugepaged_node_load));
 	rcu_read_lock();
-	radix_tree_for_each_slot(slot, &mapping->pages, &iter, start) {
-		if (iter.index >= start + HPAGE_PMD_NR)
-			break;
-
-		page = radix_tree_deref_slot(slot);
-		if (radix_tree_deref_retry(page)) {
-			slot = radix_tree_iter_retry(&iter);
+	xas_for_each(&xas, page, start + HPAGE_PMD_NR - 1) {
+		if (xas_retry(&xas, page))
 			continue;
-		}
 
-		if (radix_tree_exception(page)) {
+		if (xa_is_value(page)) {
 			if (++swap > khugepaged_max_ptes_swap) {
 				result = SCAN_EXCEED_SWAP_PTE;
 				break;
@@ -1593,7 +1586,7 @@ static void khugepaged_scan_shmem(struct mm_struct *mm,
 		present++;
 
 		if (need_resched()) {
-			slot = radix_tree_iter_resume(slot, &iter);
+			xas_pause(&xas);
 			cond_resched_rcu();
 		}
 	}
-- 
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
