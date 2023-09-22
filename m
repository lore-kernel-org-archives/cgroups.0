From: Yosry Ahmed <yosryahmed@google.com>
Subject: [PATCH v2 0/2] mm: memcg: fix tracking of pending stats updates values
Date: Fri, 22 Sep 2023 17:57:38 +0000
Message-ID: <20230922175741.635002-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695405463; x=1696010263; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=TWhlillKWVcEeVnrDyY8Q3IYayRPjR5OTdgTyF2A4S0=;
        b=KF/mZ9HKfn/WA0ZSf/lvAI/cCURUB5ub3z+0/CTXUMMlv+Tym0E4kqnaDycqPdIVzb
         Kzg/IyiwSilA9xiMNMXhEaf+Kti6bcrddodaJbrRYcALEiKJ3xPGVRNUoqKJYPL4sYe+
         8Wtdixfgwt4qHlbh6c/3jWY/1I7VWb1ERxPLo1zWs9CbxsCjzms5SodHdiLP7iVmDfTa
         0AC4QxCBiILwumu7weq3dLnxncip3+YMFKTLF7xZWLTjX+ENJzxRzUeuh63VRg5/Ei0Q
         lc/zIx8N+5pNxfFH2zacDEz/Ckqwji3fKULiTVnh46f5a0yC9ObEn6wTgdjff5datgEt
         mGJg==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>, Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>

While working on adjacent code [1], I realized that the values passed
into memcg_rstat_updated() to keep track of the magnitude of pending
updates is consistent. It is mostly in pages, but sometimes it can be in
bytes or KBs. Fix that.

Patch 1 reworks memcg_page_state_unit() so that we can reuse it in patch
2 to check and normalize the units of state updates.

[1]https://lore.kernel.org/lkml/20230921081057.3440885-1-yosryahmed@google.com/

v1 -> v2:
- Rebased on top of mm-unstable.

Yosry Ahmed (2):
  mm: memcg: refactor page state unit helpers
  mm: memcg: normalize the value passed into memcg_rstat_updated()

 mm/memcontrol.c | 64 +++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 51 insertions(+), 13 deletions(-)

-- 
2.42.0.515.g380fc7ccd1-goog

