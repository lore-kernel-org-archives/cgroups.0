From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH memcg v4] net: set proper memcg for net_init hooks allocations
Date: Tue, 26 Apr 2022 22:23:32 -0700
Message-ID: <CALvZod4oaj9MpBDVUp9KGmnqu4F3UxjXgOLkrkvmRfFjA7F1dw@mail.gmail.com>
References: <YmdeCqi6wmgiSiWh@carbon> <33085523-a8b9-1bf6-2726-f456f59015ef@openvz.org>
Mime-Version: 1.0
Return-path: <netdev-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pwauUeBlcHvBLcNyAimJGJIhIGSQVXs8oid0dWAxNRI=;
        b=nxABqQf6lZRKa97gncv5efuRIZgUZAdO5gy+OF4jUXCOKpj9bbJWK3r1gjH4Xw8PuN
         ktWmeG+np9gFm5AlHfhYGoEF6hgQvbXAvE8Quf/i9hC0H/nngx/EtDJDD9UyTTDYkAJT
         uHEDpmH3K3X7h19iV2m7d+uEYToyhrRt5/3VUYkZg4SOCqK0j5Nwhb1AdhdzECIqPo0D
         6fiUmxExbZNRQJj1AZPLh48eAj/VDbqfjf/2RVcThYoIBxWVFZI0Gnq9jo9vnf4orWCu
         AcfxlihjntfM/JqbBBJDAEDbfYDCrNFcrzMLq9J5zMricu4rMtwS+dqCljWdIGdyWkVj
         vUAA==
In-Reply-To: <33085523-a8b9-1bf6-2726-f456f59015ef@openvz.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs@openvz.org>
Cc: Vlastimil Babka <vbabka@suse.cz>, Roman Gushchin <roman.gushchin@linux.dev>, kernel@openvz.org, Florian Westphal <fw@strlen.de>, LKML <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.com>, Cgroups <cgroups@vger.kernel.org>, netdev <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>

On Mon, Apr 25, 2022 at 11:43 PM Vasily Averin <vvs@openvz.org> wrote:
>
> __register_pernet_operations() executes init hook of registered
> pernet_operation structure in all existing net namespaces.
>
> Typically, these hooks are called by a process associated with
> the specified net namespace, and all __GFP_ACCOUNT marked
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

Acked-by: Shakeel Butt <shakeelb@google.com>

[...]
>
> +static inline struct mem_cgroup *get_mem_cgroup_from_obj(void *p)
> +{
> +       struct mem_cgroup *memcg;
> +

Do we need memcg_kmem_enabled() check here or maybe
mem_cgroup_from_obj() should be doing memcg_kmem_enabled() instead of
mem_cgroup_disabled() as we can have "cgroup.memory=nokmem" boot
param.

> +       rcu_read_lock();
> +       do {
> +               memcg = mem_cgroup_from_obj(p);
> +       } while (memcg && !css_tryget(&memcg->css));
> +       rcu_read_unlock();
> +       return memcg;
> +}
