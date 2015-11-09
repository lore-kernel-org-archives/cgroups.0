From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 0/5] memcg/kmem: switch to white list policy
Date: Mon, 9 Nov 2015 14:32:53 -0500
Message-ID: <20151109193253.GC28507@mtj.duckdns.org>
References: <cover.1446924358.git.vdavydov@virtuozzo.com>
 <20151109140832.GE8916@dhcp22.suse.cz>
 <20151109182840.GJ31308@esperanza>
 <20151109185401.GB28507@mtj.duckdns.org>
 <20151109192747.GN31308@esperanza>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=wftz+MPS0tHwciqGm/NJt3TLZq9QYK92CnTOCikn6/g=;
        b=JOuQj/yfDXLDqja5ZbLMxIslDyQcpZMLY7mZc+OQapno9TZmL1+Ewgs70TanxJ9W0B
         jg6E6IcC2zjPtIssurCpWJ+kPxvX4RMIw8pmB05LINhMge38bVLx0pZx5DfgWskLDXJU
         4IkM/7CnWxJQhyVbju06n6F1o+mbtVULSXwqEp53bGyVVkZHH6HcB3EaKU06oFoGhMfp
         HtXcaD3Nu9fh9C1o3lZSsjmnyRYUY3cdtGJ52eexCpgFFHkwgylu2oLPLLtQlpBPIEvJ
         gFpC+YiNuqA0uQK0LlZOzLV0lWYJLU5ugx6e/2pM6IjjOvQifF1wRjiHsC6ddhTGSGH1
         b3ow==
Content-Disposition: inline
In-Reply-To: <20151109192747.GN31308@esperanza>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Greg Thelen <gthelen@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hello, Vladmir.

On Mon, Nov 09, 2015 at 10:27:47PM +0300, Vladimir Davydov wrote:
> Of course, we could rework slab merging so that kmem_cache_create
> returned a new dummy cache even if it was actually merged. Such a cache
> would point to the real cache, which would be used for allocations. This
> wouldn't limit slab merging, but this would add one more dereference to
> alloc path, which is even worse.

Hmmm, this could be me not really understanding but why can't we let
all slabs to be merged regardless of SLAB_ACCOUNT flag for root memcg
and point to per-memcg slabs (may be merged among them but most likely
won't matter) for !root.  We're indirecting once anyway, no?

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
