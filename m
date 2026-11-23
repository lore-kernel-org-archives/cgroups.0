Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.161.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795462383;
	b=ZoIs1oWO913nsBPZkmurVm63ZlPqNbiALWt6hTPfwAmb0IrEm1RFI6zZkpwqnK8vcUVJ
	 My/MU1ZDpKOxUq0oGWDLZ0TdTg5hH1PNjOE9Plihl1gAhEUFVXkKaDp8IFI6ckuB9tS1m
	 v81DSEVIrGgCmqKREPlbP2E781GD0fdtVUAHFHSOvnhnHuDzCO3am4tKrGPcgmf6pRF8+
	 iQ/pQVUNhT7ch7emCh7eqlUh+pMrP55pm41REo/QkRxPRJJmNjdMHwGsnJZbQF8OK7/Xb
	 0Fxq2Rgvj6PF6Jj5zQSqIvh+DCeqN3jeou1pcoRvRe8J0mLQSLhjXDnFtvJQo4QcM4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795462383;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Subject:Message-ID:Mail-Followup-To:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=glXn7S+m6d9WKK+ny9saY5JJzsG/5FMMUlfMljP3M30=;
	b=fz+hyqJhYjKwTJEeQ1vQRS5ihKeYJWXHoGQyt2tapr7ZPomMzy/VWtbqEt5pcMaL6bpy
	 mGgP99gt8t94rJQGOijd/dcdEUgUQPKRxfRM2/1XIYgKjnivWjggU2Rlt7t1HP41UIDqT
	 mpofGOdDchLNHl3t2pi/d1O5/KklSxLDLceVfs03r3iH7dX05N4fQcCkewwPD4PLNXSNa
	 KYyvQLXoG0omi3cbnMHhZvWBJLsQcivBUw/t1V6SIak8I1tmbcASXibCD9iJEqbGcl7mF
	 9NXLYFl1MJzZHN2CVmPKHnk/zn/yjpS91K58egZk02eWyH8fQzE736KR8UNv/uX9EgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=cY1APHMt;
	arc=none smtp.remote-ip=209.85.161.51
Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66D6606A31A
	for <cgroups@vger.kernel.org>; Mon, 23 Nov 2026 19:33:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D66D6606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=cY1APHMt
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-6e560e00a86so2466606eaf.1
        for <cgroups@vger.kernel.org>; Mon, 23 Nov 2026 11:33:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795462382; x=1796067182; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:mail-followup-to:message-id:subject:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=glXn7S+m6d9WKK+ny9saY5JJzsG/5FMMUlfMljP3M30=;
        b=cY1APHMtdW0lhZVXBvhOBqaJTW6dQD6YZXXlv7eosiKXfPvKyiDaYqKSQa/7ghQhDy
         16kosnNntZ6NaGBBICidqXtv+lMMCukSEPU8AiAmrFbNQcNXUYBjSv7QHM5TKt9glOC2
         MDiqtPbZ/wWl6mmPGdFSCaEevD5SR1we3IYecWXx0InSJUCLoXkPMxppXb4z7JoHnpvP
         ZlHcGU1MhvwZSkdyZbJUcX1SXJuTWBhEnQS65aIiduIVPIn+3dM0QVZSYZ6uXS0ncPC2
         uGBWBzM2c0PRCkGeNUeNX6Q6B0QrQwyBfb93HlnXgi6AsUfvuSKaMwpIRT4O7/zSvKut
         2mwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795462382; x=1796067182;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:mail-followup-to:message-id:subject:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=glXn7S+m6d9WKK+ny9saY5JJzsG/5FMMUlfMljP3M30=;
        b=zkcHMm7A9vGoFazg65hV6lOnD0hlEtk4zU7Z/+IoBf8dYmsdX8FZVtbOF4TxP0nEK+
         VEcfMABFmEvlv69aT+tKM5KQ4tcijFAeaP9cgQ2uyKFXdf6J/yymnpD/lLFQGH3iJmev
         coEm+y/R8geTViWDmMMpaqcRd1vsBXBneQ9el3v8nWY4wQTKO6l7ET06wHzKYIU2OTGX
         L05BGYninrQuyj5tH6dHeYbTosF0jN+/heZszSV7u483ufIrUCI5iJT90g1rKLjTyksc
         KvYbxTPLsDKHDJxHa2XtffdP/yQmOn9AX5Sve0ntvuj3JEh/PsHn0ls6UJC5cB4tUJ7F
         QjHg==
