From: Qian Cai <cai@lca.pw>
Subject: [PATCH v2] memcg: fix a bad line
Date: Fri,  1 Mar 2019 09:37:34 -0500
Message-ID: <20190301143734.94393-1-cai@lca.pw>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=u8p6LEaICK87ZAl5dajNGBnd4suIRJImycTZiVBF6mk=;
        b=CXOdZ1qkJEFpDrXmIdbDFbUBBQDnKKwxBoNzQ/nl3UExKo92Qa5WMRtSjviMKpm2rv
         SFoAwTu2thb0beEIxDaXIYP7hZRt9TAWPTy3RW9m6utlnE/sNtmF3tBU7yr5biidOdS1
         CO0cgbA2BXHGnDZTJRrviplkxPAbjiz4PgAL9bneX/QvIEMs/unePVw0WOAz+mapodzN
         hQLgQxaYUNtpH4TrOzljElp03YViaHMFr/8yYAzXxLPhu5EnN72Fghckv+RmBkv8Fuxi
         59CTQYerYdDzTr/vEKgECB9mHb9kaPaFTTp4+PlThUbZlRvcN0BDSDjruZ7JdkjD04vv
         7yLQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm@linux-foundation.org, hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com
Cc: guro@fb.com, jrdr.linux@gmail.com, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Qian Cai <cai@lca.pw>

The commit 230671533d64 ("mm: memory.low hierarchical behavior") missed
an asterisk in one of the comments.

mm/memcontrol.c:5774: warning: bad line:                | 0, otherwise.

Acked-by: Souptick Joarder <jrdr.linux@gmail.com>
Signed-off-by: Qian Cai <cai@lca.pw>
---

v2: improve the commit message.

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

