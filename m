From: David Rientjes <rientjes@google.com>
Subject: [patch -mm 0/6] rewrite cgroup aware oom killer for general use
Date: Fri, 16 Mar 2018 14:08:45 -0700 (PDT)
Message-ID: <alpine.DEB.2.20.1803161405410.209509@chino.kir.corp.google.com>
References: <alpine.DEB.2.20.1803121755590.192200@chino.kir.corp.google.com> <alpine.DEB.2.20.1803151351140.55261@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=N72TC+qOwynd7rWhPmbIkxIz5vKrVeEuLaLu0FJ9oIY=;
        b=iHGdXV4+AsKdY1vS8qlTM7GFnXd0bfugFpmKifj6Pm4umhZ8BHfLD4V+VtlSFZKn39
         ThwnOETFIBoZRv31pY8SAFySppwOlSod5r1mLZhaAGDrhSekvTL3+gXJ/Zc2vYPtgxul
         JeBSZtp9Ev68NBQIlGNd2xgRUhn9Pb9dA4H4toL/OwqvN46F6pzmwkuFXh0sJdxvUUX1
         vk3xO0rbEtRNlhlpmJ1C9z/ChPi3/icDzLpmtEA8CKEzQ4Lgb3HEnAw+ydRNEAymR9FE
         37RxdG26SQ4EB/M2DNHUXpt20XfMUwPrCbM0lVtrUIhY9m+Lod7KjO9uNfdZCrbNxxfm
         sBRg==
In-Reply-To: <alpine.DEB.2.20.1803151351140.55261@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

There are three significant concerns about the cgroup aware oom killer as
it is implemented in -mm:

 (1) allows users to evade the oom killer by creating subcontainers or
     using other controllers since scoring is done per cgroup and not
     hierarchically,

 (2) unfairly compares the root mem cgroup using completely different
     criteria than leaf mem cgroups and allows wildly inaccurate results
     if oom_score_adj is used, and

 (3) does not allow the user to influence the decisionmaking, such that
     important subtrees cannot be preferred or biased.

This patchset fixes (1) and (2) completely and, by doing so, introduces a
completely extensible user interface that can be expanded in the future.

Concern (3) could subsequently be addressed either before or after the
cgroup-aware oom killer feature is merged.

It preserves all functionality that currently exists in -mm and extends
it to be generally useful outside of very specialized usecases.

It eliminates the mount option for the cgroup aware oom killer entirely
since it is now enabled through the root mem cgroup's oom policy.
---
 - Rebased to next-20180305
 - Fixed issue where total_sock_pages was not being modified
 - Changed output of memory.oom_policy to show all available policies

 Documentation/cgroup-v2.txt | 100 ++++++++--------
 include/linux/cgroup-defs.h |   5 -
 include/linux/memcontrol.h  |  21 ++++
 kernel/cgroup/cgroup.c      |  13 +--
 mm/memcontrol.c             | 221 +++++++++++++++++++++---------------
 5 files changed, 204 insertions(+), 156 deletions(-)
