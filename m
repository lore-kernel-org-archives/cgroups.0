From: Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH v4 11/21] cred: Reject inodes with invalid ids in
 set_create_file_as()
Date: Tue, 26 Apr 2016 14:36:24 -0500
Message-ID: <1461699396-33000-12-git-send-email-seth.forshee@canonical.com>
References: <1461699396-33000-1-git-send-email-seth.forshee@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=canonical-com.20150623.gappssmtp.com; s=20150623;
 h=from:to:cc:subject:date:message-id:in-reply-to:references;
 bh=Lo5iDM9zOZrtGAL6ADxgGtKcisaTOotUC/Wi0eo0ick=;
 b=hq3y5nkEE07FBHvEIenezdBWbg2OxjuJsKUBaZmravKXF5GOYm7v4XlO3qcZ0SrNx5
 WTbPJzxF0NA5H42jKruazM3pizXc/fzdSBgZKgGPNLs5Y+ZgTgUPaZxAcru3A6OPymq3
 ZwS0W5ypsKKsatDarhSyJvQvdnOmdE8FW5cTPVf+Ry/VUIWN3Br7yM1QGf/RgFXxYA++
 n3VwUCZg839UYYfb8SxyuHILl3nj46c92fIkvLraY0ZlklrqyCqk1gOJxUZb4itxTZ8L
 ZyJTmJmrybtIrJASKRwi8XWXiPedBvMPkGw38de+TPxXMUM4BeT313Pcx+ZRVQEdJxez
 PKoQ==
In-Reply-To: <1461699396-33000-1-git-send-email-seth.forshee@canonical.com>
List-Id: <cgroups.vger.kernel.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-mtd/>
List-Post: <mailto:linux-mtd@lists.infradead.org>
List-Help: <mailto:linux-mtd-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-mtd>,
 <mailto:linux-mtd-request@lists.infradead.org?subject=subscribe>
Sender: "linux-mtd" <linux-mtd-bounces@lists.infradead.org>
Errors-To: linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-bcache@vger.kernel.org, Serge Hallyn <serge.hallyn@canonical.com>, Seth Forshee <seth.forshee@canonical.com>, dm-devel@redhat.com, Miklos Szeredi <mszeredi@redhat.com>, Richard Weinberger <richard.weinberger@gmail.com>, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, fuse-devel@lists.sourceforge.net, Austin S Hemmelgarn <ahferroin7@gmail.com>, linux-mtd@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, selinux@tycho.nsa.gov, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>

Using INVALID_[UG]ID for the LSM file creation context doesn't
make sense, so return an error if the inode passed to
set_create_file_as() has an invalid id.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
---
 kernel/cred.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/cred.c b/kernel/cred.c
index 0c0cd8a62285..5f264fb5737d 100644
--- a/kernel/cred.c
+++ b/kernel/cred.c
@@ -689,6 +689,8 @@ EXPORT_SYMBOL(set_security_override_from_ctx);
  */
 int set_create_files_as(struct cred *new, struct inode *inode)
 {
+	if (!uid_valid(inode->i_uid) || !gid_valid(inode->i_gid))
+		return -EINVAL;
 	new->fsuid = inode->i_uid;
 	new->fsgid = inode->i_gid;
 	return security_kernel_create_files_as(new, inode);
-- 
2.7.4


______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
