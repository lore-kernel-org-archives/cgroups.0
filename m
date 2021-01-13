From: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: [PATCH v2 2/2] MAINTAINERS: Update my email address
Date: Wed, 13 Jan 2021 16:59:42 +0800
Message-ID: <f8fe9c3b-db08-50da-d207-0952be5d2b85@bytedance.com>
References: <75494a75-a74b-3dba-9846-7f51d805023a@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=khY3b9nNLG3pn8j5ObMad/IKodRFErErRiM9bDM1Hc4=;
        b=m6cG2SZeoQC7z+233pF69aduzYVErPg7kpJnAwKckGrYeox/3cz6OJTflqkC44PiAA
         Ua3Dnyw7IzJqquKUSYJT8KQNhPwx/nBUt+TMamSiADca5useKtiXMpzEHpsr0yAW9muC
         jeANNgo8BBvZTjbXVu0nauEXPnwXC+FSgBVFUQYVJwMwOYOo9saJkLZD6BIkz7JDKVR2
         pLzx/RtBzX8qVvXQ5W1+1ttaxU+EtbysSUCzkXMVGYWcUD+i61vC9rRSD4ttddp5Jesx
         uxlQgYEDUlk/5/yBIopyVL7CSZ2GQ+AMakMnm7G6Dx2eldCI/JXBv3SwktDO5jhdL+ej
         QURA==
In-Reply-To: <75494a75-a74b-3dba-9846-7f51d805023a-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Steve Wahl <steve.wahl-ZPxbGqLxI0U@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Signed-off-by: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
---
 MAINTAINERS | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2a01cd3e0a2b..4987d1ce9ac6 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -4448,7 +4448,7 @@ F:	include/linux/console*
 
 CONTROL GROUP (CGROUP)
 M:	Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
-M:	Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
+M:	Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
 M:	Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
 L:	cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
 S:	Maintained
@@ -4472,7 +4472,7 @@ F:	block/blk-throttle.c
 F:	include/linux/blk-cgroup.h
 
 CONTROL GROUP - CPUSET
-M:	Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
+M:	Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
 L:	cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git
-- 
2.11.0

