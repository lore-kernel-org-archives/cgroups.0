From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup fixes for v5.13-rc5
Date: Thu, 10 Jun 2021 10:26:06 -0400
Message-ID: <YMIg/rC1TQwEbabA@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=YYyA+u2JrqmC9amIVXsT8BB5KdG2CQQsjkKxF0Ahoms=;
        b=dssxtbkSR9bCMY/1rfIRMRk1bu9I0aZD611EoRiJJlUeBPt50BdypNazxvdeuaM5+p
         XG2rykNMHVnJfDPHmFTF1RUHwjeXDcY6rdfLwbAH2Ob48Fl9DqwCM9ur0EHnskj0OSzW
         SBNMAt+XXHV2zqfUBTlI/aRRv3MLm7FDd/uTUSvtlMYWntF5c/q1oW2RL63T8UxgU6/9
         yRi6bx6jxwddTXg/exchgebgpfqFFDoI5EHT66y3UUdJiJc1m/fpNBEKHRreVZ119kTC
         nn8OWUOdVRyPKA9kZv0a7XORSD98YTo/VFm5LTze4UGfyMnH090KBytCJJJpNjkshgC0
         FOig==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Linus.

This is a high priority but low risk fix for a cgroup1 bug where rename(2)
can change a cgroup's name to something which can break parsing of
/proc/PID/cgroup.

Thanks.

The following changes since commit 08b2b6fdf6b26032f025084ce2893924a0cdb4a2:

  cgroup: fix spelling mistakes (2021-05-24 12:45:26 -0400)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-5.13-fixes

for you to fetch changes up to b7e24eb1caa5f8da20d405d262dba67943aedc42:

  cgroup1: don't allow '\n' in renaming (2021-06-10 09:58:50 -0400)

----------------------------------------------------------------
Alexander Kuznetsov (1):
      cgroup1: don't allow '\n' in renaming

 kernel/cgroup/cgroup-v1.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 8190b6bfc978..1f274d7fc934 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -820,6 +820,10 @@ static int cgroup1_rename(struct kernfs_node *kn, struct kernfs_node *new_parent
 	struct cgroup *cgrp = kn->priv;
 	int ret;
 
+	/* do not accept '\n' to prevent making /proc/<pid>/cgroup unparsable */
+	if (strchr(new_name_str, '\n'))
+		return -EINVAL;
+
 	if (kernfs_type(kn) != KERNFS_DIR)
 		return -ENOTDIR;
 	if (kn->parent != new_parent)
