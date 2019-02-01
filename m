From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] mm: Throttle allocators when failing reclaim over
 memory.high
Date: Fri, 1 Feb 2019 08:17:57 +0100
Message-ID: <20190201071757.GE11599@dhcp22.suse.cz>
References: <20190201011352.GA14370@chrisdown.name>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190201011352.GA14370@chrisdown.name>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, Roman Gushchin <guro@fb.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, kernel-team@fb.com

On Thu 31-01-19 20:13:52, Chris Down wrote:
[...]
> The current situation goes against both the expectations of users of
> memory.high, and our intentions as cgroup v2 developers. In
> cgroup-v2.txt, we claim that we will throttle and only under "extreme
> conditions" will memory.high protection be breached. Likewise, cgroup v2
> users generally also expect that memory.high should throttle workloads
> as they exceed their high threshold. However, as seen above, this isn't
> always how it works in practice -- even on banal setups like those with
> no swap, or where swap has become exhausted, we can end up with
> memory.high being breached and us having no weapons left in our arsenal
> to combat runaway growth with, since reclaim is futile.
> 
> It's also hard for system monitoring software or users to tell how bad
> the situation is, as "high" events for the memcg may in some cases be
> benign, and in others be catastrophic. The current status quo is that we
> fail containment in a way that doesn't provide any advance warning that
> things are about to go horribly wrong (for example, we are about to
> invoke the kernel OOM killer).
> 
> This patch introduces explicit throttling when reclaim is failing to
> keep memcg size contained at the memory.high setting. It does so by
> applying an exponential delay curve derived from the memcg's overage
> compared to memory.high.  In the normal case where the memcg is either
> below or only marginally over its memory.high setting, no throttling
> will be performed.

How does this play wit the actual OOM when the user expects oom to
resolve the situation because the reclaim is futile and there is nothing
reclaimable except for killing a process?
-- 
Michal Hocko
SUSE Labs
