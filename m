From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 0/2] blk-cgroup: Optimize blkcg_rstat_flush()
Date: Wed,  1 Jun 2022 17:18:22 -0400
Message-ID: <20220601211824.89626-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654118320;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=seAyGrXVhGHy02fnfQMGyuhJnciw9mNYlFqWhJVOexM=;
        b=Uks3lRGKm3GOGmPE1QyEWV2JadbAYwiZf59RRL/dKXFqnt1UfkV3JIcyWR8k6MZOHnOxPU
        IbYkyQphD7lGo7NSfXFoJBqNNRgE+i/fEpZqs7OtZFRJVIvQeQ1ccrggQKfdSjuhLj3kKW
        eqp0PX8xNocZERlRizWiqif6nwzTpZk=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ming Lei <ming.lei-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

This is a follow-up of [1]. There is no change in patch 1. Patch 2 has
the following changes:
 - Update comments in patch 2.
 - Put rcu_read_lock/unlock() in blkcg_rstat_flush().
 - Use READ_ONCE/WRITE_ONCE() to access lnode->next to reduce data
   races.
 - Get a blkg reference when putting into the lockless list and put it
   back when removed.

[1] https://lore.kernel.org/lkml/20220601165324.60892-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org/

Waiman Long (2):
  blk-cgroup: Correctly free percpu iostat_cpu in blkg on error exit
  blk-cgroup: Optimize blkcg_rstat_flush()

 block/blk-cgroup.c | 92 ++++++++++++++++++++++++++++++++++++++++++----
 block/blk-cgroup.h |  9 +++++
 2 files changed, 93 insertions(+), 8 deletions(-)

-- 
2.31.1

