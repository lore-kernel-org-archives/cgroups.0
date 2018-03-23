From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] mm/memcontrol.c: speed up to force empty a memory cgroup
Date: Fri, 23 Mar 2018 11:34:07 +0100
Message-ID: <20180323103407.GP23100@dhcp22.suse.cz>
References: <1521448170-19482-1-git-send-email-lirongqing@baidu.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1521448170-19482-1-git-send-email-lirongqing@baidu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li RongQing <lirongqing@baidu.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, hannes@cmpxchg.org, Andrey Ryabinin <aryabinin@virtuozzo.com>

On Mon 19-03-18 16:29:30, Li RongQing wrote:
> mem_cgroup_force_empty() tries to free only 32 (SWAP_CLUSTER_MAX) pages
> on each iteration, if a memory cgroup has lots of page cache, it will
> take many iterations to empty all page cache, so increase the reclaimed
> number per iteration to speed it up. same as in mem_cgroup_resize_limit()
> 
> a simple test show:
> 
>   $dd if=aaa  of=bbb  bs=1k count=3886080
>   $rm -f bbb
>   $time echo 100000000 >/cgroup/memory/test/memory.limit_in_bytes
>
> Before: 0m0.252s ===> after: 0m0.178s

One more note. I have only now realized that increasing the patch size
might have another negative side effect. Memcg reclaim bails out early
when the required target has been reclaimed and so we might skip memcgs
in the hierarchy and could end up hamering one child in the hierarchy
much more than others. Our current code is not ideal and we workaround
this by a smaller target and caching the last reclaimed memcg so the
imbalance is not so visible at least.

This is not something that couldn't be fixed and maybe 1M chunk would be
acceptable as well. I dunno. Let's focus on the main bottleneck first
before we start doing these changes though.
-- 
Michal Hocko
SUSE Labs
