From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v5 2/7] mm: memcontrol: convert NR_ANON_THPS account to pages
Date: Wed, 23 Dec 2020 14:08:00 -0800
Message-ID: <CALvZod7kMhb7k6rDZj18JTE=RMji-SinJmfdcPbN9PUL9Off_w@mail.gmail.com>
References: <20201217034356.4708-1-songmuchun@bytedance.com> <20201217034356.4708-3-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PoQlpaNI1/l22p0KY/MaQ96Dou9p/HLpoR9DVa4LJh8=;
        b=giGTxA/mxQx+XNfe8QbMHFkMxauB+o9JgajRnbIVQvV2WUIsFUTtYQiZimQfDBK4Si
         AueOX8SxNXBi/ULV8E5WHBMbPVvm4KL2Xf3G7gUH2RlljAPls4Gg7nODbKM1xcqER6cX
         a0MgrXFP51furYSyTt8rCXnmWC0s2wGW7AiJRcPYcknhrh70u2WQRz9FRotvdlwfOsae
         463WoX6OLSTIdNM88A2GE2UO76k+JjJ5+1vj/d6qYCbfpkc3l+eEkk4eSx1yyx0YMPKV
         6f2J8wtixvO9Pg5Xmn0vpCr09CuRdNN2E9buWaf55xaky+TKUJAzS7ERK2fdHzdYU4p8
         sC8g==
In-Reply-To: <20201217034356.4708-3-songmuchun@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun@bytedance.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, rafael@kernel.org, Alexey Dobriyan <adobriyan@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Hugh Dickins <hughd@google.com>, Roman Gushchin <guro@fb.com>, Sami Tolvanen <samitolvanen@google.com>, Feng Tang <feng.tang@intel.com>, Neil Brown <neilb@suse.de>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Randy Dunlap <rdunlap@infradead.org>, LKML <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>

On Wed, Dec 16, 2020 at 7:45 PM Muchun Song <songmuchun@bytedance.com> wrote:
>
> Currently we use struct per_cpu_nodestat to cache the vmstat
> counters, which leads to inaccurate statistics expecially THP

*especially

> vmstat counters. In the systems with hundreads of processors

*hundreds

> it can be GBs of memory. For example, for a 96 CPUs system,
> the threshold is the maximum number of 125. And the per cpu
> counters can cache 23.4375 GB in total.
>
> The THP page is already a form of batched addition (it will
> add 512 worth of memory in one go) so skipping the batching
> seems like sensible. Although every THP stats update overflows
> the per-cpu counter, resorting to atomic global updates. But
> it can make the statistics more accuracy for the THP vmstat
> counters.
>
> So we convert the NR_ANON_THPS account to pages. This patch
> is consistent with 8f182270dfec ("mm/swap.c: flush lru pvecs
> on compound page arrival"). Doing this also can make the unit
> of vmstat counters more unified. Finally, the unit of the vmstat
> counters are pages, kB and bytes. The B/KB suffix can tell us
> that the unit is bytes or kB. The rest which is without suffix
> are pages.
>
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

I agree with the motivation behind this patch but I would like to see
some performance numbers in the commit message. We might agree to pay
the price but at least we will know what exactly that cost is.
