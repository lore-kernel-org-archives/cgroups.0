From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH v2 2/3] mm: Charge active memcg when no mm is set
Date: Wed, 19 Feb 2020 14:37:11 -0500
Message-ID: <20200219193711.GC54486@cmpxchg.org>
References: <cover.1581088326.git.dschatzberg@fb.com>
 <8e41630b9d1c5d00f92a00f998285fa6003af5eb.1581088326.git.dschatzberg@fb.com>
 <20200207211807.GA138184@chrisdown.name>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DFD/PBmG0P7U1KLcfwxQ00ort/KIczMCNrbTAdH0j9g=;
        b=yaW/aMLvoyD72gqf9JCZfvj8P+9plgT82zxsbaIugjOxyXEvghFgPPkSW1TqZoFdOz
         4tr15KFItwTQfQhiWTeY+8Srat3gbX/RQ6Hgm8rIjfZHfqUEOtVpm0Q0y6F6cxJPlxus
         aT1ZO43r5M7YLtCgzwbt1D8ZnTuATju1/2pg5HZAfLmHpY1Yh/Z7A5oBPM+qsrjhzFYg
         06X+pEaoT5XF8PuErVI1qHsDU1VgFW1ysvMlUiI/+N+tGsYUStvrmG0W7bnou7gueZLc
         ihBEHv0EAdrzu6j9rSD6n8XlF0kXuGg2ShChO3x4tSekiZ9F5qExxRVGGzQojLOTDfO1
         jLJQ==
Content-Disposition: inline
In-Reply-To: <20200207211807.GA138184-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Cc: Dan Schatzberg <dschatzberg-b10kYP2dOMg@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, "open list:BLOCK LAYER" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, open list <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>

On Fri, Feb 07, 2020 at 09:18:07PM +0000, Chris Down wrote:
> > @@ -6856,8 +6857,12 @@ int mem_cgroup_try_charge(struct page *page, struct mm_struct *mm,
> > 		}
> > 	}
> > 
> > -	if (!memcg)
> > -		memcg = get_mem_cgroup_from_mm(mm);
> > +	if (!memcg) {
> > +		if (!mm)
> > +			memcg = get_mem_cgroup_from_current();
> > +		else
> > +			memcg = get_mem_cgroup_from_mm(mm);
> > +	}
> 
> Just to do due diligence, did we double check whether this results in any
> unintentional shift in accounting for those passing in both mm and memcg as
> NULL with no current->active_memcg set, since previously we never even tried
> to consult current->mm and always used root_mem_cgroup in
> get_mem_cgroup_from_mm?

Excellent question on a subtle issue.

But nobody actually passes NULL. They either pass current->mm (or a
destination mm) in syscalls, or vma->vm_mm in page faults.

The only times we end up with NULL is when kernel threads do something
and have !current->mm. We redirect those to root_mem_cgroup.

So this patch doesn't change those semantics.
