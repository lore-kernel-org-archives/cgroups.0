From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [PATCH v2 0/3] mm: memcontrol: recursive memory protection
Date: Thu, 19 Dec 2019 15:07:15 -0500
Message-ID: <20191219200718.15696-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oYiIu2mk1O8LA2y0MiTcNVGhftZjp6jwMi9mmwJQac4=;
        b=fj3AGRXKmJEfNgQiRcISC7HVWkSocovlBpyW/qprUYO7Mqg0zHOgkFsuEL7bj09x0e
         GNo2GUYrsgl7gu9dZcbcOreUdSZizGPe/8vnYBkegdu2BxjdPOUvTm4HQ1/a3N5I0rXy
         9qpO/VYJ59U2ZDJGyC2A1xNdpYrFDsJ9gEb5CkN+86hhOcJ6Cn8RTlBgbbxf4iDPI0Tg
         YA+xDeChfCuXtKz4PvRQ6A8oZN68sfPVub+RuWdmP+SXFjeLsXVA8d9CtSWvc4YGlADS
         a3oNuCkGPu+UUDyczUUDqcEq9SzvZUSvXzvruEBOZhoP+9RWO3jTbPYNnqin1YdpVr/y
         er1Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@suse.com>, Tejun Heo <tj@kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

Changes since v1:
- improved Changelogs based on the discussion with Roman. Thanks!
- fix div0 when recursive & fixed protection is combined
- fix an unused compiler warning

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
 mm/memcontrol.c                         | 243 +++++++++++++++++++-----------
 mm/page_counter.c                       |  12 +-
 5 files changed, 192 insertions(+), 96 deletions(-)


