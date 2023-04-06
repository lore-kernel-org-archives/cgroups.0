From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 0/4] cgroup/cpuset: Fix CLONE_INTO_CGROUP problem & other issues
Date: Thu,  6 Apr 2023 10:04:00 -0400
Message-ID: <20230406140404.2718574-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680789863;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=fJKC7eclbcJ2NK0QGFqPN+/Lc7oGs9ZGgHls+0SIsK4=;
        b=FUeQ22a60sO7ETEpK0buZtxddEettj8y1/Fgc8UOPatFxJLOwovnQv9yHhgcefTxfKHRPO
        TBXOMmVHJHFqTsI9eL0jBQ7uymhny6BNLYw/Hl8r+zU6G+0pIHNTOXfEMZe8tACeJrRF9n
        ChEgP6zvII1BNNCnv57/7gO3xf7hsr8=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, gscrivan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

 v3:
  - Update patches 2 & 3 to put task_cs() call under rcu_read_lock().

 v2:
  - Drop v1 patch 3
  - Add a new patch to fix an issue in cpuset_cancel_attach() and
    another patch to add cpuset_can_fork() and cpuset_cacnel_fork()
    methods.

The first patch in this series fixes a problem in
cpuset_cancel_attach(). Patches 2 and 3 fixes the CLONE_INTO_CGROUP
problem in cpuset. The last one is a minor fix.

Waiman Long (4):
  cgroup/cpuset: Wake up cpuset_attach_wq tasks in
    cpuset_cancel_attach()
  cgroup/cpuset: Make cpuset_fork() handle CLONE_INTO_CGROUP properly
  cgroup/cpuset: Add cpuset_can_fork() and cpuset_cancel_fork() methods
  cgroup/cpuset: Make cpuset_attach_task() skip subpartitions CPUs for
    top_cpuset

 kernel/cgroup/cpuset.c | 161 +++++++++++++++++++++++++++++++++--------
 1 file changed, 129 insertions(+), 32 deletions(-)

-- 
2.31.1

