From: Muchun Song <songmuchun@bytedance.com>
Subject: Re: [PATCH mm v2 8/9] memcg: enable accounting for allocations in alloc_fair_sched_group
Date: Sun, 22 May 2022 14:49:36 +0800
Message-ID: <CAMZfGtUg65D2KemysdhcQM3-gnz+c_tahzJ=WzBUcY451WBv4Q@mail.gmail.com>
References: <Yn6aL3cO7VdrmHHp@carbon> <46bbde64-7290-cabb-8fef-6f4a30263d8c@openvz.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xBwtB9T65QzhNPtQZ0QXYA7XAPyjsJvSWqKsiu1+O3c=;
        b=1tl+DtjUID/Yit6XMR1sy4CgTCo7HJWlhuAjY9JG40KKnRyzU6DDTBO7B8l8eQHvs5
         HCM1hEkHgCiX8lbuD66I4Wg6aom5XMll2U7YYcjZ8YFM9a1TDI+HJflEKyxUunm8Lx5t
         2DN0t8GjjEE5K2TKo4NqLvLu6Dqrx8grDcdVi34AwfAju6scjTPeKVdb0NuAEAZ9oDAh
         CqTsDqWcF3ZoMr7K1uQmsMtv5yVqDCA+QZsfWMEPE9pcfKpzks4o+OoxvCn8OjO9fHY+
         u+6D2zwnTQKV7bZYNGgg6da2F230kRqfS2eXe9sPxUX9yJLUnrjbvXDNsYzkpHqJeN0V
         kKnw==
In-Reply-To: <46bbde64-7290-cabb-8fef-6f4a30263d8c@openvz.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vasily Averin <vvs@openvz.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, kernel@openvz.org, LKML <linux-kernel@vger.kernel.org>, Linux Memory Management List <linux-mm@kvack.org>, Shakeel Butt <shakeelb@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, Cgroups <cgroups@vger.kernel.org>

On Sun, May 22, 2022 at 12:39 AM Vasily Averin <vvs@openvz.org> wrote:
>
> Creating of each new cpu cgroup allocates two 512-bytes kernel objects
> per CPU. This is especially important for cgroups shared parent memory
> cgroup. In this scenario, on nodes with multiple processors, these
> allocations become one of the main memory consumers.
>
> Memory allocated during new cpu cgroup creation:
> common part:    ~11Kb   +  318 bytes percpu
> cpu cgroup:     ~2.5Kb  + 1036 bytes percpu
>
> Accounting for this memory helps to avoid misuse inside memcg-limited
> contianers.
>
> Signed-off-by: Vasily Averin <vvs@openvz.org>

Reviewed-by: Muchun Song <songmuchun@bytedance.com>
