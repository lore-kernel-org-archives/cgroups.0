From: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/2] memcg: use existing function to judge root mem cgroup
Date: Fri, 22 Jun 2012 19:57:22 +0800
Message-ID: <1340366243-28104-1-git-send-email-liwp.linux@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer;
        bh=WHDKhTXldJq1UBB0QbmMOGrPDsth+ta07R9BML1AY7k=;
        b=lQ9z6bCRXfnrBHE0G5xQk8cRPUKrsgIL8V2Qbn3G161XPlESMdDSyFUqBmSn71oH8F
         OrLLcdCwLoVSe5vSBe/DRZlziBgHE/DDoeOhuQS2yTZFxrbiwBjaeg9uVys45Yf6kLPv
         CqUPbce5yw6NZ0yKh+sExOPmc/i/Lfa6srnbaHVbel9ONltTJxmeOmj79UETKLaiZViG
         VGZWCAANV73r+9rFY/nHFxV/cKpj/Nu2TDFmYgWgUyZ8xlCDH2lfcCAxwstZJQBD0Wwh
         KirhtXSifCyAGJfPZZrgcmwiHCHGyvV+yeNHl3BKhCUTVGfu9ibV4kCnVsBg6Lr9kPJT
         1WSw==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Han Ying <yinghan-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Aneesh Kumar K.V" <aneesh.kumar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Hiroyuki Kamezawa <kamezawa.hiroyuki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

From: Wanpeng Li <liwp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

Signed-off-by: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 mm/memcontrol.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index f72b5e5..776fc57 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4873,7 +4873,7 @@ mem_cgroup_create(struct cgroup *cont)
 			goto free_out;
 
 	/* root ? */
-	if (cont->parent == NULL) {
+	if (!(mem_cgroup_is_root(cont))) {
 		int cpu;
 		enable_swap_cgroup();
 		parent = NULL;
-- 
1.7.9.5
