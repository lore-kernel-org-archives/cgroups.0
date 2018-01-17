From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v6 18/99] xarray: Add ability to store errno
 values
Date: Wed, 17 Jan 2018 12:20:42 -0800
Message-ID: <20180117202203.19756-19-willy@infradead.org>
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
 bh=yA35bzbc7DQTXUnDdGots2lopsb0vOYzZ8K0lzRGVqA=; b=WFi2bv7Ebtul3dfJ2MxRBBtfo7
 t3ncN1S13dYn8Mi8eHkaC/f4PNT9PzNMBWqvneFzAFxSvg8vbVtPUJ1iIy/2g5PqHAsEZtPY4QzXv
 jLmgagBiboYTZ64/3HyPctBQkdWD0ev8mlkoK7lhaWdM7GYFhyFo7PLLjRtglD6Q65Bo=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=sf.net; s=x
 ;
 h=References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To
 :MIME-Version:Content-Type:Content-Transfer-Encoding:Content-ID:
 Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
 :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
 List-Post:List-Owner:List-Archive;
 bh=yA35bzbc7DQTXUnDdGots2lopsb0vOYzZ8K0lzRGVqA=; b=hWkX91HVYH+nZbHin/9dPx5ugK
 9/wHaUcx7t9mWUZXtr8FZQExocqlLJaFwI7eF33kLxG17zKGYJUis4Ux1NpHCdLWzex8miB02ye06
 TCM8xCdx9o90rUaA1RrRqfDz7lF/oumJvNoCL3JFiTMo0B3YVHwtZOBBXlemNGTRHYMk=;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 d=infradead.org; s=bombadil.20170209; h=References:In-Reply-To:Message-Id:
 Date:Subject:Cc:To:From:Sender:Reply-To:MIME-Version:Content-Type:
 Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
 Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
 List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
 bh=yA35bzbc7DQTXUnDdGots2lopsb0vOYzZ8K0lzRGVqA=; b=KugeWV5hP/gMn3e7K0ReKwGtG
 CBA97L4AF8wXzSzmizMWJ3Mhcc7VXH+gV+XMihfBqucm3bTizPCvLPdyIu2bNL5ss5l/IJFT1Dgf6
 vQusdjbwohNrSAtZgWGQ3AssM0g0IbbQvlwBIaIRoaVOlooiHqbCNfPaNQye7CxbTSdJYhO6OSnOZ
 qz8awXuBLtwoD+gEDzwMKFS8RkenRAVGonEee9D4wjhsA9Pb76ts5jD5jphO8RNqvCN/yafwuINPD
 mD7a+NKL1kFGxdunU81B3TYnPYAukdPyd8Y0Uy5L4E5hPQy/MrZNBFyBPEibJGIZzEb6wyyxZkmJJ
 2GGWN1ezg==;
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

While the radix tree offers no ability to store IS_ERR pointers,
documenting that the XArray does not led to some concern.  Here is a
sanctioned way to store errnos in the XArray.  I'm concerned that it
will confuse people who can't tell the difference between xa_is_err()
and xa_is_errno(), so I've added copious kernel-doc to help them tell
the difference.

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 Documentation/core-api/xarray.rst      |  8 +++++--
 include/linux/xarray.h                 | 44 ++++++++++++++++++++++++++++++++++
 tools/testing/radix-tree/xarray-test.c |  8 ++++++-
 3 files changed, 57 insertions(+), 3 deletions(-)

diff --git a/Documentation/core-api/xarray.rst b/Documentation/core-api/xarray.rst
index 914999c0bf3f..0172c7d9e6ea 100644
--- a/Documentation/core-api/xarray.rst
+++ b/Documentation/core-api/xarray.rst
@@ -42,8 +42,12 @@ When you retrieve an entry from the XArray, you can check whether it is
 a value entry by calling :c:func:`xa_is_value`, and convert it back to
 an integer by calling :c:func:`xa_to_value`.
 
