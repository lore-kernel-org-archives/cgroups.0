Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1480238CFFA
	for <cgroups@vger.kernel.org>; Mon,  8 Jun 2026 06:36:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780900614; cv=none; b=BNae9t6dn20Fe5RyNfAyAPQvSPgaDRV/DuKqhrzW+8wESmtw23R4ZgcdGdHYhQMDNTTAZXKHXOgB+FGu2Pq5fWyAr0xIJsUqg5ydHUzPa8kxDYaXbESPFKpBPxlFbAM0c7n6wSrrbeJz8XicHUDC2NtLXTbLUIghQrg3Pq0zmlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780900614; c=relaxed/simple;
	bh=CZuXo67fJvF6hBwz8qT/sDwTUPQ/oq7c4Qo2m0qAU3k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=AG88agz34BD7jJBV6WdBVaorHoDb+qY/hjyufifvXJQVUloaHzXDnkHLPCrtNFAxhkImLFk7ry3qspg6gmLNny6hdLmeEHS3x126hkOybfhopS7ZQ9HRqVprDRATp/CM47ee/tDMfm/XYMTcifAS//zVIsN6myS/S4aUJL/gkb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cVxWTZtT; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cVxWTZtT"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2c132ac5ec2so38576965ad.1
        for <cgroups@vger.kernel.org>; Sun, 07 Jun 2026 23:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780900610; x=1781505410; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mbMuCvI13wK+vW6caoDnTbULN6HvH/7zcFjXyiZbrkQ=;
        b=cVxWTZtTRJTx/i79FPwukC/PfqVBSBVwugRul7V0xpC0gv4XVPXr2aH0i5LLd32sWM
         +izEVKAjiDr8CfWitGXfD95iSTxJHuJ7He5oBZ9nufkdzCyhY3WTYotzNRvvK9VswziY
         GjgPP+Y8wXyq5DI6j5zwGjrAmGb5sDIXMkgNXp59+o4AXZbMFuWGo2cbh1gDLqMsBzdj
         x2mAyfzL4IUHHjPw54b65rUeNc90qtFvPdfA8prIadkT8DulGTmxbwpiC6+pNCNtG4wU
         kr2v1GcwIhqbzLkhJWRyCzDJCF7tG06OGJJCl4T9SZvWrQBtjFmMt+uumuJlibSf0u66
         wz/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780900610; x=1781505410;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mbMuCvI13wK+vW6caoDnTbULN6HvH/7zcFjXyiZbrkQ=;
        b=bAW2bmIc7cIT9Kf+ii+DuACZFIHIjtfiJRbzznj67c3GmskIP6BdrejUH3o6/iD+tJ
         B44HGIL2K6UigbwMg6e/f0rahNh6IZlRfuhVpY3gTFm8RrwvuAzkjVjTMA/ClUsWkSdq
         M3vwPzxTlq//zaSD3zeVLOVx4WZ+9xrcj/3YoXArrXzbNQh67KGQZS+0CQ1nGnnDD49q
         WIepkTZyN99nR2HEJJzqYkWkQ9BcoULt0FdzqZCZNNcCC5ZQBhOAAQAxWinUMg1AcKO+
         +XJH6QfA5Tt/4kXpjealSkPOWkZO2xkVGIqQ3uFJ/UtLPpWotB9gz7At0XhEViF1dldq
         m8Zg==
X-Forwarded-Encrypted: i=1; AFNElJ8TatGvcuD9/xgQwt29mMW3sSSfZZ+blbu4PeDNaTYE2m8L2Al/rEEScdy30hGgtaMxyqLYV3PG@vger.kernel.org
X-Gm-Message-State: AOJu0YwKRqTbT7hyQn4TZUooR2UdP3OJz1A99wqghfrCSTABR7C64s2V
	aPn9zvE9LSdX/NiNaMH27AmyCAULAH0oc26MVrNMmQNQrbtmg96uJIPf
X-Gm-Gg: Acq92OEcDkg8ssuhnuq3+dy/luOlUd8vPRW/tKzj0vHu5SzgX8PJA8RmYIKtuFarEYk
	ZwskhYhlgou9Wn56fySiD7hFHEDfMwC260JeTW++asuepG2tYBbJ7KI8Ta8Y9BtRv3klzlFzRsY
	dlLUM35J8SYUzb0ycKy4y0rLs7NfN5S/yPsDfjOupc4bOb5X5Et5YaGfeu3deqoBqynFz/AoNI3
	jwTQae4KFGZZY+Z8XJsCPKRjZbfFwZije6/dx517UmN1sJvTQbNRSpI3pV2OE2hT0tHIQQfOVpM
	rHymsvppa7uKO9RCkQnNxkieVbHJnCsastGUlHtSsWwRSCbspOoPUlyfDuPI+dwR+sYBhwoLNfY
	TWhYNIvD8sQJUQPub4oiXQJZOhzGENtFTh6UDWvNZ9sf0Gc5r8sy3SDVWtueoKjrBN0XP+9o/FL
	pGXNTFUkSFVdhBuHp924CcEhCQpMlLduDsRF6ogkG+Jaz9fC++MWlF
X-Received: by 2002:a17:902:c946:b0:2bf:281f:19ec with SMTP id d9443c01a7336-2c1e8208778mr165217985ad.24.1780900610193;
        Sun, 07 Jun 2026 23:36:50 -0700 (PDT)
Received: from haichao.tail057a43.ts.net ([2001:da8:e000:1206:9a2:954d:67fe:d9c2])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c164f84335sm168839725ad.19.2026.06.07.23.36.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Jun 2026 23:36:49 -0700 (PDT)
From: Ruoyu Wang <ruoyuw560@gmail.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Ruoyu Wang <ruoyuw560@gmail.com>
Subject: [PATCH] mm: memcontrol-v1: use nofail allocations for soft limit trees
Date: Mon,  8 Jun 2026 14:36:44 +0800
Message-ID: <20260608063644.39-1-ruoyuw560@gmail.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

memcg1_init() allocates one soft-limit tree node per NUMA node and
then initializes the returned object. If kzalloc_node() fails, the rb_root
and lock initialization dereference NULL.

The per-node soft-limit tree is required by memcg v1. Use nofail
GFP_KERNEL allocations for these init-time objects so the init path does
not continue without the required tree nodes.

Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
---
 mm/memcontrol-v1.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
index 433bba9dfe715..3f41a15d8a8cf 100644
--- a/mm/memcontrol-v1.c
+++ b/mm/memcontrol-v1.c
@@ -2246,7 +2246,8 @@ static int __init memcg1_init(void)
 	for_each_node(node) {
 		struct mem_cgroup_tree_per_node *rtpn;
 
-		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL, node);
+		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL | __GFP_NOFAIL,
+				    node);
 
 		rtpn->rb_root = RB_ROOT;
 		rtpn->rb_rightmost = NULL;
-- 
2.51.0

