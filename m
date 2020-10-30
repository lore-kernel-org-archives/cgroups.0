From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v20 02/20] mm/memcg: bail early from swap accounting if
 memcg disabled
Date: Fri, 30 Oct 2020 10:04:20 -0400
Message-ID: <20201030140420.GB666074@cmpxchg.org>
References: <1603968305-8026-1-git-send-email-alex.shi@linux.alibaba.com>
 <1603968305-8026-3-git-send-email-alex.shi@linux.alibaba.com>
 <20201029134648.GC599825@cmpxchg.org>
 <96b6d122-df0e-dfb0-368c-6bd714fab116@linux.alibaba.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=XFvLixYNsnzdj4toTcnFoItKGAiR6MimcB7uXhxEsAY=;
        b=YdSmPnE65j6ZxU34kUIayYUWOJdr/r9gmpdMjuHb3lqo4k7Ldna9+SpQYp+Q/O0rpo
         WDajdXIoc3E12pCo7NqjkA5VdTd3GcxyIs6fRkV9TDwZFbcvFqV+vpX1kEwgkglssWVp
         hrXznUwOVgnLP4ssAB6TzjQZYCZCsYzKg3NFhoUAkFoL5+R2IA2zHpXGCyjZ/IF6/MMx
         gqFNMF1zPrQ27+qJm3plMXyMAHfqxPv8dn/ClpIMvSHlmfhmD44gWnz56F6/+2+9h2y+
         kYQTmd6XxzlYFlW17S94k8DW9B2C0Zx8DoGp66gvVqRDJ3ZbNZTsrXicfYnke5xW9AFr
         1v2g==
Content-Disposition: inline
In-Reply-To: <96b6d122-df0e-dfb0-368c-6bd714fab116-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, mgorman-3eNAlZScCAx27rWaFMvyedHuzzzSOjJt@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, khlebnikov-XoJtRXgx1JseBXzfvpsJ4g@public.gmane.org, daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org, richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kirill-oKw7cIdHH8eLwutG50LtGA@public.gmane.org, alexander.duyck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rong.a.chen-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mhocko-IBi9RG/b67k@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, shy828301-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

On Fri, Oct 30, 2020 at 10:27:51AM +0800, Alex Shi wrote:
> 
> 
> 在 2020/10/29 下午9:46, Johannes Weiner 写道:
> >>  ? release_pages+0x1ae/0x410
> >>  shmem_alloc_and_acct_page+0x77/0x1c0
> >>  shmem_getpage_gfp+0x162/0x910
> >>  shmem_fault+0x74/0x210
> >>  ? filemap_map_pages+0x29c/0x410
> >>  __do_fault+0x37/0x190
> >>  handle_mm_fault+0x120a/0x1770
> >>  exc_page_fault+0x251/0x450
> >>  ? asm_exc_page_fault+0x8/0x30
> >>  asm_exc_page_fault+0x1e/0x30
> >>
> >> Signed-off-by: Alex Shi <alex.shi-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> >> Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
> >> Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
> >> Acked-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
> >> Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> >> Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> >> Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> >> Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
> >> Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
> >> Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> > 
> > This should go in before the previous patch that adds the WARN for it.
> 
> Right, but than the long ops may not weird. Should I remove the ops and resend the whole patchset?

You mean the warning in the changelog? I think that's alright. You can
just say that you're about to remove the !page->memcg check in the
next patch because the original reasons for having it are gone, and
memcg being disabled is the only remaining exception, so this patch
makes that check explicit in preparation for the next.

Sorry, it's all a bit of a hassle, I just wouldn't want to introduce a
known warning into the kernel between those two patches (could confuse
bisection runs, complicates partial reverts etc.)
