From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: Re: [PATCH 0/5] memcg/kmem: switch to white list policy
Date: Tue, 10 Nov 2015 10:49:14 +0300
Message-ID: <20151110074914.GQ31308@esperanza>
References: <cover.1446924358.git.vdavydov@virtuozzo.com>
 <20151109140832.GE8916@dhcp22.suse.cz>
 <20151109182840.GJ31308@esperanza>
 <20151109185401.GB28507@mtj.duckdns.org>
 <20151109192747.GN31308@esperanza>
 <20151109193253.GC28507@mtj.duckdns.org>
 <20151109201218.GP31308@esperanza>
 <20151109203053.GD28507@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20151109203053.GD28507@mtj.duckdns.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Greg Thelen <gthelen@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Nov 09, 2015 at 03:30:53PM -0500, Tejun Heo wrote:
...
> Hmm.... can't we simply merge among !SLAB_ACCOUNT and SLAB_ACCOUNT
> kmem_caches within themselves?  I don't think we'd be losing anything
> by restricting merge at that level.  For anything to be tagged
> SLAB_ACCOUNT, it has to have a potential to grow enormous after all.

OK, I'll prepare v2 which will introduce SLAB_ACCOUNT and add it to
SLAB_MERGE_SAME. Let's see what slab maintainers think of it.

Thanks,
Vladimir

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
