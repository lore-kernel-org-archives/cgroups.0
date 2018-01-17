From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v6 65/99] dax: Fix sparse warning
Date: Wed, 17 Jan 2018 12:21:29 -0800
Message-ID: <20180117202203.19756-66-willy@infradead.org>
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
 bh=gkqfWwRqwd2HZPlcOVcJrDMpt7HmnmzlXTDVEbTO50Q=; b=BH2BDfTT3MUKmJei7XHHLukyoH
 P7RJAdytGjdxVyJlpsVX2n+jZ+rYmLNxXU0nhxB6OiNDzM8Ag/r/XPBTQ4sSEQWTpEpNrS35jiSl7
 gCPfvS11gS8smAnRgFHbm5glNJaZWUkRNOUamcPObjv55J3BaQ9XXspMEpVh9dQQb9yc=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=gkqfWwRqwd2HZPlcOVcJrDMpt7HmnmzlXTDVEbTO50Q=; b=IVX7g+WYZCrNt91wB4RnNZ+Yr4
 y1CzLJcH79Xuv480IYyqhK2nl5EKPhTgIW774m9mUqYRgifp0cjWtolLGx5e6aY7nHdQPcOb2Yw+o
 ybRu40Seq1CmUBUjSGWELU/qD/bHHzmrCNNUNAHHvOqjRnKSlNacsaS+PrdUAxUcguGs=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=gkqfWwRqwd2HZPlcOVcJrDMpt7HmnmzlXTDVEbTO50Q=; b=KC+0bzRe8oBsTLyK1u0RnFhKp
 MY72rBNYkEzAfNIAnGSaZKxZX/c3W4/Vm3YftRrSRdJAO1aUf0bTxLJ2XEJd4mP3EAhSgXyRKIBXc
 +DHVy0TW2cmL1HeC5SSx+R24ae9d30e8v4B7MyX7l/HAtREfRQmNY0PRtDV0bewt5XPw6v/3+1Cs/
 HJyDgvvc8j9p+bRm4iRHoIXWEjaZ3mnkZ7DlkQFTwD2+vta1Gs6H3Tv1UWLBbsOQCxyKB7nuu8kRL
 ilLs0QzOchZA7s8Bax16XIJhMdlhLlvvO4rvE8Pts7IZm3ubB4+ch+AaRyWNVnjVjXAjDWrPWP+8j
 b6Gb+30Gw==;
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

sparse doesn't know that follow_pte_pmd() conditionally acquires the ptl,
because it's in a separate compilation unit.  Move follow_pte_pmd() to
mm.h where sparse can see it.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 include/linux/mm.h | 15 ++++++++++++++-
 mm/memory.c        | 16 +---------------
 2 files changed, 15 insertions(+), 16 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index fe1ee4313add..9c384c486edf 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1314,7 +1314,7 @@ int copy_page_range(struct mm_struct *dst, struct mm_struct *src,
 			struct vm_area_struct *vma);
 void unmap_mapping_range(struct address_space *mapping,
 		loff_t const holebegin, loff_t const holelen, int even_cows);
-int follow_pte_pmd(struct mm_struct *mm, unsigned long address,
+int __follow_pte_pmd(struct mm_struct *mm, unsigned long address,
 			     unsigned long *start, unsigned long *end,
 			     pte_t **ptepp, pmd_t **pmdpp, spinlock_t **ptlp);
 int follow_pfn(struct vm_area_struct *vma, unsigned long address,
@@ -1324,6 +1324,19 @@ int follow_phys(struct vm_area_struct *vma, unsigned long address,
 int generic_access_phys(struct vm_area_struct *vma, unsigned long addr,
 			void *buf, int len, int write);
 
+static inline int follow_pte_pmd(struct mm_struct *mm, unsigned long address,
+			     unsigned long *start, unsigned long *end,
+			     pte_t **ptepp, pmd_t **pmdpp, spinlock_t **ptlp)
+{
+	int res;
+
+	/* (void) is needed to make gcc happy */
+	(void) __cond_lock(*ptlp,
+			   !(res = __follow_pte_pmd(mm, address, start, end,
+						    ptepp, pmdpp, ptlp)));
+	return res;
+}
+
 static inline void unmap_shared_mapping_range(struct address_space *mapping,
 		loff_t const holebegin, loff_t const holelen)
 {
diff --git a/mm/memory.c b/mm/memory.c
index ca5674cbaff2..66184601ac03 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4201,7 +4201,7 @@ int __pmd_alloc(struct mm_struct *mm, pud_t *pud, unsigned long address)
 }
 #endif /* __PAGETABLE_PMD_FOLDED */
 
-static int __follow_pte_pmd(struct mm_struct *mm, unsigned long address,
+int __follow_pte_pmd(struct mm_struct *mm, unsigned long address,
 			    unsigned long *start, unsigned long *end,
 			    pte_t **ptepp, pmd_t **pmdpp, spinlock_t **ptlp)
 {
@@ -4278,20 +4278,6 @@ static inline int follow_pte(struct mm_struct *mm, unsigned long address,
 	return res;
 }
 
-int follow_pte_pmd(struct mm_struct *mm, unsigned long address,
-			     unsigned long *start, unsigned long *end,
-			     pte_t **ptepp, pmd_t **pmdpp, spinlock_t **ptlp)
-{
-	int res;
-
-	/* (void) is needed to make gcc happy */
-	(void) __cond_lock(*ptlp,
-			   !(res = __follow_pte_pmd(mm, address, start, end,
-						    ptepp, pmdpp, ptlp)));
-	return res;
-}
-EXPORT_SYMBOL(follow_pte_pmd);
-
 /**
  * follow_pfn - look up PFN at a user virtual address
  * @vma: memory mapping
-- 
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
