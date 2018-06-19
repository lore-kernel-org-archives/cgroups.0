From: Shakeel Butt <shakeelb@google.com>
Subject: [PATCH v6 0/3] Directed kmem charging
Date: Mon, 18 Jun 2018 22:13:24 -0700
Message-ID: <20180619051327.149716-1-shakeelb@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=isp0D7fOHm2B+eMegAVDPCkhp4suKkoR3rfaJmek6NA=;
        b=WMP14NhHdhEEe1tr3TYy4Fh5PUDmWJwERjLvnD7kYaPUNW/EM057iCQl2VBgsu1bhi
         nXxleeEcUiYLziOmfPbQ3XBANbGx8Cb/Pjhs007nO90wothgdcc8SoAL3JonBg7PXYGi
         GYuk1Kt2c6Uu+cKpfcwGQGurMCtNKjrYYQUcYnmfmegT0982350lv7OSB+xCP5B4GXM9
         7IqhmY8O/uFjEzk05BByqyvD9TIuFbbdlgHlsw1siWXngcX7hzabe0HFTJcg8DuXfZ9N
         XbXujiMBhcNAFOstQTyTm026k6XijzBRfD5BPQoA+kHxLxPru3NDtXCXdzsqeuGLfWI1
         R04A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Jan Kara <jack@suse.com>, Greg Thelen <gthelen@google.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, Shakeel Butt <shakeelb@google.com>

This patchset introduces memcg variant memory allocation functions.  The
caller can explicitly pass the memcg to charge for kmem allocations.
Currently the kernel, for __GFP_ACCOUNT memory allocation requests,
extract the memcg of the current task to charge for the kmem allocation.
This patch series introduces kmem allocation functions where the caller
can pass the pointer to the remote memcg.  The remote memcg will be
charged for the allocation instead of the memcg of the caller.  However
the caller must have a reference to the remote memcg.  This patch series
also introduces scope API for targeted memcg charging. So, all the
__GFP_ACCOUNT alloctions within the specified scope will be charged to
the given target memcg.

Shakeel Butt (3):
  mm: memcg: remote memcg charging for kmem allocations
  fs: fsnotify: account fsnotify metadata to kmemcg
  fs, mm: account buffer_head to kmemcg

 fs/buffer.c                          | 14 ++++-
 fs/notify/dnotify/dnotify.c          |  5 +-
 fs/notify/fanotify/fanotify.c        |  6 +-
 fs/notify/fanotify/fanotify_user.c   |  5 +-
 fs/notify/group.c                    |  6 ++
 fs/notify/inotify/inotify_fsnotify.c |  2 +-
 fs/notify/inotify/inotify_user.c     |  5 +-
 include/linux/fsnotify_backend.h     | 12 ++--
 include/linux/memcontrol.h           | 14 +++++
 include/linux/sched.h                |  3 +
 include/linux/sched/mm.h             | 24 ++++++++
 include/linux/slab.h                 | 83 ++++++++++++++++++++++++++++
 kernel/fork.c                        |  3 +
 mm/memcontrol.c                      | 54 ++++++++++++++++--
 14 files changed, 220 insertions(+), 16 deletions(-)

-- 
2.18.0.rc1.244.gcf134e6275-goog

