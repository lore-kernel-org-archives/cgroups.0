From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH] mm, memcg: introduce memory.events.local
Date: Sat, 18 May 2019 00:02:10 +0000
Message-ID: <20190518000203.GA13413@tower.DHCP.thefacebook.com>
References: <20190517234909.175734-1-shakeelb@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=0yJFAjjXi07wEJ4fA+FNNXJlqovIbNk2gdEErTE86u4=;
 b=SWsTNEXN5oyVqNvQm3KKYQfVGfUKXSMXT00I68bCuf7OCvF+vasbBtRLP0DRJkeJUeSQ
 XjZz9A1q0wFTPk024WaoWfrgHkR4TnR3CvlPz0tJsgmbyVExmMONqV6JaBtaD7f87prw
 KCj/zcf4sItlTCTFRpwv5bbOL+sanw4uj8U= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0yJFAjjXi07wEJ4fA+FNNXJlqovIbNk2gdEErTE86u4=;
 b=FBCEySafzGBYQ6hINRqfbreX61Sxe/OUyMC8oKUXJZ1Jvk0Fmw25zaqWcWGKjZvVdZGWOiGQaPoybgpgU7M3ZzT0mTPqa6gcPle5x7YlmhD2YFDMrAgiCU4+YmVnwzt+aadp0u/Niv2Z90yFDgrvbbNPLoCCQLtGD2oxc1xRnPM=
In-Reply-To: <20190517234909.175734-1-shakeelb@google.com>
Content-Language: en-US
Content-ID: <A243B38FB7E72E45A0F5595CB9DE1504@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Chris Down <chris@chrisdown.name>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Fri, May 17, 2019 at 04:49:09PM -0700, Shakeel Butt wrote:
> The memory controller in cgroup v2 exposes memory.events file for each
> memcg which shows the number of times events like low, high, max, oom
> and oom_kill have happened for the whole tree rooted at that memcg.
> Users can also poll or register notification to monitor the changes in
> that file. Any event at any level of the tree rooted at memcg will
> notify all the listeners along the path till root_mem_cgroup. There are
> existing users which depend on this behavior.
>=20
> However there are users which are only interested in the events
> happening at a specific level of the memcg tree and not in the events in
> the underlying tree rooted at that memcg. One such use-case is a
> centralized resource monitor which can dynamically adjust the limits of
> the jobs running on a system. The jobs can create their sub-hierarchy
> for their own sub-tasks. The centralized monitor is only interested in
> the events at the top level memcgs of the jobs as it can then act and
> adjust the limits of the jobs. Using the current memory.events for such
> centralized monitor is very inconvenient. The monitor will keep
> receiving events which it is not interested and to find if the received
> event is interesting, it has to read memory.event files of the next
> level and compare it with the top level one. So, let's introduce
> memory.events.local to the memcg which shows and notify for the events
> at the memcg level.
>=20
> Now, does memory.stat and memory.pressure need their local versions.
> IMHO no due to the no internal process contraint of the cgroup v2. The
> memory.stat file of the top level memcg of a job shows the stats and
> vmevents of the whole tree. The local stats or vmevents of the top level
> memcg will only change if there is a process running in that memcg but
> v2 does not allow that. Similarly for memory.pressure there will not be
> any process in the internal nodes and thus no chance of local pressure.

Hi Shakeel!

Local counters make total sense to me. And I think they will very useful
in certain cases. Thank you for working on it!

>=20
> Signed-off-by: Shakeel Butt <shakeelb@google.com>
> ---
>  include/linux/memcontrol.h |  7 ++++++-
>  mm/memcontrol.c            | 25 +++++++++++++++++++++++++
>  2 files changed, 31 insertions(+), 1 deletion(-)
>=20
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 36bdfe8e5965..de77405eec46 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -239,8 +239,9 @@ struct mem_cgroup {
>  	/* OOM-Killer disable */
>  	int		oom_kill_disable;
> =20
> -	/* memory.events */
> +	/* memory.events and memory.events.local */
>  	struct cgroup_file events_file;
> +	struct cgroup_file events_local_file;
> =20
>  	/* handle for "memory.swap.events" */
>  	struct cgroup_file swap_events_file;
> @@ -286,6 +287,7 @@ struct mem_cgroup {
>  	atomic_long_t		vmevents_local[NR_VM_EVENT_ITEMS];
> =20
>  	atomic_long_t		memory_events[MEMCG_NR_MEMORY_EVENTS];
> +	atomic_long_t		memory_events_local[MEMCG_NR_MEMORY_EVENTS];
> =20
>  	unsigned long		socket_pressure;
> =20
> @@ -761,6 +763,9 @@ static inline void count_memcg_event_mm(struct mm_str=
uct *mm,
>  static inline void memcg_memory_event(struct mem_cgroup *memcg,
>  				      enum memcg_memory_event event)
>  {
> +	atomic_long_inc(&memcg->memory_events_local[event]);
> +	cgroup_file_notify(&memcg->events_local_file);
> +
>  	do {
>  		atomic_long_inc(&memcg->memory_events[event]);
>  		cgroup_file_notify(&memcg->events_file);
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 2713b45ec3f0..a746127012fa 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5648,6 +5648,25 @@ static int memory_events_show(struct seq_file *m, =
void *v)
>  	return 0;
>  }
> =20
> +static int memory_events_local_show(struct seq_file *m, void *v)
> +{
> +	struct mem_cgroup *memcg =3D mem_cgroup_from_seq(m);
> +
> +	seq_printf(m, "low %lu\n",
> +		   atomic_long_read(&memcg->memory_events_local[MEMCG_LOW]));
> +	seq_printf(m, "high %lu\n",
> +		   atomic_long_read(&memcg->memory_events_local[MEMCG_HIGH]));
> +	seq_printf(m, "max %lu\n",
> +		   atomic_long_read(&memcg->memory_events_local[MEMCG_MAX]));
> +	seq_printf(m, "oom %lu\n",
> +		   atomic_long_read(&memcg->memory_events_local[MEMCG_OOM]));
> +	seq_printf(m, "oom_kill %lu\n",
> +		   atomic_long_read(&memcg->memory_events_local[MEMCG_OOM_KILL])
> +		   );

Can you, please, merge this part with the non-local version? Then we'll hav=
e
a guarantee that the format is the same.

A helper like this can be used, for example:
    static void __memory_events_show(struct seq_file *m, atomic_long_t *eve=
nts)
    {
    	seq_printf(...);
    }

Other than that looks good to me.

Thanks!
