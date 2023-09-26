From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH] mm, memcg: expose swapcache stat for memcg v1
Date: Tue, 26 Sep 2023 00:29:57 -0700
Message-ID: <ZRKIdTE+4cm0KDCI@infradead.org>
References: <20230902100728.3850149-1-liushixin2@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=VB02rfAqrCwJrrIDo94dHomdWocZV8cYbgBNccAUQMk=; b=ETp0JudbYO6jWOHR8dt1yjNuuo
        ANXen3hdy7Mz22SUO98P7L9/e4iniE1lGCr1mPQXHUkSKDEIyC8GY8Su3mmKooq6UR8d6xFR85zcx
        //zTrG/P1LfB768hKeFtlJYLjY1/58D/ZAf3KCd5yCxzkYcLzfmAHHJvTw7e2NyONn1XN2fQJr2uK
        1uTsOWjHzM8iM2ZucnmHgkM4qVJOq36oRA7/r5QB4Nrisp3bzJzsRfSdJd/TJhlS3ToCjWIUHuDxb
        tl+k39Lts3qdYVgNiAWcnvm4qw3dYglXtHRpPYpchgRBAglGDQn3Nc9zQA5wO31Lc1qe7EsvI8gd/
        d3wjnD1g==;
Content-Disposition: inline
In-Reply-To: <20230902100728.3850149-1-liushixin2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Liu Shixin <liushixin2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Kefeng Wang <wangkefeng.wang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Sat, Sep 02, 2023 at 06:07:28PM +0800, Liu Shixin wrote:
> Since commit b6038942480e ("mm: memcg: add swapcache stat for memcg v2")
> adds swapcache stat for the cgroup v2, it seems there is no reason to
> hide it in memcg v1. Conversely, with swapcached it is more accurate to
> evaluate the available memory for memcg.

Why are we adding new features to the long deprecated cgroup v1?

