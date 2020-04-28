From: Chris Down <chris@chrisdown.name>
Subject: [PATCH 0/2] mm: memcontrol: memory.{low,min} reclaim fix & cleanup
Date: Tue, 28 Apr 2020 19:26:37 +0100
Message-ID: <cover.1588092152.git.chris@chrisdown.name>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=UefID2OlDLM7XATtSz3mUqUNERRjSOJzh4SyUlDrdHk=;
        b=fv22xKHyOHTuLkg2qiGirsFBU8GgmId83+5knRJI3ydB77UUfZnOQLl2IPJwBd8Cn0
         XAFIqD+eY3wN8GeHQaKHks5K+pqC/P5KTWCZ8yKyOkcZ0KE8nLyWPaTNSXSx/A5phVBN
         4nvE4lcoWNruCSqXzVJoTXE3Sb9SMDUe6yi7M=
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <guro@fb.com>, Yafang Shao <laoar.shao@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

This series contains a fix for a edge case in my earlier protection
calculation patches, and a patch to make the area overall a little more
robust to hopefully help avoid this in future.

Chris Down (1):
  mm, memcg: Decouple e{low,min} state mutations from protection checks

Yafang Shao (1):
  mm: memcontrol: memory.low reclaim fix & cleanup

 include/linux/memcontrol.h | 48 +++++++++++++++++++++++++++++---------
 mm/memcontrol.c            | 43 ++++++++++++++++------------------
 mm/vmscan.c                | 17 ++++----------
 3 files changed, 61 insertions(+), 47 deletions(-)

--
2.26.2

