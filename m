From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v3 3/4] mm: treat memory.low value inclusive
Date: Thu, 5 Apr 2018 15:45:26 -0400
Message-ID: <20180405194526.GC27918@cmpxchg.org>
References: <20180405185921.4942-1-guro@fb.com>
 <20180405185921.4942-3-guro@fb.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
        ; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=0NfF4vVEsKnmZw0xYoLu3HuKb+m+EfRg8JbBU/Nwa5w=; b=0D38xaGOMqxRa2wdKMFEx97HRn
        XlDkrEh4CCqx9Aexo1GPhBthcA95kzp7xdUxxgiMVofY0P4YJA9sllgFyxJKOjIPefJywlgP70CSR
        EgPFU2+fprchw5o90Vqv+bkl687I2ORUAzpesmRrt5h2F9kX8PZDCeB5erY1jpAivquI=;
Content-Disposition: inline
In-Reply-To: <20180405185921.4942-3-guro@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Tejun Heo <tj@kernel.org>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Apr 05, 2018 at 07:59:20PM +0100, Roman Gushchin wrote:
> If memcg's usage is equal to the memory.low value, avoid reclaiming
> from this cgroup while there is a surplus of reclaimable memory.
> 
> This sounds more logical and also matches memory.high and memory.max
> behavior: both are inclusive.

I was trying to figure out why we did it this way in the first place
and found this patch:

commit 4e54dede38b45052a941bcf709f7d29f2e18174d
Author: Michal Hocko <mhocko@suse.cz>
Date:   Fri Feb 27 15:51:46 2015 -0800

    memcg: fix low limit calculation
    
    A memcg is considered low limited even when the current usage is equal to
    the low limit.  This leads to interesting side effects e.g.
    groups/hierarchies with no memory accounted are considered protected and
    so the reclaim will emit MEMCG_LOW event when encountering them.
    
    Another and much bigger issue was reported by Joonsoo Kim.  He has hit a
    NULL ptr dereference with the legacy cgroup API which even doesn't have
    low limit exposed.  The limit is 0 by default but the initial check fails
    for memcg with 0 consumption and parent_mem_cgroup() would return NULL if
    use_hierarchy is 0 and so page_counter_read would try to dereference NULL.
    
    I suppose that the current implementation is just an overlook because the
    documentation in Documentation/cgroups/unified-hierarchy.txt says:
    
      "The memory.low boundary on the other hand is a top-down allocated
      reserve.  A cgroup enjoys reclaim protection when it and all its
      ancestors are below their low boundaries"
    
    Fix the usage and the low limit comparision in mem_cgroup_low accordingly.
    
> @@ -5709,7 +5709,7 @@ bool mem_cgroup_low(struct mem_cgroup *root, struct mem_cgroup *memcg)
>  	elow = min(elow, parent_elow * low_usage / siblings_low_usage);
>  exit:
>  	memcg->memory.elow = elow;
> -	return usage < elow;
> +	return usage <= elow;

So I think this needs to be usage && usage <= elow to not emit
MEMCG_LOW events in case usage == elow == 0.