X-Forwarded-Encrypted: i=1; AL+hErGrYdmlXswwVRhuXGPDJbtZFpexo9tcwH22ml2KZatLS1fT8L8CjyLRhRdMl/O91290WTxp3UfT@vger.kernel.org
X-Gm-Message-State: APuU4Z/+aepy4x7e9BV6eahrgEeQWYVGbt75SYvcommg6ASAeOvKqXxo
	JJcGmldk/wE9dRoqaGYp2cBFoamnAcpzQfe+KCW2BGnmdeqK5Z4LteJCu5453A==
X-Gm-Gg: AZFdTZesXjK0l0jNyhrZqxgKavRt2bJ8umHUKjeolAygH0M0lDDUVjyHRj58aE+cBZq
	XJJVJMJhJGMpMJUFmfoQy8+9XT4oNgGo3slduX1wdbsE3xlZNR/aFsihWMym7iW7y3NyQUi1jtV
	+KUyznaFfOD/KCa9SiQJDe0ckhKV5rOyM233Xndtz3yan1JNEq5bL7SWFnjaRCIWJqxNCU9Ww1h
	FYVz4So48JqxWXZi5X3O0U/nQrIYwXOsq9m87oQinQe8hLRG8CabCU9Bu4VPKutd/PgXybMTSJe
	ynDOcQvOkrGf1TESkR2OeQIYofOFNtVSVbYLGw//1snDAHmtK+CIejEj5E1DGewZ/ai/oaUe+yZ
	3Z2svqpAVmXiJBZ0Efs2Wy7T+6ocbh6JNeaItd9/aCaInkZZFoT3n6P0KmxQYFh5I/wiXuu3iQZ
	QFgMZzVs0mLgOlidgZovor+lLSGuipBN7/SP3WVpdykL8vzAduoVWIpqIuXXqfhDDN16YA1BWLV
	eijzMgWm89VDebwE0OI/0ZlLkK3SzjGafqLOvjAlf8KEmYc6kDmhsr+W5BnUqfX1RWQhjDgTgeF
	o9PyN0dBp3Ac3ZwshtZy4P1Wex0ZVPrt/opU/wPhiHINbZ6c1f552UV8DbHTvQ==
X-Received: by 2002:a05:6820:c2cf:10b0:71a:f0cc:94e1 with SMTP id 006d021491bc7-71b3960c59emr7028444eaf.83.1795462381565;
        Mon, 23 Nov 2026 11:33:01 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:4b::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4bc61081159sm11792209fac.15.2026.11.23.11.33.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 11:33:00 -0800 (PST)
Date: Mon, 23 Nov 2026 11:32:59 -0800
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Li Zhe <lizhe.67@bytedance.com>, akpm@linux-foundation.org, 
	david@kernel.org, gourry@gourry.net, hannes@cmpxchg.org, ljs@kernel.org, 
	mhocko@suse.com, muchun.song@linux.dev, rakie.kim@sk.com, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, weixugc@google.com, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com, cgroups@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3] mm: add source selector to memory.reclaim
Message-ID: <awSUhzqM-QEMTX0Y@devbig011.atn3.facebook.com>
Mail-Followup-To: Li Zhe <lizhe.67@bytedance.com>, 
	akpm@linux-foundation.org, david@kernel.org, gourry@gourry.net, hannes@cmpxchg.org, 
	ljs@kernel.org, mhocko@suse.com, muchun.song@linux.dev, rakie.kim@sk.com, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, weixugc@google.com, 
	ying.huang@linux.alibaba.com, ziy@nvidia.com, cgroups@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20261116110459.11048-1-lizhe.67@bytedance.com>
 <awSSDehzWsJ68V5y@devbig011.atn3.facebook.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awSSDehzWsJ68V5y@devbig011.atn3.facebook.com>

