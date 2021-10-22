From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH memcg v2 0/2] memcg: prohibit unconditional exceeding the
 limit of dying tasks
Date: Fri, 22 Oct 2021 11:10:40 +0300
Message-ID: <21d79b86-476c-a8f2-e950-2339606f1253@virtuozzo.com>
References: <YXGZoVhROdFG2Wym@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=I94JF+1Ykb3U0G26LvnbC6EWbDpqVzT8bJcMB6mWzrA=; b=EmZl+hgNLkbPo1rB/Ms
        dotFtuMe+e6rzOv5Pz5/dmgyjg9fh/DFh2nJnICgZqxYqgNnjzLeZtfoXSMLl8vXc8eAm2Inc4c/z
        /bxHuu8lQdcxpbOB/W0t/hoxUrq6uHRKTBV2ZFvhi8q1U8hqxCRO46JREZtsA3uq+vZgLkaG0xc=;
In-Reply-To: <YXGZoVhROdFG2Wym-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Uladzislau Rezki <urezki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

Memory cgroup charging allows killed or exiting tasks to exceed the hard
limit. It can be misused and allow to trigger global OOM from inside
memcg-limited container. On the other hand if memcg fail allocation,
called from inside #PF handler it trigger global OOM from inside
pagefault_out_of_memory().

To prevent these problems this patch set:
1) removes execution of out_of_memory() from pagefault_out_of_memory(),
   becasue nobody can explain why it is necessary.
2) allows memcg to fail the allocations of dying/killed tasks. 

v2: resplit,
    use old patch from Michal Hocko removing out_of_memory() from
      pagefault_out_of_memory()

Michal Hocko (1):
  mm, oom: do not trigger out_of_memory from the #PF

Vasily Averin (1):
  memcg: prohibit unconditional exceeding the limit of dying tasks

 mm/memcontrol.c | 27 ++++++++-------------------
 mm/oom_kill.c   | 23 ++++++++++-------------
 2 files changed, 18 insertions(+), 32 deletions(-)

-- 
2.32.0

