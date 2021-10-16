From: Vasily Averin <vvs@virtuozzo.com>
Subject: Re: [PATCH mm v5] memcg: enable memory accounting in
 __alloc_pages_bulk
Date: Sat, 16 Oct 2021 09:04:07 +0300
Message-ID: <12d991ba-1702-c648-c4c7-5f9bd507582d@virtuozzo.com>
References: <0baa2b26-a41b-acab-b75d-72ec241f5151@virtuozzo.com>
 <65c1afaf-7947-ce28-55b7-06bde7aeb278@virtuozzo.com>
 <20211015143405.b7d54e4afa4ca7b2d57b6140@linux-foundation.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=xI7kQGX5KyJoY+1LjCTdHRnFhsACsaLASZrxq3vB3gA=; b=xKcMUdmxkPpA+p6rh
        y0D0ZcC/9R6ITj2oAfdNBB1Ds822WSFnZaFiCfyqVwUYngECrTruzlLlgI2pGWTgLd5XfYJ4s5k0B
        Iqdr/wHa7dhaA72qYTc0GAVDXaCmbT6HC4eh6JqXmW7Na6pFF5y/sQJnUPvKhJkfsAG21VQopb12g
        =;
In-Reply-To: <20211015143405.b7d54e4afa4ca7b2d57b6140@linux-foundation.org>
Content-Language: en-US
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Shakeel Butt <shakeelb@google.com>, Mel Gorman <mgorman@techsingularity.net>, Roman Gushchin <guro@fb.com>, Uladzislau Rezki <urezki@gmail.com>, Vlastimil Babka <vbabka@suse.cz>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel@openvz.org

On 16.10.2021 00:34, Andrew Morton wrote:
> On Thu, 14 Oct 2021 11:02:57 +0300 Vasily Averin <vvs@virtuozzo.com> wrote:
> 
>> Bulk page allocator is used in vmalloc where it can be called
>> with __GFP_ACCOUNT and must charge allocated pages into memory cgroup.
> 
> Is this problem serious enough to justify -stable backporting?  Some
> words which explaining reasoning for the backport would be helpful.
> 
> This patch makes Shakeel's "memcg: page_alloc: skip bulk allocator for
> __GFP_ACCOUNT" unnecessary.  Which should we use?

Please use Shakeel's patch.

My patch at least requires review, so at present it should be delayed.
I've submitted it because it may be useful later.
Moreover  Currently it have minor issue, function in !MEMCG_KMEM branch
in of memcontrol.h should be declare as static inline.

Thank you,
	Vasily Averin
