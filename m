From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] memcg: hugetlbfs basic usage accounting
Date: Wed, 15 Nov 2017 09:35:04 +0100
Message-ID: <20171115083504.nwczf5xq6posy3bw@dhcp22.suse.cz>
References: <20171114172429.8916-1-guro@fb.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20171114172429.8916-1-guro@fb.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Mike Kravetz <mike.kravetz@oracle.com>, Dave Hansen <dave.hansen@intel.com>, kernel-team@fb.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue 14-11-17 17:24:29, Roman Gushchin wrote:
> This patch implements basic accounting of memory consumption
> by hugetlbfs pages for cgroup v2 memory controller.
> 
> Cgroup v2 memory controller lacks any visibility into the
> hugetlbfs memory consumption. Cgroup v1 implemented a separate
> hugetlbfs controller, which provided such stats, and also
> provided some control abilities. Although porting of the
> hugetlbfs controller to cgroup v2 is arguable a good idea and
> is outside of scope of this patch, it's very useful to have
> basic stats provided by memory.stat.

Separate hugetlb cgroup controller was really a deliberate decision.
We didn't want to mix hugetlb with the reclaimable memory. There is no
reasonable way to enforce memcg limits if hugetlb pages are involved.

AFAICS your patch shouldn't break the hugetlb controller because that
one (ab)uses page[2].private to store the hstate for the accounting.
You also do not really charge those hugetlb pages so the memcg
accounting will work unchaged.

So my primary question is, why don't you simply allow hugetlb controller
rather than tweak stats for memcg? Is there any fundamental reason why
hugetlb controller is not v2 compatible?

It feels really strange to keeps stats of something the controller
doesn't really control. I can imagine confused users claiming that
numbers just do not add up...
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
