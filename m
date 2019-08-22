From: Yizhuo <yzhai003@ucr.edu>
Subject: [PATCH] mm/memcg: return value of the function mem_cgroup_from_css() is not checked
Date: Wed, 21 Aug 2019 23:22:09 -0700
Message-ID: <20190822062210.18649-1-yzhai003@ucr.edu>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=ucr.edu; i=@ucr.edu; q=dns/txt; s=selector3;
  t=1566454911; x=1597990911;
  h=from:to:cc:subject:date:message-id;
  bh=te6sDAmETT+7Bh5fmhANTjsc/hBDg1ooMbPzRFeOAW8=;
  b=tYK2Nlmvx6g2jGM/kMmeH1TzqqfCKIxmoiKzLhR2sJIi747Gy6juJL73
   J2fDAoE+a/4Vds29381skKeXFu8CIf4Uy0FUSNIr+diqItkds4QkBMMAo
   VxPZliq7dN8/GTDmEAMPl3rmTDSsXePHamHqzOpyQl2j52a3RmlPVIBM0
   c2kuzDNezBlWCi09156th0cgmSd0ebL/rdymRlG/fl0ggFxFbEg5hxwRw
   gDG/1YBwDtfUZbVn+UCOoBpLdxwIZPIiV8e7VKZ/yAFxlM+eyvmLGMsr4
   RghjQeEposawxAraWb4xR3zcPLbQ3jwCk6jSSn3tI9o2AYKDGR07gLvYk
   A==;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: 
Cc: csong@cs.ucr.edu, zhiyunq@cs.ucr.edu, Yizhuo <yzhai003@ucr.edu>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

Inside function mem_cgroup_wb_domain(), the pointer memcg
could be NULL via mem_cgroup_from_css(). However, this pointer is
not checked and directly dereferenced in the if statement,
which is potentially unsafe.

Signed-off-by: Yizhuo <yzhai003@ucr.edu>
---
 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 661f046ad318..bd84bdaed3b0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3665,7 +3665,7 @@ struct wb_domain *mem_cgroup_wb_domain(struct bdi_writeback *wb)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(wb->memcg_css);
 
-	if (!memcg->css.parent)
+	if (!memcg || !memcg->css.parent)
 		return NULL;
 
 	return &memcg->cgwb_domain;
-- 
2.17.1

