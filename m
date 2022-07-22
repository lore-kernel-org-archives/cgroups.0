From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH] mm: Remove the redundant updating of
 stats_flush_threshold
Date: Fri, 22 Jul 2022 10:05:41 -0700
Message-ID: <YtrY5V+dZl4+Gtz4@castle>
References: <20220722164949.47760-1-jiebin.sun@intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1658509548;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Y7js1RWyqBx3oqDhoWUrWmYCp205K7/u6aMi9Husos0=;
        b=r7ZEFRF55ukGJSsMqum8ZkCKf6/PLDX0tZRl767erRdenIBURHWA9F1mJlJDIhD2k54sd8
        i38xddVh8wdQJ4uxAkd1BE/363j3hZ9M+lmyMSV5ta9ON9JOP2a41+b9R3+7O8Tcm3FOAA
        8OxpP9CIfaMBpn0ieQXqAHXxtMKqouE=
Content-Disposition: inline
In-Reply-To: <20220722164949.47760-1-jiebin.sun-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jiebin Sun <jiebin.sun-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, tim.c.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ying.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, amadeuszx.slawinski-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tianyou.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, wangyang.guo-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org

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

Reviewed-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>

Good optimization, thanks!
