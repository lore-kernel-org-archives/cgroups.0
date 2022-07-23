From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [PATCH] mm: Remove the redundant updating of
 stats_flush_threshold
Date: Sat, 23 Jul 2022 21:43:45 +0800
Message-ID: <Ytv7EX1FzNg1uz1t@FVFYT0MHHV2J.usts.net>
References: <20220722164949.47760-1-jiebin.sun@intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nPpL7FVl1H6PqS4nSrWEyucV5KSmiF3t3mUkvRlHKBU=;
        b=33Pvm3siw1zIA/gqHlaxpRttHKirwq32HP3voocw7GvlH7yCIugm82MXFYusTQBr68
         knM800EJZgRHqXkSz7vdMPH3+5nKTta1dlmxzWt1AqMHiPlfYhv0qE8Lmd67TKIE8cXK
         rQN5NAzCXFChsjY2ct3ErpJIaAVOoyjfoH/sp22cfnNJAudeIYuaprca7rtdbQIfPEMM
         o2S1DnSjoLj7gxj3OOKF3zmA0043M82rpl8M+OCxC19U9RBfGtjyWE369bahfWSt2Txg
         K+a38XrTyNcnAJgQhy0yydkXBJRwQHzyyX8LwMGfX8ANV+E9J63tSjuXbvJocqeDTSnn
         6aYg==
Content-Disposition: inline
In-Reply-To: <20220722164949.47760-1-jiebin.sun-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jiebin Sun <jiebin.sun-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, amadeuszx.slawinski-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tianyou.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, wangyang.guo-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org

On Sat, Jul 23, 2022 at 12:49:49AM +0800, Jiebin Sun wrote:
> From: jiebin sun <jiebin.sun-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> Remove the redundant updating of stats_flush_threshold. If the
> global var stats_flush_threshold has exceeded the trigger value
> for __mem_cgroup_flush_stats, further increment is unnecessary.
> 
> Apply the patch and test the pts/hackbench-1.0.0 Count:4 (160 threads).
> 
> Score gain: 1.95x
> Reduce CPU cycles in __mod_memcg_lruvec_state (44.88% -> 0.12%)
> 
> CPU: ICX 8380 x 2 sockets
> Core number: 40 x 2 physical cores
> Benchmark: pts/hackbench-1.0.0 Count:4 (160 threads)
> 
> Signed-off-by: Jiebin Sun <jiebin.sun-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Acked-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Thanks.
