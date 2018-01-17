From: David Rientjes <rientjes@google.com>
Subject: [patch -mm 0/4] mm, memcg: introduce oom policies
Date: Tue, 16 Jan 2018 18:14:58 -0800 (PST)
Message-ID: <alpine.DEB.2.10.1801161812550.28198@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:user-agent:mime-version;
        bh=4fOcafIajXxlfB2mT1omota3Um0fpEK+MR2Beucjzfg=;
        b=rvHDJfE0GNHrVhyI7zSGkm/m4hPwqjkDv2wiRpjBR8q6LjbYj2XMFNc9rd+e2cQdme
         HTzqDaWtL1cBsoXPvWyIbCRFxtdOlI9S3AGjY1Up+hLzxK3tAMYYcdFVsloY+asUKJnS
         SlHor5syYzV3DJyID1XzWrHMTEq4IfdRqPgrN1VFw3OYgUdTav6BKtTZEUHLbjryyKWX
         3QMw7c+tk+N3mVQVNzmzNaj+d4CJJI9IXWK2t3uk2dxRz7My3DGiF/dj8CNA0h3xNLM3
         LGMgB4iK/DgL18w+fCIJAenMSlpcCV/pj8c3m0g9/O810sSZnoXWCkCHLVum6PchZonD
         grIQ==
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>
Cc: Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

There are three significant concerns about the cgroup aware oom killer as
it is implemented in -mm:

 (1) allows users to evade the oom killer by creating subcontainers or
     using other controllers since scoring is done per cgroup and not
     hierarchically,

 (2) does not allow the user to influence the decisionmaking, such that
     important subtrees cannot be preferred or biased, and

 (3) unfairly compares the root mem cgroup using completely different
     criteria than leaf mem cgroups and allows wildly inaccurate results
     if oom_score_adj is used.

This patchset aims to fix (1) completely and, by doing so, introduces a
completely extensible user interface that can be expanded in the future.

It eliminates the mount option for the cgroup aware oom killer entirely
since it is now enabled through the root mem cgroup's oom policy.

It eliminates a pointless tunable, memory.oom_group, that unnecessarily
pollutes the mem cgroup v2 filesystem and is invalid when cgroup v2 is
mounted with the "groupoom" option.
---
 Applied on top of -mm.

 Documentation/cgroup-v2.txt |  87 ++++++++++++++++-----------------
 include/linux/cgroup-defs.h |   5 --
 include/linux/memcontrol.h  |  37 ++++++++++----
 kernel/cgroup/cgroup.c      |  13 +----
 mm/memcontrol.c             | 116 +++++++++++++++++++++++++-------------------
 mm/oom_kill.c               |   4 +-
 6 files changed, 139 insertions(+), 123 deletions(-)
