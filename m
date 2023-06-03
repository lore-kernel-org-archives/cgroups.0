From: Muchun Song <muchun.song@linux.dev>
Subject: Re: [PATCH] memcg: use helper macro FLUSH_TIME
Date: Sat, 3 Jun 2023 19:13:24 +0800
Message-ID: <9542DF5E-6B48-48EA-BBD2-3FF801E29C65@linux.dev>
References: <20230603072116.1101690-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1685790840;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i0q/clNCiyPn574KHeniYdEndEa5TXryq3X5pe8ow6w=;
        b=HYP7ozwc29UHBTiFBxCxuhOm9xSrugaz6Honm6gB1dNkSHn6Ze3Tmz1D15istw+Iy2Rg3h
        slS/a6Ni7WVuTlJI+8H1Y+c83krBl360mi4qF4E9p6YtGRScKv05LrLem8nvMcGgsABoC1
        p8nzVqFgLh8+NgqNn2GjR4+0DBwMUGk=
In-Reply-To: <20230603072116.1101690-1-linmiaohe@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, Linux Memory Management List <linux-mm@kvack.org>, linux-kernel@vger.kernel.org



> On Jun 3, 2023, at 15:21, Miaohe Lin <linmiaohe@huawei.com> wrote:
> 
> Use helper macro FLUSH_TIME to indicate the flush time to improve the
> readability a bit. No functional change intended.
> 
> Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>

Reviewed-by: Muchun Song <songmuchun@bytedance.com>

Thanks

