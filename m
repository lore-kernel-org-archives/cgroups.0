From: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 1/2] mm, memcg: Avoid stale protection values when cgroup
 is above protection
Date: Thu, 30 Apr 2020 09:04:53 +0800
Message-ID: <CALOAHbCotD1-+o_XZPU_4_i8Nn98r5F_5NpGVd=z6UG=rUcCmA@mail.gmail.com>
References: <cover.1588092152.git.chris@chrisdown.name> <d454fca5d6b38b74d8dc35141e8519b02089a698.1588092152.git.chris@chrisdown.name>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CUmejEMI9W4148ZwbJQR4oRKJlfTuk5tiVFPgpBtfEE=;
        b=u4//czMye7iX+yYcmMhK7eYzznKYgw27pn66Zlm/n4vCL+HBVx6UoX792Q3CHu0/co
         /FWAkSuboMQrgFRjTVVQOlwchBkpd5hSwn+PmXDgWq3qCGCYF4umAVs5s/EFrGEX2u2G
         m0S5LTfiJUlEky6L995fUQPY2LE2Jpxo15lNlxeFW7yk7+N5zZPXObxIoZeMHVTSX4db
         8pWWyoCWwP7wBB+VFp6F/kTl4YwU0X7ynN3cZcUlerH2MhnkX63lZYN+rEYW0PxwxuZ/
         FJB5Zeh6+syBfi8Zyxr2EsvHcx11JakjhVraYhuCj7bNWp52dhDpg22hD1IO04SEdi8C
         JwTg==
In-Reply-To: <d454fca5d6b38b74d8dc35141e8519b02089a698.1588092152.git.chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Wed, Apr 29, 2020 at 2:26 AM Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org> wrote:
>
> From: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
>
> A cgroup can have both memory protection and a memory limit to isolate
> it from its siblings in both directions - for example, to prevent it
> from being shrunk below 2G under high pressure from outside, but also
> from growing beyond 4G under low pressure.
>
> Commit 9783aa9917f8 ("mm, memcg: proportional memory.{low,min} reclaim")
> implemented proportional scan pressure so that multiple siblings in
> excess of their protection settings don't get reclaimed equally but
> instead in accordance to their unprotected portion.
>
> During limit reclaim, this proportionality shouldn't apply of course:
> there is no competition, all pressure is from within the cgroup and
> should be applied as such. Reclaim should operate at full efficiency.
>
> However, mem_cgroup_protected() never expected anybody to look at the
> effective protection values when it indicated that the cgroup is above
> its protection. As a result, a query during limit reclaim may return
> stale protection values that were calculated by a previous reclaim cycle
> in which the cgroup did have siblings.
>
> When this happens, reclaim is unnecessarily hesitant and potentially
> slow to meet the desired limit. In theory this could lead to premature
> OOM kills, although it's not obvious this has occurred in practice.
>
> Fixes: 9783aa9917f8 ("mm, memcg: proportional memory.{low,min} reclaim")
> Signed-off-by: Yafang Shao <laoar.shao-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> Signed-off-by: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
>
> [hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org: rework code comment]
> [hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org: changelog]
> [chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org: fix store tear]
> [chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org: retitle]
> ---
>  mm/memcontrol.c | 13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 0be00826b832..b0374be44e9e 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -6392,8 +6392,19 @@ enum mem_cgroup_protection mem_cgroup_protected(struct mem_cgroup *root,
>
>         if (!root)
>                 root = root_mem_cgroup;
> -       if (memcg == root)
> +       if (memcg == root) {
> +               /*
> +                * The cgroup is the reclaim root in this reclaim
> +                * cycle, and therefore not protected. But it may have
> +                * stale effective protection values from previous
> +                * cycles in which it was not the reclaim root - for
> +                * example, global reclaim followed by limit reclaim.
> +                * Reset these values for mem_cgroup_protection().
> +                */
> +               WRITE_ONCE(memcg->memory.emin, 0);
> +               WRITE_ONCE(memcg->memory.elow, 0);


Hi Chris,

Would you pls. add some comments above these newly added WRITE_ONCE() ?
E.g.
What does them mean to fix ?
Why do we must add WRITE_ONCE() and READ_ONCE here and there all over
the memcg protection ?
Otherwise, it may be harder to understand by the others.


>                 return MEMCG_PROT_NONE;
> +       }
>
>         usage = page_counter_read(&memcg->memory);
>         if (!usage)
> --
> 2.26.2
>


-- 
Thanks
Yafang
