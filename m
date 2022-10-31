From: "Jiri Slaby (SUSE)" <jirislaby-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH] block/blk-iocost (gcc13): cast enum members to int in prints
Date: Mon, 31 Oct 2022 12:45:20 +0100
Message-ID: <20221031114520.10518-1-jirislaby@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667216723;
        bh=/nzQwQ7t8fEd/Xbji8T5TlBeyziGmIQJxHg8N9W/ml4=;
        h=From:To:Cc:Subject:Date:From;
        b=di1R1BCGvDv5KIfYWJ/0WhYLVQzNM99ivj4PXRekT4VkQArg598dXS6df8fUPt/qy
         PL7JlHCF5TrQNlt3ISUO9gHqjDWWpnPw59eVNi+FnE3fdzrdJwgelZYr/afK5L3XED
         1pzWTJ7nkI2/uAXIJxOcL0Dav5rcI9YuEo0A+RLi4JgST/jFmnjJP01UiUjrVDVT+P
         mVRYq+GU/7y1c+/YSLmuUlnkBzD0IB9LQH5DMOAhzOis2HHkm43zRFeUMhdJMxH5ST
         yhcLFqhAA7VpSOeTeuObjthPMQHzBdvW3rwzZFb8ml+x7C9qatEeJXaez50ykda6cH
         q+lcUjCfNPo/g==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Jiri Slaby (SUSE)" <jirislaby-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Martin Liska <mliska-AlSwsSmVLrQ@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Since gcc13, each member of an enum has the same type as the enum [1]. And
that is inherited from its members. Provided:
  VTIME_PER_SEC_SHIFT     = 37,
  VTIME_PER_SEC           = 1LLU << VTIME_PER_SEC_SHIFT,
the named type is unsigned long.

This generates warnings with gcc-13:
  block/blk-iocost.c: In function 'ioc_weight_prfill':
  block/blk-iocost.c:3037:37: error: format '%u' expects argument of type 'unsigned int', but argument 4 has type 'long unsigned int'

  block/blk-iocost.c: In function 'ioc_weight_show':
  block/blk-iocost.c:3047:34: error: format '%u' expects argument of type 'unsigned int', but argument 3 has type 'long unsigned int'

Cast the enum members to int when printing them.

Alternatively, we can cast them to ulong (to silence gcc < 12) and use %lu.
Alternatively, we can move VTIME_PER_SEC away from the enum.

[1] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=36113

Cc: Martin Liska <mliska-AlSwsSmVLrQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Signed-off-by: Jiri Slaby (SUSE) <jirislaby-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 block/blk-iocost.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/block/blk-iocost.c b/block/blk-iocost.c
index f01359906c83..a257ba17183b 100644
--- a/block/blk-iocost.c
+++ b/block/blk-iocost.c
@@ -3034,7 +3034,8 @@ static u64 ioc_weight_prfill(struct seq_file *sf, struct blkg_policy_data *pd,
 	struct ioc_gq *iocg = pd_to_iocg(pd);
 
 	if (dname && iocg->cfg_weight)
-		seq_printf(sf, "%s %u\n", dname, iocg->cfg_weight / WEIGHT_ONE);
+		seq_printf(sf, "%s %d\n", dname,
+				iocg->cfg_weight / (int)WEIGHT_ONE);
 	return 0;
 }
 
@@ -3044,7 +3045,8 @@ static int ioc_weight_show(struct seq_file *sf, void *v)
 	struct blkcg *blkcg = css_to_blkcg(seq_css(sf));
 	struct ioc_cgrp *iocc = blkcg_to_iocc(blkcg);
 
-	seq_printf(sf, "default %u\n", iocc->dfl_weight / WEIGHT_ONE);
+	seq_printf(sf, "default %d\n",
+			iocc->dfl_weight / (int)WEIGHT_ONE);
 	blkcg_print_blkgs(sf, blkcg, ioc_weight_prfill,
 			  &blkcg_policy_iocost, seq_cft(sf)->private, false);
 	return 0;
-- 
2.38.1

