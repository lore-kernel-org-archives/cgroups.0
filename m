From: Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH v4 20/21] fuse: Restrict allow_other to the superblock's namespace or a descendant
Date: Tue, 26 Apr 2016 14:36:33 -0500
Message-ID: <1461699396-33000-21-git-send-email-seth.forshee@canonical.com>
References: <1461699396-33000-1-git-send-email-seth.forshee@canonical.com>
Return-path: <linux-raid-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=canonical-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=xVETxp19myjlkr9oWfx2dXb9pOJQfW/T7A25FZmF28w=;
        b=Ibmdzzi0vCZxWRNsWTlYmiTfaY6ubAsX0D7k9/uJPjNl078Kef0TGKmsxoUYkdNX37
         xohnPsrsmsEkVP1HUkXe0Ju9t5CE/p46rP5YofhT0kj5rmMtWjCUshVovzIW1NJi0/bZ
         ws5lcZo8wK0acYG22OgKIkBJjYTCBAJcUmIam72CGmH3GeLu7iWbXILW+lSkLBZmppoR
         3EdkAUfc63r0olvlyffBstvwbuyijCEKu7Uie1Jad4AsvapRRYKeI+UU2/B30maGKoAQ
         A/3Shm8hqzaLZ6DdljQ/lo0iD/jZMWaACz2Gyl4JLf86SAbjcay+xLKUafcO4qiOne4p
         FOgg==
In-Reply-To: <1461699396-33000-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-raid-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Eric W. Biederman" <ebiederm@xmission.com>, Miklos Szeredi <miklos@szeredi.hu>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, Serge Hallyn <serge.hallyn@canonical.com>, Richard Weinberger <richard.weinberger@gmail.com>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Miklos Szeredi <mszeredi@redhat.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-mtd@lists.infradead.org, linux-fsdevel@vger.kernel.org, fuse-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, selinux@tycho.nsa.gov, cgroups@vger.kernel.org, Seth Forshee <seth.forshee@canonical.com>

Unprivileged users are normally restricted from mounting with the
allow_other option by system policy, but this could be bypassed
for a mount done with user namespace root permissions. In such
cases allow_other should not allow users outside the userns
to access the mount as doing so would give the unprivileged user
the ability to manipulate processes it would otherwise be unable
to manipulate. Restrict allow_other to apply to users in the same
userns used at mount or a descendant of that namespace. Also
export current_in_userns() for use by fuse when built as a
module.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
Acked-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/fuse/dir.c           | 2 +-
 kernel/user_namespace.c | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index ecba75bf6640..1a6c5af49608 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1015,7 +1015,7 @@ int fuse_allow_current_process(struct fuse_conn *fc)
 	const struct cred *cred;
 
 	if (fc->flags & FUSE_ALLOW_OTHER)
-		return 1;
+		return current_in_userns(fc->user_ns);
 
 	cred = current_cred();
 	if (uid_eq(cred->euid, fc->user_id) &&
diff --git a/kernel/user_namespace.c b/kernel/user_namespace.c
index 68f594212759..fa2294e14b77 100644
--- a/kernel/user_namespace.c
+++ b/kernel/user_namespace.c
@@ -951,6 +951,7 @@ bool current_in_userns(const struct user_namespace *target_ns)
 	}
 	return false;
 }
+EXPORT_SYMBOL(current_in_userns);
 
 static inline struct user_namespace *to_user_ns(struct ns_common *ns)
 {
-- 
2.7.4

