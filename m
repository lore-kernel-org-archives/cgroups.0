Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3006F403B04
	for <cgroups@vger.kernel.org>; Wed, 10 Jun 2026 20:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781122384; cv=none; b=palZ5eRZfCZ2ZihLBGADKBuu5dYBeId3hitjklTEYGJ7JvpcqnFqA3mMP4qO9mrpEVTfq5iLQHX1NUvGPQGjORx4ofrPQRIMPVqHeHDj68Hcj/ss7z2smqdgvE+ton+VA5jhN6MhJyuBcY5gTCYO3p41zm1NEP3PzWZ3M1au5Iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781122384; c=relaxed/simple;
	bh=XCLXnOmTwKXh09FcYtQFFaA7Jpvehuih5/s/Esa9XgA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MwwOYg35a477Nz7RAZJHDtJjJmoaZW5ORIhqjHQlZL5i43K4PGw2Fbl/xTrm7t+S9Ra3hFYz2vQDYD2pBP518oAhFdAk+4X9C8NeSDipTrkJEGXAoU/JdbVwc2Ynk9fYAAi1FudFAjRZ7UP6RF4vPmldf0iknVtKvkQgVcvndeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=U89rvehF; arc=none smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="U89rvehF"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8ce9df4732cso72537666d6.1
        for <cgroups@vger.kernel.org>; Wed, 10 Jun 2026 13:12:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1781122377; x=1781727177; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5/w5IO6RWAJnNghyz7HGZ8KjTibYl6mxc1wTK9gnS8M=;
        b=U89rvehFEHxEMK7PFZYfFR18kWOCZanlPn7D/236dPmSgbe7z0Rd3TEztIDx1OlD5S
         WyW1gy0UaLBCVLn8ykVE83DvMbZHrr5S8k1D3urbym10cvGs3BbGuG51gVbK7DPhnDYP
         1Hp0Hkon7DdJ8AzAxskbDCU+y8x4C28hdT3TX6bZ53QS0YXGcPn3oetMo7UdYvMCXSDR
         gDtH+u9bE5LYnhCWmWMMdbUUy3ZwAnuBWNit6YAIbqbyfZ8dbNvTY/Fhy46E7M164yjh
         itKxUsar6LFAgPXEB1nDpvaZDIbFJ5Eae7CcrI1dQU5SxTE/9DtR+91S6Md/EC4RDx7T
         Tu0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781122377; x=1781727177;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5/w5IO6RWAJnNghyz7HGZ8KjTibYl6mxc1wTK9gnS8M=;
        b=fNDlL1gqhJX4kzkHMutFSRMjqfgpYTPFWy2SN3WnYaqLqTDzUBw56APWx3n7UC71KV
         HPSDHJsnH2kAUhWrJHTzgUn/15ZMP1jrCKc+8GShFZm4LqqKmwuz5nCWv4ldmoRFLuZg
         DFKcN9FrdwjAQY+sn100tv8lyJiDhY3wCLx+EKhqkxe7mXJOI8XHqFQjOiFZetSYyXIq
         aPQwJ/JDQsYd94qps9Gal7117prz+vvnpSZghAtXDCkT1y/ys/CD2EzyUAqADYqa587b
         2aJNKtcTJNWwa1m2IvMNlrBijgAge6f8rzQK5ywW6Mk08TxlthzA+eutzsesvDNkLsbw
         5Vkw==
X-Forwarded-Encrypted: i=1; AFNElJ9KuZMiZXCHH6FqLtXUM2dobZDgZ1TJbuEAH89axauQj1/I5RfD6o+k/l4JgzAzwtIxQYuREvOS@vger.kernel.org
X-Gm-Message-State: AOJu0Yw6KK9fp/Xh/d86u5HMmE2WHmP3ZLO4yAtdt51m+/U+QcTZlad3
	Mfe5msbW7wloYYrc/W5EDtbRSLDvD+6TZJKmmytaTRHvdrTtP/5b3wXp2CSwn5eHSuk=
