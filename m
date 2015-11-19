From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH v2 2/6] Revert "gfp: add __GFP_NOACCOUNT"
Date: Thu, 19 Nov 2015 13:59:32 -0500
Message-ID: <20151119185932.GB3941@cmpxchg.org>
References: <cover.1447172835.git.vdavydov@virtuozzo.com>
 <7edf2c7333f027ad6a890884558fde60b5144140.1447172835.git.vdavydov@virtuozzo.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <7edf2c7333f027ad6a890884558fde60b5144140.1447172835.git.vdavydov@virtuozzo.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Tejun Heo <tj@kernel.org>, Greg Thelen <gthelen@google.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Nov 10, 2015 at 09:34:03PM +0300, Vladimir Davydov wrote:
> This reverts commit 8f4fc071b1926d0b20336e2b3f8ab85c94c734c5.
> 
> Black-list kmem accounting policy (aka __GFP_NOACCOUNT) turned out to be
> fragile and difficult to maintain, because there seem to be many more
> allocations that should not be accounted than those that should be.
> Besides, false accounting an allocation might result in much worse
> consequences than not accounting at all, namely increased memory
> consumption due to pinned dead kmem caches.
> 
> So it was decided to switch to the white-list policy. This patch reverts
> bits introducing the black-list policy. The white-list policy will be
> introduced later in the series.
> 
> Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
