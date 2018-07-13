From: David Rientjes <rientjes@google.com>
Subject: [patch v3 -mm 0/6] rewrite cgroup aware oom killer for general use
Date: Fri, 13 Jul 2018 16:07:23 -0700 (PDT)
Message-ID: <alpine.DEB.2.21.1807131604560.217600@chino.kir.corp.google.com>
References: <alpine.DEB.2.20.1803121755590.192200@chino.kir.corp.google.com> <alpine.DEB.2.20.1803151351140.55261@chino.kir.corp.google.com> <alpine.DEB.2.20.1803161405410.209509@chino.kir.corp.google.com>
 <alpine.DEB.2.20.1803221451370.17056@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=3nT8/OaJFbIBKu9R5rivmEY5NIymfud7kC1ewr2xxfg=;
        b=vM6+58LE0Yyi6Z/CpK7NMee3AyULAQg99idjRTBl8opQqoZkSkwSJYx0qBwAjNp9Vm
         9gnLFkaSstMwz3uLrp/81VtsKWQpOU/JXix/gwDWO9lZ0JZo2XMTopBbwCHvWfJ817bU
         XenjR7uj50JB9H+kSvhmACPwZfv892LfGAIS+0jxd/5H4ThF7158kpOkYpTs8bPhJWkk
         bLGxjZKukSfkpQ9ZWYC5pbPQ+XjvZeeIb6ZrANvxHgDx4tu5FsemENN8S3d0CV8c7Ba8
         GVWQ8NtrvNF3Vk9LYocF5jG7tUa7JOoOzOd9DJoDH1q72dH2IpWyb+0ArzuuQgt26SLg
         bUbA==
In-Reply-To: <alpine.DEB.2.20.1803221451370.17056@chino.kir.corp.google.com>
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
v3:
 - Rebased to next-20180713

v2:
 - Rebased to next-20180322
 - Fixed get_nr_swap_pages() build bug found by kbuild test robot

 Documentation/admin-guide/cgroup-v2.rst | 100 ++++++-----
 include/linux/cgroup-defs.h             |   5 -
 include/linux/memcontrol.h              |  21 +++
 kernel/cgroup/cgroup.c                  |  13 +-
 mm/memcontrol.c                         | 221 ++++++++++++++----------
 5 files changed, 204 insertions(+), 156 deletions(-)
