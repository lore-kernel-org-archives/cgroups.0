From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH mm v5] memcg: enable memory accounting in
 __alloc_pages_bulk
Date: Fri, 15 Oct 2021 14:34:05 -0700
Message-ID: <20211015143405.b7d54e4afa4ca7b2d57b6140@linux-foundation.org>
References: <0baa2b26-a41b-acab-b75d-72ec241f5151@virtuozzo.com>
        <65c1afaf-7947-ce28-55b7-06bde7aeb278@virtuozzo.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1634333648;
        bh=2tyMLoz7LKioqYzGr2VimJ9SCcxFOLwmrLyZHfNoTNw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lZ8cYv7MXOGE5rKlvl0Do+7ZT7bSOjmWHroiiJBLfDCL6UeFaGIzT70s7XAJH5fks
         +8JKp9BXhuxBMHZZHmwEfGqkAdlB7NSmh88Rr/Vf++ZVs7WjILD8ypwD2bPFaita53
         mqQ+VLZNgENPu9qhJneMQi8dw6fXy4mtb9+AzkoQ=
In-Reply-To: <65c1afaf-7947-ce28-55b7-06bde7aeb278-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Uladzislau Rezki <urezki-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org

On Thu, 14 Oct 2021 11:02:57 +0300 Vasily Averin <vvs-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org> wrote:

> Bulk page allocator is used in vmalloc where it can be called
> with __GFP_ACCOUNT and must charge allocated pages into memory cgroup.

Is this problem serious enough to justify -stable backporting?  Some
words which explaining reasoning for the backport would be helpful.

This patch makes Shakeel's "memcg: page_alloc: skip bulk allocator for
__GFP_ACCOUNT" unnecessary.  Which should we use?
