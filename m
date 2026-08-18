Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902F630FF1D;
	Tue, 18 Aug 2026 05:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787031504; cv=none; b=hB2oCt6a0HcTSB9LSLr78hGi+lmsJpBMm7JWCiZNwznzNsRSlayjL83JnTKJFUqL71H0PzA/yAMbY7nOEuDr8/70tpcm7rw5woQWkmg0rn5roOVfFgL+A5Z+qAWBj8tKKxzOfd9K1dWCm4MCk6N1xOyXm855cByz3Zru6tcZWRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787031504; c=relaxed/simple;
	bh=iNXAL5QBSvFg8MqOSVXEQqqL3N8OsXIMpmVJhlAlWpc=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=ARPfEDoEyHiP2fpiJfPUQ3wt323KotE+pfsn1Hzq+DWrL1ncOW3w9q/beoOQ30HUirUuabRd/QEWz9BF+9fVRRdqXc8Yb2mG9SWakBCpi2V0t9sdIDUl7l8GZGkAZm3CoZAooJZswGGOk1KfwH/3GCIovZYw358kY/0i9tQIxCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M2W3x5sX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M2W3x5sX"
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0B1EAC19425;
	Tue, 18 Aug 2026 05:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787031504;
	bh=iNXAL5QBSvFg8MqOSVXEQqqL3N8OsXIMpmVJhlAlWpc=;
	h=From:Subject:Date:To:Cc:Reply-To:From;
	b=M2W3x5sXEF0qu1SIMbJ3udwLccLGRQp37dg0x2JDA2r1gQPf4tNEjAix10MskWFMb
	 hC2EI4cgjTi7frkTOk0NOfKdKKxg+r2b0NGj/EkPJeoS/CDLWGLVJRxBwqbGe8uNWG
	 heizzq/NjcnoPJbOs1XWRp44hoVp1/MrXtuV1f5o+3dxVNMVynSlpPpw/AC2UyAL+8
	 +4mSEGbStzySh4Sn5NEcqDMlA+OvgYwlCKmNU/qwTJ8NldfFpyspShkxRSyWDTJU7i
	 xTSyw9R6eoXYdg8PQkQPV/ffMCgo1Ls/gDuG0ELuN10OCjFHWvAJQOdtWXMS8LBApY
	 UJQrG0gleWhTA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4404C5DF70;
	Tue, 18 Aug 2026 05:38:23 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Subject: [PATCH 0/7] mm/mglru: clean up folio counters and flag usage
Date: Tue, 18 Aug 2026 13:38:02 +0800
Message-Id: <20260818-mglru-flags-cleanup-v1-0-8dbbdac0d28c@tencent.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/yXMQQqDMBBA0avIrDugYkV7FekiHSdxJI2SaUpBv
 HujLt/i/w2Uo7DCo9gg8ldUlpBR3QqgyQTHKGM21GXdll3V4dv5mNB64xTJswlpRaKmJ2vG9t5
 YyOUa2crvvA7Py5peM9PnWMG+/wFKXeG3dwAAAA==
X-Change-ID: 20260818-mglru-flags-cleanup-cc49cfad654f
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Muchun Song <muchun.song@linux.dev>, Chris Li <chrisl@kernel.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Yu Zhao <yuzhao@google.com>, Zi Yan <ziy@nvidia.com>, 
 Qi Zheng <qi.zheng@linux.dev>, cgroups@vger.kernel.org, 
 linux-kernel@vger.kernel.org, Kairui Song <ryncsn@gmail.com>, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787031500; l=1840;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=iNXAL5QBSvFg8MqOSVXEQqqL3N8OsXIMpmVJhlAlWpc=;
 b=Pd+Wqg0HcpNXrBdlBTcn9izWhVx+gpdl+yHTtPE03/yo3IZwhaGWK/gihzWmav8MpWVOP2VyJ
 Lj+mgHjbzZxBXNujNarGSitm06PAQWZLFS8mzZDOViGQKi/AZUvtfjF
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com

This is a cleanup series separated out from the MGLRU-FG series [1]. As
that series is getting too long in following updates, seperate out the
clean up part for easier review and merge.

No feature change is intended, except one bugfix. It mostly replaces
the open-coded bit operations scattered throughout the MGLRU code with
new helpers, with proper kdocs, sanity debug checks, and hardens a few
MGLRU functions.

A subtle generation counter leak is also found during the refactoring
and the fix is included.

Also collected review feedbacks on the cleanup part from the posted
series, thanks to Barry and Baoquan.

Link: https://lore.kernel.org/linux-mm/20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com/ [1]
Signed-off-by: Kairui Song <kasong@tencent.com>
---
Kairui Song (7):
      mm/memcontrol: make lru_zone_size atomic and simplify sanity check
      mm/mglru: introduce helpers for manipulating gen and refs flags
      mm/migrate: copy the referenced state via folio_migrate_refs()
      mm/mglru: move max_seq read into walk_update_folio
      mm/mglru: use explicit tier range in read_ctrl_pos()
      mm/mglru: fix potential generation folio number leak
      mm/mglru: improve code readability and harden folio_inc_gen

 include/linux/memcontrol.h |   9 +++-
 include/linux/mm_inline.h  | 102 ++++++++++++++++++++++++++++++-----
 include/linux/mmzone.h     |   4 ++
 mm/folio.c                 |  19 ++++---
 mm/memcontrol.c            |  18 +------
 mm/migrate.c               |   4 +-
 mm/vmscan.c                | 129 ++++++++++++++++++++++++---------------------
 7 files changed, 183 insertions(+), 102 deletions(-)
---
base-commit: 3b1d6bd7bb11fd040bfa7b712486f5bd41a276cf
change-id: 20260818-mglru-flags-cleanup-cc49cfad654f

Best regards,
--  
Kairui Song <kasong@tencent.com>