On Mon, Nov 23, 2026 at 11:29:24AM -0800, Joshua Hahn wrote:
> On Mon, Nov 16, 2026 at 07:04:59PM +0800, Li Zhe wrote:
> > memory.reclaim can apply proactive reclaim to a memcg, but it cannot
> > target source nodes the way global node reclaim can. Proactive memcg
> > reclaim follows a fast-to-slow fallback order, which attempts demotion
> > before reclaiming from slower tiers.
> > 
> > As a result, a memcg controller cannot decide whether reclaim should
> > start from DRAM or from a slower tier. For a cgroup that is close to OOM
> > and needs charge reduction, or for a controller trying to shape a
> > workload's DRAM/CXL resident distribution, the default policy may spend
> > reclaim effort on the wrong source tier.
> > 
> > Add source=nodes:<nodelist> to memory.reclaim. The selector only chooses
> > the resident source nodes where the existing memcg reclaim path applies
> > pressure. It does not select demotion targets, force demotion, force
> > eviction, promote pages, or change completion accounting. Leaving source
> > unspecified preserves existing behavior.
> 
> Hi Zhe,
> 
> Thanks for the patch and sorry that it took so long to reply.
> I've actually spent a lot of time thinking about this commit to see if
> it can be used to establish per-memcg-tier residency limits on machines
> running multiple workloads via memcgs.
> 
> So you could have a daemon running, checking the per-tier usage for a
> cgroup, and creating pressure to evict pages downward from that cgroup
> specifically.
> 
> So if a cgroup is using 10G more node0 (DRAM) than it should be, you can
> write "echo 10G source=nodes:0" > memory.reclaim to try and free up that
> space. I'm running some experiments locally and really thinking through
> this to see what that would lead to.
> 
> Anyways, to me the only concern that I have is what happens when that
> reclaim fails. Let's say that you have a situation where CXL is
> completely full, preventing future demtions. At the same time, we have
> a memcg that is using too much DRAM, so we try to reclaim from the
> DRAM node and pressure downwards.
> 
> The thing is, I think proactive reclaim doesn't allow swapouts on tiered
> systems. 

Sorry, I had meant to add more context here. I meant that proactive
reclaim doesn't allow swapouts directly. See
6b426d071419 mm: disable top-tier fallback to reclaim on proactive reclaim
for some more context. 

