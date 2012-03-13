From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH v2 02/13] memcg: Kernel memory accounting
 infrastructure.
Date: Tue, 13 Mar 2012 15:24:46 +0900
Message-ID: <20120313152446.28b0d696.kamezawa.hiroyu@jp.fujitsu.com>
References: <1331325556-16447-1-git-send-email-ssouhlal@FreeBSD.org>
	<1331325556-16447-3-git-send-email-ssouhlal@FreeBSD.org>
	<4F5C5E54.2020408@parallels.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <4F5C5E54.2020408@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Glauber Costa <glommer@parallels.com>
Cc: Suleiman Souhlal <ssouhlal@FreeBSD.org>, cgroups@vger.kernel.org, suleiman@google.com, penberg@kernel.org, cl@linux.com, yinghan@google.com, hughd@google.com, gthelen@google.com, peterz@infradead.org, dan.magenheimer@oracle.com, hannes@cmpxchg.org, mgorman@suse.de, James.Bottomley@HansenPartnership.com, linux-mm@kvack.org, devel@openvz.org, linux-kernel@vger.kernel.org

On Sun, 11 Mar 2012 12:12:04 +0400
Glauber Costa <glommer@parallels.com> wrote:

> On 03/10/2012 12:39 AM, Suleiman Souhlal wrote:
> > Enabled with CONFIG_CGROUP_MEM_RES_CTLR_KMEM.
> >
> > Adds the following files:
> >      - memory.kmem.independent_kmem_limit
> >      - memory.kmem.usage_in_bytes
> >      - memory.kmem.limit_in_bytes
> >
> > Signed-off-by: Suleiman Souhlal<suleiman@google.com>
> > ---
> >   mm/memcontrol.c |  136 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
> >   1 files changed, 135 insertions(+), 1 deletions(-)
> >
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 37ad2cb..e6fd558 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -220,6 +220,10 @@ enum memcg_flags {
> >   				 */
> >   	MEMCG_MEMSW_IS_MINIMUM,	/* Set when res.limit == memsw.limit */
> >   	MEMCG_OOM_KILL_DISABLE,	/* OOM-Killer disable */
> > +	MEMCG_INDEPENDENT_KMEM_LIMIT,	/*
> > +					 * kernel memory is not counted in
> > +					 * memory.usage_in_bytes
> > +					 */
> >   };


After looking codes, I think we need to think
whether independent_kmem_limit is good or not....

How about adding MEMCG_KMEM_ACCOUNT flag instead of this and use only
memcg->res/memcg->memsw rather than adding a new counter, memcg->kmem ?

if MEMCG_KMEM_ACCOUNT is set     -> slab is accoutned to mem->res/memsw.
if MEMCG_KMEM_ACCOUNT is not set -> slab is never accounted.

(I think On/Off switch is required..)

Thanks,
-Kame

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
