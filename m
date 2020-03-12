From: Chris Down <chris@chrisdown.name>
Subject: [PATCH 0/6] mm, memcg: cgroup v2 tunable load/store tearing fixes
Date: Thu, 12 Mar 2020 17:32:45 +0000
Message-ID: <cover.1584034301.git.chris@chrisdown.name>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition;
        bh=EMQBFUEliM01ip8eYZWL54ZvB7/WFqSxm3Itb84CtRE=;
        b=k+rsyxmleUdEKNf2d3kL7o7aiIxuTWtLn6o1bdXxge9PXpxV5wPfTKxhslPzkpG0Ar
         G5gSlzvijsb4gXxQfcmGRT1CfQ9MAD/nDqTxMBpLtubU80R8hfLmLGOjuZEo1pkWHAVw
         etC0c1ppz8Vikx3F9E4p63Pul+eZweVNu48ZM=
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

Chris Down (6):
  mm, memcg: Prevent memory.high load/store tearing
  mm, memcg: Prevent memory.max load tearing
  mm, memcg: Prevent memory.low load/store tearing
  mm, memcg: Prevent memory.min load/store tearing
  mm, memcg: Prevent memory.swap.max load tearing
  mm, memcg: Prevent mem_cgroup_protected store tearing

 mm/memcontrol.c   | 42 ++++++++++++++++++++++--------------------
 mm/page_counter.c | 17 +++++++++++------
 2 files changed, 33 insertions(+), 26 deletions(-)

-- 
2.25.1

