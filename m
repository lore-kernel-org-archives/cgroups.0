From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH]
 mm-vmscan-dont-mess-with-pgdat-flags-in-memcg-reclaim-v2-fix
Date: Fri, 6 Apr 2018 12:36:05 -0400
Message-ID: <20180406163605.GE20806@cmpxchg.org>
References: <CALvZod7P7cE38fDrWd=0caA2J6ZOmSzEuLGQH9VSaagCbo5O+A@mail.gmail.com>
 <20180406135215.10057-1-aryabinin@virtuozzo.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
        ; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=G1W9EH839+87r9MXmeuL0pSDxs06KZ8k62C/vHaConA=; b=akaIdFeTT0FencETsReWLrJmI1
        WxxaBYaO1aBd6j31WoAqgLw/sheHq3DQRA0H/zfuYmGhqYkw8jWeBPqbylBNkPa0VHxky944WKPE0
        b+QvVVwoYgbApWN+Yik5E3GojtyKuXdhOprEYzINYJkAtY40DFAX9yD9k83FYMz9J8kY=;
Content-Disposition: inline
In-Reply-To: <20180406135215.10057-1-aryabinin@virtuozzo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Shakeel Butt <shakeelb@google.com>, Mel Gorman <mgorman@techsingularity.net>, Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@kernel.org>, Linux MM <linux-mm@kvack.org>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org

On Fri, Apr 06, 2018 at 04:52:15PM +0300, Andrey Ryabinin wrote:
> On 04/06/2018 05:13 AM, Shakeel Butt wrote:
> > Question: Should this 'flags' be per-node? Is it ok for a congested
> > memcg to call wait_iff_congested for all nodes?
> 
> Indeed, congestion state should be pre-node. If memcg on node A is
> congested, there is no point is stalling memcg reclaim from node B.
> 
> Make congestion state per-cgroup-per-node and record it in
> 'struct mem_cgroup_per_node'.
> 
> Signed-off-by: Andrey Ryabinin <aryabinin@virtuozzo.com>

Thanks for fixing this, Andrey. This is great.

For the combined patch and this fix:

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
