From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] Documentation/memcg: remove restriction of setting kmem
 limit
Date: Thu, 5 May 2016 10:32:21 +0200
Message-ID: <20160505083221.GD4386@dhcp22.suse.cz>
References: <572B0105.50503@huawei.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <572B0105.50503@huawei.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Qiang Huang <h.huangqiang@huawei.com>
Cc: corbet@lwn.net, tj@kernel.org, Zefan Li <lizefan@huawei.com>, hannes@cmpxchg.org, akpm@linux-foundation.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org

On Thu 05-05-16 16:15:01, Qiang Huang wrote:
> We don't have this restriction for a long time, docs should
> be fixed.
> 
> Signed-off-by: Qiang Huang <h.huangqiang@huawei.com>
> ---
>  Documentation/cgroup-v1/memory.txt | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
> 
> diff --git a/Documentation/cgroup-v1/memory.txt b/Documentation/cgroup-v1/memory.txt
> index ff71e16..d45b201 100644
> --- a/Documentation/cgroup-v1/memory.txt
> +++ b/Documentation/cgroup-v1/memory.txt
> @@ -281,11 +281,9 @@ different than user memory, since it can't be swapped out, which makes it
>  possible to DoS the system by consuming too much of this precious resource.
>  
>  Kernel memory won't be accounted at all until limit on a group is set. This
> -allows for existing setups to continue working without disruption.  The limit
> -cannot be set if the cgroup have children, or if there are already tasks in the
> -cgroup. Attempting to set the limit under those conditions will return -EBUSY.
> -When use_hierarchy == 1 and a group is accounted, its children will
> -automatically be accounted regardless of their limit value.
> +allows for existing setups to continue working without disruption. When
> +use_hierarchy == 1 and a group is accounted, its children will automatically
> +be accounted regardless of their limit value.

The restriction is not there anymore because the accounting is enabled
by default even in the cgroup v1 - see b313aeee2509 ("mm: memcontrol:
enable kmem accounting for all cgroups in the legacy hierarchy"). So
this _whole_ paragraph could see some update.

-- 
Michal Hocko
SUSE Labs
