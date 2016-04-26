From: Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH v4 10/21] fs: Check for invalid i_uid in may_follow_link()
Date: Tue, 26 Apr 2016 14:36:23 -0500
Message-ID: <1461699396-33000-11-git-send-email-seth.forshee@canonical.com>
References: <1461699396-33000-1-git-send-email-seth.forshee@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=canonical-com.20150623.gappssmtp.com; s=20150623;
 h=from:to:cc:subject:date:message-id:in-reply-to:references;
 bh=hfAVIOUNE/FEhSXuwJacQd4lvyAjACtDTcsa8KkVSEg=;
 b=eDAQDD/iKQ9QcBr4Ag4TeCvoZS8kiOxg7N++YYU9lH/X+8mDTZHdUVmwOse/RFNc1N
 FAHqy7c2JICV6lZ6LA2iqSAhr/1rk7I6ijKxvHJzVStbh432gpP+dP5HMCujGl3SWYSn
 nO+m0mBdIJcoizMwug+Y0CvU14zO2pLlCE7Wwnwe6TZlwkUDwaqlWwYZJVf2oQEfDfwT
 txsATnbDphmzQV7JWhCbDkkoryDVM7Nx3hmQ5jplHQGQYup9pQ5HPkgHZ1NoeSHAoBHo
 P3VaJ7I9fMOc6Cc6mQYSrqFU8uF84x9WpsbxZ+7fr6ZFbbkB/8cX4Lh1F7+d349y8Qhr
 Bwlw==
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
To: "Eric W. Biederman" <ebiederm@xmission.com>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-bcache@vger.kernel.org, Serge Hallyn <serge.hallyn@canonical.com>, Seth Forshee <seth.forshee@canonical.com>, dm-devel@redhat.com, Miklos Szeredi <mszeredi@redhat.com>, Richard Weinberger <richard.weinberger@gmail.com>, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, fuse-devel@lists.sourceforge.net, Austin S Hemmelgarn <ahferroin7@gmail.com>, linux-mtd@lists.infradead.org, selinux@tycho.nsa.gov, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>

Filesystem uids which don't map into a user namespace may result
in inode->i_uid being INVALID_UID. A symlink and its parent
could have different owners in the filesystem can both get
mapped to INVALID_UID, which may result in following a symlink
when this would not have otherwise been permitted when protected
symlinks are enabled.

Add a new helper function, uid_valid_eq(), and use this to
validate that the ids in may_follow_link() are both equal and
valid. Also add an equivalent helper for gids, which is
currently unused.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
---
 fs/namei.c             |  2 +-
 include/linux/uidgid.h | 10 ++++++++++
 2 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/fs/namei.c b/fs/namei.c
index a29094c6f4a1..6fe8b0d8ca90 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -915,7 +915,7 @@ static inline int may_follow_link(struct nameidata *nd)
 		return 0;
 
 	/* Allowed if parent directory and link owner match. */
-	if (uid_eq(parent->i_uid, inode->i_uid))
+	if (uid_valid_eq(parent->i_uid, inode->i_uid))
 		return 0;
 
 	if (nd->flags & LOOKUP_RCU)
diff --git a/include/linux/uidgid.h b/include/linux/uidgid.h
index 03835522dfcb..e09529fe2668 100644
--- a/include/linux/uidgid.h
+++ b/include/linux/uidgid.h
@@ -117,6 +117,16 @@ static inline bool gid_valid(kgid_t gid)
 	return __kgid_val(gid) != (gid_t) -1;
 }
 
+static inline bool uid_valid_eq(kuid_t left, kuid_t right)
+{
+	return uid_eq(left, right) && uid_valid(left);
+}
+
+static inline bool gid_valid_eq(kgid_t left, kgid_t right)
+{
+	return gid_eq(left, right) && gid_valid(left);
+}
+
 #ifdef CONFIG_USER_NS
 
 extern kuid_t make_kuid(struct user_namespace *from, uid_t uid);
-- 
2.7.4


______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
