From: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 03/12] Revert "memcg: avoid dangling reference count in
 creation failure."
Date: Tue, 09 Apr 2013 11:50:05 +0900
Message-ID: <516381DD.8050706@jp.fujitsu.com>
References: <5162648B.9070802@huawei.com> <516264BF.2020009@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <516264BF.2020009@huawei.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Li Zefan <lizefan@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Glauber Costa <glommer@parallels.com>, Johannes Weiner <hannes@cmpxchg.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, linux-mm@kvack.org

(2013/04/08 15:33), Li Zefan wrote:
> From: Michal Hocko <mhocko@suse.cz>
> 
> This reverts commit e4715f01be697a3730c78f8ffffb595591d6a88c
> 
> mem_cgroup_put is hierarchy aware so mem_cgroup_put(memcg) already drops
> an additional reference from all parents so the additional
> mem_cgrroup_put(parent) potentially causes use-after-free.
> 
> Signed-off-by: Li Zefan <lizefan@huawei.com>
> Signed-off-by: Michal Hocko <mhocko@suse.cz>

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>



--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
