From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH v3 1/3] mm: memcg: fix stale protection of reclaim
 target memcg
Date: Fri, 2 Dec 2022 16:35:27 -0800
Message-ID: <20221202163527.a72646c9d42f3678b20dac7b@linux-foundation.org>
References: <20221202031512.1365483-1-yosryahmed@google.com>
        <20221202031512.1365483-2-yosryahmed@google.com>
        <CAJD7tkZouk+r=Qk554AOk1-3eYy-gTC8KC+OJQY13ZkNZ9Qe+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1670027729;
        bh=Yaq0k4zhQofrvgBxN7RFAqXF4aXsNAdfyTsZyQ8We4w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ALPbCVF9uULHb7x26GBSJf9oTw+hKWJIcFI1K4iQKJ9gSsVxhfI7Xr5WJGbqVOgSo
         SDKWCNFONERZIXj1KlFgErerzNWA+6svhWqs7DbxZjvxzzQOmD+fLm5N6nYfibvVOH
         BdFO4gdkwQAcgMGJxEfBxDXMZf92yog0ZxU6KFr0=
In-Reply-To: <CAJD7tkZouk+r=Qk554AOk1-3eYy-gTC8KC+OJQY13ZkNZ9Qe+Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Yu Zhao <yuzhao-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

On Fri, 2 Dec 2022 16:26:05 -0800 Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:

> Andrew, does this need to be picked up by stable branches?

Does it?  The changelog doesn't have a clear description of the
user-visible effects of the flaw, which is the guiding light for a
backport?


