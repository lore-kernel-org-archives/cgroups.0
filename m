From: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH] cgroup: simplify cleanup in cgroup_css_set_fork()
Date: Tue, 23 Aug 2022 11:11:47 +0200
Message-ID: <20220823091147.846082-1-brauner@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661245950;
        bh=LY81cFa6Hp4+F4iWQfiCKjYWO2rDP4Jd5dOawMq0Nwc=;
        h=From:To:Cc:Subject:Date:From;
        b=O1Nt4fZnBO7pCWJ/0YHn8T1JzK6MWOqu5yTXEIaBYiqT0dttiA3Qqc18OeDWBBfUO
         C51XPExzytdanQidC5odOytcYLreYfrUtJ4eNZINIiccECXDVD1K/Bln8WjKiCZL9D
         cZQoXlSi84L3WUku3WM5PHKtTEhAYSEOf5nXgVYWMb1Am7+XVKstDO5nIiDVqZm0IJ
         Yk9kQx80VP3sxwz2ShXwXSIPJKbkVe4PMLhRnp3hILbIN3uwwXL+1ovtHIoCgLKEll
         2J5nA1cuwS0H6Ce3xpePezQ0R2NJL/b85HlQUf8tGruXaUy+cFMQVoKILOsjSdnz/v
         MusWPaylvnNdw==
X-Developer-Signature: v=1; a=openpgp-sha256; l=1071; i=brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; h=from:subject; bh=LY81cFa6Hp4+F4iWQfiCKjYWO2rDP4Jd5dOawMq0Nwc=; b=owGbwMvMwCU28Zj0gdSKO4sYT6slMSSzzLzQP32L86RLDx4I+fmUX7394sfmqUvezvyR9Ozy5XSb +feKbnaUsjCIcTHIiimyOLSbhMst56nYbJSpATOHlQlkCAMXpwBMZPZDhv8uX97fPepWzy6w6yvPqf lsravWppnIh4Tt1+bh0OAskRZh+Mk471n6/nVC4bxP9qcsVknOK/1pe+5I/inp591rrxxZk8QPAA==
X-Developer-Key: i=brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; a=openpgp; fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>

The call that initializes kargs->cset is find_css_set() and it is the
last call in cgroup_css_set_fork(). If find_css_set() fails kargs->cset
is NULL and we go to the cleanup path where we check that kargs->cset is
non-NULL and if it is we call put_css_set(kargs->cset). But it'll always
be NULL so put_css_set(kargs->cset) is never hit. Remove it.

Fixes: ef2c41cf38a7 ("clone3: allow spawning processes into cgroups")
Reported-by: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Signed-off-by: Christian Brauner (Microsoft) <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index ffaccd6373f1..2ba516205057 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -6247,8 +6247,6 @@ static int cgroup_css_set_fork(struct kernel_clone_args *kargs)
 	if (dst_cgrp)
 		cgroup_put(dst_cgrp);
 	put_css_set(cset);
-	if (kargs->cset)
-		put_css_set(kargs->cset);
 	return ret;
 }
 

base-commit: 1c23f9e627a7b412978b4e852793c5e3c3efc555
-- 
2.34.1

