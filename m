From: Qian Cai <cai@lca.pw>
Subject: [PATCH] memcg: fix a bad line
Date: Wed, 27 Feb 2019 15:52:42 -0500
Message-ID: <20190227205242.77355-1-cai@lca.pw>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=Pqif0CrV1iUCG/KA2vWPDRwvp9OJTIFlQ54VsyglFrA=;
        b=I6JQ/yotuISU27iCbP/uRP3BXZAQTkjhUR8mLvqgVXslpFqQXt7qTFRGq59Q4nhyR+
         N4zyfRHkeZxbfUuUCjOCQUrAl+8S3gcZi4SHSM/Vwq242ev6SMYWQooULcmqx4kknsq0
         zzPv1kWgZKXquriQC1JvPAOivaQeiCCR478M+JtAHgWv5zvbRFTNCaCvW8ei4XQBJRzn
         mSaxEThp0/UAwIXc8kiQ5p2ubj9UN6nKb79wUdtsByzN5+bE1lhhdNoVnY2LKRTwB2pe
         ysup6SCRVBW9W/RaToCsKq4EdOUU16VzmsE/lBmU259HjOJKhaBqftWmm/LuYNCoT8KG
         9DsQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Qian Cai <cai@lca.pw>

Miss a star.

Signed-off-by: Qian Cai <cai@lca.pw>
---
 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index af7f18b32389..d4b96dc4bd8a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -5747,7 +5747,7 @@ struct cgroup_subsys memory_cgrp_subsys = {
  *
  *             | memory.current, if memory.current < memory.low
  * low_usage = |
-	       | 0, otherwise.
+ *	       | 0, otherwise.
  *
  *
  * Such definition of the effective memory.low provides the expected
-- 
2.17.2 (Apple Git-113)

