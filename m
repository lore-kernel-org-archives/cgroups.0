From: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v4 0/3] memcg: cleanup memory cgroup
Date: Mon, 25 Jun 2012 17:33:13 +0800
Message-ID: <1340616793-10142-1-git-send-email-liwp.linux@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer;
        bh=+hUkk8dQshBs2Dy/PYMhv4lFDjL/mU9zIx5hW7X5CH8=;
        b=cCEI8RWDnW6W3w+3ypXAoKxlQpZAWD4z7SXRThfyCq5bZegKeCnXJZe3QZIxyMTWLs
         J+VbSix/1zA8quU621KVfog4FFohETHpnRrv4r4zCITIX4KzDP/3TLg4At+FpemDOmBi
         qpZP3hqIbvxhENRVpD6/yOjTkl5LUInkC21YjjQB/2G3mVmZ7BBPxabXmymIS05h0kyM
         Sg6Qa7VpjgS4GFgNcrsbSOj+rCwnCTTSFxTUIF/XPJOAbhgpjaUTLH1Bqj3IGPC2iGPc
         bi9KlG5tVFwuYLEZuClrV0pLZIVOlDuMz1Te/6AMS2TZRg5TJbD1Y4nGlujX1YrO/UKo
         Mv2A==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

From: Wanpeng Li <liwp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

Changelog:

* drop memcg: move recent_rotated and recent_scanned informations patch
* drop memcg: replace unsigned long by u64 to avoid overflow
* drop memcg: optimize memcg_get_hierarchical_limit

Wanpeng Li (3):

memcg: cleanup useless LRU_ALL_EVICTABLE
memcg: change mem_control_xxx to mem_cgroup_xxx
memcg: cleanup all typo in memory cgroup

Signed-off-by: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 include/linux/mmzone.h |    2 +-
 include/linux/vmstat.h |    2 +-
 mm/memcontrol.c        |   40 +++++++++++++++++++---------------------
 3 files changed, 21 insertions(+), 23 deletions(-)
