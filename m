From: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2] mm/memcg: cleanup memory cgroup
Date: Mon, 25 Jun 2012 14:05:23 +0800
Message-ID: <1340604323-8004-1-git-send-email-liwp.linux@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer;
        bh=XZ9UaYVH4BPiWYGFRLgUKvhdpXDk1eEefzLOUqedshQ=;
        b=JcZw5epxYwgiNNZL10Luy8SvErc5OELJI+xDy1W1kxUz1Ys1VcYrdubJv0jJ7INu69
         QeZaWLppOamCy098Y5BOUn6PtoL8RCHJPRsFdqv88+zrnSbq0TxHSb3ORQj8iS2/3mRn
         cbdPyvAH0HEfgLB+tUE+mgwPHRpF4qD4rQ4/kDqwhV1jHMUOYWPz0/wDezqqKVvUYYwn
         SYwl+rxDEkAH4PcgThZ2pZqanQmaytHKhpzGnwRnQE5WAM9V/DRcw7OmQQpYRbWL/Zy7
         Bxo8zb3ASkFRY0Ujxz/t0fkugJgcv0eHdemW6sAySLcI3+15FRqQ0nFkhyT5a68/016t
         Zlxg==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Eric Dumazet <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Mike Frysinger <vapier-aBrp7R+bbdUdnm+yROfE0A@public.gmane.org>, Arun Sharma <asharma-b10kYP2dOMg@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

From: Wanpeng Li <liwp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

Changelog:

* drop memcg: move recent_rotated and recent_scanned informations patch
* fix  zone_page_state()::/include/linux/vmstat.h returns 'unsigned long'

Wanpeng Li (6):

memcg: replace unsigned long by u64 to avoid overflow
memcg: cleanup useless LRU_ALL_EVICTABLE
memcg: change mem_control_xxx to mem_cgroup_xxx
memcg: optimize memcg_get_hierarchical_limit
memcg: cleanup all typo in memory cgroup

Signed-off-by: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 include/linux/mmzone.h |    2 +-
 include/linux/vmstat.h |    2 +-
 mm/memcontrol.c        |   40 +++++++++++++++++++---------------------
 3 files changed, 21 insertions(+), 23 deletions(-)