X-Gm-Gg: Acq92OG5d6wcYxRcTtlnUORSS1mXYwNET1AwhMxYOAhgqiHH9PYVQhY7NGHiMgWsXIi
	Opot2YMOYsEv/sVqjukSNwArwK6V+kBcWje7g1sbk32gsXMBArYHdzqZVjlfGYPDCZnkV2vsQDi
	NnY1MQFx6tCeyDRMEEpmMBubZBcoF4gc9zeFYOO1jTnBubnxsFtw5XIsNP2tddSPI0Z4nWoAwgV
	n0Z2kg+WW7XPQMq4HbkMTo3heI3gEPGx8UgekVpuPGkWl+xxI9cVLaT1/1hBASAzLbAUH8bZDnZ
	vPdvym0qThYCZGMRg5M8SSFdbOWPXHQpXnhtVKaU+7GEgYgqraWsQ3u7Geeom5cBdaYMYSq8OHc
	19CC1Dh1T593mqHFinNkQdGROEjYQTf1JAgo/12sK+6DPP+JoPTcoLk/LoXOcjaQcn6f4ysLJrU
	MHfi9VSxS5qpAdYYeEFhx6qS8/551J+n/y523xeNPdjoIM/V9T2E/8N8wxh67Xx4yIS8iji7F7V
	TwQOxWwqzPoUiCJhw==
X-Received: by 2002:a05:6214:4586:b0:8ac:a6bd:503b with SMTP id 6a1803df08f44-8d187aef6a5mr16950546d6.15.1781122376601;
        Wed, 10 Jun 2026 13:12:56 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8cecd0535b0sm241706096d6.28.2026.06.10.13.12.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2026 13:12:55 -0700 (PDT)
Date: Wed, 10 Jun 2026 16:12:52 -0400
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Balbir Singh <balbirs@nvidia.com>, lsf-pc@lists.linux-foundation.org,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	cgroups@vger.kernel.org, linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org, damon@lists.linux.dev,
	kernel-team@meta.com, gregkh@linuxfoundation.org, rafael@kernel.org,
	dakr@kernel.org, dave@stgolabs.net, jonathan.cameron@huawei.com,
	dave.jiang@intel.com, alison.schofield@intel.com,
	vishal.l.verma@intel.com, ira.weiny@intel.com,
	dan.j.williams@intel.com, longman@redhat.com,
	akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, osalvador@suse.de,
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
	rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com,
	apopple@nvidia.com, axelrasmussen@google.com, yuanchu@google.com,
	weixugc@google.com, yury.norov@gmail.com, linux@rasmusvillemoes.dk,
	mhiramat@kernel.org, mathieu.desnoyers@efficios.com, tj@kernel.org,
	hannes@cmpxchg.org, mkoutny@suse.com, jackmanb@google.com,
	sj@kernel.org, baolin.wang@linux.alibaba.com, npache@redhat.com,
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
	lance.yang@linux.dev, muchun.song@linux.dev, xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev, jannh@google.com, linmiaohe@huawei.com,
	nao.horiguchi@gmail.com, pfalcato@suse.de, rientjes@google.com,
	shakeel.butt@linux.dev, riel@surriel.com, harry.yoo@oracle.com,
	cl@gentwo.org, roman.gushchin@linux.dev, chrisl@kernel.org,
	kasong@tencent.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, zhengqi.arch@bytedance.com, terry.bowman@amd.com
Subject: Re: [LSF/MM/BPF TOPIC][RFC PATCH v4 00/27] Private Memory Nodes (w/
 Compressed RAM)
Message-ID: <ainFROZ3WrGioyuY@gourry-fedora-PF4VCD3F>
References: <20260222084842.1824063-1-gourry@gourry.net>
 <ag6XyvxR-NU5rGn-@parvat>
 <ahOqzpzAua96HVkn@gourry-fedora-PF4VCD3F>
 <ah47NNhuiClgGCdn@parvat>
 <ah6bDNxlB1zBUnzN@gourry-fedora-PF4VCD3F>
 <ah-0CyZurn5D1ezY@parvat>
 <aik_ddHymus2DJ6D@gourry-fedora-PF4VCD3F>
 <c1b66e7a-bb95-4295-8193-55ceadaaa578@kernel.org>
 <aimSzvoJDrpeQsmM@gourry-fedora-PF4VCD3F>
 <d01fb1ed-2418-42ee-aea2-37f9a5c5729c@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d01fb1ed-2418-42ee-aea2-37f9a5c5729c@kernel.org>

