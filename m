From: Shakeel Butt <shakeelb@google.com>
Subject: [PATCH v8 0/2] Directed kmem charging
Date: Wed, 27 Jun 2018 12:12:48 -0700
Message-ID: <20180627191250.209150-1-shakeelb@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=TlrWWiQPCjtC68tVmQ7b4F+X4V3UVnh2azcLgqQiihM=;
        b=Bq/hMMEGB/x9xox1vKQmpA8TnWjUQ3cVxD760QU68bDDWQAVR6wgBN6aHeWoKQDwWf
         x3SiCzX21Hc7O5Po2zJoBeYAKx37/PB356xhoZrI+XW+nlrTfa/oSjmijvqwXuFbdM7p
         UU8MCvzxc55L1dlVyLFs81xckxYX0Kzr1iV9OVRNvhez1xceNcKKjNIPs5Dv3potbtfl
         yzvtwCvHZxxtgm0zqmLOVbBKcl9sm5LUe0UqATfRjGeh5E3FwJk/bVq1rVU9sJ1Q/WOD
         735uIGBvJkJA7woiZS0AVa+A0UXnWp+9RPEA9CyrVEIkAjhrk5LsJrUHA9X0pzN+/WMI
         3a8A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Jan Kara <jack@suse.com>, Greg Thelen <gthelen@google.com>, Amir Goldstein <amir73il@gmail.com>, Roman Gushchin <guro@fb.com>, Alexander Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>

The Linux kernel's memory cgroup allows limiting the memory usage of
the jobs running on the system to provide isolation between the jobs.
All the kernel memory allocated in the context of the job and marked
with __GFP_ACCOUNT will also be included in the memory usage and be
limited by the job's limit.

The kernel memory can only be charged to the memcg of the process in
whose context kernel memory was allocated. However there are cases where
the allocated kernel memory should be charged to the memcg different
from the current processes's memcg. This patch series contains two such
concrete use-cases i.e. fsnotify and buffer_head.

The fsnotify event objects can consume a lot of system memory for large
or unlimited queues if there is either no or slow listener. The events
are allocated in the context of the event producer. However they should
be charged to the event consumer. Similarly the buffer_head objects can
be allocated in a memcg different from the memcg of the page for which
buffer_head objects are being allocated.

To solve this issue, this patch series introduces mechanism to charge
kernel memory to a given memcg. In case of fsnotify events, the memcg of
the consumer can be used for charging and for buffer_head, the memcg of
the page can be charged. For directed charging, the caller can use the
scope API memalloc_[un]use_memcg() to specify the memcg to charge for
all the __GFP_ACCOUNT allocations within the scope.

Shakeel Butt (2):
  fs: fsnotify: account fsnotify metadata to kmemcg
  fs, mm: account buffer_head to kmemcg

 fs/buffer.c                          | 15 ++++++-
 fs/notify/dnotify/dnotify.c          |  5 ++-
 fs/notify/fanotify/fanotify.c        | 17 ++++++--
 fs/notify/fanotify/fanotify_user.c   |  5 ++-
 fs/notify/group.c                    |  4 ++
 fs/notify/inotify/inotify_fsnotify.c | 15 ++++++-
 fs/notify/inotify/inotify_user.c     |  5 ++-
 include/linux/fsnotify_backend.h     | 12 ++++--
 include/linux/memcontrol.h           | 14 +++++++
 include/linux/sched.h                |  3 ++
 include/linux/sched/mm.h             | 41 +++++++++++++++++++
 kernel/fork.c                        |  3 ++
 mm/memcontrol.c                      | 60 ++++++++++++++++++++++++++--
 13 files changed, 182 insertions(+), 17 deletions(-)

-- 
2.18.0.rc2.346.g013aa6912e-goog

