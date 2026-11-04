Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793786349;
	b=cm/B9LZN2NZdggGB4zWoJYnz/PB3Hqpvn6p8Wm54WNu5z271iJlf21GZkHHZnLxh80CO
	 jAMDXCPY/dzBq6agf8N/dsyN6lDPDyVRCh5sixF6WiOS2cvjhR0SE7TGwUzuw3D37k3Mw
	 xZdQ6367Okss0d8XoRiKNKliHYKg4azgAV1hpbsHEW4D0d+UsF2x2hRW6Lp6kREZ9aPyX
	 DP2QqRVbhJ0inmyuMpJssHuxR8ciWGhik80LWfdhp32whU0UHmC3dbr2zpAeVursOiiza
	 x3D2eBQwqk8XCu8olApr4+aGlmUmfRybKjjSlMJ46jNLwSfNxlIGUMgmXAL0q1oXpUg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793786349;
	h=Received:DKIM-Signature:Received:From:Subject:Date:Message-Id:
	 MIME-Version:Content-Type:Content-Transfer-Encoding:X-B4-Tracking:To:
	 Cc:X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=3Sob1uMONq6SSsdxxC9IdsMSiFRpVas+YBu0+aDW3Z4=;
	b=EtedNj+xDnqmhL+J7a6VCcjYUmdKjeGFqTzekVJ4oJ3DlgXrR7HzFxPwdUy50g5a9dqs
	 ogry1WsJzeSrZx6EMDRAY/W2pEd9gaWbkvDq4Xge/rNPbvzdhCGAp7IIjqw1aGZA7Zqnz
	 kuwMe3sQU+6njjDHFy6JjRjxD1wI54cqr9tXPDH/D4KebWOfAHNl16JQ8J5MWPGBeLV32
	 wSz0mfS7IGXGCOXRQP3GlzvB5pVxwWz4E40Ktnhcxj4eYG9JKkJPTY5+FmYxzkmtsFuqv
	 0XijuVyzHixM3mNIrNWoafuTgq4Mqm1Djt/XWTF8Q+PY+EoWA3qwysITvj/qCptMvmg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ftxirbjq;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60619606A31B;
	Wed,  4 Nov 2026 09:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ftxirbjq
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=100.80.115.77
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793786349;
	b=QbvIEBrRsN2y0APf8IQnv5jkZBZP8uHgUdqlrHmum5L9irwFiEv+s0iqvuKusyJTFFgb
	 /0kKG59Tkdz3ezE7HK4hXSzGz+7DDc7+GEQ9o26VBSBOLvRn8TWjxroaETBj6T7wT7Wtv
	 emHN5QjcA4R5ck3hdwc8mfQ3GAnFoPBLa/AER2s9oT2/TL0t8GpXxIz2mT0A9ljDtE+E5
	 Uf2EbQ7kKFpJmVyRhwyt3yuV0bVAUScBlgEDZ8vTGKdu5YuQRdHlimQwbQ6OmG4avVQT3
	 IfINuh9pC/2g3hjnv+kldo+NB35b60FwUmZLv1q1wSRR0f8iaR7j2GEzY/D8EHzYYfA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793786349;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=3Sob1uMONq6SSsdxxC9IdsMSiFRpVas+YBu0+aDW3Z4=;
	b=KG/NPaTXs19rpk4K+h7lxcqsAmDliyrcrBc13fH2um1wFzVLYL6yB1YiKxJ4HczTAYpZ
	 Zx6RGqA+gg9L9DPRzEtH8K4WSvLCnQlL/qQ/j80kpmJ3c1rqxenRBYYGq24eH6VsULSbY
	 RjlcFT1d7v0LiRazsB1K7B/Cpimad9oH3gnFbwiMd3pQfN0MjrNY1EX+eVg5FMr+4p5us
	 fdXLIoiwcKqOnym64vNuPza3pq2sWNCDxZivanqI0QLZTgqw/239SvNwLuirRh0uvWFF7
	 JoxdFHkAJHZBoucVeXVTlxlUPHGxPn0Lx08+THJr6vkXTIoFpSHE2JA3zyipgm+oO6g==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id B6CE31F00919;
	Wed,  4 Nov 2026 09:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793786349;
	bh=3Sob1uMONq6SSsdxxC9IdsMSiFRpVas+YBu0+aDW3Z4=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=ftxirbjqa58cGKoYms+B2+AEZvxmfkOYxeogVZSSXcP0RYRHRPMUxesvr7n4wybyh
	 4QnHr/4yTVZH4n3qvXvkRsIPCyvGjkBqFGNZuRFbqhidPF/Vv5GuKe7bISZorErXiq
	 OYJyYQ8MnOeh3LEbJM65/j5kCqLYHq8+w/Rm9C1utUJbnDbD56DYbPLUILs7n5jLn8
	 Sh0P23rRZr+Riol4iQNJUEDLvNgWIxv+zBFZAHQuDwdiiyoFvfnUS0pvFBWAQOUu+N
	 aDPudopCw0QujRlcT7khXfCAZLawyvCWOzxp2yOCletO8c0CRmhPHIHqM0sak503my
	 JY/2exbYfF9QA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 134E746D91;
	Wed,  4 Nov 2026 09:59:08 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Subject: [PATCH 0/2] mm: fix memcg_data reads during a THP split
