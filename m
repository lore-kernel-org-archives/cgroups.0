From: Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH v4 01/21] fs: fix a posible leak of allocated superblock
Date: Tue, 26 Apr 2016 14:36:14 -0500
Message-ID: <1461699396-33000-2-git-send-email-seth.forshee@canonical.com>
References: <1461699396-33000-1-git-send-email-seth.forshee@canonical.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=canonical-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=d5m6xtGnCIj2kOi9yohuL/tUq13CGdPSJocC5pMsZ2A=;
        b=b5Y5oQy+8WXWh56tfv7//XTFo3cyv5C3xaxqsQVHQE24VqkRFBlDwpF8amlNHXf1Ss
         oWJ5Vt1yx1XVL47bZ6uBgUpvnJN4ZoPehCzttVPHz5C+mkDApGEIjyQVDnQ0GzFEQOKO
         0Jn6DK5CIYBHlWUYZhWnLs/0K5TuV6kBD1Ozgi1YeBeI5radSVXnfmUfbsIOrI4p8YTu
         YOyOVzgn+GqjS/AuQYR0Pq7h81t7tYBHA5V517pqj26lMSPNcgH42C3U6kwg5yzMqJll
         qj09xCmv6KvbEaj2s9VR2Ezrag2SBZg7jJOZN1aSdOWjz3cbMccPDL56Gn54g+pidXMJ
         6qEg==
In-Reply-To: <1461699396-33000-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-fsdevel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Eric W. Biederman" <ebiederm@xmission.com>, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Serge Hallyn <serge.hallyn@canonical.com>, Richard Weinberger <richard.weinberger@gmail.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Miklos Szeredi <mszeredi@redhat.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, fuse-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, cgroups@vger.kernel.org, Seth Forshee <seth.forshee@canonical.com>

From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>

We probably need to fix superblock leak in patch (v4 "fs: Add user
namesapace member to struct super_block"):

Imagine posible code path in sget_userns: we iterate through
type->fs_supers and do not find suitable sb, we drop sb_lock to
allocate s and go to retry. After we dropped sb_lock some other
task from different userns takes sb_lock, it is already in retry
stage and has s allocated, so it puts its s in type->fs_supers
list. So in retry we will find these sb in list and check it has
a different userns, and finally we will return without freeing s.

Signed-off-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Acked-by: Seth Forshee <seth.forshee@canonical.com>
---
 fs/super.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/super.c b/fs/super.c
index 829841e0ae7e..092a7828442e 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -474,6 +474,10 @@ retry:
 				continue;
 			if (user_ns != old->s_user_ns) {
 				spin_unlock(&sb_lock);
+				if (s) {
+					up_write(&s->s_umount);
+					destroy_super(s);
+				}
 				return ERR_PTR(-EBUSY);
 			}
 			if (!grab_super(old))
-- 
2.7.4

