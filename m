From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v6 16/99] xarray: Add xas_create_range
Date: Wed, 17 Jan 2018 12:20:40 -0800
Message-ID: <20180117202203.19756-17-willy@infradead.org>
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
 bh=QBvHViXVnkVEPmgjEoQYNX4IHNnWrbJw+OscY9Dm/qw=; b=WkaJEtsqhwVvsPWJiWdfzsUyz5
 CAD2Dd8gaYdRYpLRGJSLpL2sSoRAf6EwkT9ELYJ/CRcp6TD4Tg2epKljzwsJOIqxEPUcdOzqiVjzA
 fwkDwmocIFNLxxNttDlG7tgMFxkQMDd+WRDjT4c8kAH7tdLsjiHv9efSbq4Wi2L3UPYA=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=QBvHViXVnkVEPmgjEoQYNX4IHNnWrbJw+OscY9Dm/qw=; b=CLaLYeE3svw+nwb6GGKnnGb6BR
 WU/1SJUE6UWHLJR8XrJCX+SEGAEyuXei8JX/pyxHUCcn3WEc9qjFjbPyc93oR9PzrVOa8f8K2faaE
 kLZ2E1O4vlC/g+GPz/tYFyXKf/GR/IPFjMB+uzuw4gEqNI90Yp4Q6YoPnMlNyJ7pob6s=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=QBvHViXVnkVEPmgjEoQYNX4IHNnWrbJw+OscY9Dm/qw=; b=s432/WlHtq2r6+H7DZcEBuVKP
 Pj69E6eIV/HJGEWKz8dWArjxbQ/5bsibhCQnoRgVglHGCR4scNIiNGY32EVYbpu9YGy21rzUxSHUZ
 dJ0qkhHmePvrF9gQwJRN8MbbhiutzlWNkGj0Uhf8MOuEM6IE4RWU7LAlscRcyS85QP6O6T9rRF7Dh
 c09E8719hUQqD2gurpeJ6DLvQmxZ12Rh+dT2ar1JOpkYlEyd96PDBD7Pxy9MUOlYTV03+HEG2C0LJ
 8AFyId6yy8w6Izdx4Hmc7YP/lqXwkGCudlz270er3erkhH1RkxbCH+BG6wDvEbKeMRXbsWZCAj6mb
 pHQKn52cw==;
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

This hopefully temporary function is useful for users who have not yet
been converted to multi-index entries.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 include/linux/xarray.h |  2 ++
 lib/xarray.c           | 22 ++++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/include/linux/xarray.h b/include/linux/xarray.h
index 01ce313fc00e..acb6d02ff194 100644
--- a/include/linux/xarray.h
+++ b/include/linux/xarray.h
@@ -705,6 +705,8 @@ void xas_init_tags(const struct xa_state *);
 bool xas_nomem(struct xa_state *, gfp_t);
 void xas_pause(struct xa_state *);
 
+void xas_create_range(struct xa_state *, unsigned long max);
+
 /**
  * xas_reload() - Refetch an entry from the xarray.
  * @xas: XArray operation state.
diff --git a/lib/xarray.c b/lib/xarray.c
index e8ece1fff9fd..c044373d6893 100644
--- a/lib/xarray.c
+++ b/lib/xarray.c
@@ -612,6 +612,28 @@ void *xas_create(struct xa_state *xas)
 }
 EXPORT_SYMBOL_GPL(xas_create);
 
+/**
+ * xas_create_range() - Ensure that stores to this range will succeed
+ * @xas: XArray operation state.
+ * @max: The highest index to create a slot for.
+ *
+ * Creates all of the slots in the range between the current position of
+ * @xas and @max.  This is for the benefit of users who have not yet been
+ * converted to multi-index entries.
+ *
+ * The implementation is naive.
+ */
+void xas_create_range(struct xa_state *xas, unsigned long max)
+{
+	XA_STATE(tmp, xas->xa, xas->xa_index);
+
+	do {
+		xas_create(&tmp);
+		xas_set(&tmp, tmp.xa_index + XA_CHUNK_SIZE);
+	} while (tmp.xa_index < max);
+}
+EXPORT_SYMBOL_GPL(xas_create_range);
+
 static void store_siblings(struct xa_state *xas, void *entry, void *curr,
 				int *countp, int *valuesp)
 {
-- 
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
