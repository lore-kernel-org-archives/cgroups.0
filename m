From: Nicholas Krause <xerofoify@gmail.com>
Subject: [PATCH] mm:Return proper error code return if call to kzalloc_node falis in the function alloc_mem_cgroup_per_zone_info
Date: Mon, 29 Jun 2015 11:46:53 -0400
Message-ID: <1435592813-24499-1-git-send-email-xerofoify@gmail.com>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=x9vvbM1Mgk6PfqXAJDAGdbPdIfpatAAN313t6YYG+iY=;
        b=el2xpA9f8OhKMl3KUf7Zsxl/UAZZ0IM7xsSHrOrtha187OnnqzzEQ08gotLVDT2F1b
         MhLkBNarvgJjiE33e7wgGuYTlphR4MhQUw1OZIKIAymespiRzvfXK0hdUCjYj3VE7sZf
         DYqeTv/NPIuZfH+XRxC6MsWyOyRfBDtw0adyeRDsA1L19MbMF+FduqPD8g1uWT/aDfIa
         uIdaSfaAl0yo5ENwN4AHCeN+hquVr7Osxosfoh+8Tn6fr5AJvM0qU5uLmYJthuUHg3aF
         Vbf9+dvYexaY1juHAfr+y/sPoBrcGJeNEILz3mG0qZUNE5LjyG2XJQ6114GpZF0i2DVF
         ZPHQ==
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes@cmpxchg.org
Cc: mhocko@suse.cz, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

This changes us returning the value of one to -ENOMEM when the call
for allocating memory with the function kzalloc_node fails in order
to better comply with kernel coding pratices of returning this
particular error code when memory allocations that are unrecoverable
occur.

Signed-off-by: Nicholas Krause <xerofoify@gmail.com>
---
 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index acb93c5..4e80811 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4442,7 +4442,7 @@ static int alloc_mem_cgroup_per_zone_info(struct mem_cgroup *memcg, int node)
 		tmp = -1;
 	pn = kzalloc_node(sizeof(*pn), GFP_KERNEL, tmp);
 	if (!pn)
-		return 1;
+		return -ENOMEM;
 
 	for (zone = 0; zone < MAX_NR_ZONES; zone++) {
 		mz = &pn->zoneinfo[zone];
-- 
2.1.4

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
