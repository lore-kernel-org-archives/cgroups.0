From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH cgroup/for-6.0-fixes] cpuset: Add Waiman Long as a cpuset
 maintainer
Date: Tue, 6 Sep 2022 06:58:25 -1000
Message-ID: <Yxd8MUTOPbxvZVOk@slm.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :sender:from:to:cc:subject:date;
        bh=dyT2g59rUzulB+5aRGJcwTyIEc/5vl4B4tRvr2YBao4=;
        b=NfbjvVMxPPL7Dy613X81VrnkQmnmjHUtnljibbjjtpTvw9wvfljsZw5JSjDsxdaB8K
         WU4wUYSV50CRpMj5k/n0BYFscvLZWYkqcG7TeArCU85/Co+VjMEj6XSZhknRUmggElDB
         p0n5uVQl6z4Xvqx5V4nBG7iwfNq29Wx8dAF8cH53rtLsVCOpRUB/i1sxvOdIXp9XimXK
         GFRWkwrEwcDGPwCr37vthmcvu2NDvzFLHuB/SiFfC2C9DqD6rGUPAxntv8gaObjpTS7b
         HoDomdGTOnPNdcRK3Jr9Y4aCFXhY2/nUgt9brp/jhDRXRsO1EfAjf2L3xhVWCePjRlfe
         TS0g==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Waiman has been very active with cpuset recently and I've been cc'ing him
for cpuset related changes for a while now. Let's make him a cpuset
maintainer.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index d30f26e07cd3..336bf8b97123 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5245,6 +5245,7 @@ F:	block/blk-throttle.c
 F:	include/linux/blk-cgroup.h
 
 CONTROL GROUP - CPUSET
+M:	Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
 M:	Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
 L:	cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
 S:	Maintained
-- 
2.37.3

