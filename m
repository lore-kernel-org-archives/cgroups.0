From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v6 13/99] xarray: Add xa_extract
Date: Wed, 17 Jan 2018 12:20:37 -0800
Message-ID: <20180117202203.19756-14-willy@infradead.org>
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
 bh=lEEfn76qnCTuFgRhbz/vcwL7dbZHrwifjfwexVZmsOc=; b=Lf6mcKab90OOJN/DWsyHBLTVpZ
 W+esjtadTkW48Hb6joaQnOMF/UlVX9KcKIF6TwR0Vsu/cyKPV8EZP/vG79LPagglz2R93Wo9rfYcK
 i5KXhZly8XuTD5hxIICCrTyo9CmFekK5Q7BjrIRYtzLWoDDIXI8b/XQmlC9UeJrgu9rU=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=lEEfn76qnCTuFgRhbz/vcwL7dbZHrwifjfwexVZmsOc=; b=D51rsol8GRO8g1pAA+i2jYCWqk
 cB6IYgnmgMaatMVUjmdLXZzgPqhAYhvPv1B7cVMVJ+CEwQPpe2b/aBsIy982IHJ1jIgglHHsr5pvm
 pyxHsjatdWWhNne3m4PAGbnS4Tca7RxhYlEUsCIMNNV0iV6sijG5Xn6cuhFYV86JIu/E=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=lEEfn76qnCTuFgRhbz/vcwL7dbZHrwifjfwexVZmsOc=; b=D3/Qgy7NhgCKL9JjxW0Wb+JKR
 7tQNp9c5QsBioFY2TmIW3KVC3ou/SMGtPSzpi9TiFlJc4cmiOfAQWrms4/TNAuMShN9gBs49kVu7V
 tQuILmEkRGreA0xvSdKrgmEGFOcFmmIT0aG+h+FbFRBNiVmIYUoKIF9k1CmEscEVzSOLoH6yfx7lA
 m27r4893wI65YEn/iUF+Bzrjgh66Wf7M4fVcMGa3kipy6m2mgW5SgpZLfYo4G91A2vaCHLYIbInCS
 UoLEQDA7uiWIh0faXTWdjetvVfDVMnkujqWJtpuUpe+P40I3oGM0h2BQ/COiwlJ4H8XYmtIUx1o1k
 ZgJTWOM/A==;
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

This function combines the functionality of radix_tree_gang_lookup() and
radix_tree_gang_lookup_tagged().  It extracts entries matching the
specified filter into a normal array.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 include/linux/xarray.h |  2 ++
 lib/xarray.c           | 80 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 82 insertions(+)

diff --git a/include/linux/xarray.h b/include/linux/xarray.h
index fcd7ef68933a..d79fd48e4957 100644
--- a/include/linux/xarray.h
+++ b/include/linux/xarray.h
@@ -219,6 +219,8 @@ void *xa_find(struct xarray *xa, unsigned long *index,
 		unsigned long max, xa_tag_t) __attribute__((nonnull(2)));
 void *xa_find_after(struct xarray *xa, unsigned long *index,
 		unsigned long max, xa_tag_t) __attribute__((nonnull(2)));
+unsigned int xa_extract(struct xarray *, void **dst, unsigned long start,
+		unsigned long max, unsigned int n, xa_tag_t);
 
 /**
  * xa_init() - Initialise an empty XArray.
diff --git a/lib/xarray.c b/lib/xarray.c
index 3e6be0a07525..be276618f81b 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -1368,6 +1368,86 @@ void *xa_find_after(struct xarray *xa, unsigned long *indexp,
 }
 EXPORT_SYMBOL(xa_find_after);
 
+static unsigned int xas_extract_present(struct xa_state *xas, void **dst,
+			unsigned long max, unsigned int n)
+{
+	void *entry;
+	unsigned int i = 0;
+
+	rcu_read_lock();
+	xas_for_each(xas, entry, max) {
+		if (xas_retry(xas, entry))
+			continue;
+		dst[i++] = entry;
+		if (i == n)
+			break;
+	}
+	rcu_read_unlock();
+
+	return i;
+}
+
+static unsigned int xas_extract_tag(struct xa_state *xas, void **dst,
+			unsigned long max, unsigned int n, xa_tag_t tag)
+{
+	void *entry;
+	unsigned int i = 0;
+
+	rcu_read_lock();
+	xas_for_each_tag(xas, entry, max, tag) {
+		if (xas_retry(xas, entry))
+			continue;
+		dst[i++] = entry;
+		if (i == n)
+			break;
+	}
+	rcu_read_unlock();
+
+	return i;
+}
+
+/**
+ * xa_extract() - Copy selected entries from the XArray into a normal array.
+ * @xa: The source XArray to copy from.
+ * @dst: The buffer to copy entries into.
+ * @start: The first index in the XArray eligible to be selected.
+ * @max: The last index in the XArray eligible to be selected.
+ * @n: The maximum number of entries to copy.
+ * @filter: Selection criterion.
+ *
+ * Copies up to @n entries that match @filter from the XArray.  The
+ * copied entries will have indices between @start and @max, inclusive.
+ *
+ * The @filter may be an XArray tag value, in which case entries which are
+ * tagged with that tag will be copied.  It may also be %XA_PRESENT, in
+ * which case non-NULL entries will be copied.
+ *
+ * This function uses the RCU lock to protect itself.  That means that the
+ * entries returned may not represent a snapshot of the XArray at a moment
+ * in time.  For example, if index 5 is stored to, then index 10 is stored to,
+ * calling xa_extract() may return the old contents of index 5 and the
+ * new contents of index 10.  Indices not modified while this function is
+ * running will not be skipped.
+ *
+ * If you need stronger guarantees, holding the xa_lock across calls to this
+ * function will prevent concurrent modification.
+ *
+ * Return: The number of entries copied.
+ */
+unsigned int xa_extract(struct xarray *xa, void **dst, unsigned long start,
+			unsigned long max, unsigned int n, xa_tag_t filter)
+{
+	XA_STATE(xas, xa, start);
+
+	if (!n)
+		return 0;
+
+	if ((__force unsigned int)filter < XA_MAX_TAGS)
+		return xas_extract_tag(&xas, dst, max, n, filter);
+	return xas_extract_present(&xas, dst, max, n);
+}
+EXPORT_SYMBOL(xa_extract);
+
 #ifdef XA_DEBUG
 void xa_dump_node(const struct xa_node *node)
 {
-- 
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
