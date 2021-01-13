From: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: [PATCH 1/2] MAINTAINERS: Remove stale URLs for cpuset
Date: Wed, 13 Jan 2021 16:49:51 +0800
Message-ID: <75494a75-a74b-3dba-9846-7f51d805023a@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-transfer-encoding;
        bh=GmUxp2i9/ls4jbfKHAxa1rq9T2F6H/PzjNNAVFN28no=;
        b=Qx2TyElpWLNjYbk8m/+90E+AZnuXQ8WXuUpuX0eAPizIX/Mha1z7a6K6YofaVUWg2h
         T84cFo3H+Uv8POrtug45HUfPwwklSnYZ/LiHWEZiqg9ldhfOmuLzTlucKSEbeIxnJUtr
         em2v8fCzERnyXk1MMX0DirsvwWS1XOx4DdsQBZZIn2ERNBmMZx/qJ/GAlRHn/9Gv90hb
         NODDr/qA/2D/GlN6OzzmEbNrGqN9TsGu3EIHwXTF2ZyL95xdwHPqilukdQfz+VsFvrBb
         FeyBhtFHm5/UXuqzzS7kXPScpPwWYYJSfyl6qmT0YyQbX8+yWMlvW+9LS4HEp+AE2BtY
         UpjQ==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Steve Wahl <steve.wahl-ZPxbGqLxI0U@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Those URLs are no longer accessable.

Reported-by: Steve Wahl <steve.wahl-ZPxbGqLxI0U@public.gmane.org>
Signed-off-by: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
---
 MAINTAINERS | 2 --
 1 file changed, 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 546aa66428c9..89140540aa8d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4494,8 +4494,6 @@ CONTROL GROUP - CPUSET
 M:	Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
 L:	cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
 S:	Maintained
-W:	http://www.bullopensource.org/cpuset/
-W:	http://oss.sgi.com/projects/cpusets/
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git
 F:	Documentation/admin-guide/cgroup-v1/cpusets.rst
 F:	include/linux/cpuset.h
-- 
2.25.1

