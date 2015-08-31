From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/2] memcg: always enable kmemcg on the default
 hierarchy
Date: Mon, 31 Aug 2015 15:54:23 -0700
Message-ID: <20150831155423.41fd128501c0e75ab1981a65@linux-foundation.org>
References: <20150828220158.GD11089@htj.dyndns.org>
	<20150828220237.GE11089@htj.dyndns.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20150828220237.GE11089@htj.dyndns.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, vdavydov@parallels.com, kernel-team@fb.com

On Fri, 28 Aug 2015 18:02:37 -0400 Tejun Heo <tj@kernel.org> wrote:

> On the default hierarchy, all memory consumption will be accounted
> together and controlled by the same set of limits.  Enable kmemcg on
> the default hierarchy by default.  Boot parameter "disable_kmemcg" can
> be specified to turn it off.
> 
> ...
>
>  mm/memcontrol.c |   43 ++++++++++++++++++++++++++++++-------------
>  1 file changed, 30 insertions(+), 13 deletions(-)

Some documentation updates will be needed?
 
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -346,6 +346,17 @@ EXPORT_SYMBOL(tcp_proto_cgroup);
>  #endif
>  
>  #ifdef CONFIG_MEMCG_KMEM
> +
> +static bool kmemcg_disabled;
> +
> +static int __init disable_kmemcg(char *s)
> +{
> +	kmemcg_disabled = true;
> +	pr_info("memcg: kernel memory support disabled on cgroup2");

typo?

> +	return 0;
> +}
> +__setup("disable_kmemcg", disable_kmemcg);

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
