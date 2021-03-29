From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [External] [PATCH 2/3] mm: Charge active memcg when no mm is set
Date: Mon, 29 Mar 2021 13:59:39 -0700
Message-ID: <CALvZod4TdgwWvBTRSYaXdBfYP=UZgVnDM_eK7o9PutOSgWdHXg@mail.gmail.com>
References: <20210329144829.1834347-1-schatzberg.dan@gmail.com>
 <20210329144829.1834347-3-schatzberg.dan@gmail.com> <CAMZfGtVT85+1_Bu9LBaG6DUsr1kYsepQ-1-K7BDD0Wn3L+BQgg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MofHa7TTek6RL65+2DpRLXuv6k37Riyeap6vLBZF2qY=;
        b=nQqoXFYpUc3Z1lEJ0V3ny2PJfnJV7IXvNf8Xadd4vjUpMOQKE0qrM446dKVDb9tLnO
         P4yimsDSrO+PpYO8NisjNVnaige/4fZW9IMZqFEaoCxIFJhJZM7vs/PyF8CMJbOACtdQ
         z67qd5sQJZ6ht9Yiy9J1UkYnmQeXuZLF1uHSEfzpUFCMZ0ZeCwT1i/DGXi0ZGr0xNgww
         doO0lFecfRDzw1Oox5ZhH/sUZWSuUbhZClFdl3quTAuqzLqEokqiNxoF2ZZsqoU52g7A
         30nkZsZkdOmUQmSn8B7BHiZSCdyBEFiXp1aeqCqv37lg+mtFcO0CpHBDTep3XtdxBpiW
         I8HQ==
In-Reply-To: <CAMZfGtVT85+1_Bu9LBaG6DUsr1kYsepQ-1-K7BDD0Wn3L+BQgg@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun@bytedance.com>
Cc: Dan Schatzberg <schatzberg.dan@gmail.com>, Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Hugh Dickins <hughd@google.com>, Roman Gushchin <guro@fb.com>, Yang Shi <shy828301@gmail.com>, Alex Shi <alex.shi@linux.alibaba.com>, Alexander Duyck <alexander.h.duyck@linux.intel.com>, Yafang Shao <laoar.shao@gmail.com>, Wei Yang <richard.weiyang@gmail.com>, "open list:BLOCK LAYER" <linux-block@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "open list:MEMORY MANAGEMENT" <linux-mm@kvack.org>

On Mon, Mar 29, 2021 at 9:13 AM Muchun Song <songmuchun@bytedance.com> wrote:
>
> On Mon, Mar 29, 2021 at 10:49 PM Dan Schatzberg
> <schatzberg.dan@gmail.com> wrote:
[...]
>
> Since remote memcg must hold a reference, we do not
> need to do something like get_active_memcg() does.
> Just use css_get to obtain a ref, it is simpler. Just
> Like below.
>
> +       if (unlikely(!mm)) {
> +               memcg = active_memcg();
> +               if (unlikely(memcg)) {
> +                       /* remote memcg must hold a ref. */
> +                       css_get(memcg);
> +                       return memcg;
> +               }
>

I second Muchun's suggestion.
