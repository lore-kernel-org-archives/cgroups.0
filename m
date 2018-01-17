From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v6 21/99] xarray: Add xa_reserve and xa_release
Date: Wed, 17 Jan 2018 12:20:45 -0800
Message-ID: <20180117202203.19756-22-willy@infradead.org>
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
 bh=kxMDFVvJxazhbqx48cDE1jvnCN9jWvyDKrSQLHcLun4=; b=eTuKb6j1uZSP1B0lLBnAbd9z7K
 Vd9C31897as8uN6movKVgRmghN2lwQuMOFYzlyOXTDqJjNax3XEvgFSHH9aCpSGrl4ZdL1LC2t9Vu
 voqgpFJPVveXMVL6NK1DGXOTbYpUTG0IVMT3EZU5T8ieK1CyX+lHgPi6hyML8f5C+UxI=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=kxMDFVvJxazhbqx48cDE1jvnCN9jWvyDKrSQLHcLun4=; b=LLg8dzJ+FAcI98BO8HrOOTC2C4
 Rz+/yEqHWNsFZXW5YCpwXnLhkdEGiei9DgGIbOLXvnmx5yAVyXNUz+AcxmwgwNmqk90n+9vNYaYou
 N7b4XUzhecRtJFfQ4fU1FV11QgrJqQM2thtwN2qYJJIEvFVU2KsTujGz7hM74fX5Y0Vs=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=kxMDFVvJxazhbqx48cDE1jvnCN9jWvyDKrSQLHcLun4=; b=Nted86jAFb7CV8xrVgaT3ribU
 xjmbwrMwn2i3RaszinUbHmBVZnXNLv4mxYIpxjMqABJlfnzrVbdthmc83/34N+lo7GQABzTF4+2D8
 NF0zlCgBARCOWBB8inrmxqc4Uqi/HcMciCyh9Yl0mf1Z2iRfQJLsimcIVfQFC3r6aMtSFUXR1tXVz
 zOMiqSWFWf4BTvIQL/mSIkCjxLII0qsZd8K12ICvPrSrf0Ed5zgX56aFEYQw6EZjtunQGMx4P1Lw+
 PtLU8bH9MXtJyQjYNaI9GbWukripbuO/K0kINJimRKsieQQoH3pDuCG8qe0zUWkZ2LdOH5cUQHRrf
 EqoSPRAOQ==;
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

This function simply creates a slot in the XArray for users which need
to acquire multiple locks before storing their entry in the tree and
so cannot use a plain xa_store().

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 include/linux/xarray.h                 | 14 ++++++++++
 lib/xarray.c                           | 51 ++++++++++++++++++++++++++++++++++
 tools/testing/radix-tree/xarray-test.c | 25 +++++++++++++++++
 3 files changed, 90 insertions(+)

diff --git a/include/linux/xarray.h b/include/linux/xarray.h
index 6f59f1f60205..c3f7405c5517 100644
--- a/include/linux/xarray.h
+++ b/include/linux/xarray.h
@@ -259,6 +259,7 @@ void *xa_load(struct xarray *, unsigned long index);
 void *xa_store(struct xarray *, unsigned long index, void *entry, gfp_t);
 void *xa_cmpxchg(struct xarray *, unsigned long index,
 			void *old, void *entry, gfp_t);
+int xa_reserve(struct xarray *, unsigned long index, gfp_t);
 bool xa_get_tag(struct xarray *, unsigned long index, xa_tag_t);
 void xa_set_tag(struct xarray *, unsigned long index, xa_tag_t);
 void xa_clear_tag(struct xarray *, unsigned long index, xa_tag_t);
@@ -373,6 +374,19 @@ static inline int xa_insert(struct xarray *xa, unsigned long index,
 	return -EEXIST;
 }
 
+/**
+ * xa_release() - Release a reserved entry.
+ * @xa: XArray.
+ * @index: Index of entry.
+ *
+ * After calling xa_reserve(), you can call this function to release the
+ * reservation.  It is harmless to call this function if the entry was used.
+ */
+static inline void xa_release(struct xarray *xa, unsigned long index)
+{
+	xa_cmpxchg(xa, index, NULL, NULL, 0);
+}
+
 #define xa_trylock(xa)		spin_trylock(&(xa)->xa_lock)
 #define xa_lock(xa)		spin_lock(&(xa)->xa_lock)
 #define xa_unlock(xa)		spin_unlock(&(xa)->xa_lock)
