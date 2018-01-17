From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v6 28/99] page cache: Remove stray radix comment
Date: Wed, 17 Jan 2018 12:20:52 -0800
Message-ID: <20180117202203.19756-29-willy@infradead.org>
References: <20180117202203.19756-1-willy@infradead.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
	Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	 bh=LgIVRdadDQUrdwPpHFL/GTiBkaUVw+O6xdLtI+s3gpc=; b=kiTN4IIIeag0r/mV+FIOzgBwZ
	dcOAON1+oTzztWEcqM+FXAwbqtnUUR6p7bwZXGJjWZXjNLBDco76gA/Vl30I4Y9suOJvAyKhyYYu4
	ar8xzkYouL7khNNqP9Ceg/bnuDlsAxqv4y8m01/c8TIW+0dtV5jo7insEs9kioUOjGKZwvmliXIz9
	qGCa5Vr0eD/AqUPWHDJkdWdmgBIxsgFkjd26qq+V6+BwW+ODtvkrTepyCxvvCFIipfdWmiAUhrvBy
	AfGTWOUgQTIyIIEXS6C8mkLCSg/c9bTs8oKB9bg4q41cxpt3rchmvbU2iWwBM+xotMzU8wIIDfHVY
	dwmmV89vQ==;
In-Reply-To: <20180117202203.19756-1-willy@infradead.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-mm@kvack.org, linux-fsdevel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-nilfs@vger.kernel.org, linux-btrfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-usb@vger.kernel.org, Bjorn Andersson <bjorn.andersson@linaro.org>, Stefano Stabellini <sstabellini@kernel.org>, iommu@lists.linux-foundation.org, linux-remoteproc@vger.kernel.org, linux-s390@vger.kernel.org, intel-gfx@lists.freedesktop.org, cgroups@vger.kernel.org, linux-sh@vger.kernel.org, David Howells <dhowells@redhat.com>

From: Matthew Wilcox <mawilcox@microsoft.com>

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 mm/filemap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index d2a0031d61f5..2536fcacb5bc 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2606,7 +2606,7 @@ static struct page *do_read_cache_page(struct address_space *mapping,
 			put_page(page);
 			if (err == -EEXIST)
 				goto repeat;
-			/* Presumably ENOMEM for radix tree node */
+			/* Presumably ENOMEM for xarray node */
 			return ERR_PTR(err);
 		}
 
-- 
2.15.1

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
