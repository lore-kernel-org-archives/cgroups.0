From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm/workingset: do not forget to unlock page
Date: Wed, 3 Feb 2016 11:24:00 -0500
Message-ID: <20160203162400.GB10440@cmpxchg.org>
References: <1454493513-19316-1-git-send-email-sergey.senozhatsky@gmail.com>
 <20160203104136.GA517@swordfish>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20160203104136.GA517@swordfish>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vladimir Davydov <vdavydov@virtuozzo.com>, Michal Hocko <mhocko@suse.cz>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

On Wed, Feb 03, 2016 at 07:41:36PM +0900, Sergey Senozhatsky wrote:
> From 1d6315221f2f81c53c99f9980158f8ae49dbd582 Mon Sep 17 00:00:00 2001
> From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
> Date: Wed, 3 Feb 2016 18:49:16 +0900
> Subject: [PATCH] mm/workingset: do not forget to unlock_page in workingset_activation
> 
> Do not return from workingset_activation() with locked rcu and page.
> 
> Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

Thanks Sergey. Even though I wrote this function, my brain must have
gone "it can't be locking anything when it returns NULL, right?" It's
a dumb interface. Luckily, that's fixed with follow-up patches in -mm.

As for this one:

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Fixes: mm: workingset: per-cgroup cache thrash detection

Andrew, can you please fold this?

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
