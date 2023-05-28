From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH] memcg: remove unused mem_cgroup_from_obj()
Date: Sun, 28 May 2023 20:36:43 +0100
Message-ID: <ZHOtS67ZtMPsyNVk@casper.infradead.org>
References: <20230527103126.398267-1-linmiaohe@huawei.com>
 <ZHGAcaqOx/e8lqwV@casper.infradead.org>
 <CAJD7tkYSrVkAONXko0eE6LWS__kK_Xeto9MVGwTxuqT5j6N8RQ@mail.gmail.com>
 <ZHIcnOV/mrkcerlG@casper.infradead.org>
 <CAJD7tkZ2Q1ZCqNchpiiC6FCE08dYH6tzANA=VqujeDgT8YhRUA@mail.gmail.com>
 <D2B59104-B602-45A3-B938-AE5DC67BAC98@linux.dev>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=e9C5sp0JfDN0TOfD6vzNrxMlNWDxTkjAnRW3Cl3BwKc=; b=QrafmJMTDakEdl29f/4YCuqjSX
        TaT+j+jNB/c9w16rhRp1JiKt+zted/BzWUU0uB+Np/k0UXpfVxSnECIFF8U62AHN8GRbHBq3d0OZu
        bCE9Q93On8wlFEotIREI7fN5xjG8MxffyKcz7q4ySbQzxreKAOnwjqg0WQhtUUfzVaPHyRj0XFcrw
        BvFaD61P/4HPB940FseNTpr8BYIjgmFkLuwrLthIPTpvYjcAUCmVe+b0xcIjAO3LZYTkBajbZxHEy
        KR4zi1C+WuQQRmLyPIjWm7vW0+VlOsN1J/vaZ4NpvWzc+8sEYbTq1Ry6oiN5XalqcZKk4KAC6Tpwy
        uxitormg==;
Content-Disposition: inline
In-Reply-To: <D2B59104-B602-45A3-B938-AE5DC67BAC98@linux.dev>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <muchun.song@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>, Miaohe Lin <linmiaohe@huawei.com>, Vasily Averin <vasily.averin@linux.dev>, hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, shakeelb@google.com, akpm@linux-foundation.org, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Sun, May 28, 2023 at 09:01:37PM +0800, Muchun Song wrote:
> with *init_net*. If Vasily does not want to bring commit 1d0403d20f6c back,
> this patch LGTM. Otherwise, let's wait for Vasily.

If we're not going to bring back 1d0403d20f6c then we should
simply revert fc4db90fe71e instead of applying this patch.
