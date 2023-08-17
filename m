From: "Gustavo A. R. Silva" <gustavoars-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH v3][next] cgroup: Avoid -Wstringop-overflow warnings
Date: Thu, 17 Aug 2023 11:19:13 -0600
Message-ID: <ZN5WkbPelHUSTXOA@work>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692292692;
        bh=PUtRgHl3t9y/PCdYajGwcmizA+UGYBohYR7AEs0pjoo=;
        h=Date:From:To:Cc:Subject:From;
        b=qrg+XKqtRmV4/lmX29QP+7xjp0iql30uzjiD/+IZf66y5T9KcdewLTYZLNPMLLHyM
         zZuOu2SBecnTFBGa+i5d8VK1GcTirNqkjHGiCHxy0AtS5/VasEbdKajh/kCrAhRnB0
         ENAHlyX5uztjNp2p+SMQATfNTA0AjNScQgDEWtxMjBJs0Nfn9AgMsEYjz6kE4bNIOq
         cTF8302WgmW7xV7ayZzahJqkK2AT4OyN83DHtmaVZKbBwHcMOuAe5RmpNWN6yLRzw3
         HOiC+2xAbd3s9kXKmpB+C/kqsS3s5VE9PLJWxVPFgyuO30dXs6ROSxF9HEwlIKjFta
         iH27n6fLi5eIg==
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

This is a workaround to prevent the compiler complaining about
accessing an array of size zero when evaluating the arguments
of a couple of function calls. See below:

kernel/cgroup/cgroup.c: In function 'find_css_set':
kernel/cgroup/cgroup.c:1206:16: warning: 'find_existing_css_set' accessing 4 bytes in a region of size 0 [-Wstringop-overflow=]
 1206 |         cset = find_existing_css_set(old_cset, cgrp, template);
      |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
kernel/cgroup/cgroup.c:1206:16: note: referencing argument 3 of type 'struct cgroup_subsys_state *[0]'
kernel/cgroup/cgroup.c:1071:24: note: in a call to function 'find_existing_css_set'
 1071 | static struct css_set *find_existing_css_set(struct css_set *old_cset,
      |                        ^~~~~~~~~~~~~~~~~~~~~

With the change to pointer-to-pointer, the functions are not prevented
from being executed, and they will do what they have to do when
CGROUP_SUBSYS_COUNT == 0.

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
Changes in v3:
 - Update changelog text to point out that this is a workaround.

Changes in v2:
 - Use pointer-to-pointer instead of pointer-to-array.
 - Update changelog text.
 - Link: https://lore.kernel.org/linux-hardening/ZN02iLcZYgxHFrEN@work/

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

