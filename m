From: Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH v4 05/21] block_dev: Check permissions towards block device inode when mounting
Date: Tue, 26 Apr 2016 14:36:18 -0500
Message-ID: <1461699396-33000-6-git-send-email-seth.forshee@canonical.com>
References: <1461699396-33000-1-git-send-email-seth.forshee@canonical.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=canonical-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=UHwmomD63z/RGnd7NeaL27R4JrM01/jEm5xMtjenPws=;
        b=B8HIVwhrPuXoz7l43B03uyqFwMN2nLBg8/1QDFqGG3QIg4eUlQTV9ZRQvGDsDe3TnL
         VOk9VYybs16BdJM9Uq0kC5NI7GPm71crin8wuRXAAVv1F2Nfy5OyRlTRM4f85wCYTbz/
         9+B86FvjoyJxb2iruRM02GdFQvkLvh9kv9mNf9IV3CqUpKDF84M2su8fbSOhqpecEXWI
         sA1spUWDYlfsRPObT/M9qGq2h/43/63pegJCbO41GCzfbBpAKZyssdilNi4r9gccxHSE
         VGOv9vu4xRJHAwHR0B5Ux9TKdkRZAY6yQkCp0sinZnIg5zrxEl8tMCYaXcp8FzZE9MvA
         Mr1w==
In-Reply-To: <1461699396-33000-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Eric W. Biederman" <ebiederm@xmission.com>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Serge Hallyn <serge.hallyn@canonical.com>, Richard Weinberger <richard.weinberger@gmail.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Miklos Szeredi <mszeredi@redhat.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, fuse-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, cgroups@vger.kernel.org, Seth Forshee <seth.forshee@canonical.com>

Unprivileged users should not be able to mount block devices when
they lack sufficient privileges towards the block device inode.
Update blkdev_get_by_path() to validate that the user has the
required access to the inode at the specified path. The check
will be skipped for CAP_SYS_ADMIN, so privileged mounts will
continue working as before.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
---
 fs/block_dev.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index e9b937845bdb..2007040afb7b 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -1429,9 +1429,14 @@ struct block_device *blkdev_get_by_path(const char *path, fmode_t mode,
 					void *holder)
 {
 	struct block_device *bdev;
+	int perm = 0;
 	int err;
 
-	bdev = lookup_bdev(path, 0);
+	if (mode & FMODE_READ)
+		perm |= MAY_READ;
+	if (mode & FMODE_WRITE)
+		perm |= MAY_WRITE;
+	bdev = lookup_bdev(path, perm);
 	if (IS_ERR(bdev))
 		return bdev;
 
-- 
2.7.4

