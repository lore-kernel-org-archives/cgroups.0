From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 1/1] mm, memcg: inline mem_cgroup_{charge/uncharge} to
 improve disabled memcg config
Date: Fri, 9 Jul 2021 10:27:01 -0700
Message-ID: <CALvZod4=WD9suY1J+DKwOjxyCrCYvH=eQVPAjvZ2JJ2Qn3C2Zg@mail.gmail.com>
References: <20210709171554.3494654-1-surenb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=A3BFSbignNESj8/rrwZ1G7zuaCPgGVuO823S/jHyGy0=;
        b=raXro5aqHVk05FqTrS0rJjDV0MZ5+ERPmzQZfuH4nwxpLbqvs33kwRqpd1Y3wfueAn
         13oMZAwMS/vpxqlRC13oy5NBgkRRbSl3Fu51UXlk4PfttNKOME2w6oJ61aE5yP/SwLqo
         An96A6j5eCxtZEaUfZYKpsyaPZpufz6QEAQxfBeyaZ5K4AWiDHQPINxpSYf77MWMDGJO
         O1W4afwnIwmK9CpfZybIzXwmVK8krSTUIV3I/B9kMDzTBKTaseBG/LJ3JQeYJh5Tdm5X
         cAlwgtTckxjr7yAQGgJc1AdMzb5aa+aBL5xSvmoV25k/DvgyefzRjrWC2G3AHuRPtNWA
         0iSA==
In-Reply-To: <20210709171554.3494654-1-surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, alexs-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, kernel-team <kernel-team@andr>

On Fri, Jul 9, 2021 at 10:15 AM Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> Inline mem_cgroup_{charge/uncharge} and mem_cgroup_uncharge_list functions
> functions to perform mem_cgroup_disabled static key check inline before
> calling the main body of the function. This minimizes the memcg overhead
> in the pagefault and exit_mmap paths when memcgs are disabled using
> cgroup_disable=memory command-line option.
> This change results in ~0.4% overhead reduction when running PFT test
> comparing {CONFIG_MEMCG=n} against {CONFIG_MEMCG=y, cgroup_disable=memory}
> configurationon on an 8-core ARM64 Android device.
>
> Signed-off-by: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
