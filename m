From: Mel Gorman <mgorman@techsingularity.net>
Subject: Re: [PATCH memcg] mm/page_alloc.c: avoid statistic update with 0
Date: Tue, 12 Oct 2021 12:38:04 +0100
Message-ID: <20211012113804.GT3959@techsingularity.net>
References: <b2371951-bb8a-e62e-8d33-10830bbf6275@virtuozzo.com>
 <29155011-f884-b0e5-218e-911039568acb@suse.cz>
 <f52c5cd3-9b74-0fd5-2b7b-83ca21c52b2a@virtuozzo.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <f52c5cd3-9b74-0fd5-2b7b-83ca21c52b2a@virtuozzo.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs@virtuozzo.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel@openvz.org, Uladzislau Rezki <urezki@gmail.com>

On Tue, Oct 12, 2021 at 01:42:41PM +0300, Vasily Averin wrote:
> On 08.10.2021 14:47, Vlastimil Babka wrote:
> > On 10/8/21 11:24, Vasily Averin wrote:
> >> __alloc_pages_bulk can call __count_zid_vm_events and zone_statistics
> >> with nr_account = 0.
> > 
> > But that's not a bug, right? Just an effective no-op that's not commonly
> > happening, so is it worth the check?
> 
> Why not?
> 
> Yes, it's not a bug, it just makes the kernel a bit more efficient in a very unlikely case.

At the cost of an additional branch in the likely case that may be
mispredicted.

> However, it looks strange and makes uninformed code reviewers like me worry about possible
> problems inside the affected functions. No one else calls these functions from 0.
>  

The accounting functions should still work with a 0 delta.

-- 
Mel Gorman
SUSE Labs
