From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH] mm: add group_oom_kill memory event
Date: Mon, 13 Dec 2021 12:19:30 +0100
Message-ID: <YbcsQhxKwpW4127B@dhcp22.suse.cz>
References: <20211203162426.3375036-1-schatzberg.dan@gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1639394373; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ire/tjZ+0o47YsB/d9PyauJHzxOJtSQJIvqpR3Apzt0=;
        b=sDGcWHfWM6aHjXn75M6zAANHID7akGsBt2d+ckoKJl6HkN29KFRZJTeBksHJd23xRHZEZ3
        dwMc16bqrvoEhcFDpLeoaM+aFgQivmvayeq/z4OdisESzYKF2RUrfzqZuQri8H+L3N08uZ
        gKOApVPPC4cLuGWh+UIgyrQCorNe2Ug=
Content-Disposition: inline
In-Reply-To: <20211203162426.3375036-1-schatzberg.dan@gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Schatzberg <schatzberg.dan@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Roman Gushchin <guro@fb.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Jonathan Corbet <corbet@lwn.net>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Shakeel Butt <shakeelb@google.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Muchun Song <songmuchun@bytedance.com>, Alex Shi <alexs@kernel.org>, Wei Yang <richard.weiyang@gmail.com>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <linux-mm@kvack.org>

On Fri 03-12-21 08:24:23, Dan Schatzberg wrote:
> Our container agent wants to know when a container exits if it was OOM
> killed or not to report to the user. We use memory.oom.group = 1 to
> ensure that OOM kills within the container's cgroup kill
> everything. Existing memory.events are insufficient for knowing if
> this triggered:

Yes our events reporting is not really friendly for this kind of usage.
OOM_KILL is accounted to the memcg of the task so it will not be updated
for inter nodes other than recursively (so never in local events).
OOM event, even though it is reported to the memcg under oom, cannot be
really used either because in some cases the oom killer is simply not
invoked. So there indeed is no clear way to tell what is happening under
the memcg hierarchy and what is happening for the whole hierarchy.
 
> 1) Our current approach reads memory.events oom_kill and reports the
> container was killed if the value is non-zero. This is erroneous in
> some cases where containers create their children cgroups with
> memory.oom.group=1 as such OOM kills will get counted against the
> container cgroup's oom_kill counter despite not actually OOM killing
> the entire container.
> 
> 2) Reading memory.events.local will fail to identify OOM kills in leaf
> cgroups (that don't set memory.oom.group) within the container cgroup.

I am a bit confused by 2). local events by definition cannot tell you
anything about children cgroups.

> This patch adds a new oom_group_kill event when memory.oom.group
> triggers to allow userspace to cleanly identify when an entire cgroup
> is oom killed.

New counter makes sense to me because it allows to tell oom events even
on the middle nodes.

> Signed-off-by: Dan Schatzberg <schatzberg.dan@gmail.com>

once the cgroup v1 interface part is dropped (as suggested by Johannes),
feel free to add
Acked-by: Michal Hocko <mhocko@suse.com>

> ---
>  Documentation/admin-guide/cgroup-v2.rst | 4 ++++
>  include/linux/memcontrol.h              | 1 +
>  mm/memcontrol.c                         | 5 +++++
>  mm/oom_kill.c                           | 1 +
>  4 files changed, 11 insertions(+)
> 
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> index 2aeb7ae8b393..eec830ce2068 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -1268,6 +1268,10 @@ PAGE_SIZE multiple when read back.
>  		The number of processes belonging to this cgroup
>  		killed by any kind of OOM killer.
>  
> +          oom_group_kill
> +                The number of times all tasks in the cgroup were killed
> +                due to memory.oom.group.

This can be rather confusing for hierarchicaly reported values but the
same applies for other counters as well. So be it.
[...]
> @@ -4390,6 +4390,9 @@ static int mem_cgroup_oom_control_read(struct seq_file *sf, void *v)
>  	seq_printf(sf, "under_oom %d\n", (bool)memcg->under_oom);
>  	seq_printf(sf, "oom_kill %lu\n",
>  		   atomic_long_read(&memcg->memory_events[MEMCG_OOM_KILL]));
> +	seq_printf(sf, "oom_group_kill %lu\n",
> +		   atomic_long_read(
> +			&memcg->memory_events[MEMCG_OOM_GROUP_KILL]));
>  	return 0;
>  }

This should be dropped.
-- 
Michal Hocko
SUSE Labs
