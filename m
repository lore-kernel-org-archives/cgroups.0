From: "Gustavo A. R. Silva" <gustavoars-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH v2][next] cgroup: Avoid -Wstringop-overflow warnings
Date: Wed, 16 Aug 2023 14:50:16 -0600
Message-ID: <ZN02iLcZYgxHFrEN@work>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692218954;
        bh=QhCtYfiJ9yBB45D2p9WLrwsVABEKS7Yy1YuV43E9miY=;
        h=Date:From:To:Cc:Subject:From;
        b=YYXkS7RB8V3DfstWtUpMXDOwDYXeMsme42+Th5r4ciFC0XHeDyeC7yF4yYkYL07/C
         nh0H0ixa8/E7G4o1KWy6KTS8nleyaYZtjrS7n4zThJPNxlCtWphu0/2DhJ5rvcsUvv
         En5Lftv7G82VY6EbMAhd5R3/zd4tAM1waeqV6gQoy1tId82G3vhZVS0g7Cykqw0YIo
         v5E75hT3CuCBL6At1WU8zcw51jtWTKCiDDFTrfok/IQYQeMm5HDb7A3xSXhd1OTJVa
         Z6LAoF13N3IclI8WX5Srfdpvbivd+9Obz4BV31xaxjM3qLo/VpO7DzI1G88iSfnx6v
         j/rUi8HQTs2UQ==
Content-Disposition: inline
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Gustavo A. R. Silva" <gustavoars-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-hardening-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Change the notation from pointer-to-array to pointer-to-pointer.
With this, we avoid the compiler complaining about trying
to access a region of size zero as an argument during function
calls.

Address the following -Wstringop-overflow warnings seen when
built with ARM architecture and aspeed_g4_defconfig configuration
(notice that under this configuration CGROUP_SUBSYS_COUNT == 0):

kernel/cgroup/cgroup.c:1208:16: warning: 'find_existing_css_set' accessing 4 bytes in a region of size 0 [-Wstringop-overflow=]
kernel/cgroup/cgroup.c:1258:15: warning: 'css_set_hash' accessing 4 bytes in a region of size 0 [-Wstringop-overflow=]
kernel/cgroup/cgroup.c:6089:18: warning: 'css_set_hash' accessing 4 bytes in a region of size 0 [-Wstringop-overflow=]
kernel/cgroup/cgroup.c:6153:18: warning: 'css_set_hash' accessing 4 bytes in a region of size 0 [-Wstringop-overflow=]

This results in no differences in binary output.

Link: https://github.com/KSPP/linux/issues/316
Signed-off-by: Gustavo A. R. Silva <gustavoars-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
Changes in v2:
 - Use pointer-to-pointer instead of pointer-to-array.
 - Update changelog text.

v1:
 - Link: https://lore.kernel.org/linux-hardening/ZIpm3pcs3iCP9UaR@work/

 kernel/cgroup/cgroup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index ccbbba06da5b..68e2d9812e3f 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -929,7 +929,7 @@ static void css_set_move_task(struct task_struct *task,
 #define CSS_SET_HASH_BITS	7
 static DEFINE_HASHTABLE(css_set_table, CSS_SET_HASH_BITS);
 
-static unsigned long css_set_hash(struct cgroup_subsys_state *css[])
+static unsigned long css_set_hash(struct cgroup_subsys_state **css)
 {
 	unsigned long key = 0UL;
 	struct cgroup_subsys *ss;
@@ -1070,7 +1070,7 @@ static bool compare_css_sets(struct css_set *cset,
  */
 static struct css_set *find_existing_css_set(struct css_set *old_cset,
 					struct cgroup *cgrp,
-					struct cgroup_subsys_state *template[])
+					struct cgroup_subsys_state **template)
 {
 	struct cgroup_root *root = cgrp->root;
 	struct cgroup_subsys *ss;
-- 
2.34.1

