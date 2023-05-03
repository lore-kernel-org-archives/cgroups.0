From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 1/2] memcg: use seq_buf_do_printk() with mem_cgroup_print_oom_meminfo()
Date: Wed, 3 May 2023 17:52:26 +0000
Message-ID: <20230503175226.nyjmmbnohm6xxckd@google.com>
References: <20230428132406.2540811-1-yosryahmed@google.com> <20230428132406.2540811-2-yosryahmed@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683136348; x=1685728348;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=RZYSjSUR1TVNLCONU/ktPYm4b5B8g2ry+YtlqDqVDwA=;
        b=06jHQvfsD3SDUJMSu6ULA+Lqi2Rheb3urP5pez8MV1dafSxYy0/iecp7i3W9YM8kw0
         Z8sDp7LJx6LxY6887Lp9tpfA2PRnZ+5qsmf/2ne9kOhMV6oNSgGhzuXqwMC3i6HQpw8p
         D8X9p8yhzKfJ/bgSYEC5uIPGefibu0HxTKSIOIWINb3PnNySA5vrkGDdfiFHPxJVa3eg
         fzeTNSZPX/rk1YdIOuq6L93DdQc6YUPO6bt/7O5Wu9R3mWPc7MGSncLmqdQi7vfNKPNv
         eNUJWumFkZPqhtINkPq+WqdkN0g7gmfclLzeSV9JpuQEB/g+6NsZV9V3lB08IqjbYy4P
         Yf/Q==
In-Reply-To: <20230428132406.2540811-2-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Chris Li <chrisl-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

On Fri, Apr 28, 2023 at 01:24:05PM +0000, Yosry Ahmed wrote:
> Currently, we format all the memcg stats into a buffer in
> mem_cgroup_print_oom_meminfo() and use pr_info() to dump it to the logs.
> However, this buffer is large in size. Although it is currently working
> as intended, ther is a dependency between the memcg stats buffer and the
> printk record size limit.
> 
> If we add more stats in the future and the buffer becomes larger than
> the printk record size limit, or if the prink record size limit is
> reduced, the logs may be truncated.
> 
> It is safer to use seq_buf_do_printk(), which will automatically break
> up the buffer at line breaks and issue small printk() calls.
> 
> Refactor the code to move the seq_buf from memory_stat_format() to its
> callers, and use seq_buf_do_printk() to print the seq_buf in
> mem_cgroup_print_oom_meminfo().
> 
> Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> Reviewed-by: Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

Acked-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
