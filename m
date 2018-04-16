From: Shakeel Butt <shakeelb@google.com>
Subject: [PATCH v5 0/2] Directed kmem charging
Date: Mon, 16 Apr 2018 13:51:48 -0700
Message-ID: <20180416205150.113915-1-shakeelb@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=PIeIsYPNo1yiSNK8T1oRdDldSchnG3GNjKdDOormGLg=;
        b=YevGx64WfISV5JUqUVUOJtuXPsw7QbYBoX/AIPrHdGzA1UP4pScLGA+yMIxe0/g/4W
         fW9+69wBCKqfcwc+kPDEtVBs7kGpoXtp7ClZ5/71rlM1mE+bCRFA1uAqO9xt4K2NotsF
         pnFXenTlzubj6lIvZVfSmUC+HeOqZacAHCTusD5VGlPlzEa4Iqjv6/MGZrZLJeQgvPQd
         ht45Io60fJW1cDCa4L4uN7FZwG2kmgTO5mIbpmJ7z8DvKYXz8NfmL5jKjs3MkYheMJvk
         AorRPbjXLpjITrsgmkWErXovt53D81TlTZBzqUCv7s+bybBhR+M3W9TjjGqjgSPwj//2
         8LUQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>, Jan Kara <jack@suse.cz>, Amir Goldstein <amir73il@gmail.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, Greg Thelen <gthelen@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Mel Gorman <mgorman@suse.de>, Vlastimil Babka <vbabka@suse.cz>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Shakeel Butt <shakeelb@google.com>

This patchset introduces memcg variant memory allocation functions. The
caller can explicitly pass the memcg to charge for kmem allocations.
Currently the kernel, for __GFP_ACCOUNT memory allocation requests,
extract the memcg of the current task to charge for the kmem allocation.
This patch series introduces kmem allocation functions where the caller
can pass the pointer to the remote memcg. The remote memcg will be
charged for the allocation instead of the memcg of the caller. However
the caller must have a reference to the remote memcg.

Fixed the build for SLOB in v2, added the target_memcg in task_struct in
v3, added node variant for kmem allocation functions and rebased fsnotify
patch over Jan's patches in v4 and in v5 fixed CONFIG_MEMCG=n build and
removed the extra branch in the common case of memory allocation.

Shakeel Butt (2):
  mm: memcg: remote memcg charging for kmem allocations
  fs: fsnotify: account fsnotify metadata to kmemcg

 fs/notify/dnotify/dnotify.c          |  5 ++-
 fs/notify/fanotify/fanotify.c        |  6 ++-
 fs/notify/fanotify/fanotify_user.c   |  5 ++-
 fs/notify/group.c                    |  4 ++
 fs/notify/inotify/inotify_fsnotify.c |  2 +-
 fs/notify/inotify/inotify_user.c     |  5 ++-
 include/linux/fsnotify_backend.h     | 12 ++++--
 include/linux/memcontrol.h           |  7 ++++
 include/linux/sched.h                |  3 ++
 include/linux/sched/mm.h             | 24 +++++++++++
 include/linux/slab.h                 | 59 ++++++++++++++++++++++++++++
 kernel/fork.c                        |  3 ++
 mm/memcontrol.c                      | 20 ++++++++--
 13 files changed, 141 insertions(+), 14 deletions(-)

-- 
2.17.0.484.g0c8726318c-goog

