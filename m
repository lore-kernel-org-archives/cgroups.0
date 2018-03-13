From: David Rientjes <rientjes@google.com>
Subject: [patch -mm v3 0/3] mm, memcg: introduce oom policies
Date: Mon, 12 Mar 2018 17:57:51 -0700 (PDT)
Message-ID: <alpine.DEB.2.20.1803121755590.192200@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:user-agent:mime-version;
        bh=xw8WJdddWeO8YbPgxrQM4cYlVvL2X56t9I7GdnKa0BA=;
        b=b5kZVtpjnxIWYMk46akW6T2YbSXIiF8wyHULgKZS0ZqLfCv+vV9HGO5mElWzEptFL4
         dUiNF0JcpNMBnHVf5I3ewnhZB+IO4llWY6RxpMaY4VWUjkbgUjeEveu+NdeR10UESkKE
         N9f7gt3X6ad5gQuB/MkroZfkxxDc4zX8shb/Obwrto9MTXrviLNiflwB0FGcDEwfcT6e
         n4G86UA9TMOrblxXugsLSNyjAAO9TqgIY/33A33UC/DFNDElmUZWty2cfqMZuvfHrnde
         OSXCHaW9tYZ4XgXbC9LdvSpX9pijbpU6qIUrwrqe4YqNX//3MRNFiTNdLX4g4bC4LaWF
         wesA==
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

This patchset aims to fix (1) completely and, by doing so, introduces a
completely extensible user interface that can be expanded in the future.

It preserves all functionality that currently exists in -mm and extends
it to be generally useful outside of very specialized usecases.

It eliminates the mount option for the cgroup aware oom killer entirely
since it is now enabled through the root mem cgroup's oom policy.
---
 v3:
  - updated documentation
  - rebased to next-20180309

 Documentation/cgroup-v2.txt | 90 ++++++++++++++++++++++++-------------
 include/linux/cgroup-defs.h |  5 ---
 include/linux/memcontrol.h  | 21 +++++++++
 kernel/cgroup/cgroup.c      | 13 +-----
 mm/memcontrol.c             | 64 +++++++++++++++++++++-----
 5 files changed, 132 insertions(+), 61 deletions(-)
