From: xiakaixu1987-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [PATCH] mm: memcontrol: Assign boolean values to a bool variable
Date: Sat,  7 Nov 2020 16:24:55 +0800
Message-ID: <1604737495-6418-1-git-send-email-kaixuxia@tencent.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=JHHlZp1uRQshZtVOevTd8kVtiW2laSXxZhJcCQo5cWA=;
        b=F6LWRqEvicBf2UN13VB/7aC+ImV1y7V/8eAIjVqjWAEwNwPrnYcDIfH2BaMMj9E2ip
         IflIZc+QBAEB8h6loN1v83UhaNc84Af6eIT42giwMAUXHbeaUCGX3rvDIVgUelI71jU+
         95Jh1Grak51pUzoFZ4LI4Vi2g93k8rgEUr6wh2iThMlZmZvmLUv0KCPtyI+4jtS+TTdp
         m80cSSptzouL5UKP3d7FEzyvu7akyhNQ5VXuct/ShmWhKWc8X8jMpsMecOLELB9aK9Qh
         bYlpdLiVGoJBXeZN1pEepSPZpxe39XZmEGZ5UqhbBadEAWx0ymNvUZc00wJs00Ln99R2
         aYhA==
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kaixu Xia <kaixuxia-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

From: Kaixu Xia <kaixuxia-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

Fix the following coccinelle warnings:

./mm/memcontrol.c:7341:2-22: WARNING: Assignment of 0/1 to bool variable
./mm/memcontrol.c:7343:2-22: WARNING: Assignment of 0/1 to bool variable

Reported-by: Tosk Robot <tencent_os_robot-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
Signed-off-by: Kaixu Xia <kaixuxia-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
---
 mm/memcontrol.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 3dcbf24d2227..60147cf9f0c0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -7349,9 +7349,9 @@ bool mem_cgroup_swap_full(struct page *page)
 static int __init setup_swap_account(char *s)
 {
 	if (!strcmp(s, "1"))
-		cgroup_memory_noswap = 0;
+		cgroup_memory_noswap = false;
 	else if (!strcmp(s, "0"))
-		cgroup_memory_noswap = 1;
+		cgroup_memory_noswap = true;
 	return 1;
 }
 __setup("swapaccount=", setup_swap_account);
-- 
2.20.0

