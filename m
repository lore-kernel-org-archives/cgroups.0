From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 0/5] memcg/kmem: switch to white list policy
Date: Mon, 9 Nov 2015 11:45:18 -0500
Message-ID: <20151109164518.GA23356@cmpxchg.org>
References: <cover.1446924358.git.vdavydov@virtuozzo.com>
 <20151109140832.GE8916@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20151109140832.GE8916@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Vladimir Davydov <vdavydov@virtuozzo.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Greg Thelen <gthelen@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Nov 09, 2015 at 03:08:32PM +0100, Michal Hocko wrote:
> I am _all_ for this semantic I am just not sure what to do with the
> legacy kmem controller. Can we change its semantic? If we cannot do that
> we would have to distinguish legacy and unified hierarchies during
> runtime and add the flag automagically for the first one (that would
> however require to keep __GFP_NOACCOUNT as well) which is all as clear
> as mud. But maybe the workloads which are using kmem legacy API can cope
> with that.

I think we can make that change for the existing kmem accounting too,
simply because the whitelist should be covering all memory consumers
that actually matter for isolation in practice. Yes, there is a risk
for accidents, but we are not actually intending to change semantics.

> Anyway if we go this way then I think the kmem accounting would be safe
> to be enabled by default with the cgroup2.

Cool, I'm happy we're on the same page about this.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
