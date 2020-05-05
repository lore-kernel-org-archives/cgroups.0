From: Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v3 0/2] mm: memcontrol: memory.{low,min} reclaim fix & cleanup
Date: Tue,  5 May 2020 04:41:25 -0400
Message-ID: <20200505084127.12923-1-laoar.shao@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=3Y0v2e1Lb5wtzzcdYvvYnMyMMtu+m1Dmqf+0QoZUhSA=;
        b=W8I+ypz+cgycacfqwemetGRj30vIPDplypv2/Xw57pculAjHckI9bGny/k3mNTwZSw
         mWH6WTxtwICdRj5L6uZO4Ldj3URk8KnAGufc8LmnraYmECPwDY+K5xkPJ2MOFth3h7Pu
         NoJpF3Mg1ycdxynBawfjuBzhVfLqsMoeYA697UtPbu928uNV+lREnMfVTogtTXyZCGqz
         3rDrKnQbd8Ugaf+vPfa3bOHr4iVK19wF39eyEes0GzcOqz/H2DLBfjVkvPb7a/ASr0/i
         4Axs85+ravwposSptCnI0lJITCWWR+uCwK2ridpnaWSCpSsaxraQ0c/VXCWJmIj1UuOC
         Qqjg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: akpm@linux-foundation.org
Cc: mhocko@kernel.org, hannes@cmpxchg.org, chris@chrisdown.name, guro@fb.com, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Yafang Shao <laoar.shao@gmail.com>

This series contains a fix for a edge case in my earlier protection
calculation patches, and a patch to make the area overall a little more
robust to hopefully help avoid this in future.

[chris@chrisdown.name: commit log above]

Changes since v2: commit log improved by Michal.

Chris Down (1):
  mm, memcg: Decouple e{low,min} state mutations from protection checks

Yafang Shao (1):
  mm, memcg: Avoid stale protection values when cgroup is above
    protection

 include/linux/memcontrol.h | 85 ++++++++++++++++++++++++++++++++------
 mm/memcontrol.c            | 36 +++++++---------
 mm/vmscan.c                | 20 +++------
 3 files changed, 93 insertions(+), 48 deletions(-)

-- 
2.18.2

