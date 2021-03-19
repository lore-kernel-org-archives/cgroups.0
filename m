From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] mm: page_alloc: fix memcg accounting leak in speculative
 cache lookup
Date: Fri, 19 Mar 2021 13:21:37 +0000
Message-ID: <20210319132137.GZ3420@casper.infradead.org>
References: <20210319071547.60973-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=2KS9BVm2N7BFC51UrW+/8IGJ0MRGc1xx7mmgTk+g7Ck=; b=n3IUUh3aXo0JWD2wwOFW2ef/JX
        7he8eoKNWqSKvmwXduCO9vGrHKcg6SnwHcWTHJz45edEUqaq/hk8q727hY2kq9y+jTFam61GWQrhG
        fmfHy5usrFG5GE9yqN8jAw8ePQ6miFu5YdhdXtNUwb1GYKYsbxiX8h/xOTD7qgAT3ZAhYH9G+vjhe
        L8g1fXJrm4rd3vUE4Ho2bTvg3vU4DixQcHhX1a/yYR/xYepeqAIlRcNguEJRERXQcB9jfShsBIsie
        liOlvmtwm1KYswYxVtFGkUXreaphaYAvVDtIZ/CKukhYqlB5DpNYwgkol/zsXmaXvINPWvHH8E2V3
        H2OmBNDA==;
Content-Disposition: inline
In-Reply-To: <20210319071547.60973-1-hannes@cmpxchg.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, Zhou Guanghui <zhouguanghui1@huawei.com>, Zi Yan <ziy@nvidia.com>, Shakeel Butt <shakeelb@google.com>, Roman Gushchin <guro@fb.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Fri, Mar 19, 2021 at 03:15:47AM -0400, Johannes Weiner wrote:
> When the freeing of a higher-order page block (non-compound) races
> with a speculative page cache lookup, __free_pages() needs to leave
> the first order-0 page in the chunk to the lookup but free the buddy
> pages that the lookup doesn't know about separately.

Thanks.
