From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [RFC PATCH 0/2] mm/memcontrol: Finer-grained memory control
Date: Wed, 10 Apr 2019 21:54:43 +0200
Message-ID: <20190410195443.GL10383@dhcp22.suse.cz>
References: <20190410191321.9527-1-longman@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190410191321.9527-1-longman@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Vladimir Davydov <vdavydov.dev@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <guro@fb.com>, Shakeel Butt <shakeelb@google.com>, Kirill Tkhai <ktkhai@virtuozzo.com>, Aaron Lu <aaron.lu@intel.com>

On Wed 10-04-19 15:13:19, Waiman Long wrote:
> The current control mechanism for memory cgroup v2 lumps all the memory
> together irrespective of the type of memory objects. However, there
> are cases where users may have more concern about one type of memory
> usage than the others.
> 
> We have customer request to limit memory consumption on anonymous memory
> only as they said the feature was available in other OSes like Solaris.

Please be more specific about a usecase.

> To allow finer-grained control of memory, this patchset 2 new control
> knobs for memory controller:
>  - memory.subset.list for specifying the type of memory to be under control.
>  - memory.subset.high for the high limit of memory consumption of that
>    memory type.

Please be more specific about the semantic.

I am really skeptical about this feature to be honest, though.

> For simplicity, the limit is not hierarchical and applies to only tasks
> in the local memory cgroup.

This is a no-go to begin with.

> Waiman Long (2):
>   mm/memcontrol: Finer-grained control for subset of allocated memory
>   mm/memcontrol: Add a new MEMCG_SUBSET_HIGH event
> 
>  Documentation/admin-guide/cgroup-v2.rst |  35 +++++++++
>  include/linux/memcontrol.h              |   8 ++
>  mm/memcontrol.c                         | 100 +++++++++++++++++++++++-
>  3 files changed, 142 insertions(+), 1 deletion(-)
> 
> -- 
> 2.18.1

-- 
Michal Hocko
SUSE Labs
