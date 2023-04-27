From: Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH 1/2] memcg: use seq_buf_do_printk() with
 mem_cgroup_print_oom_meminfo()
Date: Thu, 27 Apr 2023 09:45:25 +0900
Message-ID: <20230427004525.GE1496740@google.com>
References: <20230426133919.1342942-1-yosryahmed@google.com>
 <20230426133919.1342942-2-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1682556331; x=1685148331;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ts741rvt3EAjVFILrn+Ylxxz4plnfZzZiWZWR2pi4+E=;
        b=X0/KEcMUWIF64/6JcKv0zgFw7E6ZmkGDYstg9d2n+0xZVW4F88EUh6zA77/6TpQGMs
         m7hDdPloutxu/VAItlE5Szi5wAHQKb7SB5rObMOVrSOz8+O7W9C9QnrjhvFlAb7P5jaN
         aU7b4Qu8CWA8HSx3LJzqmehasjFzH3h3W+3P0=
Content-Disposition: inline
In-Reply-To: <20230426133919.1342942-2-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Chris Li <chrisl-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On (23/04/26 13:39), Yosry Ahmed wrote:
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

FWIW,
Reviewed-by: Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