-The XArray does not support storing :c:func:`IS_ERR` pointers as some
-conflict with value entries or internal entries.
+The XArray does not support storing :c:func:`IS_ERR` pointers because
+some conflict with value entries or internal entries.  If you need
+to store error numbers in the array, you can encode them into error
+entries with :c:func:`xa_mk_errno`, check whether a returned entry is
+an error with :c:func:`xa_is_errno` and convert it back into an errno
+with :c:func:`xa_to_errno`.
 
 An unusual feature of the XArray is the ability to create entries which
 occupy a range of indices.  Once stored to, looking up any index in
diff --git a/include/linux/xarray.h b/include/linux/xarray.h
index acb6d02ff194..ca6af6dd42c4 100644
--- a/include/linux/xarray.h
+++ b/include/linux/xarray.h
@@ -75,6 +75,50 @@ static inline bool xa_is_value(const void *entry)
 	return (unsigned long)entry & 1;
 }
 
+/**
+ * xa_mk_errno() - Create an XArray entry from an error number.
+ * @error: Error number to store in XArray.
+ *
+ * Return: An entry suitable for storing in the XArray.
+ */
+static inline void *xa_mk_errno(long error)
+{
+	return (void *)(error << 2);
+}
+
+/**
+ * xa_to_errno() - Get error number stored in an XArray entry.
+ * @entry: XArray entry.
+ *
+ * Calling this function on an entry which is not an xa_is_errno() will
+ * yield unpredictable results.  Do not confuse this function with xa_err();
+ * this function is for errnos which have been stored in the XArray, and
+ * that function is for errors returned from the XArray implementation.
+ *
+ * Return: The error number stored in the XArray entry.
+ */
+static inline long xa_to_errno(const void *entry)
+{
+	return (long)entry >> 2;
+}
+
+/**
+ * xa_is_errno() - Determine if an entry is an errno.
+ * @entry: XArray entry.
+ *
+ * Do not confuse this function with xa_is_err(); that function tells you
+ * whether the XArray implementation returned an error; this function
+ * tells you whether the entry you successfully stored in the XArray
+ * represented an errno.  If you have never stored an errno in the XArray,
+ * you do not have to check this.
+ *
+ * Return: True if the entry is an errno, false if it is a pointer.
+ */
+static inline bool xa_is_errno(const void *entry)
+{
+	return (((unsigned long)entry & 3) == 0) && (entry > (void *)-4096);
+}
+
 /*
  * xa_mk_internal() - Create an internal entry.
  * @v: Value to turn into an internal entry.
diff --git a/tools/testing/radix-tree/xarray-test.c b/tools/testing/radix-tree/xarray-test.c
index 2ad460c1febf..4d3541ac31e9 100644
--- a/tools/testing/radix-tree/xarray-test.c
+++ b/tools/testing/radix-tree/xarray-test.c
@@ -29,7 +29,13 @@ void check_xa_err(struct xarray *xa)
 	assert(xa_err(xa_store(xa, 1, xa_mk_value(0), GFP_KERNEL)) == 0);
 	assert(xa_err(xa_store(xa, 1, NULL, 0)) == 0);
 // kills the test-suite :-(
-//     assert(xa_err(xa_store(xa, 0, xa_mk_internal(0), 0)) == -EINVAL);
+//	assert(xa_err(xa_store(xa, 0, xa_mk_internal(0), 0)) == -EINVAL);
+
+	assert(xa_err(xa_store(xa, 0, xa_mk_errno(-ENOMEM), GFP_KERNEL)) == 0);
+	assert(xa_err(xa_load(xa, 0)) == 0);
+	assert(xa_is_errno(xa_load(xa, 0)) == true);
+	assert(xa_to_errno(xa_load(xa, 0)) == -ENOMEM);
+	xa_erase(xa, 0);
 }
 
 void check_xa_tag(struct xarray *xa)
-- 
2.15.1


------------------------------------------------------------------------------
Check out the vibrant tech community on one of the world's most
engaging tech sites, Slashdot.org! http://sdm.link/slashdot
