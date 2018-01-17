From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v6 62/99] dax: Convert dax_insert_pfn_mkwrite to
 XArray
Date: Wed, 17 Jan 2018 12:21:26 -0800
Message-ID: <20180117202203.19756-63-willy@infradead.org>
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
 bh=ui0jdz9E027vx6kh4BN1DpRsE9/lobM/lWsy/ECHg1w=; b=kjLTAPoKQ+T+4nz58L6pqSRvN1
 gKY0wvIEFMK/25CnvfBZvtXBylebMZZFrHlg5l6GyNCUXXuod4NdFVPWE3WblG2H1iBQjxyq/Ri/9
 258uS9iUIH9IvH8WZ8+kYeEbFtY15bv7FLGRCaaJv+zacqBsq8zo42Tv5GFJPnGijSJo=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=ui0jdz9E027vx6kh4BN1DpRsE9/lobM/lWsy/ECHg1w=; b=ZYe72NtWPmUYOa56Xdw6Sm4GGZ
 Yj09QXQ8Clp0AWe0CR5XF7ZZ0feAQNKAkIChsYCHexWxPlw36HZoupwYRVT1ny8YPEcmxpBrKh54b
 TZyrTjLee0OMO2lI4Olmfi7N/6M7CBwyUf/tQzkYJMkHEKwEVcFYAMmBYxEfohkE02qA=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=ui0jdz9E027vx6kh4BN1DpRsE9/lobM/lWsy/ECHg1w=; b=pUgZyHzEvv3RkL+Uz5fUTSOH/
 GCtMTSLtHkkf6Xk0hgsTDzt2yMxZGaLpQFIHw14I9rO/jNxWIahYBUT1xPW0lpBbVusYPWjTMVGDr
 HfQshAqjS5eaAjs6VMhgcPrite+VtRwtTHBJzWM4OkQQ+/hUbr8M08T4muzTdmbLhMDnlLCC0nVBU
 fhMPyCIii/AcRi0cyhg6F9Pnl4G9Ql/bMQvN4+jQjNwOSjLKBy2v6KrLVHSWkNSunR6xdcvJXk1fQ
 7RszCtCcu1TTfeMUvyBkG/9KcDOkguTQLJwU2Jb86qRzIjpQB/ql5hnsDGEgo1+vx6MZv+1hzIWBv
 qc9S4jdAA==;
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
 fs/dax.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/dax.c b/fs/dax.c
index b66b8c896ed8..e6b25ef112f2 100644
--- a/fs/dax.c
+++ b/fs/dax.c
@@ -1497,21 +1497,21 @@ static int dax_insert_pfn_mkwrite(struct vm_fault *vmf,
 	void *entry;
 	int vmf_ret, error;
 
-	xa_lock_irq(&mapping->pages);
+	xas_lock_irq(&xas);
 	entry = get_unlocked_mapping_entry(&xas);
 	/* Did we race with someone splitting entry or so? */
 	if (!entry ||
 	    (pe_size == PE_SIZE_PTE && !dax_is_pte_entry(entry)) ||
 	    (pe_size == PE_SIZE_PMD && !dax_is_pmd_entry(entry))) {
 		put_unlocked_mapping_entry(&xas, entry);
-		xa_unlock_irq(&mapping->pages);
+		xas_unlock_irq(&xas);
 		trace_dax_insert_pfn_mkwrite_no_entry(mapping->host, vmf,
 						      VM_FAULT_NOPAGE);
 		return VM_FAULT_NOPAGE;
 	}
-	radix_tree_tag_set(&mapping->pages, index, PAGECACHE_TAG_DIRTY);
+	xas_set_tag(&xas, PAGECACHE_TAG_DIRTY);
 	entry = lock_slot(&xas);
-	xa_unlock_irq(&mapping->pages);
+	xas_unlock_irq(&xas);
 	switch (pe_size) {
 	case PE_SIZE_PTE:
 		error = vm_insert_mixed_mkwrite(vmf->vma, vmf->address, pfn);
-- 
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
