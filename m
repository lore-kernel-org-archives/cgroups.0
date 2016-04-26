From: Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH v4 15/21] fs: Don't remove suid for CAP_FSETID in s_user_ns
Date: Tue, 26 Apr 2016 14:36:28 -0500
Message-ID: <1461699396-33000-16-git-send-email-seth.forshee@canonical.com>
References: <1461699396-33000-1-git-send-email-seth.forshee@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-mtd-bounces+gldm-linux-mtd-36=gmane.org@lists.infradead.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=canonical-com.20150623.gappssmtp.com; s=20150623;
 h=from:to:cc:subject:date:message-id:in-reply-to:references;
 bh=6wp+PLaoRzmNmk4QzmosQuFHoGYfjs+oQVk8R8M0s9M=;
 b=nU6xY84n4EcejeABOJPlpQWzlde2y+gFYrVPYMyDw1oMv+Ckh/I2EHW6oNDifmvrwA
 F+iPl3QW86jymi1Vp/jPHJ1geMzZUAZ1pa1837hWkqt2UqKq8/XQx0SppP++sV1dGGs2
 rLPDifC0r4rxeoUHXQr+AG5Qa0EHjvAkoERETXyCrwFZYuHebrfTNW2t1aPmr/3Lnh8n
 LXTomFFahH4N9OZyZZO7hr8Ii7XpQsXZESqu7KzGLFS57kaPLjUzfGSmj0Kso8ydAZSw
 5EFdNlScxed0nPc31FaQJlonYCM4gC59k/Bu4h4feOLfNcLUTW8AIisgX/HhwcoSzNiT
 xOvw==
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

Expand the check in should_remove_suid() to keep privileges for
CAP_FSETID in s_user_ns rather than init_user_ns.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
---
 fs/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/inode.c b/fs/inode.c
index 69b8b526c194..cd52170f9117 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1690,7 +1690,8 @@ int should_remove_suid(struct dentry *dentry)
 	if (unlikely((mode & S_ISGID) && (mode & S_IXGRP)))
 		kill |= ATTR_KILL_SGID;
 
-	if (unlikely(kill && !capable(CAP_FSETID) && S_ISREG(mode)))
+	if (unlikely(kill && !ns_capable(dentry->d_sb->s_user_ns, CAP_FSETID) &&
+		     S_ISREG(mode)))
 		return kill;
 
 	return 0;
-- 
2.7.4


______________________________________________________
Linux MTD discussion mailing list
http://lists.infradead.org/mailman/listinfo/linux-mtd/
