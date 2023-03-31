From: Waiman Long <longman@redhat.com>
Subject: [PATCH 0/3] cgroup/cpuset: Fix CLONE_INTO_CGROUP problem & other issues
Date: Fri, 31 Mar 2023 10:50:42 -0400
Message-ID: <20230331145045.2251683-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680274281;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=NxiS3F96XX8Cx+zMaAlwGGsTAfl1PqYiaP5Qp7Bk1SM=;
        b=QI6JOJVzU0KWrY9CL9gO9ELlt6FtB91gb/G+MR0hu6LiMpECRfBqH4+M4ZhYYcSz0hoikK
        yh9PhcyLgjr06XQm0CXMO2+tn1HoK108ce5cVfc03/pKh93BmnQIh74sm5y9MTAZ/rxke8
        pYJ2tl5hoDp6Yt1WtWuNKBKFG5scuUc=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Christian Brauner <brauner@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, gscrivan@redhat.com, Waiman Long <longman@redhat.com>

The first patch of this series fixes the incorrect cpumask problem
when the CLONE_INTO_CGROUP flag is used to clone a child to a different
cgroup. It also includes 2 other miscellaneous fixes to the cpuset code.

Waiman Long (3):
  cgroup/cpuset: Make cpuset_fork() handle CLONE_INTO_CGROUP properly
  cgroup/cpuset: Make cpuset_attach_task() skip subpartitions CPUs for
    top_cpuset
  cgroup/cpuset: Allow only one active attach operation per cpuset

 kernel/cgroup/cpuset.c | 76 ++++++++++++++++++++++++++++--------------
 1 file changed, 51 insertions(+), 25 deletions(-)

-- 
2.31.1

