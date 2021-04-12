From: yulei.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [RFC v2 0/2] introduce new attribute "priority" to control group
Date: Tue, 13 Apr 2021 00:40:09 +0800
Message-ID: <cover.1618219939.git.yuleixzhang@tencent.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rWd8qaffFtx7x0KdjfNiWGmezRnoMswRgKduJuFiO4A=;
        b=WEvsRmRxGAgXGh1Q+11q9oWawxwjMoAvDbSSeSLffAn+syXlTlKtqPce9hXAFsv1EQ
         Qb4wTXhTPMBsqKmhqz0/FGvuIwxwgtJg/ztFW9/GLhJ0DMS/jmc+AEkeZTG6K24Bu3oO
         XOh/0L2v5CfHP3Osp9aiNhDOgLXTApyKFSkZDjb6zsqHDa87D1g77S0vJJ8Oao9Tb0hV
         WO6V/slUu9coDshH8er9wOtVgm4guloaK/+HnxPUu/OvUSfysY50fvvNRDp16cfDlufZ
         knvN/TZXW1z20kQLfNVlBKXRGBADo7+gJzufp5eLhx0LmORqOs+NOCEmFRppfBV2DSrm
         sJyg==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, benbjiang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, kernellwp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, lihaiwei.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linussli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, herberthbli-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, Yulei Zhang <yuleixzhang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

From: Yulei Zhang <yuleixzhang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

Last time we introduce the idea of adding prioritized tasks management
to control group. Sometimes we may assign the same amount of resources
to multiple cgroups due to the environment restriction, but we still 
hope there are preference order to handle the tasks in those cgroups,
the 'prio' attribute may help to do the ranking jobs. 

The default value of "priority" is set to 0 which means the highest
priority, and the totally levels of priority is defined by
CGROUP_PRIORITY_MAX. Each subsystem could register callback to receive the
priority change notification for their own purposes. 

In this v2 patch we apply a simple rule to the oom hanlder base on the
order of priority to demonstrate the intention about adding this attribute.
When enable the prioritized oom, it will perfer to pick up the victim from the
memory cgroup with lower priority, and try the best to keep the tasks
alive in high ranked memcg.

V2->V1:
1. Introduce prioritized oom in memcg.

Lei Chen (1):
  cgroup: add support for cgroup priority

Yulei Zhang (1):
  memcg: introduce prioritized oom in memcg

 include/linux/cgroup-defs.h |  2 +
 include/linux/cgroup.h      |  2 +
 include/linux/memcontrol.h  | 38 ++++++++++++++
 include/linux/oom.h         |  1 +
 kernel/cgroup/cgroup.c      | 90 +++++++++++++++++++++++++++++++++
 mm/memcontrol.c             | 99 ++++++++++++++++++++++++++++++++++++-
 mm/oom_kill.c               |  6 +--
 7 files changed, 233 insertions(+), 5 deletions(-)

-- 
2.28.0

