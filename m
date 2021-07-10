From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [External] [PATCH v3 3/3] mm, memcg: inline swap-related
 functions to improve disabled memcg config
Date: Sat, 10 Jul 2021 19:19:01 +0800
Message-ID: <CAMZfGtWCHm4is0Z16tc1WQN+jwJc6PNqyasNxVMRp_dQsFjrkg@mail.gmail.com>
References: <20210710003626.3549282-1-surenb@google.com> <20210710003626.3549282-3-surenb@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=5Fxzax5cpRXuDAgNVxBd/5Ht8jrK3NBiBX9Z3Z3en2A=;
        b=Nd2YCVkKoDLy3hEtStCKbIcb6+F7OwCpW5WNUXe41pujO9UWnItUfazYVV0AUIWnx0
         V5Qqf8UukAsVyB2gF/oVZghm6cWIM7/NTpp6BdhzmerA1z1YSmFRUoACKPA01k6wkc8K
         ZzDsu5CNXZIfn5YNrREUIcuet1/Eh3NMpstMmVR/vb5ckoeb0n91CRhjIZRUNl82jK8o
         z8fXtNc4rn/I2DI5plmBilqgX7EOxK5exQQw/Qyw7jNkKHwRVwm/AzTC54Gq1FHjYihW
         QJ7SE5HzfbbFCdjB44ohBfXhQAyPRakHcorVvbATqCZvWebbY3zOPwgqS8GJQHOzePx7
         7YPw==
In-Reply-To: <20210710003626.3549282-3-surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Yang Shi <shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Alex Shi <alexs-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, David Hildenbrand <david-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Memory Management List <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, kernel-team@android.

On Sat, Jul 10, 2021 at 8:36 AM Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> Inline mem_cgroup_try_charge_swap, mem_cgroup_uncharge_swap and
> cgroup_throttle_swaprate functions to perform mem_cgroup_disabled static
> key check inline before calling the main body of the function. This
> minimizes the memcg overhead in the pagefault and exit_mmap paths when
> memcgs are disabled using cgroup_disable=memory command-line option.
> This change results in ~1% overhead reduction when running PFT test
> comparing {CONFIG_MEMCG=n} against {CONFIG_MEMCG=y, cgroup_disable=memory}
> configuration on an 8-core ARM64 Android device.
>
> Signed-off-by: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

LGTM.

Reviewed-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Thanks.
