From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: Re: [PATCH v2 7/7] Documentation: cgroup: add
 memory.swap.{current,max} description
Date: Fri, 18 Dec 2015 18:39:24 +0300
Message-ID: <20151218153924.GT28521@esperanza>
References: <cover.1450352791.git.vdavydov@virtuozzo.com>
 <dbb4bf6bc071997982855c8f7d403c22cea60ffb.1450352792.git.vdavydov@virtuozzo.com>
 <567374AB.3010101@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <567374AB.3010101@jp.fujitsu.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Dec 18, 2015 at 11:51:23AM +0900, Kamezawa Hiroyuki wrote:
...
> Could you give here a hint how to calculate amount of swapcache,
> counted both in memory.current and swap.current ?

Currently it's impossible, but once memory.stat has settled in the
unified hierarchy, it might be worth adding a stat counter for such
pages (equivalent to SwapCached in the global /proc/meminfo).

Thanks,
Vladimir

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
