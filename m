From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/2] cgroup/cpuset: Task migration optimization
Date: Thu,  8 Dec 2022 14:56:32 -0500
Message-ID: <20221208195634.2604362-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670529423;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=TZRYE/zC/NinxkpytfI2ULEuvdHw2Fkmlz2Sq9exJ+g=;
        b=SXyxWtaBKS9Y5auEhcUtLIjtfx+Wn3vRt+SvNQ0r6tPYITavcYpnMCf6DwTE0MZjGKlF8N
        rL+7yWQGIS+Xe0CAC+EhfN/mRyqnYq87AU8Sn4vbhY0+JC8Se8jhhZgRBIooGE9E0oY+A8
        hfXWcgUBQdfBi3jJM5KK+oPN8PApPyk=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

It is found that workloads that generate a lot of task migrations
among different cpusets are severely throttled because of the use
of percpu rwsem in cpuset_rwsem. It is the same problem that led to
commit 3942a9bd7b58 ("locking, rcu, cgroup: Avoid synchronize_sched()
in __cgroup_procs_write()") and commit 6a010a49b63a ("cgroup: Make
!percpu threadgroup_rwsem operations optional").

The first patch in this series changes cpuset_can_attach() to use
the read lock instead of the write lock. The second patch allows
disabling of percpu reader fast path depending on the presence of
CGRP_ROOT_FAVOR_DYNMODS flag in the cgroup root.

Waiman Long (2):
  cgroup/cpuset: Use cpuset_rwsem read lock in cpuset_can_attach()
  cgroup/cpuset: Make percpu cpuset_rwsem operation depending on DYNMODS
    state

 kernel/cgroup/cpuset.c | 75 ++++++++++++++++++++++++++++++++----------
 1 file changed, 58 insertions(+), 17 deletions(-)

-- 
2.31.1

