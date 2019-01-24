From: Roman Gushchin <guro@fb.com>
Subject: Re: [PATCH 2/2] mm: Consider subtrees in memory.events
Date: Thu, 24 Jan 2019 00:24:05 +0000
Message-ID: <20190124002359.GB21563@castle.DHCP.thefacebook.com>
References: <20190123223144.GA10798@chrisdown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=facebook;
 bh=vidOgNFzpWSv+2q4f4PnFnWhyhThSoFlN1OA92UuNRU=;
 b=NCF1Z9Alea0L9UgTKKDqQuHnGX4pUEBhYAMf7xZl5UEc3tnVKqk6/NReRIa7Xbtu6i9G
 RNKCrnktT/qivbr9yhiRXftUMzmwNJ0rFDBSv1234te/WAEgvbPobxCqp2j1/CbrBDWy
 dzljSdEUma7FRwuSZW+n6pt2ApPHO2ha74c= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vidOgNFzpWSv+2q4f4PnFnWhyhThSoFlN1OA92UuNRU=;
 b=b0h2rQqYrJvHVdJOPPGgE6Cqde3WaMgdenleTXPsAq/AZ2Opc1bvBzHHPzbdLrQ8j20qXH43E0mkYZmekFDhssJZLHPmxUc/52AENsjUxrq0iIKMrbtpHrgdJZ3t8X0keH4bTU4Fvw0GNm6MgJOJdoiTn2YK1HKb9uv3LFiG5gM=
In-Reply-To: <20190123223144.GA10798@chrisdown.name>
Content-Language: en-US
Content-ID: <4EF58E70687BCD4598BE7A330F81C27C@namprd15.prod.outlook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Chris Down <chris@chrisdown.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Tejun Heo <tj@kernel.org>, Dennis Zhou <dennis@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Kernel Team <Kernel-team@fb.com>

On Wed, Jan 23, 2019 at 05:31:44PM -0500, Chris Down wrote:
> memory.stat and other files already consider subtrees in their output,
> and we should too in order to not present an inconsistent interface.
>=20
> The current situation is fairly confusing, because people interacting
> with cgroups expect hierarchical behaviour in the vein of memory.stat,
> cgroup.events, and other files. For example, this causes confusion when
> debugging reclaim events under low, as currently these always read "0"
> at non-leaf memcg nodes, which frequently causes people to misdiagnose
> breach behaviour. The same confusion applies to other counters in this
> file when debugging issues.
>=20
> Aggregation is done at write time instead of at read-time since these
> counters aren't hot (unlike memory.stat which is per-page, so it does it
> at read time), and it makes sense to bundle this with the file
> notifications.

I agree with the consistency argument (matching cgroup.events, ...),
and it's definitely looks better for oom* events, but at the same time it f=
eels
like a API break.

Just for example, let's say you have a delegated sub-tree with memory.max
set. Earlier, getting memory.high/max event meant that the whole sub-tree
is tight on memory, and, for example, led to shutdown of some parts of the =
tree.
After your change, it might mean that some sub-cgroup has reached its limit=
,
and probably doesn't matter on the top level.

Maybe it's still ok, but we definitely need to document it better. It feels
bad that different versions of the kernel will handle it differently, so
the userspace has to workaround it to actually use these events.

Also, please, make sure that it doesn't break memcg kselftests.

>=20
> After this patch, events are propagated up the hierarchy:
>=20
>    [root@ktst ~]# cat /sys/fs/cgroup/system.slice/memory.events
>    low 0
>    high 0
>    max 0
>    oom 0
>    oom_kill 0
>    [root@ktst ~]# systemd-run -p MemoryMax=3D1 true
>    Running as unit: run-r251162a189fb4562b9dabfdc9b0422f5.service
>    [root@ktst ~]# cat /sys/fs/cgroup/system.slice/memory.events
>    low 0
>    high 0
>    max 7
>    oom 1
>    oom_kill 1
>=20
> Signed-off-by: Chris Down <chris@chrisdown.name>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> To: Andrew Morton <akpm@linux-foundation.org>

s/To/CC

> Cc: Michal Hocko <mhocko@kernel.org>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Roman Gushchin <guro@fb.com>
> Cc: Dennis Zhou <dennis@kernel.org>
> Cc: linux-kernel@vger.kernel.org
> Cc: cgroups@vger.kernel.org
> Cc: linux-mm@kvack.org
> Cc: kernel-team@fb.com
> ---
> include/linux/memcontrol.h | 6 ++++--
> 1 file changed, 4 insertions(+), 2 deletions(-)
>=20
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 380a212a8c52..5428b372def4 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -769,8 +769,10 @@ static inline void count_memcg_event_mm(struct mm_st=
ruct *mm,
> static inline void memcg_memory_event(struct mem_cgroup *memcg,
> 				      enum memcg_memory_event event)
> {
> -	atomic_long_inc(&memcg->memory_events[event]);
> -	cgroup_file_notify(&memcg->events_file);
> +	do {
> +		atomic_long_inc(&memcg->memory_events[event]);
> +		cgroup_file_notify(&memcg->events_file);
> +	} while ((memcg =3D parent_mem_cgroup(memcg)));

We don't have memory.events file for the root cgroup, so we can stop earlie=
r.

Thanks!
