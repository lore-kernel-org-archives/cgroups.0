From: zhaoxiaoqiang007-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] cgroup: remove cgroup_mount from comments
Date: Fri, 16 Jul 2021 17:18:53 +0800
Message-ID: <20210716091853.1049-1-zhaoxiaoqiang11@jd.com>
Reply-To: zhaoxiaoqiang007-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:reply-to:mime-version
         :content-transfer-encoding;
        bh=uDUNa0EcB9Oof2rQJyV0DbNI25r/rWDu0m3opyTl7Y4=;
        b=Zm8GGZrZI8+jWXAZOl2WF2v2GIioF9ifPmmt3UEAnyivukqQoFOFcqlnuxWEo0j6Tb
         CXu/wINeRiG8mkV9Gs7bVQDfOVfBQkoemU+MQ72ZaF2A5K87tbrCBg/dxStrLWUBH4Dj
         IJVvD/jDVnsQGGiO4WSZLZzCkL7TDd5mEH0SMayoQrNhhiBnbrWNgGzutwk0zGLZKjAI
         SswtoZHcOBdYNnKVEIHwpUiWTQ/Yi+tFOQfWhOsCmX24VorMn/Bvv/pgrKYFckB0V3oJ
         z88F367aH3xcz8N3nlBgzaeskTjmzSGkOcb2ayFotDieePcVLHXnUdo/s5h/sxJlYXpD
         cvOA==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, trivial-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, zhaoxiaoqiang11 <zhaoxiaoqiang11-zFXdYKnZPWw@public.gmane.org>

From: zhaoxiaoqiang11 <zhaoxiaoqiang11-zFXdYKnZPWw@public.gmane.org>

Git rid of the inappropriate comment

Since cgroup is fully switched to fs_context, function cgroup_mount
is removed and it's confused to mention in comments of cgroup_kill_sb.
Just wipe it out.

Signed-off-by: zhaoxiaoqiang11 <zhaoxiaoqiang11-zFXdYKnZPWw@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 3a0161c21b6b..d0725c1a8db5 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -2169,7 +2169,6 @@ static void cgroup_kill_sb(struct super_block *sb)
 	/*
 	 * If @root doesn't have any children, start killing it.
 	 * This prevents new mounts by disabling percpu_ref_tryget_live().
-	 * cgroup_mount() may wait for @root's release.
 	 *
 	 * And don't kill the default root.
 	 */
-- 
2.27.0

