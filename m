From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: Re: [External] Re: [PATCH v5 2/7] mm: memcontrol: convert
 NR_ANON_THPS account to pages
Date: Thu, 24 Dec 2020 10:45:58 +0800
Message-ID: <CAMZfGtVQvD4o-nVdCqNBjWtjDzxcfqme9xMH9ar=C=_sMyDm+g@mail.gmail.com>
References: <20201217034356.4708-1-songmuchun@bytedance.com>
 <20201217034356.4708-3-songmuchun@bytedance.com> <CALvZod7kMhb7k6rDZj18JTE=RMji-SinJmfdcPbN9PUL9Off_w@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fDRfu0M1YLV1uhT7YoKaiH9p9Ye/ITZc1yvaQ4SUQRQ=;
        b=ZJPDaWbo/DIXrpPoj3kbzFZq3ifzLIDVBRcOUeeDau6bNYnMbfXwq+Q3xjq+SqbDy4
         Dim1zSamlWYGDHO7vC5p5k5feoa3IXuVpZaqrm86asSB+klu5vOjmug219Kw/52k8nAo
         eHOfWtYH2gjhQhErEg4GMr3D5/GaUBAn4XQCkV/btHnMMR6M1AEaIiPQpHv9/jr0V9p5
         dPyMkWT6VkJRbkcY3AvB9Eta4zTVQCQmf9DRFylxLwf8Zm98OVmndOXtNERC8HmdkP0F
         kuhZWGA2K7XU/Gz+RkI2T6VYvzo+paOxH/7ud2cUmqITTJde3TZ5DowlQoAvpRH7yspk
         1t5Q==
In-Reply-To: <CALvZod7kMhb7k6rDZj18JTE=RMji-SinJmfdcPbN9PUL9Off_w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Alexey Dobriyan <adobriyan-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Sami Tolvanen <samitolvanen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Feng Tang <feng.tang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Neil Brown <neilb-l3A5Bk7waGM@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Randy Dunlap <rdunlap-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-fsdevel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Dec 24, 2020 at 6:08 AM Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
>
> On Wed, Dec 16, 2020 at 7:45 PM Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org> wrote:
> >
> > Currently we use struct per_cpu_nodestat to cache the vmstat
> > counters, which leads to inaccurate statistics expecially THP
>
> *especially

Thanks.

>
> > vmstat counters. In the systems with hundreads of processors
>
> *hundreds

Thanks.

>
> > it can be GBs of memory. For example, for a 96 CPUs system,
> > the threshold is the maximum number of 125. And the per cpu
> > counters can cache 23.4375 GB in total.
> >
> > The THP page is already a form of batched addition (it will
> > add 512 worth of memory in one go) so skipping the batching
> > seems like sensible. Although every THP stats update overflows
> > the per-cpu counter, resorting to atomic global updates. But
> > it can make the statistics more accuracy for the THP vmstat
> > counters.
> >
> > So we convert the NR_ANON_THPS account to pages. This patch
> > is consistent with 8f182270dfec ("mm/swap.c: flush lru pvecs
> > on compound page arrival"). Doing this also can make the unit
> > of vmstat counters more unified. Finally, the unit of the vmstat
> > counters are pages, kB and bytes. The B/KB suffix can tell us
> > that the unit is bytes or kB. The rest which is without suffix
> > are pages.
> >
> > Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
>
> I agree with the motivation behind this patch but I would like to see
> some performance numbers in the commit message. We might agree to pay
> the price but at least we will know what exactly that cost is.

Do you have any recommendations about benchmarks?
I can do a test. Thanks very much.

-- 
Yours,
Muchun
