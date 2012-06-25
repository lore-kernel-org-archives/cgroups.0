From: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 0/4] mm/memcg: cleanup memory cgroup
Date: Mon, 25 Jun 2012 16:42:45 +0800
Message-ID: <1340613765-9372-1-git-send-email-liwp.linux@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer;
        bh=wW/hA/VT4qojC1SanTktsapFpgY5rXJmyUEIRAczhG0=;
        b=DePuM5Gh6RsqHEc+OHDicQhkhP88CVjNGNzcHQSOc3c+yxwVrdTBxciBPBzzuMWeC2
         Tdkt772IxF9CkJ/WMfpWUuOt03PqPK7vA7xjF5ZQthKOok9ieuWJJDmmfr2Y1hh04Not
         i0qLCgiLX8y/lkNGDMf0mEfxt8mu6/oh9o1MbAjJgzrBUC/kKYyDI2wLqA5dAGxh7ULa
         ChQjcwwZKS9cjyzgax0hXBvWw9xD92S/AjoRPUgHmvA/BcT6Kk8spaTmGszF+rGjEK44
         Afm1QHbrZT8U5sGFF5Tqp2YqxeC4NEOrzXx//8qSUr9u8CDu3Arjw4f20+OLSAM6ODna
         3Lbg==
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
* drop memcg: replace unsigned long by u64 to avoid overflow

Wanpeng Li (4):

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
