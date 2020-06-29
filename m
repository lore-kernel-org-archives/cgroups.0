From: Eric Sandeen <sandeen@redhat.com>
Subject: [PATCH] doc: cgroup: add f2fs and xfs to supported list for writeback
Date: Mon, 29 Jun 2020 14:08:09 -0500
Message-ID: <c8271324-9132-388c-5242-d7699f011892@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593457705;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=n2qVe7QVtMWlsu3tW293XYJBZ3r5SYGfqQyhGd9NB2s=;
        b=Ij4PBgcSg3Ntims8eYjhczQG0ARN8QglfAWrodFofst2aw7QaYiOcET3Hw72LrnenPGKes
        0ZCiaX6ecA50df/o7VpoyZjad6QJlmHXU+17fcI0hsUFPZwB5BlSZ2ZdhtPaMs9X8O2wfb
        +3QqEPmzBVN82VzSlgZ8g/Pwe4cSavg=
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, Jonathan Corbet <corbet@lwn.net>
Cc: cgroups@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, linux-xfs <linux-xfs@vger.kernel.org>

f2fs and xfs have both added support for cgroup writeback:

578c647 f2fs: implement cgroup writeback support
adfb5fb xfs: implement cgroup aware writeback

so add them to the supported list in the docs.

Signed-off-by: Eric Sandeen <sandeen@redhat.com>
---

TBH I wonder about the wisdom of having this detail in
the doc, as it apparently gets missed quite often ...

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index ce3e05e..4f82afa 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -1684,9 +1684,9 @@ per-cgroup dirty memory states are examined and the more restrictive
 of the two is enforced.
 
 cgroup writeback requires explicit support from the underlying
-filesystem.  Currently, cgroup writeback is implemented on ext2, ext4
-and btrfs.  On other filesystems, all writeback IOs are attributed to
-the root cgroup.
+filesystem.  Currently, cgroup writeback is implemented on ext2, ext4,
+btrfs, f2fs, and xfs.  On other filesystems, all writeback IOs are 
+attributed to the root cgroup.
 
 There are inherent differences in memory and writeback management
 which affects how cgroup ownership is tracked.  Memory is tracked per

