From: Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH v3 2/6] memcg: root_cgroup cannot reach mem_cgroup_move_parent
Date: Mon, 29 Oct 2012 17:48:00 +0400
Message-ID: <508E8910.40203@parallels.com>
References: <1351251453-6140-1-git-send-email-mhocko@suse.cz> <1351251453-6140-3-git-send-email-mhocko@suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1351251453-6140-3-git-send-email-mhocko@suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Balbir Singh <bsingharora@gmail.com>

On 10/26/2012 03:37 PM, Michal Hocko wrote:
> The root cgroup cannot be destroyed so we never hit it down the
> mem_cgroup_pre_destroy path and mem_cgroup_force_empty_write shouldn't
> even try to do anything if called for the root.
> 
> This means that mem_cgroup_move_parent doesn't have to bother with the
> root cgroup and it can assume it can always move charges upwards.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> Reviewed-by: Tejun Heo <tj@kernel.org>

I think it would be safer to have this folded in the last patch, to
avoid a weird intermediate state (specially for force_empty). Being a
single statement, it doesn't confuse review so much.

However, this is also pretty much just a nitpick, do as you prefer.

Reviewed-by: Glauber Costa <glommer@parallels.com>

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
