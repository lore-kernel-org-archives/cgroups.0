From: Matthew Wilcox <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH v20 08/20] mm: page_idle_get_page() does not need lru_lock
Date: Thu, 5 Nov 2020 15:43:53 +0000
Message-ID: <20201105154353.GN17076@casper.infradead.org>
References: <1603968305-8026-9-git-send-email-alex.shi@linux.alibaba.com>
 <20201102144110.GB724984@cmpxchg.org>
 <20201102144927.GN27442@casper.infradead.org>
 <20201102202003.GA740958@cmpxchg.org>
 <b4038b87-cf5a-fcb7-06f4-b98874029615@linux.alibaba.com>
 <20201104174603.GB744831@cmpxchg.org>
 <6eea82d8-e406-06ee-2333-eb6e2f1944e5@linux.alibaba.com>
 <20201105045702.GI17076@casper.infradead.org>
 <1e8f0162-cf2e-03eb-e7e0-ccc9f6a3eaf2@linux.alibaba.com>
 <20201105153649.GC744831@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Ak6ESadBcps7kJu00eYxbLPP9OazYAE8zIQ9Ca8IMrU=; b=oUe9xJv58WdNmKxA4k7ReOGJzG
        wNDtZuuG3dlslzXqPfSb5s5TqkLIPrMV9w0DfCQivxQTt7o8dane0CtTTK2oEtGUiSa/p5RIDDPt3
        BMQUONTXOZtSt6N/jl45jAUnJtLCOGJwtI2FHGHimgx1Gb/+gn1vy9+naRt7EQna2f6w3JYQsOxhN
        LGfE+lIdjhnAW9EyHRCnv33KdxFrqD7ZMeP2sBzj/W2PlXOE2O23dXqxwE2s0sYellkWMqnx4vdY8
        7if7PzFgSqNMpqKHbm0pFd5Zegwku1Zy1hgTC3KLrdpy4ss4jbgY7jgtAmYNMyN6KNqRE9/8lySUU
        IlRCVxdw==;
Content-Disposition: inline
In-Reply-To: <20201105153649.GC744831-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Vlastimil Babka <vbabka-AlSwsSmVLrQ@public.gmane.org>, Minchan Kim <minchan-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Thu, Nov 05, 2020 at 10:36:49AM -0500, Johannes Weiner wrote:
> But the code is highly specific - synchronizing one struct page member
> for one particular use case. Let's keep at least a reference to what
> we are synchronizing against. There is a non-zero chance that if the
> comment goes out of date, so does the code. How about this?
> 
> 	/*
> 	 * page_idle does a lockless/optimistic rmap scan on page->mapping.
> 	 * Make sure the compiler doesn't split the stores of anon_vma and
> 	 * the PAGE_MAPPING_ANON type identifier, otherwise the rmap code
> 	 * could mistake the mapping for a struct address_space and crash.
> 	 */

Fine by me!  There may be other cases where seeing a split store would
be bad, so I didn't want to call out page_idle explicitly.  But if you
want to, I'm happy with this comment.
