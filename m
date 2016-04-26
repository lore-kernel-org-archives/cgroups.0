From: Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH v4 21/21] fuse: Allow user namespace mounts
Date: Tue, 26 Apr 2016 14:36:34 -0500
Message-ID: <1461699396-33000-22-git-send-email-seth.forshee@canonical.com>
References: <1461699396-33000-1-git-send-email-seth.forshee@canonical.com>
Return-path: <linux-raid-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=canonical-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=TZ95t5kEVYJ729MJMguIjd5rNvxKhdNn5VRYSIMAaUg=;
        b=xpAqK7Ee3KwoKL4SdXN1CmyzuLX+zZ5aV3sATpTHJvKE+ULSvLKbp7vurWsosf7IXa
         qJE4RqAwoJyCv2uG+tHM44xKR83L+V8YBP6ltDMSlOl71/UtUuKC9rVQ6qfnjiHBsLRL
         OC0LMynwTBJP33bY2xDmNLJW6oTvNXbkSdOQ0QSg+Pp4NwfTN9nqZiSCxDzmDzT3Oq8C
         +IqqljRxc8mlh1vTocjzNiscpjQgwbaLfS42ujTkSWWrRzkYUDzOZ08yuUkFbCG1bGuy
         heZl0cMw6mQYC9p20fjmiPpHfSxDWfLvbauAocW2vOnYVuPyVCUzasYnSGH1ggpVyyER
         zTBQ==
In-Reply-To: <1461699396-33000-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-raid-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Eric W. Biederman" <ebiederm@xmission.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Serge Hallyn <serge.hallyn@canonical.com>, Richard Weinberger <richard.weinberger@gmail.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Miklos Szeredi <mszeredi@redhat.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, fuse-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, cgroups@vger.kernel.org, Seth Forshee <seth.forshee@canonical.com>

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
Acked-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/fuse/inode.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 0a771145d853..254f1944ee98 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -1199,7 +1199,7 @@ static void fuse_kill_sb_anon(struct super_block *sb)
 static struct file_system_type fuse_fs_type = {
 	.owner		= THIS_MODULE,
 	.name		= "fuse",
-	.fs_flags	= FS_HAS_SUBTYPE,
+	.fs_flags	= FS_HAS_SUBTYPE | FS_USERNS_MOUNT,
 	.mount		= fuse_mount,
 	.kill_sb	= fuse_kill_sb_anon,
 };
@@ -1231,7 +1231,7 @@ static struct file_system_type fuseblk_fs_type = {
 	.name		= "fuseblk",
 	.mount		= fuse_mount_blk,
 	.kill_sb	= fuse_kill_sb_blk,
-	.fs_flags	= FS_REQUIRES_DEV | FS_HAS_SUBTYPE,
+	.fs_flags	= FS_REQUIRES_DEV | FS_HAS_SUBTYPE | FS_USERNS_MOUNT,
 };
 MODULE_ALIAS_FS("fuseblk");
 
-- 
2.7.4

