From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v4 0/5] cgroup/cpuset: Fix CLONE_INTO_CGROUP problem & other issues
Date: Tue, 11 Apr 2023 09:35:56 -0400
Message-ID: <20230411133601.2969636-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681220182;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=0AGalK6TkETefuR8vqn2ZgXGP9Ke/hGkmxhOP0sbpu8=;
        b=GCaV4vKC7lpUtrB+yF7L2tJ9iJ4YXq71L06EhqtFwXbJrqXMiEyYd+SOEw0s3KdpuvP8IX
        nade9prE8hWDc/Bf/XOA5rLqtE07ieQ9kYHG8Hrl6ZCt9xP5ut6kPRQaMqyzld0/BdxHhY
        FbgHCI0hf1GS/v2r6nXaP6NlnO8zKG4=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Giuseppe Scrivano <gscrivan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

 v4:
  - Add missing rcu_read_lock/unlock to cpuset_cancel_fork() in patch 3.
  - Add patch 5 to reduce performance impact for the
    non-CLONE_INTO_CGROUP case.

 v3:
  - Update patches 2 & 3 to put task_cs() call under rcu_read_lock().

 v2:
  - Drop v1 patch 3
  - Add a new patch to fix an issue in cpuset_cancel_attach() and
    another patch to add cpuset_can_fork() and cpuset_cacnel_fork()
    methods.

The first patch in this series fixes a problem in
cpuset_cancel_attach(). Patches 2 and 3 fixes the CLONE_INTO_CGROUP
problem in cpuset. Patch 4 is a minor fix. The last patch is a
performance optimization patch for the non-CLONE_INTO_CGROUP case.

Waiman Long (5):
  cgroup/cpuset: Wake up cpuset_attach_wq tasks in
    cpuset_cancel_attach()
  cgroup/cpuset: Make cpuset_fork() handle CLONE_INTO_CGROUP properly
  cgroup/cpuset: Add cpuset_can_fork() and cpuset_cancel_fork() methods
  cgroup/cpuset: Make cpuset_attach_task() skip subpartitions CPUs for
    top_cpuset
  cgroup/cpuset: Optimize out unneeded
    cpuset_can_fork/cpuset_cancel_fork calls

 include/linux/cgroup-defs.h |   6 ++
 kernel/cgroup/cgroup.c      |  23 +++--
 kernel/cgroup/cpuset.c      | 167 +++++++++++++++++++++++++++++-------
 3 files changed, 159 insertions(+), 37 deletions(-)

-- 
2.31.1