diff --git a/lib/xarray.c b/lib/xarray.c
index ace309cc9253..b4dec8e2d202 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -1275,6 +1275,8 @@ void *xa_cmpxchg(struct xarray *xa, unsigned long index,
 	do {
 		xas_lock(&xas);
 		curr = xas_load(&xas);
+		if (curr == XA_ZERO_ENTRY)
+			curr = NULL;
 		if (curr == old)
 			xas_store(&xas, entry);
 		xas_unlock(&xas);
@@ -1310,6 +1312,8 @@ void *__xa_cmpxchg(struct xarray *xa, unsigned long index,
 
 	do {
 		curr = xas_load(&xas);
+		if (curr == XA_ZERO_ENTRY)
+			curr = NULL;
 		if (curr == old)
 			xas_store(&xas, entry);
 	} while (__xas_nomem(&xas, gfp));
@@ -1318,6 +1322,53 @@ void *__xa_cmpxchg(struct xarray *xa, unsigned long index,
 }
 EXPORT_SYMBOL(__xa_cmpxchg);
 
+/**
+ * xa_reserve() - Reserve this index in the XArray.
+ * @xa: XArray.
+ * @index: Index into array.
+ * @gfp: Memory allocation flags.
+ *
+ * Ensures there is somewhere to store an entry at @index in the array.
+ * If there is already something stored at @index, this function does
+ * nothing.  If there was nothing there, the entry is marked as reserved.
+ * Loads from @index will continue to see a %NULL pointer until a
+ * subsequent store to @index.
+ *
+ * If you do not use the entry that you have reserved, call xa_release()
+ * or xa_erase() to free any unnecessary memory.
+ *
+ * Return: 0 if the reservation succeeded or -ENOMEM if it failed.
+ */
+int xa_reserve(struct xarray *xa, unsigned long index, gfp_t gfp)
+{
+	XA_STATE(xas, xa, index);
+	unsigned int lock_type = xa_lock_type(xa);
+	void *curr;
+
+	do {
+		if (lock_type == XA_LOCK_IRQ)
+			xas_lock_irq(&xas);
+		else if (lock_type == XA_LOCK_BH)
+			xas_lock_bh(&xas);
+		else
+			xas_lock(&xas);
+
+		curr = xas_create(&xas);
+		if (!curr)
+			xas_store(&xas, XA_ZERO_ENTRY);
+
+                if (lock_type == XA_LOCK_IRQ)
+                        xas_unlock_irq(&xas);
+                else if (lock_type == XA_LOCK_BH)
+                        xas_unlock_bh(&xas);
+                else
+                        xas_unlock(&xas);
+	} while (xas_nomem(&xas, gfp));
+
+	return xas_error(&xas);
+}
+EXPORT_SYMBOL(xa_reserve);
+
 /**
  * __xa_set_tag() - Set this tag on this entry while locked.
  * @xa: XArray.
diff --git a/tools/testing/radix-tree/xarray-test.c b/tools/testing/radix-tree/xarray-test.c
index 4d3541ac31e9..fe38b53df2ab 100644
--- a/tools/testing/radix-tree/xarray-test.c
+++ b/tools/testing/radix-tree/xarray-test.c
@@ -502,6 +502,29 @@ void check_move(struct xarray *xa)
 	} while (i < (1 << 16));
 }
 
+void check_reserve(struct xarray *xa)
+{
+	assert(xa_empty(xa));
+	xa_reserve(xa, 12345678, GFP_KERNEL);
+	assert(!xa_empty(xa));
+	assert(!xa_load(xa, 12345678));
+	xa_release(xa, 12345678);
+	assert(xa_empty(xa));
+
+	xa_reserve(xa, 12345678, GFP_KERNEL);
+	assert(!xa_store(xa, 12345678, xa_mk_value(12345678), GFP_NOWAIT));
+	xa_release(xa, 12345678);
+	assert(xa_erase(xa, 12345678) == xa_mk_value(12345678));
+	assert(xa_empty(xa));
+
+	xa_reserve(xa, 12345678, GFP_KERNEL);
+	assert(!xa_cmpxchg(xa, 12345678, NULL, xa_mk_value(12345678),
+								GFP_NOWAIT));
+	xa_release(xa, 12345678);
+	assert(xa_erase(xa, 12345678) == xa_mk_value(12345678));
+	assert(xa_empty(xa));
+}
+
 void xarray_checks(void)
 {
 	DEFINE_XARRAY(array);
@@ -548,6 +571,8 @@ void xarray_checks(void)
 
 	check_move(&array);
 	item_kill_tree(&array);
+
+	check_reserve(&array);
 }
 
 int __weak main(void)
-- 
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