> So what would happen is, you would (1) fail demotions, and then (2) fail
> to swap out, which means the pages have nowhere to go. And repeatedly
> running the same command over and over again will not lead to any
> progress at all.
> 
> > With this, userspace can build the policy it needs on top of existing
> > kernel reclaim behavior:
> > 
> > 1. start reclaim from lower-tier nodes to reduce the cgroup's memory
> >    usage more directly;
> > 2. steer reclaim toward over-represented nodes to shape a workload's
> >    DRAM/CXL resident distribution; and
> > 3. reclaim from lower-tier nodes first so later top-tier reclaim has
> >    room for demotion.
> > 
> > Example: nodes 0-2=DRAM, node3=CXL
> > 
> >   echo 1G > memory.reclaim # progress from nodes 0-3
> >   echo "1G source=nodes:3" > memory.reclaim # reclaim from CXL
> >   echo "1G source=nodes:0-2" > memory.reclaim # usually demote to CXL
> 
> And so I can see why you would have to run something like this in order
> to actually make room, moving from the bottom going up. Make space for
> the memory that's about to come in from the top.
> 
> To me this makes a lot of sense, and it's something that we (Meta) has
> thought about quite extensively internally as well (from Johannes and
> Gregory, who are also CC-ed in this mail).
> 
> But at the same time, this is not really an atomic operation. So memory
> usage between the two operations can change very rapidly. I wanted to
> start a conversation about this point and whether this is something that
> the commit should address. I would like to hone in on a use case and
> think about how the users should be expected to use these things first.
> 
> Thanks a lot Zhe, and sorry again for the delayed response.
> I hope you have a great day!
> Joshua
> 
> > The typed source= form also leaves room for future source selectors
> > without changing the ABI introduced here.
> > 
> > Tested in a CXL setup with nodes 0-2 as DRAM and node 3 as CXL. A
> > userspace controller steered eight cgroups toward a 50:50 DRAM:CXL
> > resident ratio while a background workload created reclaim and demotion
> > pressure. With source=nodes, all eight cgroups ended with 45%-55% of
> > their memory on DRAM. Under the same pressure, the plain memory.reclaim
> > baseline left the worst cgroup far away from the target range.
> > 
> > Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
> > ---
> > v2: https://lore.kernel.org/all/20261102070440.16262-1-lizhe.67@bytedance.com/#t
> > v1: https://lore.kernel.org/all/20261019141401.11927-1-lizhe.67@bytedance.com/
> > 
> > Changes since v2:
> > - Dropped the separate cover letter and shortened/refocused the commit
> >   message, as suggested by Joshua Hahn and Gregory Price.
> > - Added an eight-cgroup CXL test summary under background
> >   reclaim/demotion pressure, as suggested by Joshua Hahn.
> > 
> > ---
> >  Documentation/admin-guide/cgroup-v2.rst | 11 ++++++
> >  mm/bpf_memcontrol.c                     |  3 +-
> >  mm/internal.h                           |  3 +-
> >  mm/memcontrol-v1.c                      |  6 ++-
> >  mm/memcontrol.c                         | 11 ++++--
> >  mm/vmscan.c                             | 49 +++++++++++++++++++++++--
> >  6 files changed, 72 insertions(+), 11 deletions(-)
> > 
> > diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> > index 9e3c67b02ae2..992f9bdc46a1 100644
> > --- a/Documentation/admin-guide/cgroup-v2.rst
> > +++ b/Documentation/admin-guide/cgroup-v2.rst
> > @@ -1458,6 +1458,7 @@ The following nested keys are defined.
> >  
> >  	  ==========            ================================
> >  	  swappiness            Swappiness value to reclaim with
> > +	  source                Source to apply reclaim pressure to
> >  	  ==========            ================================
> >  
> >  	Specifying a swappiness value instructs the kernel to perform
> > @@ -1468,6 +1469,16 @@ The following nested keys are defined.
> >  	The valid range for swappiness is [0-200, max], setting
> >  	swappiness=max exclusively reclaims anonymous memory.
> >  
> > +	Specifying a source value constrains where proactive reclaim applies
> > +	pressure. Currently only source=nodes:<nodelist> is supported. For
> > +	example::
> > +
> > +	  echo "1G source=nodes:0-1" > memory.reclaim
> > +
> > +	This applies proactive reclaim pressure to memory of the target cgroup
> > +	resident on nodes 0-1. It does not constrain demotion targets and does
> > +	not change memory.reclaim completion accounting.
> > +
> >    memory.peak
> >  	A read-write single value file which exists on non-root cgroups.
> >  
> > diff --git a/mm/bpf_memcontrol.c b/mm/bpf_memcontrol.c
> > index d8f579c28560..7d98f55a044f 100644
> > --- a/mm/bpf_memcontrol.c
> > +++ b/mm/bpf_memcontrol.c
> > @@ -201,7 +201,8 @@ __bpf_kfunc long bpf_proactive_reclaim(struct mem_cgroup *memcg,
> >  	nr_reclaimed = try_to_free_mem_cgroup_pages(memcg, nr_pages, GFP_KERNEL,
> >  						    MEMCG_RECLAIM_MAY_SWAP |
> >  						    MEMCG_RECLAIM_PROACTIVE,
> > -						    swappiness == -1 ? NULL : &swappiness);
> > +						    swappiness == -1 ? NULL : &swappiness,
> > +						    NULL);
> >  
> >  	return nr_reclaimed * PAGE_SIZE;
> >  }
> > diff --git a/mm/internal.h b/mm/internal.h
> > index e3f92883bf23..ff24a58d47e8 100644
> > --- a/mm/internal.h
> > +++ b/mm/internal.h
> > @@ -83,7 +83,8 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
> >  					   unsigned long nr_pages,
> >  					   gfp_t gfp_mask,
> >  					   unsigned int reclaim_options,
> > -					   int *swappiness);
> > +					   int *swappiness,
> > +					   const nodemask_t *source_nodes);
> >  
> >  #ifdef CONFIG_NUMA
> >  extern int sysctl_min_unmapped_ratio;
> > diff --git a/mm/memcontrol-v1.c b/mm/memcontrol-v1.c
> > index b7f286888507..74aa06fee76a 100644
> > --- a/mm/memcontrol-v1.c
> > +++ b/mm/memcontrol-v1.c
> > @@ -1464,7 +1464,8 @@ static int mem_cgroup_resize_max(struct mem_cgroup *memcg,
> >  		}
> >  
> >  		if (!try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL,
> > -				memsw ? 0 : MEMCG_RECLAIM_MAY_SWAP, NULL)) {
> > +				memsw ? 0 : MEMCG_RECLAIM_MAY_SWAP,
> > +				NULL, NULL)) {
> >  			ret = -EBUSY;
> >  			break;
> >  		}
> > @@ -1500,7 +1501,8 @@ static int mem_cgroup_force_empty(struct mem_cgroup *memcg)
> >  			break;
> >  
> >  		if (!try_to_free_mem_cgroup_pages(memcg, 1, GFP_KERNEL,
> > -						  MEMCG_RECLAIM_MAY_SWAP, NULL))
> > +						  MEMCG_RECLAIM_MAY_SWAP,
> > +						  NULL, NULL))
> >  			nr_retries--;
> >  	}
> >  
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 84f4a8fd4d16..116c6853c9ba 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -2444,7 +2444,7 @@ static unsigned long reclaim_high(struct mem_cgroup *memcg,
> >  		nr_reclaimed += try_to_free_mem_cgroup_pages(memcg, nr_pages,
> >  							gfp_mask,
> >  							MEMCG_RECLAIM_MAY_SWAP,
> > -							NULL);
> > +							NULL, NULL);
> >  		psi_memstall_leave(&pflags);
> >  	} while ((memcg = parent_mem_cgroup(memcg)) &&
> >  		 !mem_cgroup_is_root(memcg));
> > @@ -2774,7 +2774,8 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
> >  
> >  	psi_memstall_enter(&pflags);
> >  	nr_reclaimed = try_to_free_mem_cgroup_pages(mem_over_limit, nr_pages,
> > -						    gfp_mask, reclaim_options, NULL);
> > +						    gfp_mask, reclaim_options,
> > +						    NULL, NULL);
> >  	psi_memstall_leave(&pflags);
> >  
> >  	if (mem_cgroup_margin(mem_over_limit) >= nr_pages)
> > @@ -5001,7 +5002,8 @@ static ssize_t memory_high_write(struct kernfs_open_file *of,
> >  		}
> >  
> >  		reclaimed = try_to_free_mem_cgroup_pages(memcg, nr_pages - high,
> > -					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP, NULL);
> > +					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP,
> > +					NULL, NULL);
> >  
> >  		if (!reclaimed && !nr_retries--)
> >  			break;
> > @@ -5060,7 +5062,8 @@ static ssize_t memory_max_write(struct kernfs_open_file *of,
> >  
> >  		if (nr_reclaims) {
> >  			if (!try_to_free_mem_cgroup_pages(memcg, nr_pages - max,
> > -					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP, NULL))
> > +					GFP_KERNEL, MEMCG_RECLAIM_MAY_SWAP,
> > +					NULL, NULL))
> >  				nr_reclaims--;
> >  			continue;
> >  		}
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index 6a1af9b92349..15e2e5710468 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -7013,12 +7013,14 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
> >  					   unsigned long nr_pages,
> >  					   gfp_t gfp_mask,
> >  					   unsigned int reclaim_options,
> > -					   int *swappiness)
> > +					   int *swappiness,
> > +					   const nodemask_t *source_nodes)
> >  {
> >  	unsigned long nr_reclaimed;
> >  	unsigned int noreclaim_flag;
> >  	struct scan_control sc = {
> >  		.nr_to_reclaim = max(nr_pages, SWAP_CLUSTER_MAX),
> > +		.nodemask = source_nodes,
> >  		.proactive_swappiness = swappiness,
> >  		.gfp_mask = (current_gfp_context(gfp_mask) & GFP_RECLAIM_MASK) |
> >  				(GFP_HIGHUSER_MOVABLE & ~GFP_RECLAIM_MASK),
> > @@ -7054,7 +7056,8 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *memcg,
> >  					   unsigned long nr_pages,
> >  					   gfp_t gfp_mask,
> >  					   unsigned int reclaim_options,
> > -					   int *swappiness)
> > +					   int *swappiness,
> > +					   const nodemask_t *source_nodes)
> >  {
> >  	return 0;
> >  }
> > @@ -8098,20 +8101,51 @@ static unsigned long __node_reclaim(struct pglist_data *pgdat,
> >  enum {
> >  	MEMORY_RECLAIM_SWAPPINESS = 0,
> >  	MEMORY_RECLAIM_SWAPPINESS_MAX,
> > +	MEMORY_RECLAIM_SOURCE,
> >  	MEMORY_RECLAIM_NULL,
> >  };
> >  static const match_table_t tokens = {
> >  	{ MEMORY_RECLAIM_SWAPPINESS, "swappiness=%d"},
> >  	{ MEMORY_RECLAIM_SWAPPINESS_MAX, "swappiness=max"},
> > +	{ MEMORY_RECLAIM_SOURCE, "source=%s"},
> >  	{ MEMORY_RECLAIM_NULL, NULL },
> >  };
> >  
> > +#define MEMORY_RECLAIM_SOURCE_NODES	"nodes:"
> > +#define MEMORY_RECLAIM_SOURCE_NODES_LEN	(sizeof(MEMORY_RECLAIM_SOURCE_NODES) - 1)
> > +
> > +static int parse_memory_reclaim_source(const char *source,
> > +				       nodemask_t *source_nodes)
> > +{
> > +	const char *nodes;
> > +
> > +	if (strncmp(source, MEMORY_RECLAIM_SOURCE_NODES,
> > +		    MEMORY_RECLAIM_SOURCE_NODES_LEN))
> > +		return -EINVAL;
> > +
> > +	nodes = source + MEMORY_RECLAIM_SOURCE_NODES_LEN;
> > +	if (!*nodes)
> > +		return -EINVAL;
> > +
> > +	nodes_clear(*source_nodes);
> > +	if (nodelist_parse(nodes, *source_nodes))
> > +		return -EINVAL;
> > +
> > +	nodes_and(*source_nodes, *source_nodes, node_states[N_MEMORY]);
> > +	if (nodes_empty(*source_nodes))
> > +		return -EINVAL;
> > +
> > +	return 0;
> > +}
> > +
> >  int user_proactive_reclaim(char *buf,
> >  			   struct mem_cgroup *memcg, pg_data_t *pgdat)
> >  {
> >  	unsigned int nr_retries = MAX_RECLAIM_RETRIES;
> >  	unsigned long nr_to_reclaim, nr_reclaimed = 0;
> >  	int swappiness = -1;
> > +	nodemask_t source_nodes;
> > +	const nodemask_t *source_nodemask = NULL;
> >  	char *old_buf, *start;
> >  	substring_t args[MAX_OPT_ARGS];
> >  	gfp_t gfp_mask = GFP_KERNEL;
> > @@ -8142,6 +8176,14 @@ int user_proactive_reclaim(char *buf,
> >  		case MEMORY_RECLAIM_SWAPPINESS_MAX:
> >  			swappiness = SWAPPINESS_ANON_ONLY;
> >  			break;
> > +		case MEMORY_RECLAIM_SOURCE:
> > +			if (!memcg || source_nodemask)
> > +				return -EINVAL;
> > +			if (parse_memory_reclaim_source(args[0].from,
> > +							&source_nodes))
> > +				return -EINVAL;
> > +			source_nodemask = &source_nodes;
> > +			break;
> >  		default:
> >  			return -EINVAL;
> >  		}
> > @@ -8181,7 +8223,8 @@ int user_proactive_reclaim(char *buf,
> >  			reclaimed = try_to_free_mem_cgroup_pages(memcg,
> >  						 batch_size, gfp_mask,
> >  						 reclaim_options,
> > -						 swappiness == -1 ? NULL : &swappiness);
> > +						 swappiness == -1 ? NULL : &swappiness,
> > +						 source_nodemask);
> >  		} else {
> >  			struct scan_control sc = {
> >  				.gfp_mask = current_gfp_context(gfp_mask),
> > -- 
> > 2.20.1
