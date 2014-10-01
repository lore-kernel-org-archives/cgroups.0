From: Paul McQuade <paulmcquad@gmail.com>
Subject: [PATCH] mm: memcontrol Use #include <linux/uaccess.h>
Date: Wed,  1 Oct 2014 16:44:56 +0100
Message-ID: <1412178296-2972-1-git-send-email-paulmcquad@gmail.com>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=9vbTFw2j9qg9w7ROamDtBFKGRNHx1Ws98NYTzPRtJhE=;
        b=FDRJahS+f7Fm1+lKrOtZCkMpyk3oZVxL3vbhuHIXBIsKJA++rpXa9P6Q7/FbU/4LSz
         bke/iaGxVr36XsCOr2+8Glp3mZm59xCXiSlxLuOAOTYwZFUt3sNbZ1Yf2qivtSK83nRh
         TO8h6mNtS3p1VieAwQK/xYVX1Oaol2Kzgqows+L74+bqDfI3CHV1aPX7hdJOGsjpJFlV
         Hl1MmCXK3sjZKMOOMLzlgnLBEhXZ7Zx2RN+TNomsXgIoxrU/U+msXyrLBamZ2Yd+9KNb
         Q+YQlvZViFA2Fd3kAlbqlKzL5jGabQ6O6GhVNrZgXMsl04D8ifIoieZ46JIH1DIO8GTf
         Fl5Q==
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: paulmcquad@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, mhocko@suse.cz, hannes@cmpxchg.org

Remove asm headers for linux headers

Signed-off-by: Paul McQuade <paulmcquad@gmail.com>
---
 mm/memcontrol.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 085dc6d..51dbe80 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -56,14 +56,14 @@
 #include <linux/oom.h>
 #include <linux/lockdep.h>
 #include <linux/file.h>
+#include <linux/uaccess.h>
+
 #include "internal.h"
 #include <net/sock.h>
 #include <net/ip.h>
 #include <net/tcp_memcontrol.h>
 #include "slab.h"
 
-#include <asm/uaccess.h>
-
 #include <trace/events/vmscan.h>
 
 struct cgroup_subsys memory_cgrp_subsys __read_mostly;
-- 
1.9.1

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
