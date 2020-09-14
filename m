From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 0/3] mm/memcg: Miscellaneous cleanups and streamlining
Date: Sun, 13 Sep 2020 22:44:49 -0400
Message-ID: <20200914024452.19167-1-longman@redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600051517;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=aBvg4ZsjHs40Kc9w9Qs5hEd580WSaR6Ix3MTYhAg0bQ=;
        b=Dv23q6GRTnIlY8c56FNqDQiRRQ5ArizTIL8qAONQho3n7rBN+MjVZpTLBc3GRkCtZqd5ii
        WEgIuXfvETfUsOAhTuz+MZsd31avubEJ1iOQ/Lg2LHhOlMcLmLvnGd3WFz88GLpG8JCoQG
        HVK7SA78xhrumwse/JPBhbDOW1iRtj0=
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

v2:
 - For patch 2, separate v1 and v2 processing and add back the missing
   total_swap_pages check.
 - For patch 3, use union to merge swap and memsw page counters.

Patch 1 removes an unused enum charge_type.

Patch 2 streamlines mem_cgroup_get_max().

Patch 3 unifies swap and memsw page counters in mem_cgroup.

Waiman Long (3):
  mm/memcg: Clean up obsolete enum charge_type
  mm/memcg: Simplify mem_cgroup_get_max()
  mm/memcg: Unify swap and memsw page counters

 include/linux/memcontrol.h | 13 ++++++++-----
 mm/memcontrol.c            | 29 ++++++++---------------------
 2 files changed, 16 insertions(+), 26 deletions(-)

-- 
2.18.1

