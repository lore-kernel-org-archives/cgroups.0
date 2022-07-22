From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH] mm: Remove the redundant updating of stats_flush_threshold
Date: Fri, 22 Jul 2022 16:22:57 +0000
Message-ID: <20220722162257.bl5zhc7ta6jvuy5e@google.com>
References: <20220722164949.47760-1-jiebin.sun@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=1v2THhkhdYklOspAmtCEFIjJCUUKeZARMXv38MhEpow=;
        b=UdOoN7qszmGcLnXMR4Ew1xMk2ipFrNQlnWb3XVRdsbye4OO074AP9hVBoaK+o/nqK/
         CwKsZVRH5EgCwsoFrJMaA1WNLMs35xMsQgcbYZN/OGUI1c0YAVZY7U60QZJ0pz/GkYg1
         O53wc4BVKC5ra0Dz2rtYq9nfp8be8Fz1BprUoXtxN1kdcLIcWwcoFHfg5otCLDGgQVeN
         KxJVE/sLDbVrbc17rkla+7UpCEF4GFgUU1vEEoDCBaSF+fDLyzn89cShgYYjgx7BnkNB
         XPBHkIJ6zv2qG5FtDrr9wveeK/ub8/0hS0rM0Wu1atXR494PpbVCtp3fMS5dI5EyK9jU
         wUTw==
In-Reply-To: <20220722164949.47760-1-jiebin.sun@intel.com>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Jiebin Sun <jiebin.sun@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, songmuchun@bytedance.com, akpm@linux-foundation.org, tim.c.chen@intel.com, ying.huang@intel.com, amadeuszx.slawinski@linux.intel.com, tianyou.li@intel.com, wangyang.guo@intel.com

On Sat, Jul 23, 2022 at 12:49:49AM +0800, Jiebin Sun wrote:
> From: jiebin sun <jiebin.sun@intel.com>
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
> Signed-off-by: Jiebin Sun <jiebin.sun@intel.com>

Yes, this makes sense. No need to dirty a cacheline if we are already
over the threshold.

Acked-by: Shakeel Butt <shakeelb@google.com>

