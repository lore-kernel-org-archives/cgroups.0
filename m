From: Waiman Long <longman@redhat.com>
Subject: [PATCH 0/3] mm/memcg: Miscellaneous cleanups and streamlining
Date: Thu, 20 Aug 2020 09:03:47 -0400
Message-ID: <20200820130350.3211-1-longman@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1597928653;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=hToOrTBcLzAKV5opdBYDcXptdpuWDT/30+sf1Uf9L88=;
        b=i+O9/34nFr8ztmA+rTsZvTl6P9PPJwnqEv8YWtNXpcWhm2YjWrDcIcMNwTwsX9g6SOFrce
        yzg3Bt7kZsFJTbg09/ILSKfr561BaBCuSbaMGmPWduL5lfkWqGKCBAsviJq7qpXLiPL8JU
        JNlAeG+8jnqwN2oEUxS7kG+MHrs5JEs=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>, Chris Down <chris@chrisdown.name>, Roman Gushchin <guro@fb.com>, Yafang Shao <laoar.shao@gmail.com>, Waiman Long <longman@redhat.com>

Patch 1 removes an unused enum charge_type.

Patch 2 streamlines mem_cgroup_get_max().

Patch 3 unifies swap and memsw page counters in mem_cgroup.

Waiman Long (3):
  mm/memcg: Clean up obsolete enum charge_type
  mm/memcg: Simplify mem_cgroup_get_max()
  mm/memcg: Unify swap and memsw page counters

 include/linux/memcontrol.h |  3 +--
 mm/memcontrol.c            | 30 ++++++++++--------------------
 2 files changed, 11 insertions(+), 22 deletions(-)

-- 
2.18.1

