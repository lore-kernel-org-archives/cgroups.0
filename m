From: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH memcg RFC 0/3] memcg: prohibit unconditional exceeding the
 limit of dying tasks
Date: Wed, 20 Oct 2021 15:11:35 +0300
Message-ID: <fe1d45a1-276d-b0f4-fb71-8f5c1a9e8872@virtuozzo.com>
References: <YW/WoJDFM3ddHn7Y@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:Subject
        :From; bh=Ogt0vQ4+gupep/lvDlFo1PXQW0DADnBHbHdATcZzm20=; b=bAVEJIxgSYk7Fvn45dl
        zabDL0FPXFzAupZNKZRT+F3njJTT6tY9TEmQJfiWXuyPNfiAgrA40jD02Ij0xywkyAmFyWwkgp9WE
        ArvtFI3nv6lb059uOy/T3Eck744pZCN7U6fYnWGjpyp72IRxDyJtspl6cWMLMCGZo3CyD2VdEsg=;
In-Reply-To: <YW/WoJDFM3ddHn7Y-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Uladzislau Rezki <urezki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Tetsuo Handa <penguin-kernel-1yMVhJb1mP/7nzcFbJAaVXf5DAMn2ifp@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

Dear Michal,
as you requested, I splited v4 patch version into 3 separate parts.
Let's discuss each of them.

Open questions/ToDo:

- Update patch descriptions (and add some comments) 

- in part 2 aka "memcg: remove charge forcinig for dying tasks":
  should we keep task_is_dying() in mem_cgroup_out_of_memory() ?

- in part 3 aka "memcg: handle memcg oom failures"
   what is the best way to notify pagefault_out_of_memory() about 
    mem_cgroup_out_of_memory failure ?
    
- what is the best way to handle memcg failure doe to kmem limit,
    it can trigger false global OOM

Vasily Averin (3):
  mm: do not firce global OOM from inside dying tasks
  memcg: remove charge forcinig for dying tasks
  memcg: handle memcg oom failures

 mm/memcontrol.c | 52 ++++++++++++++++++++++++++++---------------------
 mm/oom_kill.c   |  3 +++
 2 files changed, 33 insertions(+), 22 deletions(-)

-- 
2.32.0

