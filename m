From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v6 14/99] xarray: Add xa_destroy
Date: Wed, 17 Jan 2018 12:20:38 -0800
Message-ID: <20180117202203.19756-15-willy@infradead.org>
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
 bh=XZtf49OplSNMiLX2AdGPemxvR5yK74fT0+YCogl7RG0=; b=K0uqmX6IHq4NJITWSXdscVviTG
 eHBVuq5V9QUBCrd9dYtB1wl6jZpLIMifTH9X0oKu92Uj030ZmuU4Rbf8nCuB27xXQeDuRbV/hWUMC
 yl14ZFUgvQMhFgK8QsunqcuC8Jc3HtobpkZyVyw6ms4hi7hKYL5vFw0SpvURvVZXfmjk=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=XZtf49OplSNMiLX2AdGPemxvR5yK74fT0+YCogl7RG0=; b=GPCofIATU3z6OdVstVy5Lqo3l6
 fVFW5cXoro2iFOyWqtpqMEnj2S6HHSnrxfUOEV+qHTb1rzjUunwNqvea+kO3+kjnMErqctc1ZeNbT
 YyKZgEgy4BZVsR40HiCihgaY1SbP4N/LxJ4oqQqq/X1C2eZNvOUzDVNmMLFhiFbDA9LE=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=XZtf49OplSNMiLX2AdGPemxvR5yK74fT0+YCogl7RG0=; b=QmbhubtDr7K5WFLbyK4kQof0s
 6Ng4OyngkDksoT7Ixgj9XmPWjI2UZAAbu4gGE1btwZ6MsT7nuUJuj2Fm/zC5PUbUW3THLpzDYl64D
 K8LDP+ddcSimGLlKblADHL1CBd4Mbe3OnirXeBv/zzx7KKv8WpyN5pE6UcTOtAxSkAxNf0tfCVEdW
 23DMTzLA5TvQJVwfHHH7ocgFMpswLb/o+kFNtn1kZ7kXrG08zBDnS5kqYGG/ZrLdOv2OTXCi3ETUT
 QQ36q3IizDLgM2wiMs3NHs1o4Be1L62aAeRm0z9cdroGlEHxct0eRW/iyZpYQCOGbiVVcz3OE2JUR
 Dmts5O7pQ==;
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

This function frees all the internal memory allocated to the xarray
and reinitialises it to be empty.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 include/linux/xarray.h |  1 +
 lib/xarray.c           | 26 ++++++++++++++++++++++++++
 2 files changed, 27 insertions(+)

diff --git a/include/linux/xarray.h b/include/linux/xarray.h
index d79fd48e4957..d106b2fe4cec 100644
--- a/include/linux/xarray.h
+++ b/include/linux/xarray.h
@@ -221,6 +221,7 @@ void *xa_find_after(struct xarray *xa, unsigned long *index,
 		unsigned long max, xa_tag_t) __attribute__((nonnull(2)));
 unsigned int xa_extract(struct xarray *, void **dst, unsigned long start,
 		unsigned long max, unsigned int n, xa_tag_t);
+void xa_destroy(struct xarray *);
 
 /**
  * xa_init() - Initialise an empty XArray.
diff --git a/lib/xarray.c b/lib/xarray.c
index be276618f81b..af81d4bf9ae1 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -1448,6 +1448,32 @@ unsigned int xa_extract(struct xarray *xa, void **dst, unsigned long start,
 }
 EXPORT_SYMBOL(xa_extract);
 
+/**
+ * xa_destroy() - Free all internal data structures.
+ * @xa: XArray.
+ *
+ * After calling this function, the XArray is empty and has freed all memory
+ * allocated for its internal data structures.  You are responsible for
+ * freeing the objects referenced by the XArray.
+ */
+void xa_destroy(struct xarray *xa)
+{
+	XA_STATE(xas, xa, 0);
+	unsigned long flags;
+	void *entry;
+
+	xas.xa_node = NULL;
+	xas_lock_irqsave(&xas, flags);
+	entry = xa_head_locked(xa);
+	RCU_INIT_POINTER(xa->xa_head, NULL);
+	xas_init_tags(&xas);
+	/* lockdep checks we're still holding the lock in xas_free_nodes() */
+	if (xa_is_node(entry))
+		xas_free_nodes(&xas, xa_to_node(entry));
+	xas_unlock_irqrestore(&xas, flags);
+}
+EXPORT_SYMBOL(xa_destroy);
+
 #ifdef XA_DEBUG
 void xa_dump_node(const struct xa_node *node)
 {
-- 
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
