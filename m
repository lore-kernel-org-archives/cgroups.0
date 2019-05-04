From: Shakeel Butt <shakeelb@google.com>
Subject: [PATCH v2] memcg, fsnotify: no oom-kill for remote memcg charging
Date: Sat,  4 May 2019 07:52:42 -0700
Message-ID: <20190504145242.258875-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Q+yvnmyjVEzdFHEWBcoadDmmU/3yK5ganIOIoyEwouc=;
        b=qFtjqSrcM4UGgRoJ8/RzfeaVyMan+d7Ts2pByis/59NTZYLaxr1drG0H5BJleMrsrh
         MfXyUTFpANjtUv9d/3lln9gmv0JiZwKgSmPn/unKXf6ckvtwaiukK2EpBgYXSp2zaMVT
         oBZSmqvUFGBLW+493GEBswqRKrbAhreW7h3pvJZKJyvSY9xqc6PSChOyIBpwKVl7OcOV
         OYC8eGUnH5wq7H0Hf6xM8doNcgTcKdvF+OGgfSn2qK2KmkPDC1b9x7Pj9K9UegrblR69
         dmm+H2DsQQ2Abc1ZsllHD5tiuI6keEcXuEUtH1k4JAzFM/AERoSNSFeerIz2sPD+jA9M
         2gsA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Jan Kara <jack@suse.cz>, Amir Goldstein <amir73il@gmail.com>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Shakeel Butt <shakeelb@google.com>

The commit d46eb14b735b ("fs: fsnotify: account fsnotify metadata to
kmemcg") added remote memcg charging for fanotify and inotify event
objects. The aim was to charge the memory to the listener who is
interested in the events but without triggering the OOM killer.
Otherwise there would be security concerns for the listener. At the
time, oom-kill trigger was not in the charging path. A parallel work
added the oom-kill back to charging path i.e. commit 29ef680ae7c2
("memcg, oom: move out_of_memory back to the charge path"). So to not
trigger oom-killer in the remote memcg, explicitly add
__GFP_RETRY_MAYFAIL to the fanotigy and inotify event allocations.

Signed-off-by: Shakeel Butt <shakeelb@google.com>
---
Changelog since v1:
- Fixed usage of __GFP_RETRY_MAYFAIL flag.

 fs/notify/fanotify/fanotify.c        | 5 ++++-
 fs/notify/inotify/inotify_fsnotify.c | 7 +++++--
 2 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/notify/fanotify/fanotify.c b/fs/notify/fanotify/fanotify.c
index 6b9c27548997..f78fd4c8f12d 100644
--- a/fs/notify/fanotify/fanotify.c
+++ b/fs/notify/fanotify/fanotify.c
@@ -288,10 +288,13 @@ struct fanotify_event *fanotify_alloc_event(struct fsnotify_group *group,
 	/*
 	 * For queues with unlimited length lost events are not expected and
 	 * can possibly have security implications. Avoid losing events when
-	 * memory is short.
+	 * memory is short. Also make sure to not trigger OOM killer in the
+	 * target memcg for the limited size queues.
 	 */
 	if (group->max_events == UINT_MAX)
 		gfp |= __GFP_NOFAIL;
+	else
+		gfp |= __GFP_RETRY_MAYFAIL;
 
 	/* Whoever is interested in the event, pays for the allocation. */
 	memalloc_use_memcg(group->memcg);
diff --git a/fs/notify/inotify/inotify_fsnotify.c b/fs/notify/inotify/inotify_fsnotify.c
index ff30abd6a49b..17c08daa1ba7 100644
--- a/fs/notify/inotify/inotify_fsnotify.c
+++ b/fs/notify/inotify/inotify_fsnotify.c
@@ -99,9 +99,12 @@ int inotify_handle_event(struct fsnotify_group *group,
 	i_mark = container_of(inode_mark, struct inotify_inode_mark,
 			      fsn_mark);
 
-	/* Whoever is interested in the event, pays for the allocation. */
+	/*
+	 * Whoever is interested in the event, pays for the allocation. However
+	 * do not trigger the OOM killer in the target memcg.
+	 */
 	memalloc_use_memcg(group->memcg);
-	event = kmalloc(alloc_len, GFP_KERNEL_ACCOUNT);
+	event = kmalloc(alloc_len, GFP_KERNEL_ACCOUNT | __GFP_RETRY_MAYFAIL);
 	memalloc_unuse_memcg();
 
 	if (unlikely(!event)) {
-- 
2.21.0.1020.gf2820cf01a-goog

