From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] mm/memcontrol.c: fix another unused function warning
Date: Wed, 2 Oct 2019 09:53:26 +0200
Message-ID: <20191002075326.GF15624@dhcp22.suse.cz>
References: <20191001142227.1227176-1-arnd@arndb.de>
 <1569940805.5576.257.camel@lca.pw>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1569940805.5576.257.camel@lca.pw>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Qian Cai <cai@lca.pw>
Cc: Arnd Bergmann <arnd@arndb.de>, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Chris Down <chris@chrisdown.name>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com

On Tue 01-10-19 10:40:05, Qian Cai wrote:
> On Tue, 2019-10-01 at 16:22 +0200, Arnd Bergmann wrote:
> > Removing the mem_cgroup_id_get() stub function introduced a new warning
> > of the same kind when CONFIG_MMU is disabled:
> 
> Shouldn't CONFIG_MEMCG depends on CONFIG_MMU instead?

I wanted to do that in the past but there was a clear disagreement from
Johannes.
-- 
Michal Hocko
SUSE Labs
