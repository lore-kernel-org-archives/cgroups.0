From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH memcg RFC] net: set proper memcg for net_init hooks allocations
Date: Thu, 21 Apr 2022 08:56:12 -0700
Message-ID: <CALvZod47PARcupR4P41p5XJRfCaTqSuy-cfXs7Ky9=-aJQuoFA@mail.gmail.com>
References: <46c1c59e-1368-620d-e57a-f35c2c82084d@linux.dev> <55605876-d05a-8be3-a6ae-ec26de9ee178@openvz.org>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Tb6I/vNw4MkH6cXJACmThyQFIFSwo0v3WzOA2XSKmSs=;
        b=hkeImdbTeSMXSMeckvO9JBqgK+ypyTZt/okKK7TMyp+Jj42kGAhZ/7QBcpqgOpnqZj
         gGCX5b138SAqJNu67mSEPBS6HjBSc3NUwwii2N9q3VIj1j6hfggpfT0NzCG9RSRX5XzX
         nem4EvlLHjThukcbQCBeuQSpwwkuANGAiKT4jdpMxO+QaID+CZCjyfdsqCFNkXN894SL
         ibNTaINtlSpFjl1GBaz7n+xDgttL7ngW7o2eXndy6RqXfSveGmsHbAN72F463+yh9jhQ
         LwpxF/i4bpdWG8LRcg6N36V32wZxeba+ZnbpooMdNjNU398VMLDoMlcqVKTjzjuxKwPh
         7KWg==
In-Reply-To: <55605876-d05a-8be3-a6ae-ec26de9ee178@openvz.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs@openvz.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Roman Gushchin <roman.gushchin@linux.dev>, kernel@openvz.org, LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Michal Hocko <mhocko@suse.com>, Florian Westphal <fw@strlen.de>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>

On Sat, Apr 16, 2022 at 11:39 PM Vasily Averin <vvs@openvz.org> wrote:
>
> __register_pernet_operations() executes init hook of registered
> pernet_operation structure in all existing net namespaces.
>
> Typically, these hooks are called by a process associated with
> the specified net namespace, and all __GFP_ACCOUNTING marked
> allocation are accounted for corresponding container/memcg.
>
> However __register_pernet_operations() calls the hooks in the same
> context, and as a result all marked allocations are accounted
> to one memcg for all processed net namespaces.
>
> This patch adjusts active memcg for each net namespace and helps
> to account memory allocated inside ops_init() into the proper memcg.
>
> Signed-off-by: Vasily Averin <vvs@openvz.org>
> ---
> Dear Vlastimil, Roman,
> I'm not sure that memcg is used correctly here,
> is it perhaps some additional locking required?
> ---
>  net/core/net_namespace.c | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/net/core/net_namespace.c b/net/core/net_namespace.c
> index a5b5bb99c644..171c6e0b2337 100644
> --- a/net/core/net_namespace.c
> +++ b/net/core/net_namespace.c
> @@ -26,6 +26,7 @@
>  #include <net/net_namespace.h>
>  #include <net/netns/generic.h>
>
> +#include <linux/sched/mm.h>
>  /*
>   *     Our network namespace constructor/destructor lists
>   */
> @@ -1147,7 +1148,13 @@ static int __register_pernet_operations(struct list_head *list,
>                  * setup_net() and cleanup_net() are not possible.
>                  */
>                 for_each_net(net) {
> +                       struct mem_cgroup *old, *memcg = NULL;
> +#ifdef CONFIG_MEMCG
> +                       memcg = (net == &init_net) ? root_mem_cgroup : mem_cgroup_from_obj(net);

memcg from obj is unstable, so you need a reference on memcg. You can
introduce get_mem_cgroup_from_kmem() which works for both
MEMCG_DATA_OBJCGS and MEMCG_DATA_KMEM. For uncharged objects (like
init_net) it should return NULL.

> +#endif
> +                       old = set_active_memcg(memcg);
>                         error = ops_init(ops, net);
> +                       set_active_memcg(old);
>                         if (error)
>                                 goto out_undo;
>                         list_add_tail(&net->exit_list, &net_exit_list);
> --
> 2.31.1
>
