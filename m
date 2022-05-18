From: Shida Zhang <starzhangzsd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2] cgroup: remove the superfluous judgment
Date: Wed, 18 May 2022 09:36:47 +0800
Message-ID: <20220518013647.1749568-1-zhangshida@kylinos.cn>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xx6rePJGi7UaKhXkXrJAOBEtEBFBD4Xp8h1aCNNQ5pk=;
        b=UQsNDu+K3TL0RoWiqYU8aJzPlG4KoKs+NqzgTjzA9gmgB35p+OeNfvgvxiT+Otn5ux
         jI5s5WqirBU7Jhbz2L+2B+EJXfZ2e4Cs3jAZ/A0cQMHaqEnA96dxbK2nCn7UlGNwaamT
         vImHt36Kj+bSNIwtjD+WJcqbXUskciCiPM1BbywHDZQvN8JxmTzU2MFyqB3E1OqyDLPZ
         vO8A3/HfT0FQ0B2vxv1qWYmZKph3LyIe5s/jDZcMgrwyx4sty97N81e32k6rigUqWKIh
         CeBuaUr31rQy/LHnS/aJHG3hlw7k5cwRtGBd4X70mYiDYzbWzv3/zupNOkklKPlQW7CU
         Cu/w==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: zhangshida-UOlijcLmZ/InDS1+zs4M5A@public.gmane.org, starzhangzsd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Remove the superfluous judgment since the function is
never called for a root cgroup, as suggested by Tejun.

Suggested-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Signed-off-by: Shida Zhang <zhangshida-UOlijcLmZ/InDS1+zs4M5A@public.gmane.org>
---
 Changes from v1:
 - Just remove the superfluous judgment instead.

 kernel/cgroup/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index adb820e98f24..7d8a463c461b 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -5685,7 +5685,7 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 	css_clear_dir(&cgrp->self);
 	kernfs_remove(cgrp->kn);
 
-	if (parent && cgroup_is_threaded(cgrp))
+	if (cgroup_is_threaded(cgrp))
 		parent->nr_threaded_children--;
 
 	spin_lock_irq(&css_set_lock);
-- 
2.25.1

