From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v2] memcg: charge before adding to swapcache on swapin
Date: Tue, 23 Feb 2021 08:39:51 -0800
Message-ID: <CALvZod73d_ECo+OVW9NMbnCe5g2iYxL6jCQaSTktvR-=z6vdgQ@mail.gmail.com>
References: <20210223055505.2594953-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+E3RqKwI3DqPgCvOyDy4gIUAe0bpQ6Te+CARgN71T3Q=;
        b=GhVta4M2dkEUmj17lyRCCl5KAtHb5qECT6ll8PfiYJYL+xyd5EIkxm+jnsnp4LgOlZ
         fo0vMcBFEttAdGXi8HlTG0RiPUE2KVzD3kQ/R0Y0t+f/2kyPTKNfUpht4YXxP3mmLuKy
         71bYLKPMzAfBzcWRj0zEPNBOUnXUVY0DyC0qH7w1QuqUW74NYEi/hGzwvMpkFbucKUz6
         /J17k3uojknHtxBXUR2HNiGXiie9Vt2mVTlXH6s/WHxnajKgtLpdaUSx0A5jgWxdCIi/
         8WP2Bjo888QxYCbTCr7wPv6aQNB+FmewUo+AzmfOZbj0S2VvnJCfSzfRJhizLlOe2u72
         0UDA==
In-Reply-To: <20210223055505.2594953-1-shakeelb@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>

On Mon, Feb 22, 2021 at 9:55 PM Shakeel Butt <shakeelb@google.com> wrote:
[snip]
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -596,6 +596,9 @@ static inline bool mem_cgroup_below_min(struct mem_cgroup *memcg)
>  }
>
>  int mem_cgroup_charge(struct page *page, struct mm_struct *mm, gfp_t gfp_mask);
> +int mem_cgroup_charge_swapin_page(struct page *page, struct mm_struct *mm,
> +                                 gfp_t gfp, swp_entry_t entry);
> +void mem_cgroup_finish_swapin_page(struct page *page, swp_entry_t entry);
>
>  void mem_cgroup_uncharge(struct page *page);
>  void mem_cgroup_uncharge_list(struct list_head *page_list);
> @@ -1141,6 +1144,17 @@ static inline int mem_cgroup_charge(struct page *page, struct mm_struct *mm,
>         return 0;
>  }
>
> +static inline int mem_cgroup_charge_swapin_page(struct page *page,
> +                       struct mm_struct *mm, gfp_t gfp, swp_entry_t entry);

I didn't build-test the !CONFIG_MEMCG config and missed this
semicolon. Andrew, let me know if you want me to send a new version.

> +{
> +       return 0;
> +}
> +