Date: Wed, 04 Nov 2026 18:59:07 +0900
Message-Id: <20261104-kpagecgroup-split-v1-0-f70e947fec85@samsung.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAOsB62oC/x3MQQqAIBRF0a3EHyeYRFlbiQZiL/sUJVoRSHtPG
 p7BvYkiAiNSXyQKuDnysWdUZUF2MbuD4CmblFRNJZUWqzcO1oXj8iL6jU+hTVt3tgFUC8qdD5j
 5+Z/D+L4feHUaV2MAAAA=
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tao Yi <escape@deepseek.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Matthew Wilcox <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, linux-mm@kvack.org, 
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793786347; l=1142;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=y+BIdTbHzrH+8Uu1YnmKDz/Hk8zUyXmI5VDnrLuv9PY=;
 b=0+otGc3rNezYaJu/zwXPPYuiIecNe6HZUqy7esh0CFuBqce5P1RDP0GxbRJvib69MJuiM1e+o
 VoK4dvibbOeC6yGIvA864Y0zKn7FrlYCtd9M/sFikqiNwtBE7itbRNL
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com

Tao Yi reported an oops in page_cgroup_ino() while reading
/proc/kpagecgroup and traced it to the THP split in an RFC [1]. The
RFC skips frozen folios in the reader. Patch 1 moves the memcg_data
copy in the split instead. Patch 2 orders the same loads in
page_owner and needs patch 1.

Charged large kmalloc pages are frozen, so the RFC would report them
as uncharged. My review of the RFC [2] got no reply. Tested on x86_64
with KASAN, see patch 1.

[1] https://lore.kernel.org/all/20260907124001.1544655-1-escape@deepseek.com/
[2] https://lore.kernel.org/all/20261028040418epcms2p7ac0f584cdfdc6a0ea9b7f20eadeada3d@epcms2p7/

---
Daejun Park (2):
      mm/huge_memory: set memcg_data before a split page leaves the folio
      mm/page_owner: also check PageTail before reading memcg_data

 mm/huge_memory.c | 17 +++++++++++++----
 mm/memcontrol.c  |  9 ++++++++-
 mm/page_owner.c  |  7 +++++++
 3 files changed, 28 insertions(+), 5 deletions(-)
---
base-commit: a13b500946e5dc467976838572b8ddd2fd777ca7
change-id: 20261028-kpagecgroup-split-8a749c6ee27e

Best regards,
-- 
Daejun Park <daejun7.park@samsung.com>


