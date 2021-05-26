From: yulei.kernel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Subject: [RFC 0/7] Introduce memory allocation speed throttle in memcg
Date: Thu, 27 May 2021 00:17:57 +0800
Message-ID: <cover.1622043596.git.yuleixzhang@tencent.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=A0w/o3IkjMbtzBP+G5B7RkNRxwztBrjISmACawCMzhc=;
        b=BzhDZu2ZZfru6U5oCb5BuNBaDkOXDDmaGoh9ZU4xsSlhADs1QRoctIFAj4OB+56NtW
         cS3vx8lvM1pT3lqCZOeMHAGgGF85CNGH7vd8UxYSKanRD288+mz2AXdrCZTmKTqjJiVj
         hN/7NL6lGceX+7YklcQSnP29WGQ2s4ezLgmhy9Jed5XTpz/IKptb8Y1KlnPC0crLxCbN
         IknFuUNLAa19NEvBu/HG8POdOBtEPWtIZKo9yhZPnobFAFOICR6e3KO+FAiDU81jOGyb
         velQ4TlIMO7c62fcM8fZvocIaWL3ZmwYTYE7vTGccl/ex2qts0mDyDqTXNh1vXmEuE/n
         kExw==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, christian-STijNZzMWpgWenYVfaLwtA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, benbjiang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org, kernellwp-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Yulei Zhang <yuleixzhang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

From: Yulei Zhang <yuleixzhang-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

In this patch set we present the idea to suppress the memory allocation
speed in memory cgroup, which aims to avoid direct reclaim caused by
memory allocation burst while under memory pressure.

As minimum watermark could be easily broken if certain tasks allocate
massive amount of memory in a short period of time, in that case it will
trigger the direct memory reclaim and cause unacceptable jitters for
latency critical tasks, such as guaranteed pod task in K8s.

With memory allocation speed throttle(mst) mechanism we could lower the
memory allocation speed in certian cgroup, usually for low priority tasks,
so that could avoid the direct memory reclaim in time.

And per-memcg interfaces are introduced under memcg tree, not visiable for
root memcg.
- <cgroup_root>/<cgroup_name>/memory.alloc_bps
 - 0 -> means memory speed throttle disabled
 - non-zero -> value in bytes for memory allocation speed limits

- <cgroup_root>/<cgroup_name>/memory.stat:mst_mem_spd_max
  it records the max memory allocation speed of the memory cgroup in the
  last period of time slice

- <cgroup_root>/<cgroup_name>/memory.stat:mst_nr_throttled
  it represents the number of times for allocation throttling

Yulei Zhang (7):
  mm: record total charge and max speed counter in memcg
  mm: introduce alloc_bps to memcg for memory allocation speed throttle
  mm: memory allocation speed throttle setup in hierarchy
  mm: introduce slice analysis into memory speed throttle mechanism
  mm: introduce memory allocation speed throttle
  mm: record the numbers of memory allocation throttle
  mm: introduce mst low and min watermark

 include/linux/memcontrol.h   |  23 +++
 include/linux/page_counter.h |   8 +
 init/Kconfig                 |   8 +
 mm/memcontrol.c              | 295 +++++++++++++++++++++++++++++++++++
 mm/page_counter.c            |  39 +++++
 5 files changed, 373 insertions(+)

-- 
2.28.0

