From: Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH 3/5] cgroup, memcg: move cgroup_event implementation to
 memcg
Date: Mon, 5 Aug 2013 11:14:04 +0800
Message-ID: <51FF187C.4070002@huawei.com>
References: <1375632446-2581-1-git-send-email-tj@kernel.org> <1375632446-2581-4-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <1375632446-2581-4-git-send-email-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Tejun Heo <tj@kernel.org>
Cc: hannes@cmpxchg.org, mhocko@suse.cz, bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

=D3=DA 2013/8/5 0:07, Tejun Heo =D0=B4=B5=C0:
> cgroup_event is way over-designed and tries to build a generic
> flexible event mechanism into cgroup - fully customizable event
> specification for each user of the interface.  This is utterly
> unnecessary and overboard especially in the light of the planned
> unified hierarchy as there's gonna be single agent.  Simply generating
> events at fixed points, or if that's too restrictive, configureable
> cadence or single set of configureable points should be enough.
>=20
> Thankfully, memcg is the only user and gets to keep it.  Replacing it
> with something simpler on sane_behavior is strongly recommended.
>=20
> This patch moves cgroup_event and "cgroup.event_control"
> implementation to mm/memcontrol.c.  Clearing of events on cgroup
> destruction is moved from cgroup_destroy_locked() to
> mem_cgroup_css_offline(), which shouldn't make any noticeable
> difference.
>=20
> Note that "cgroup.event_control" will now exist only on the hierarchy
> with memcg attached to it.  While this change is visible to userland,
> it is unlikely to be noticeable as the file has never been meaningful
> outside memcg.
>=20
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: Balbir Singh <bsingharora@gmail.com>
> ---
>  kernel/cgroup.c | 237 ------------------------------------------------=
-------
>  mm/memcontrol.c | 238 ++++++++++++++++++++++++++++++++++++++++++++++++=
++++++++
>  2 files changed, 238 insertions(+), 237 deletions(-)
>=20

init/Kconfig needs to be updated too:

menuconfig CGROUPS
        boolean "Control Group support"
        depends on EVENTFD
...
config SCHED_AUTOGROUP
        bool "Automatic process group scheduling"
        select EVENTFD
        select CGROUPS

> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index 2583b7b..a0b5e22 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -56,7 +56,6 @@
>  #include <linux/pid_namespace.h>
>  #include <linux/idr.h>
>  #include <linux/vmalloc.h> /* TODO: replace with more sophisticated ar=
ray */
> -#include <linux/eventfd.h>
>  #include <linux/poll.h>

poll.h also can be removed.

>  #include <linux/flex_array.h> /* used in cgroup_attach_task */
>  #include <linux/kthread.h>
> @@ -154,36 +153,6 @@ struct css_id {
>  	unsigned short stack[0]; /* Array of Length (depth+1) */
>  };
> =20

[...]

> =20
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 2885e3e..3700b65 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c

#include <linux/eventfd.h>
#include <linux/poll.h>

> @@ -239,6 +239,36 @@ struct mem_cgroup_eventfd_list {
>  	struct eventfd_ctx *eventfd;
>  };


--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=3Dmailto:"dont@kvack.org"> email@kvack.org </a>
