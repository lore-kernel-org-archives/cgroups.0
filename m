From: Yizhuo Zhai <yzhai003@ucr.edu>
Subject: Potential NULL pointer deference in mm/memcontrol.c
Date: Wed, 9 Oct 2019 21:56:04 -0700
Message-ID: <CABvMjLRgShsBiod+GVcqirmKeFLN_KfxdDDwGo22YK0wULepwA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=ucr.edu; i=@ucr.edu; q=dns/txt; s=selector3;
  t=1570683395; x=1602219395;
  h=mime-version:from:date:message-id:subject:to;
  bh=l8fka7UYOSDuLxUdqgi3tx7DvHNj0L8HgAjIPCh+cSg=;
  b=tkjd0RcGZuHPYaNLbkDNXv5uyop0AZvc4JQX6NUuM/5JUR0p12IjM90I
   HFrCxXKuDCEcpZU8j8YYv3yt1I7s1IIez/e7W8Mv/IY5mbf6nZh06US3c
   MO5pfFlNCCgHaxiOlbW2Q/tLmGJCQXt8tQ1VkAYdltEhlJpVr9rNwsbvI
   Bfeqjf1s34ZSp5mwaRkieUJKJpaoL6RA+vfcY9+hqMrpsmApIfhNVonst
   TSYoGXyYXkOCNwDnLknVF9shs7f4765Crtr3SCMUETEvdWEi9Iwp73RFl
   q8dlMYzc1tXuZiD6nE56+aFMF3BIhaZH5iIW+BVOKWNq0Ap00V46yi+ey
   A==;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Zhiyun Qian <zhiyunq@cs.ucr.edu>, Chengyu Song <csong@cs.ucr.edu>

Hi All:
mm/memcontrol.c:
The function mem_cgroup_from_css() could return NULL, but some callers
in this file
checks the return value but directly dereference it, which seems
potentially unsafe.
Such callers include mem_cgroup_hierarchy_read(),
mem_cgroup_hierarchy_write(), mem_cgroup_read_u64(),
mem_cgroup_reset(), etc.
-- 
Kind Regards,

Yizhuo Zhai

Computer Science, Graduate Student
University of California, Riverside
