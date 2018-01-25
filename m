From: David Rientjes <rientjes@google.com>
Subject: [patch -mm v2 0/3] mm, memcg: introduce oom policies
Date: Thu, 25 Jan 2018 15:53:41 -0800 (PST)
Message-ID: <alpine.DEB.2.10.1801251552320.161808@chino.kir.corp.google.com>
References: <alpine.DEB.2.10.1801161812550.28198@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=RHCKjEhZUD5Qoo6dVEEnTkJo2qSlXIOrsHlwaKh1SiY=;
        b=XGvZAjRqKhK7uL5PBz75esHz2wNQoZz2+XyYJykSnSz4VX7gkmeDonA5gd5QX8Mdj4
         oWBPh4bRUH7lbzxJTesfJuy5kcSFbFF7ciAI6M2MQkmSbXiHDmOZzwrft7ftV6YjtO1U
         Z5UNiie1F+y/5SL4D7fN5nu6+mK8/zi2VraNQBI9/5mpCSNBhhxIs+F0d7ftcqnwphpb
         mWdud/rqex5wY5TxCUilwXgMNPLlk7UdfYVvowK2vePyDo/3/SQpzwkiS0UF0EKhgGcQ
         7fNEbcz0WkXxEd9G1kwviNiDIMtMGZm3Z4kYID4KqnYfY14OdHp6i7rBscr/qNBrBd6B
         Ittg==
In-Reply-To: <alpine.DEB.2.10.1801161812550.28198@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
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

It preserves memory.oom_group behavior.
---
 Applied on top of -mm.

 Documentation/cgroup-v2.txt | 64 ++++++++++++++++++++++++++++-----------------
 include/linux/cgroup-defs.h |  5 ----
 include/linux/memcontrol.h  | 21 +++++++++++++++
 kernel/cgroup/cgroup.c      | 13 +--------
 mm/memcontrol.c             | 64 ++++++++++++++++++++++++++++++++++++---------
 5 files changed, 114 insertions(+), 53 deletions(-)

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
