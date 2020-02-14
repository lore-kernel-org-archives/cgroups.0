From: Eric Dumazet <edumazet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2] cgroup: memcg: net: do not associate sock with
 unrelated cgroup
Date: Fri, 14 Feb 2020 14:38:08 -0800
Message-ID: <CANn89iLe7KVjaechEhtV4=QRy4s8qBQDiX9e8LX_xq8tunrQNA@mail.gmail.com>
References: <20200214222415.181467-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UhXhwNSRwdSyi+H9zMRuLq0WFPtWCQTooj0QtYbRLG8=;
        b=LYB/2WoTc0NUWQ7WAgvwRxpic7dTAP9/iI+IjkZnQRJx+5k39FyA4S4N3pmh8wcWqz
         AvLEKE2SjemIzT9ZtDMYJ5uqfQfwIBVHdbyFYDdMnzm8nm8qRGQ7OcBlUWfrU4zHwvZb
         PhUuwhIPS3pSexguM+13PMLeT8PeHqXx37bpMydKP8fZVFkdxVBVbBNTMz/IMIkXGKFs
         oE2s8v7rPEwjU9xEMptc3TmOHtHV/g5owFopfH0Fm7rh7Hr8J5cZw9cTWP5dmeyCnXNn
         rq3L8OW1us+mcfcgMy3ATrfW0PSGDZglwVRh7HmIoFZvLw78Vnokrdl77eiZ6m4SVJW0
         eoXQ==
In-Reply-To: <20200214222415.181467-1-shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Fri, Feb 14, 2020 at 2:24 PM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> We are testing network memory accounting in our setup and noticed
> inconsistent network memory usage and often unrelated cgroups network
> usage correlates with testing workload. On further inspection, it
> seems like mem_cgroup_sk_alloc() and cgroup_sk_alloc() are broken in
> irq context specially for cgroup v1.
>
> mem_cgroup_sk_alloc() and cgroup_sk_alloc() can be called in irq context
> and kind of assumes that this can only happen from sk_clone_lock()
> and the source sock object has already associated cgroup. However in
> cgroup v1, where network memory accounting is opt-in, the source sock
> can be unassociated with any cgroup and the new cloned sock can get
> associated with unrelated interrupted cgroup.
>
> Cgroup v2 can also suffer if the source sock object was created by
> process in the root cgroup or if sk_alloc() is called in irq context.
> The fix is to just do nothing in interrupt.

So, when will the association be done ?
At accept() time ?
Is it done already ?

Thanks


>
> Fixes: 2d7580738345 ("mm: memcontrol: consolidate cgroup socket tracking")
> Fixes: d979a39d7242 ("cgroup: duplicate cgroup reference when cloning sockets")
> Signed-off-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> ---
>
> Changes since v1:
> - Fix cgroup_sk_alloc() too.
>
>  kernel/cgroup/cgroup.c | 4 ++++
>  mm/memcontrol.c        | 4 ++++
>  2 files changed, 8 insertions(+)
>
> diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
> index 9a8a5ded3c48..46e5f5518fba 100644
> --- a/kernel/cgroup/cgroup.c
> +++ b/kernel/cgroup/cgroup.c
> @@ -6449,6 +6449,10 @@ void cgroup_sk_alloc(struct sock_cgroup_data *skcd)
>                 return;
>         }
>
> +       /* Do not associate the sock with unrelated interrupted task's memcg. */
> +       if (in_interrupt())
> +               return;
> +
>         rcu_read_lock();
>
>         while (true) {
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 63bb6a2aab81..f500da82bfe8 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -6697,6 +6697,10 @@ void mem_cgroup_sk_alloc(struct sock *sk)
>                 return;
>         }
>
> +       /* Do not associate the sock with unrelated interrupted task's memcg. */
> +       if (in_interrupt())
> +               return;
> +
>         rcu_read_lock();
>         memcg = mem_cgroup_from_task(current);
>         if (memcg == root_mem_cgroup)
> --
> 2.25.0.265.gbab2e86ba0-goog
>
