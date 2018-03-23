From: Andrey Ryabinin <aryabinin@virtuozzo.com>
Subject: [PATCH v2 0/4] vmscan per-cgroup reclaim fixes
Date: Fri, 23 Mar 2018 18:20:25 +0300
Message-ID: <20180323152029.11084-1-aryabinin@virtuozzo.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=virtuozzo.com;
 s=selector1; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=Kd1Fc7R4pmo15Z1b9rkVtkELIRrlyjPq275tQa2ZiaY=;
 b=cRbRp+YGN+MdCgcGnXuBo4qqxevbARGM4+9/u+kt71f/oWB9b/kaOTkVFbz7msxxMiwp01wEPxRl7QKFqY6Lgmav7Yp60qeH3JvYFqqoidZ0Kvfzy8CfSID6FXXyIePmKCZZ6bERPcAVesxSMCotJ1Uvjv9JKfwYn/YzJEZG5x0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>, Mel Gorman <mgorman@techsingularity.net>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeelb@google.com>, Steven Rostedt <rostedt@goodmis.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

Changes since v1:
 - Added acks.
 - Dropped "mm/vmscan: replace mm_vmscan_lru_shrink_inactive with shrink_page_list tracepoint"
    patch. It's better to avoid changing the tracepoint as some people may be used to it.
    Removing 'nr_scanned' and 'file' arguments is also not very good. Yes, these numbers could
    be obtained from mm_vmscan_lru_isolate tracepoint, but it's easier when it's all in one place.

 - Compare with nr_writeback,dirty, etc only isolated file pages as it always was.
 - Minor changelog tweaks.

Andrey Ryabinin (4):
  mm/vmscan: Update stale comments
  mm/vmscan: remove redundant current_may_throttle() check
  mm/vmscan: Don't change pgdat state on base of a single LRU list
    state.
  mm/vmscan: Don't mess with pgdat->flags in memcg reclaim.

 include/linux/backing-dev.h |   2 +-
 include/linux/memcontrol.h  |   2 +
 mm/backing-dev.c            |  19 ++---
 mm/vmscan.c                 | 166 ++++++++++++++++++++++++++++++--------------
 4 files changed, 122 insertions(+), 67 deletions(-)

-- 
2.16.1