On Wed, Jun 10, 2026 at 08:59:59PM +0200, David Hildenbrand (Arm) wrote:
> On 6/10/26 18:37, Gregory Price wrote:
> > On Wed, Jun 10, 2026 at 05:00:33PM +0200, David Hildenbrand (Arm) wrote:
> >> On 6/10/26 12:41, Gregory Price wrote:
> > 
> > So, I remember this being asked, and I didn't fully grok the request.
> > 
> > I'm still not sure I fully understand the question, so apologies if I'm
> > answer the wrong things here.
> > 
> > I understand this question in two ways:
> > 
> >   1) Can we disallow PAGE allocation and limit this to FOLIO allocation
> 
> Yes. Can we only allow folios to be allocated from private memory nodes. So let
> me reply to that one below.
> 
... snip ...
> 
> At LSF/MM we talked about how GFP flags are bad and how deriving stuff from the
> context might be better. I think there was also talk about how the memalloc_*
> interface might be a better way forward. Maybe we would start giving the
> allocator more context ("we are allocating a folio").
> 
> The following is incomplete (esp. hugetlb stuff I assume), just as some idea:
>

Ok, the mental gap I have is not knowing the full context behind
memalloc.  I'll take this and do some reading / prototyping, but
this looks entirely reasonable.

I will still probably send the next RFC version tomorrow or friday,
as I want to get some eyes on the __GFP_PRIVATE-less pattern.

Also, I made a new `anondax` driver which enables userland testing
of this functionality without any specialty hardware.

tl;dr:

fd = open("/dev/anondax0.0", ....);
buf = mmap(fd, ...);
buf[0] = 0xDEADBEEF; /* fault to anondax driver */

static vm_fault_t anon_dax_fault(struct vm_fault *vmf)
{
        struct dev_dax *dev_dax = vmf->vma->vm_file->private_data;
        vm_fault_t ret;
        int id;

        id = dax_read_lock();
        if (!dax_alive(dev_dax->dax_dev))
                ret = VM_FAULT_SIGBUS;
        else
                ret = do_anonymous_page_node(vmf, dev_dax->target_node);
        dax_read_unlock(id);

        if (ret & VM_FAULT_OOM)
                return VM_FAULT_SIGBUS;
        return ret ? ret : VM_FAULT_NOPAGE;
}

With:
  qemu-system-x86_64 -m 5G \
    -object memory-backend-ram,id=m0,size=4G -numa node,nodeid=0,memdev=m0 \
    -object memory-backend-ram,id=m1,size=1G -numa node,nodeid=1,memdev=m1 \
    -append "... memmap=0x40000000!0x140000000"

Voila - buddy-managed private anonymous memory (1G region)

No need to reinvent page_alloc.c or fault handling :]

This can be used to hammer on reclaim/compaction/whatever support
without needing any particular hardware setup, and in fact it gives
some memory devices a path to support in userland while standards
get worked out.

do_anonymous_page_node is a bit of a bodge right now but I just haven't
fleshed it out yet.  The idea is - don't reinvent the fault path, just
provide the appropriate context to memory.c to do the right thing.

If this is acceptable, I imagine whatever interface gets implemented
will carry an in-tree driver export only, similar to hotplug/kmem.

