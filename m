From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 0/2] memcg: OOM log improvements
Date: Fri, 28 Apr 2023 13:24:04 +0000
Message-ID: <20230428132406.2540811-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682688250; x=1685280250;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=WHCBk5ekoAeggcfMzSItuZKOWJ2+XlF6kZloOg6sBWI=;
        b=ExU31UHiJbjXrqTR/RqtL1j7rtOUfrWye3kSIY+A9bN+qQOyMIen7nZ14d0Cslj/rw
         0K0Bqef8k5GwIXCOnaTSAtRwXteDZmLIh3M61j5KjQlBPVJeSd7nlkWo+zsS3dmJYcg1
         4kPNtWe5dhSdiycCKhAgpILFExYKaISctW+uSpbiivNtdrGlhP1C28da5SqI+Iiz/NK1
         BUf2RYaYobH43+xZz2BSvVquZXldFj1iCvK92+4k6ySBsJwHjva5lbQtAhc1AiBKG1pL
         LpsLc8MUIU41XiyWbUGY1rpSwpiDqSKC8VLyEJxX3Lg3X0R8kl5GTNZ9vmj9HQs11RGP
         83HQ==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Chris Li <chrisl-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

This short patch series brings back some cgroup v1 stats in OOM logs
that were unnecessarily changed before. It also makes memcg OOM logs
less reliant on printk() internals.

The series uses seq_buf_do_printk() which was only recently introduced
[1]. It did not land in Linus's tree yet, but ideally it will land this
merge window. It lives in linux-next as commit 96928d9032a7 ("seq_buf:
Add seq_buf_do_printk() helper").

v1 -> v2:
- Collect Ack's and Reviewed-by's on patch 1 (thanks!).
- Reworded the commit log for patch 2 after discussions with Michal
  Hocko.

[1]https://lore.kernel.org/lkml/20230415100110.1419872-1-senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org/

Yosry Ahmed (2):
  memcg: use seq_buf_do_printk() with mem_cgroup_print_oom_meminfo()
  memcg: dump memory.stat during cgroup OOM for v1

 mm/memcontrol.c | 85 ++++++++++++++++++++++++++++---------------------
 1 file changed, 48 insertions(+), 37 deletions(-)

-- 
2.40.1.495.gc816e09b53d-goog

