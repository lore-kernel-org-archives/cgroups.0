From: SeongJae Park <sj@kernel.org>
Subject: Re: [PATCH v3 0/4] Change the return value for page isolation functions
Date: Wed, 15 Feb 2023 20:26:48 +0000
Message-ID: <20230215202648.92523-1-sj@kernel.org>
References: <cover.1676424378.git.baolin.wang@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676492811;
        bh=2B6OYT9baMUmpj081N8ApuyZRaf3nEcY8nE/MG7VCLo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QiKfIFOoUtM5otYmOb4O15O0dd+y9jtdA0UPtxP+BzMwcPKnA86t78F5aDKbxDUNy
         T/vJvHYUQfceohEwF4AHNCxD6Wpeq94+aTuEB8ZB7V1gqm8ntK5e2800CP2aoYKu7z
         PhEemm418KOfo5AyZsrbrzzSzYXGiPvQMqxa2A6xlFUyhNYriVakJCZIIgYT6hGgve
         jDL9lq9U8roY2wHXkAqsyNZ2JQeesizuQ20V8+zfX4b4cRB7U3qgwS2tqvpSIA6+Wi
         MbGX5r3DSAjg5OEalCoR5xTSmn2WUTDPEPA8+IariufCKZFD2uRE9+nujtdOHnqfE2
         xwXkeEd3X8gBw==
In-Reply-To: <cover.1676424378.git.baolin.wang@linux.alibaba.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org, sj@kernel.org, hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com, muchun.song@linux.dev, naoya.horiguchi@nec.com, linmiaohe@huawei.com, david@redhat.com, osalvador@suse.de, mike.kravetz@oracle.com, willy@infradead.org, damon@lists.linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

Hi Baolin,

On Wed, 15 Feb 2023 18:39:33 +0800 Baolin Wang <baolin.wang@linux.alibaba.com> wrote:

> Now the page isolation functions did not return a boolean to indicate
> success or not, instead it will return a negative error when failed
> to isolate a page. So below code used in most places seem a boolean
> success/failure thing, which can confuse people whether the isolation
> is successful.
> 
> if (folio_isolate_lru(folio))
>         continue;
> 
> Moreover the page isolation functions only return 0 or -EBUSY, and
> most users did not care about the negative error except for few users,
> thus we can convert all page isolation functions to return a boolean
> value, which can remove the confusion to make code more clear.
> 
> No functional changes intended in this patch series.

For the series,

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]