> From 64aaff5f40497201ecc089c3339df6576184c433 Mon Sep 17 00:00:00 2001
> From: "David Hildenbrand (Arm)" <david@kernel.org>
> Date: Wed, 10 Jun 2026 20:55:49 +0200
> Subject: [PATCH] tmp
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
>  include/linux/sched.h    |  2 +-
>  include/linux/sched/mm.h | 11 +++++++++++
>  mm/mempolicy.c           | 14 ++++++++++++--
>  mm/page_alloc.c          |  7 ++++++-
>  4 files changed, 30 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index ee06cba5c6f5..9c850b7be6bf 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1778,7 +1778,7 @@ extern struct pid *cad_pid;
>  						 * I am cleaning dirty pages from some other bdi. */
>  #define PF_KTHREAD		0x00200000	/* I am a kernel thread */
>  #define PF_RANDOMIZE		0x00400000	/* Randomize virtual address space */
> -#define PF__HOLE__00800000	0x00800000
> +#define PF__MEMALLOC_FOLIO	0x00800000	/* Allocating a folio that can end up on
> private memory nodes */
>  #define PF__HOLE__01000000	0x01000000
>  #define PF__HOLE__02000000	0x02000000
>  #define PF_NO_SETAFFINITY	0x04000000	/* Userland is not allowed to meddle with
> cpus_mask */
> diff --git a/include/linux/sched/mm.h b/include/linux/sched/mm.h
> index 95d0040df584..2101a447c084 100644
> --- a/include/linux/sched/mm.h
> +++ b/include/linux/sched/mm.h
> @@ -471,6 +471,17 @@ static inline void memalloc_pin_restore(unsigned int flags)
>  	memalloc_flags_restore(flags);
>  }
> 
> +static inline unsigned int memalloc_folio_save(void)
> +{
> +	return memalloc_flags_save(PF_MEMALLOC_FOLIO);
> +}
> +
> +static inline void memalloc_folio_restore(unsigned int flags)
> +{
> +	memalloc_flags_restore(flags);
> +}
> +
> +
>  #ifdef CONFIG_MEMCG
>  DECLARE_PER_CPU(struct mem_cgroup *, int_active_memcg);
>  /**
> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index 36699fabd3c2..a78b0e5a1fce 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -2506,8 +2506,13 @@ static struct page *alloc_pages_mpol(gfp_t gfp, unsigned
> int order,
>  struct folio *folio_alloc_mpol_noprof(gfp_t gfp, unsigned int order,
>  		struct mempolicy *pol, pgoff_t ilx, int nid)
>  {
> -	struct page *page = alloc_pages_mpol(gfp | __GFP_COMP, order, pol,
> +	struct page *page;
> +	int flags;
> +
> +	flags = memalloc_folio_save();
> +	page = alloc_pages_mpol(gfp | __GFP_COMP, order, pol,
>  			ilx, nid);
> +	memalloc_folio_restore(flags);
>  	if (!page)
>  		return NULL;
> 
> @@ -2588,7 +2593,12 @@ EXPORT_SYMBOL(alloc_pages_noprof);
> 
>  struct folio *folio_alloc_noprof(gfp_t gfp, unsigned int order)
>  {
> -	return page_rmappable_folio(alloc_pages_noprof(gfp | __GFP_COMP, order));
> +	struct folio *folio;
> +	int flags;
> +
> +	flags = memalloc_folio_save();
> +	folio = page_rmappable_folio(alloc_pages_noprof(gfp | __GFP_COMP, order));
> +	memalloc_folio_restore(flags);
> +	return folio;
>  }
>  EXPORT_SYMBOL(folio_alloc_noprof);
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index ee902a468c2f..37434b37f7af 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -5345,8 +5345,13 @@ EXPORT_SYMBOL(__alloc_pages_noprof);
>  struct folio *__folio_alloc_noprof(gfp_t gfp, unsigned int order, int
> preferred_nid,
>  		nodemask_t *nodemask)
>  {
> -	struct page *page = __alloc_pages_noprof(gfp | __GFP_COMP, order,
> +	struct page *page;
> +	int flags;
> +
> +	flags = memalloc_folio_save();
> +	page = __alloc_pages_noprof(gfp | __GFP_COMP, order,
>  					preferred_nid, nodemask);
> +	memalloc_folio_restore(flags);
>  	return page_rmappable_folio(page);
>  }
>  EXPORT_SYMBOL(__folio_alloc_noprof);
> -- 
> 2.43.0
> 
> 
> -- 
> Cheers,
> 
> David
