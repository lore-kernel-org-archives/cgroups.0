From: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v4 0/2] memcg: cleanup memory cgroup
Date: Mon, 25 Jun 2012 19:15:00 +0800
Message-ID: <1340622900-13034-1-git-send-email-liwp.linux@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer;
        bh=5DLNR3r8PT0bX9msn+bbxfsGUSPb12Yqbrgt6q9THfU=;
        b=PZBOQ8pK2E2aLgG/f09+73ICgIdcAPHLTU0/snvhqtgztjGO/9McA5CzAVk8HXJoto
         RyGqnPdwvZiZAlPeI4EO5ZoHdiQU0kdUQ/n5t2EPa6UpCryJswi0KEQS51IQ86dMUXfx
         nrBIS+dBP4Qm9lna+2gwmZF3rKloLtzDzTP3LNQMdUa3n/L7hkhEy90h3uJDx/yvsLhE
         FwYwjfAkuW2ARUf1edgM1gPb11kTODuBoLWV4OAwR0ZpILRmMiXVvAYrupJH0c0dCnfF
         ucJcEUwyIlpaZOKsYjU0uwE2dvurb4Nn/mdhGh44L2b9KTFPx+U7+Ha+mnQGUNwB3dQ9
         fZYg==
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
* not add Add LRU_ALL_UNEVICTABLE
* drop memcg: cleanup all typo in memory cgroup, if it really need, I will resend in single patch
* drop memcg: optimize memcg_get_hierarchical_limit 

Wanpeng Li (2):

memcg: cleanup useless LRU_ALL_EVICTABLE
memcg: change mem_control_xxx to mem_cgroup_xxx

---
 include/linux/mmzone.h |    1 -
 mm/memcontrol.c        |   8 +++---
 2 files changed, 4 insertions(+), 5 deletions(-)
-- 
1.7.9.5
