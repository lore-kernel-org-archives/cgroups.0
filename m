From: Muchun Song <songmuchun@bytedance.com>
Subject: Re: [External] [PATCH v3 1/3] mm, memcg: add mem_cgroup_disabled
 checks in vmpressure and swap-related functions
Date: Sat, 10 Jul 2021 18:54:20 +0800
Message-ID: <CAMZfGtWXKJ6_UxqA6su=1ZVc8geqEYoLzxP7xtoHDm_Qp5pQzA@mail.gmail.com>
References: <20210710003626.3549282-1-surenb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=1s5ME4E9PBHhxefrSgaXyV85rhPOWx7hl7SzszoI7Lk=;
        b=0pfcb1vI948P1gvNDslUqtWbRUsXRvKRNuV9F3pPgrHR2s3UsDCIghddiHvbvrXVxV
         5llF4dEfFB8WySwiUhgB1D9rax7Z6wq+CfuzeCJzojghsDKmWmk8VVvoYKqJeebd6FPZ
         j0oRnz9DHrONGKG24D69LgXXR/9BGJALPat15lJT2ji1Js4UFXcF4Psk1Kxa1fDKYpeb
         6gH3XrKRZJvmT7Kmk5Uv5C80kZs4HevyiN9M4xPFFlfDfaGja4bicSe4vODy0xSA9PVd
         2FqNRaQZbvCjkZjDv00R77bCcUofQYePGaoUBUrrNtVjip23PhH+wgJTnHgbl4REDCbY
         p+dg==
In-Reply-To: <20210710003626.3549282-1-surenb@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb@google.com>
Cc: Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Shakeel Butt <shakeelb@google.com>, Roman Gushchin <guro@fb.com>, Yang Shi <shy828301@gmail.com>, Alex Shi <alexs@kernel.org>, Wei Yang <richard.weiyang@gmail.com>, Vlastimil Babka <vbabka@suse.cz>, Jens Axboe <axboe@kernel.dk>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, David Hildenbrand <david@redhat.com>, Matthew Wilcox <willy@infradead.org>, apopple@nvidia.com, Minchan Kim <minchan@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, Linux Memory Management List <linux-mm@kvack.org>, kernel-team@android.

On Sat, Jul 10, 2021 at 8:36 AM Suren Baghdasaryan <surenb@google.com> wrote:
>
> Add mem_cgroup_disabled check in vmpressure, mem_cgroup_uncharge_swap and
> cgroup_throttle_swaprate functions. This minimizes the memcg overhead in
> the pagefault and exit_mmap paths when memcgs are disabled using
> cgroup_disable=memory command-line option.
> This change results in ~2.1% overhead reduction when running PFT test
> comparing {CONFIG_MEMCG=n, CONFIG_MEMCG_SWAP=n} against {CONFIG_MEMCG=y,
> CONFIG_MEMCG_SWAP=y, cgroup_disable=memory} configuration on an 8-core
> ARM64 Android device.
>
> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
> Reviewed-by: Shakeel Butt <shakeelb@google.com>
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>

The changes are straightforward. LGTM.
Reviewed-by: Muchun Song <songmuchun@bytedance.com>
