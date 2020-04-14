From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v8 03/10] mm/lru: replace pgdat lru_lock with lruvec lock
Date: Tue, 14 Apr 2020 12:31:14 -0400
Message-ID: <20200414163114.GA136578@cmpxchg.org>
References: <1579143909-156105-1-git-send-email-alex.shi@linux.alibaba.com>
 <1579143909-156105-4-git-send-email-alex.shi@linux.alibaba.com>
 <20200116215222.GA64230@cmpxchg.org>
 <cdcdb710-1d78-6fac-48d7-35519ddcdc6a@linux.alibaba.com>
 <20200413180725.GA99267@cmpxchg.org>
 <8e7bf170-2bb5-f862-c12b-809f7f7d96cb@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=VLlqU4q1Tg1FlNFBFuJbOrDiNdW49LDEweZ01PUJ+98=;
        b=KqIgm1YWeupPQ5AKLZtSk0DWobRLAyx4G0DicpwgPEuui+DlaMsDiKTWKhHut76tPe
         cYkvg60mA+l32MQOTN2Yo9cr2x9SfF7mZFyW2bPkKGoWpB9W4i9Fg/XLdxsyHIRG6xIv
         Vdu9Te/V8atdgTrrO4LzPtLZ5EpU2OptdF7l28ADsB3fiAaEBk922FWRSmKrVCt6HG0T
         xX+N2nBIgTpHnzmZk3oEfPv09qpNqpyFn1/hmFKdTUV/HIjx0pv9hZkhSNQb2tcIGmmd
         fw0D7qs3MC9hPJXIiHPKn2r0dwccVBsgYR0SfZ5+96775nW8w/RprUF1bKur1zG/sKiy
         6YYg==
Content-Disposition: inline
In-Reply-To: <8e7bf170-2bb5-f862-c12b-809f7f7d96cb-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, yang.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Qian Cai <cai-J5quhbR+WMc@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrea Arcangeli <aarcange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Aneesh Ku

On Tue, Apr 14, 2020 at 12:52:30PM +0800, Alex Shi wrote:
> 在 2020/4/14 上午2:07, Johannes Weiner 写道:
> > Plus, the overhead of tracking is tiny - 512k per G of swap (0.04%).
> > 
> > Maybe we should just delete MEMCG_SWAP and unconditionally track swap
> > entry ownership when the memory controller is enabled. I don't see a
> > good reason not to, and it would simplify the entire swapin path, the
> > LRU locking, and the page->mem_cgroup stabilization rules.
> > 
> 
> Sorry for not follow you up, did you mean just remove the MEMCG_SWAP configuration
> and keep the feature in default memcg? 

Yes.

> That does can remove lrucare, but PageLRU lock scheme still fails since
> we can not isolate the page during commit_charge, is that right?

No, without lrucare the scheme works. Charges usually do:

page->mem_cgroup = new;
SetPageLRU(page);

And so if you can TestClearPageLRU(), page->mem_cgroup is stable.

lrucare charging is the exception: it changes page->mem_cgroup AFTER
PageLRU has already been set, and even when it CANNOT acquire the
PageLRU lock itself. It violates the rules.

If we make MEMCG_SWAP mandatory, we always have cgroup records for
swapped out pages. That means we can charge all swapin pages
(incl. readahead pages) directly in __read_swap_cache_async(), before
setting PageLRU on the new pages.

Then we can delete lrucare.

And then TestClearPageLRU() guarantees page->mem_cgroup is stable.
