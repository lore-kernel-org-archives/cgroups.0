From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v6 17/99] xarray: Add MAINTAINERS entry
Date: Wed, 17 Jan 2018 12:20:41 -0800
Message-ID: <20180117202203.19756-18-willy@infradead.org>
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
 bh=82H3zweFnHH27bR2aNmm9vzn7f0RsZrKjI/BrKOxcNE=; b=T8QuYZIgJIkkZTBVF8+wZCLst/
 o9vEdzQfnwC8yo5ESaPjUfM38+aBxAES/5ZpCkTXlxhrOOvUgjMP0s7LI121ZHTbhMgrDUhEwW+c/
 GjoF9X3UBgoTHrUfEw8YXU0SdYhTL9FhW/tUJbg1m2tu50/y6wSuxJWnxqtProztnNRM=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=82H3zweFnHH27bR2aNmm9vzn7f0RsZrKjI/BrKOxcNE=; b=Wen919EBzji2b6ciXD+Eyoig91
 XaJ+/lUetJmozzuP83jWk/l6XvfP+AknDUW3ed0q/k9hARwpGnFpUbMaGAmd28RyifkDDCtCm7DNz
 In0HPjGgKhXKaeOe6XlFMBmtVE0Wk+3Hk1pt4U34tHGGZm/acwL4PnlUY9WZZeH7L/fo=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=82H3zweFnHH27bR2aNmm9vzn7f0RsZrKjI/BrKOxcNE=; b=N0ZZuAUypwP3e6CJFT10O5l/j
 rsNX/eWlcGKJhrR/EZCL157FAe9mVnEnBIf/DO7gQKI4FoOdCqQ00SY//fkNhgqrAYJYlSYCSTgDQ
 2vujMagMYceDgOim9l6YsSeUKZaDAhK+m5qAWDFbc7oqwTsOwY+nstV42wWQtLfB/dVR7I9o3Op1T
 TRFqxZHwkcYd986aQmteU+uCpZTz4Fmljg07sPri+QtHIc1c6062Ap4yqeVSL8CZcv1zRF70aA1NZ
 XZGHAlBomsjQbou4f5YKDEUMjxcCLsVeZ5i58bCluMa0XK7fq5K8hqo+9nBLmAZkdc/ORw/GDcgxH
 bQ1k463ZQ==;
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

Add myself as XArray and IDR maintainer.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 MAINTAINERS | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 18994806e441..55ae4c0b38d5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14893,6 +14893,18 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86/vdso
 S:	Maintained
 F:	arch/x86/entry/vdso/
 
+XARRAY
+M:	Matthew Wilcox <mawilcox@microsoft.com>
+M:	Matthew Wilcox <willy@infradead.org>
+L:	linux-fsdevel@vger.kernel.org
+S:	Supported
+F:	Documentation/core-api/xarray.rst
+F:	lib/idr.c
+F:	lib/xarray.c
+F:	include/linux/idr.h
+F:	include/linux/xarray.h
+F:	tools/testing/radix-tree
+
 XC2028/3028 TUNER DRIVER
 M:	Mauro Carvalho Chehab <mchehab@s-opensource.com>
 M:	Mauro Carvalho Chehab <mchehab@kernel.org>
-- 
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
