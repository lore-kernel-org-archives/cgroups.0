From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH v2 0/8] memcg, cgroup: kill css_id
Date: Wed, 24 Jul 2013 16:32:14 +0200
Message-ID: <20130724143214.GL2540@dhcp22.suse.cz>
References: <51EFA554.6080801@huawei.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <51EFA554.6080801@huawei.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Glauber Costa <glommer@parallels.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, linux-mm@kvack.org

On Wed 24-07-13 17:58:44, Li Zefan wrote:
> This patchset converts memcg to use cgroup->id, and then we can remove
> cgroup css_id.
> 
> As we've removed memcg's own refcnt, converting memcg to use cgroup->id
> is very straight-forward.
> 
> The patchset is based on Tejun's cgroup tree.

Does it depend on any particular patches? I am asking because I would
need to cherry pick those and apply them into my -mm git tree before
these.

> Li Zefan (8):
>       cgroup: convert cgroup_ida to cgroup_idr
>       cgroup: document how cgroup IDs are assigned
>       cgroup: implement cgroup_from_id()
>       memcg: convert to use cgroup_is_descendant()
>       memcg: convert to use cgroup id
>       memcg: fail to create cgroup if the cgroup id is too big
>       memcg: stop using css id
>       cgroup: kill css_id
> --
>  include/linux/cgroup.h |  49 ++-------
>  kernel/cgroup.c        | 308 ++++++++-----------------------------------------------
>  mm/memcontrol.c        |  59 ++++++-----
>  3 files changed, 90 insertions(+), 326 deletions(-)

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
