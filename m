From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH 0/3] Directed kmem charging
Date: Tue, 13 Feb 2018 18:56:50 -0800
Message-ID: <20180214025653.132942-1-shakeelb@google.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=8HmRdc6cOzghCnzRYYmWN038q5DR30QMADFjqPbSVgk=;
        b=Wntc0Ep2RveHNIO9HqtD2gcwReNaje6kTSXLDNhgFl84jqU3RnOgAkLufN37koVG1V
         feZT+j34XjG7AAbIyXkNF8OgPSHSLrTcRAfOV/SbHYgbBlXL3Wxo2rTEvojJ9exZqW6u
         gVJMhJJK//HYIdOuejjs9WtTLzT17fcMQ61Ezk+rxrWjbsFsjR59nQnzTRK72qNHSSxN
         o/7IKHGcM1pSbox5yVBiOaNT+SyfxRaVemJtKUXJRV6phzWvDCkTCaDTRBIXXMH/GG+5
         9UoRUupmpbVd0eQ4K1IxVnKoQ2MuOH1CRYVzslhHyPr3BZAzoc7GSy6PpjzsF2WmGqUl
         dbiA==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Pekka Enberg <penberg-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>
Cc: linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

This patchset introduces memcg variant memory allocation functions. The
caller can explicitly pass the memcg to charge for kmem allocations.
Currently the kernel, for __GFP_ACCOUNT memory allocation requests,
extract the memcg of the current task to charge for the kmem allocation.
This patch series introduces kmem allocation functions where the caller
can pass the pointer to the remote memcg. The remote memcg will be
charged for the allocation instead of the memcg of the caller.


Shakeel Butt (3):
  mm: memcg: plumbing memcg for kmem cache allocations
  mm: memcg: plumbing memcg for kmalloc allocations
  fs: fsnotify: account fsnotify metadata to kmemcg

 fs/notify/dnotify/dnotify.c          |   5 +-
 fs/notify/fanotify/fanotify.c        |  12 ++-
 fs/notify/fanotify/fanotify.h        |   3 +-
 fs/notify/fanotify/fanotify_user.c   |   8 +-
 fs/notify/group.c                    |   4 +
 fs/notify/inotify/inotify_fsnotify.c |   2 +-
 fs/notify/inotify/inotify_user.c     |   5 +-
 fs/notify/mark.c                     |   9 +-
 include/linux/fsnotify_backend.h     |  12 ++-
 include/linux/memcontrol.h           |  12 ++-
 include/linux/slab.h                 |  86 +++++++++++++++-
 mm/memcontrol.c                      |  29 ++++--
 mm/page_alloc.c                      |   2 +-
 mm/slab.c                            | 107 ++++++++++++++++----
 mm/slab.h                            |   6 +-
 mm/slab_common.c                     |  41 +++++++-
 mm/slub.c                            | 140 ++++++++++++++++++++++-----
 17 files changed, 404 insertions(+), 79 deletions(-)

-- 
2.16.1.291.g4437f3f132-goog
