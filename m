From: Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH v3 1/6] memcg: split mem_cgroup_force_empty into reclaiming
 and reparenting parts
Date: Mon, 29 Oct 2012 17:45:16 +0400
Message-ID: <508E886C.20908@parallels.com>
References: <1351251453-6140-1-git-send-email-mhocko@suse.cz> <1351251453-6140-2-git-send-email-mhocko@suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1351251453-6140-2-git-send-email-mhocko@suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Balbir Singh <bsingharora@gmail.com>

On 10/26/2012 03:37 PM, Michal Hocko wrote:
> mem_cgroup_force_empty did two separate things depending on free_all
> parameter from the very beginning. It either reclaimed as many pages as
> possible and moved the rest to the parent or just moved charges to the
> parent. The first variant is used as memory.force_empty callback while
> the later is used from the mem_cgroup_pre_destroy.
> 
> The whole games around gotos are far from being nice and there is no
> reason to keep those two functions inside one. Let's split them and
> also move the responsibility for css reference counting to their callers
> to make to code easier.
> 
> This patch doesn't have any functional changes.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> Reviewed-by: Tejun Heo <tj@kernel.org>

Reviewed-by: Glauber Costa <glommer@parallels.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
