From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] MAINTAINERS: make Vladimir co-maintainer of the memory
 controller
Date: Tue, 1 Dec 2015 09:33:15 +0100
Message-ID: <20151201083314.GA4567@dhcp22.suse.cz>
References: <1448908170-2990-1-git-send-email-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1448908170-2990-1-git-send-email-hannes@cmpxchg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vladimir Davydov <vdavydov@virtuozzo.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon 30-11-15 13:29:30, Johannes Weiner wrote:
> Vladimir architected and authored much of the current state of the
> memcg's slab memory accounting and tracking. Make sure he gets CC'd
> on bug reports ;-)
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Michal Hocko <mhocko@suse.com>

> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index ea17512..f97f17f 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -2973,6 +2973,7 @@ F:	kernel/cpuset.c
>  CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)
>  M:	Johannes Weiner <hannes@cmpxchg.org>
>  M:	Michal Hocko <mhocko@kernel.org>
> +M:	Vladimir Davydov <vdavydov@virtuozzo.com>
>  L:	cgroups@vger.kernel.org
>  L:	linux-mm@kvack.org
>  S:	Maintained
> -- 
> 2.6.2

-- 
Michal Hocko
SUSE Labs
