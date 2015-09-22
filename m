From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH 2/5] cgroup, memcg, cpuset: implement
 cgroup_taskset_for_each_leader()
Date: Tue, 22 Sep 2015 17:49:34 +0200
Message-ID: <20150922154933.GB4027@dhcp22.suse.cz>
References: <1441998022-12953-1-git-send-email-tj@kernel.org>
 <1441998022-12953-3-git-send-email-tj@kernel.org>
 <20150914204907.GI25369@htj.duckdns.org>
 <20150918160417.GD4065@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20150918160417.GD4065@mtj.duckdns.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: lizefan@huawei.com, cgroups@vger.kernel.org, hannes@cmpxchg.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Fri 18-09-15 12:04:17, Tejun Heo wrote:
> On Mon, Sep 14, 2015 at 04:49:07PM -0400, Tejun Heo wrote:
> > Michal, if you're okay with this patch, I'll apply the patchset in
> > cgroup/for-4.4.
> 
> Michal?

I am sorry but I wasn't online very much last week. The old and new code
are similarly hackish so I am OK with it. Ideally we should be able to
migrate all the tasks for both the legacy and the default hierarchies
this would require more changes in this area though.

Acked-by: Michal Hocko <mhocko@suse.com>

Thanks!
-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
