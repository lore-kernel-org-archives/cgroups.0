From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 2/2] memcg: dump memory.stat during cgroup OOM for v1
Date: Wed, 3 May 2023 18:04:29 +0000
Message-ID: <20230503180429.zxgq4h5rc6gonikm@google.com>
References: <20230428132406.2540811-1-yosryahmed@google.com> <20230428132406.2540811-3-yosryahmed@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683137071; x=1685729071;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WX9b5D7rzQ77/+awqXVJW5yY30EN/bdP/BzW/WEcv4Y=;
        b=LdwlmBbdlsfaGXWQgwsVRjR/EWY38T58sSfiKFEZbOA4CQgTYko1AoCJO4k625/3iM
         ViTDM2Preuu2ZBeNcdAkUhvF3+HFiWN1DPHRkfYcbQCRa8+FL1gc7dMkqyZ7isrbDKBD
         dtkCrQbPmCuYE4+f9eNBZffM1E8qDOeCbWmpdnm35HNjLN9VnrgwgSQhIKpBryY2L8Y/
         TsR9+zdxk/w8Wc2tpa1ve9nu6rNHFw6GJTrJhsXXMTpcR9qJvMTPNWF+vrr7KfJZpq13
         vmfVBu7L+13cGlpFMLapZMacnXnh+OKaC7iUt/6FX+HbKhzBqql5LWlZF50t57n4ufzG
         sLww==
In-Reply-To: <20230428132406.2540811-3-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Sergey Senozhatsky <senozhatsky-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Petr Mladek <pmladek-IBi9RG/b67k@public.gmane.org>, Chris Li <chrisl-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Apr 28, 2023 at 01:24:06PM +0000, Yosry Ahmed wrote:
> Commit c8713d0b2312 ("mm: memcontrol: dump memory.stat during cgroup
> OOM") made sure we dump all the stats in memory.stat during a cgroup
> OOM, but it also introduced a slight behavioral change. The code used to
> print the non-hierarchical v1 cgroup stats for the entire cgroup
> subtree, now it only prints the v2 cgroup stats for the cgroup under
> OOM.
> 
> For cgroup v1 users, this introduces a few problems:
> (a) The non-hierarchical stats of the memcg under OOM are no longer
> shown.
> (b) A couple of v1-only stats (e.g. pgpgin, pgpgout) are no longer
> shown.
> (c) We show the list of cgroup v2 stats, even in cgroup v1. This list of
> stats is not tracked with v1 in mind. While most of the stats seem to be
> working on v1, there may be some stats that are not fully or correctly
> tracked.
> 
> Although OOM log is not set in stone, we should not change it for no
> reason. When upgrading the kernel version to a version including
> commit c8713d0b2312 ("mm: memcontrol: dump memory.stat during cgroup
> OOM"), these behavioral changes are noticed in cgroup v1.
> 
> The fix is simple. Commit c8713d0b2312 ("mm: memcontrol: dump memory.stat
> during cgroup OOM") separated stats formatting from stats display for
> v2, to reuse the stats formatting in the OOM logs. Do the same for v1.
> 
> Move the v2 specific formatting from memory_stat_format() to
> memcg_stat_format(), add memcg1_stat_format() for v1, and make
> memory_stat_format() select between them based on cgroup version.
> Since memory_stat_show() now works for both v1 & v2, drop
> memcg_stat_show().
> 
> Signed-off-by: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Acked-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
