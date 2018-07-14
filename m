From: Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH] mm: avoid bothering interrupted task when charge memcg in softirq
Date: Sat, 14 Jul 2018 16:32:02 +0800
Message-ID: <1531557122-12540-1-git-send-email-laoar.shao@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=Akf5sLt8347RHVY+scAnPDa1ovmW923VlqnFnICc500=;
        b=urtRXWaM4QG2OkH5hzq0uiTLDIL43VY6FuA6MHz191bAZLEF8HbzrtRkY0Gas3f9ck
         w/jWZ+GaX/B51oJO5hHpZLv4Pj0+kUv6yEVKaSOLy3HH20P3TMuHpr0Mm+/o7CYhWiGT
         CKPoxvD/wyDqZVOcWTRMk8DPwux9wuP62FY/L0ERhebYDM/RuQqNVVBleUFBdYjrb7tv
         ip/xzq2VEBHcjHjSq3kwYT7XXBRKGMdvtgOXyDk7oTyeciEvMvfWk7L4Vx4eBO+3OuAl
         zzmRM8vYTNQEYtyDVGnJo5Rne+5Lgz2bR+V+T+b3Xter3mZ69VkP9n8/kx99+gWnAqrk
         q/Iw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>

try_charge maybe executed in packet receive path, which is in interrupt
context.
In this situation, the 'current' is the interrupted task, which may has
no relation to the rx softirq, So it is nonsense to use 'current'.

Avoid bothering the interrupted if page_counter_try_charge failes.

Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 mm/memcontrol.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 68ef266..13f95db 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2123,6 +2123,9 @@ static int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
 		goto retry;
 	}
 
+	if (in_softirq())
+		goto nomem;
+
 	/*
 	 * Unlike in global OOM situations, memcg is not in a physical
 	 * memory shortage.  Allow dying and OOM-killed tasks to
-- 
1.8.3.1

