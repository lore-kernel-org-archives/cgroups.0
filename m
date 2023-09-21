From: Yosry Ahmed <yosryahmed@google.com>
Subject: [PATCH 0/5] mm: memcg: subtree stats flushing and thresholds
Date: Thu, 21 Sep 2023 08:10:52 +0000
Message-ID: <20230921081057.3440885-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1695321130; x=1695925930; darn=vger.kernel.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mOW1s/LOhiEKmGFQGGQ/gb7iNiCsFWbcKv8d4ZT/dpI=;
        b=kOux8/8V0qi3LikJmeyi+kgFW4/Yi2d5zbrDwEGQJO45KZK7qlfg5m1hF8N7Cgs8x/
         5aiJdkf+1GwnY4NZROjohnVZVFfS7hjws6FFv9ml5s/HT7h7AxNQGkLI8d9XXDT4RKYH
         C04uH/JIQpzo/IxM6w63tZuJNU/L7dWeYMBcjkQjlIQ7rzJTe99ZYK8OXiQQ15Rzwn0f
         CM0I+Q6nazKSdBMgBzkssnBvH+vXBs27mjn89eSPUWqOe8GETrie03zqoif9VCaq6g4P
         cUeJW4dXt1HBWllPcgMLu8PkjR1vZGKqdcFgL3PYM3jZLIwlGBQQe2ORnlRZMB5Q8IAS
         JBJw==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Ivan Babrou <ivan@cloudflare.com>, Tejun Heo <tj@kernel.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>, Waiman Long <longman@redhat.com>, kernel-team@cloudflare.com, Wei Xu <weixugc@google.com>, Greg Thelen <gthelen@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>

This series attempts to address shortages in today's approach for memcg
stats flushing, namely occasionally stale or expensive stat reads. The
series does so by changing the threshold that we use to decide whether
to trigger a flush to be per memcg instead of global (patch 3), and then
changing flushing to be per memcg (i.e. subtree flushes) instead of
global (patch 5).

Patch 3 & 5 are the core of the series, and they include more details
and testing results. The rest are either cleanups or prep work.

This series replaces the "memcg: more sophisticated stats flushing"
series [1], which also replaces another series, in a long list of
attempts to improve memcg stats flushing. It is not a v2 as it is a
completely different approach. This is based on collected feedback from
discussions on lkml in all previous attempts. Hopefully, this is the
final attempt.

[1]https://lore.kernel.org/lkml/20230913073846.1528938-1-yosryahmed@google.com/

Yosry Ahmed (5):
  mm: memcg: change flush_next_time to flush_last_time
  mm: memcg: move vmstats structs definition above flushing code
  mm: memcg: make stats flushing threshold per-memcg
  mm: workingset: move the stats flush into workingset_test_recent()
  mm: memcg: restore subtree stats flushing

 include/linux/memcontrol.h |   8 +-
 mm/memcontrol.c            | 269 +++++++++++++++++++++----------------
 mm/vmscan.c                |   2 +-
 mm/workingset.c            |  37 +++--
 4 files changed, 181 insertions(+), 135 deletions(-)

-- 
2.42.0.459.ge4e396fd5e-goog

