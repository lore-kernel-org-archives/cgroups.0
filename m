From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 0/2] memcg: OOM log improvements
Date: Wed, 26 Apr 2023 13:39:17 +0000
Message-ID: <20230426133919.1342942-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682516362; x=1685108362;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=FB4DXeiyaGWRGpg1RZJs4YrYQeUFxP8q5oC/iiUzgWk=;
        b=emGe3v+hKdvQrvjl4a2uL61Vidypm6iAFv9LSm15rGZal80ihx30dhzmaX4DR2L5FI
         tzvhVTsOh4fiIVKvw8+UJCzuQDaHqPwEDZnDfNM9fcc/5zhQ7ZE02esGSLVrOacFGa2w
         PbUcgEDLQnqqBYxN8oTZvoL/7EkcSB7Fmoc93quhvb+ktB1bnrmZe3xDyxBjM3c6j1rK
         SAP7DHJ7DGgrwr66cJZRVAOm37uuP+EvleqsdnJUlRGJOdNwzmWm5u2YBeR8mCuVrKsp
         +4dbdz//BxR2iJejLqq+0lkxEiAE1VA6eocg/jtU4SCC2xkrltYe/xm1xPFS9I+qR8OR
         Tllw==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Chris Li <chrisl-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

This short patch series brings back some cgroup v1 stats in OOM logs,
and it makes memcg OOM logging less reliant on printk() internals.

The series uses seq_buf_do_printk() which was only recently introduced
[1]. It did not land in Linus's tree yet, but ideally it will land this
merge window. I thought I would share the patches meanwhile for
feedback.

[1]https://lore.kernel.org/lkml/20230415100110.1419872-1-senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org/

Yosry Ahmed (2):
  memcg: use seq_buf_do_printk() with mem_cgroup_print_oom_meminfo()
  memcg: dump memory.stat during cgroup OOM for v1

 mm/memcontrol.c | 85 ++++++++++++++++++++++++++++---------------------
 1 file changed, 48 insertions(+), 37 deletions(-)

-- 
2.40.1.495.gc816e09b53d-goog

