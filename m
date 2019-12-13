From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH 0/3] mm: memcontrol: recursive memory protection
Date: Fri, 13 Dec 2019 14:21:55 -0500
Message-ID: <20191213192158.188939-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Md8aPp7pWyGuw5IIpUNdRQgPAvuPZuMepp2Ahz2Nx4M=;
        b=wgSZLGRUOXwzFB4dfBnzTeSU23C7S7RRsjtSNusnCzXmKwnqrtYtHchbbxHW6dqapq
         MjghPETHNvKrpaC4P42jqcAt5wpcqzU0OADzTYo1e7xY99FcQTby3wlOrGvEBtpkc3L2
         6G0T1SS8d+6LQjg38Y2yKe6cLvZylqzSJ+aEhVQjCpBshBp3/jeI6QsuKw3DcOyxqTBC
         MsKge1RHa22f8HtCjtNI02qMb+YOCDmCOgVfeMTTv/2eA/4D6h9d1lEZPJxI6dUoIiQa
         sp8jbhVfvh+id58flVOEQZM5L+C5XnCBhhgjSG85RPGD9hI6Pm1nbl37bI40mNck5b3M
         gQpw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>, Roman Gushchin <guro@fb.com>, Tejun Heo <tj@kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

The current memory.low (and memory.min) semantics require protection
to be assigned to a cgroup in an untinterrupted chain from the
top-level cgroup all the way to the leaf.

In practice, we want to protect entire cgroup subtrees from each other
(system management software vs. workload), but we would like the VM to
balance memory optimally *within* each subtree, without having to make
explicit weight allocations among individual components. The current
semantics make that impossible.

This patch series extends memory.low/min such that the knobs apply
recursively to the entire subtree. Users can still assign explicit
protection to subgroups, but if they don't, the protection set by the
parent cgroup will be distributed dynamically such that children
compete freely - as if no memory control were enabled inside the
subtree - but enjoy protection from neighboring trees.

Patch #1 fixes an existing bug that can give a cgroup tree more
protection than it should receive as per ancestor configuration.

Patch #2 simplifies and documents the existing code to make it easier
to reason about the changes in the next patch.

Patch #3 finally implements recursive memory protection semantics.

Because of a risk of regressing legacy setups, the new semantics are
hidden behind a cgroup2 mount option, 'memory_recursiveprot'.

More details in patch #3.

 Documentation/admin-guide/cgroup-v2.rst |  11 ++
 include/linux/cgroup-defs.h             |   5 +
 kernel/cgroup/cgroup.c                  |  17 ++-
 mm/memcontrol.c                         | 241 +++++++++++++++++++-----------
 mm/page_counter.c                       |  12 +-
 5 files changed, 190 insertions(+), 96 deletions(-)


