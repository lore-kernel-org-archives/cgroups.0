Received: from mail-qk2-f13.google.com (mail-qk2-f13.google.com [74.125.230.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B3352CCC4
	for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 22:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790114710; cv=none; b=pcUbQFREce1EvHQ9c8+C2IRXtto2e4BMHy74tIPbhK5iNscFP9odI7sGipMfxYZuSCnNNy7usZ9u/PpDsjw4DuvHDVPkRzOTfMWfeFhMMPr43j36pV0LnZrUvAY6jHhWpJBiyMwKp8nAi480OL0E474kj6MOleV/go5IaR/B1Fk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790114710; c=relaxed/simple;
	bh=RRH1Vy+Zp/3SPkBGo9aHf3zXVNOp+j6j9mQwfJznZmI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Wiu8wQ4yk4cWtjQLqiyoNnifIyHFK6WeFKnw2tfLUPNgVbb91N3jca1Arb0Br71HxhyR2oZKwN1pG2Jmb4Lh0JEn0DVUCrtE2EFZLIAiT8kF9SlQ7OeNtNvj4vtzCIixtnyrJvmFUBvpNivGzrdkcuJk5Xdp36FWVz8Fnd4VS0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=qyAeO4Im; arc=none smtp.client-ip=74.125.230.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="qyAeO4Im"
Received: by mail-qk2-f13.google.com with SMTP id af79cd13be357-939109f067fso38186685a.2
        for <cgroups@vger.kernel.org>; Tue, 22 Sep 2026 15:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790114700; x=1790719500; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=anrpgiCeXWmBr1az5PEHzf4nylW2QouLqia/wBZNbT4=;
        b=qyAeO4ImlxQWHWrY3rOI+d0jNqWFqqyELQ56tlRiHnq25pIvKuTEJrR3OrKTFcd4FP
         IBWytxk9SOvSacV53yQXEJxrCz7JFBDHXXmbeZzXj0EB/0NOWsfpSVn6yoXESESrC7en
         dWDirDwk2QkTXluyyhV/DpGjnVcz/j2jc1v8BpLdtDbcf5sjhv0PBXWkeMqUn2k3Taqh
         Br/RM3e48CnC2TjK95UIB1Un9r7oOaUxLLkos8lL9ixrdl11BIKHZKIuPajT92vSGr1Q
         qIAPWwqVvLVWxLDUlYny2dsxjQOz/CXVwD1OBKCicazpUsOUeEuMWOX7N+ZjO7LVxQvN
         v/GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790114700; x=1790719500;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=anrpgiCeXWmBr1az5PEHzf4nylW2QouLqia/wBZNbT4=;
        b=BLkvEmeumK4DDbfoI0xomHWUsdLiW+8U4XMcfX+44/VorTUv8NN2TLnpzFEbfsiyfn
         kWV39FKHCkbjkC6WURBbKV4nutwz+lFIhgEqJapslwVsYcMsJ5Znmz7Qv/9kJbX01Dml
         E3KuZSqZF3RUG5IepR7xvOsY0KE8I+h0AUMIMTwG8mAQpdYTdyQJXZdPW+kChIaP4Fgp
         JW4ZVVPe9OyAc8JYMZPiHNU+XTzunANU5AC+OhzG5cZLMkAoQ/xlgaQrVcRNF+ifalyy
         LBTAOZWhSlTrpVz2fKb04AdiQ08DqUwpWXFlVY6O11bjKt06fNArsYckJ5jaw1Xqpf5L
         wyGA==
X-Forwarded-Encrypted: i=1; AKwUvBzNhHS4Xuc9/Kgta/4JIc+qolKkHp7pjvfA01SG/CTeDxFfYhRIn6yx/VgZ3a+k9jEeNXglsvgc@vger.kernel.org
X-Gm-Message-State: AFuF++l0KnU8h/AJSEEK+LiK0oT+mbcj73B7mt0fLCfNBOT6p8HlXg/B
	tpWxcCMDMfZvVvPoPeeqYzB6eQ4YUIErcv2d7LlJb0QF7tzZ8xCYvkB/1OKkhArQcHw=
X-Gm-Gg: AYBFou2RKpMEWJIR3I109Sfbpju8N9HY0ONfn16dm680dHjuIwvJz1o5ILwftcDJaGO
	+cmg2Ga+yv0iX1P1DKffgtMkG4Sdnj0kykCq5rZE0/VWUx8xv6kU96TOaMxqMaQqlV1cu8gDvsd
	OsMU5lrtGlz6lPrPuf6k4Agcaj/sTMy6yFM9HXU+p+FQwkFFjrSVrlJvOLlMMMi67Mzbz9g4IWw
	wBbOJeSzZGFvEo4yE/xIIGVyVkBvXCSxfmWcvyzy1aeO4xGONw4Sd41eBQpSHVH+LunG2SwI70g
	53IpHB58gtTTWwzB+POs+7XvD7LqMdqb+6u8gXCLd1hg/z6HY2DNSizLU8tkF+1dhz+6hiOgmXk
	flTEh/u4nT09z0xlBemJzHjbQt6ojsSLk4ehHXAtvOPDF0Q02li6omCEtVqanL6DnXEWiUpEktB
	FG0/R5soerXHviQa+2PAk2SCLa+scIp+uOdYxoxV+T9x/G5M+4t4rVbwenStf3X3P96wMbNwwY4
	tnunZqRXu/1D0xLWZUpbVE/RShjVoDYVNN9p1PZ0RTJkYSeswfxcAk=
X-Received: by 2002:a05:620a:4890:b0:939:a1cc:f234 with SMTP id af79cd13be357-93c2509dec2mr122764985a.5.1790114700080;
        Tue, 22 Sep 2026 15:05:00 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-93c284a1cd9sm4296985a.39.2026.09.22.15.04.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2026 15:04:59 -0700 (PDT)
Date: Tue, 22 Sep 2026 18:04:56 -0400
From: Gregory Price <gourry@gourry.net>
To: Arun George/Arun George <arun.george@samsung.com>
Cc: linux-mm@kvack.org, Zhigang.Luo@amd.com, balbirs@nvidia.com, 
	brendan.jackman@linux.dev, yuzenghui@huawei.com, apopple@nvidia.com, alucerop@amd.com, 
	matthew.brost@intel.com, akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, corbet@lwn.net, skhan@linuxfoundation.org, 
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org, djbw@kernel.org, 
	vishal.l.verma@intel.com, dave.jiang@intel.com, alison.schofield@intel.com, 
	osandov@osandov.com, jannh@google.com, pfalcato@suse.de, jackmanb@google.com, 
	hannes@cmpxchg.org, ziy@nvidia.com, pbonzini@redhat.com, osalvador@suse.de, 
	joshua.hahnjy@gmail.com, rakie.kim@sk.com, byungchul@sk.com, ying.huang@linux.alibaba.com, 
	kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev, baohua@kernel.org, 
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com, yury.norov@gmail.com, 
	linux@rasmusvillemoes.dk, longman@redhat.com, ridong.chen@linux.dev, tj@kernel.org, 
	mkoutny@suse.com, sj@kernel.org, jgg@ziepe.ca, jhubbard@nvidia.com, 
	peterx@redhat.com, baolin.wang@linux.alibaba.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, lance.yang@linux.dev, usama.arif@linux.dev, 
	xu.xin16@zte.com.cn, chengming.zhou@linux.dev, roman.gushchin@linux.dev, 
	muchun.song@linux.dev, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	driver-core@lists.linux.dev, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	linux-debuggers@vger.kernel.org, linux-fsdevel@vger.kernel.org, kvm@vger.kernel.org, 
	cgroups@vger.kernel.org, damon@lists.linux.dev, linux-kselftest@vger.kernel.org, 
	kernel-team@meta.com, hokyoon.lee@samsung.com, wj28.lee@samsung.com, 
	gost.dev@samsung.com, vikash.k5@samsung.com, d.bueso@samsung.com
Subject: Re: [PATCH v5 00/36] Private Memory NUMA Nodes
Message-ID: <arL2eTRaDeR3DCQx@gourry-fedora-PF4VCD3F>
References: <CGME20260720193443epcas5p167fa7d8490edfb4d8c0aa6a259db058f@epcas5p1.samsung.com>
 <20260720193431.3841992-1-gourry@gourry.net>
 <963815509.21784796303385.JavaMail.epsvc@epcpadp1new>
 <amJGUuBZ2857QjDB@gourry-fedora-PF4VCD3F>
 <360067785.01790071202608.JavaMail.epsvc@epcpadp1new>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <360067785.01790071202608.JavaMail.epsvc@epcpadp1new>

On Tue, Sep 22, 2026 at 03:27:44PM +0530, Arun George/Arun George wrote:
> Hi Gregory,
> 
> Thanks for sharing the working branch.
> 
> Some of us at Samsung are testing the series (both v4 & v5) on a 
> compression capable CXL expander and are observing encouraging results.
>

This is really cool, thank you so much for spending the cycles to test.

I'm working on getting a v6 out soon.  Glad to see the progress!

> Good things first! We feel that the isolation using private nodes and 
> the capability selection using NODE_PRIVATE_CAP_* work functionally well 
> for the compressed memory use cases.
> 
> On improvement points, we observed much higher 'page_faults', 
> 'allocation_stalls' etc. which contributed to the higher tail latencies 
> in some tests. I hope these are already part of the optimization plans. 
> The higher latencies might have resulted from the write_protection 
> applied to the private node, I believe.
> 

Yes, this is expected, and I think there are questions about how it
should be optimized both in a provisioning sense and a software sense.

For example, exposing a full memory expander as 100% compressible may
not make sense - given that this could many a lot of memory.  I have
some data that shows it may make more sense to split a memory expander
into two regions to better fit the compressible region to meet the
actual capacity the cold-tail is capable of consuming.

On the software side there may be some ability to adjust this at
runtime with hotplug instead of requiring a reboot, but I think that
needs to be experimented with.

> On the tools side, we used MLC and Taobench for the tests.
> 

Great! I also have some TaoBench and fio results i'm looking to share,
glad to have some additional peer review using Tao.

> Note that our intention for this phase of experiments was to test only 
> the 'private node' layer based isolation, and not the cram and below 
> layers for the compressed memory. Therefore we did not enable/utilize 
> the compression capability in the hardware for these set of experiments 
> (enabling compression would require the cram level ballooning/memory 
> shrinking and cxl level interfacing driver to the compression device). 
> That would be different set of experiments where we would be testing the 
> cram balloon shrinkers and our alternate algorithms (upstream targeted). 
> So cram and below layers were used only for enumeration of private node 
> regions for these tests and not for the run-time memory shrinkers.
> 

Agreed, i'm looking forward to getting past the isolation bits and get
more focused on the compression implementation details.

> ======= Test Methodology ==============
> 
> We explored these 3 cases:
> 
>     1) (Baseline – existing CXL infra):  DRAM 16GB + CXL 32GB. Here we 
> used the existing CXL driver infra to enable the device. No private node 
> is involved. And compression is disabled on device.
> 
>     2) (private node in default write protected path): DRAM 16GB + CXL 
> Private Node 32GB. Here private node infra is used to enable the device. 
> And compression is disabled on device.
> 
>     3) (private node with no write protection): DRAM 16GB + CXL Private 
> Node 32GB. Here private node infra is used to enable the device without 
> the write protection/fencing enabled. Compression is disabled on device. 
> We could not complete these runs as they resulted in kernel panics. 
> Guess the code path is not stable yet for this (We had hoped that case 1 
> and case 3 results would be similar). We also observed some unmovable 
> page warnings logs in 'dmesg' before crash (might be related to the 
> panic). Adding the log snippets at the end.
> 

Very similar to my test setup, seems like good signal we are of similar
mind on the use case.  (For readers: there was no coordination here).

I personally did not test private-node without write protection,
although it makes sense to test the throughput of a demotion-only
node as a baseline.  Smart.

My guess is there was probably a reclaim throughput issue, or there may
have been a bug in the v4/v5 code.  I will look at adding some pressure
tests to my suite that test demotion-only explicitly.

> ========= Results summary ===================
> 
> Private (CRAM) node performance is lower compared to a normal CXL memory 
> allocation path. VM stats shows more page_faults and allocation_stalls 
> on the private node case. Could it be the allocator waits for migration 
> path to demote pages to private node? Or the actual hot pages in dram 
> got demoted to private node to make space during overwrites? We will try 
> further analysis on this.
> 

- allocator waits for migration?
  
  Yes.  And worse, once the node is full, migration will fail and you'll
  swap directly from the top tier and reduce your reclaim behavior on
  the lower node.  It becomes very important to push proactive reclaim
  on a demotion-only tier to ensure there is sufficient headroom to
  receive demotions in the future, since direct-reclaim basically never
  targets a lower-tier on the first pass.

  There's a big discussion about whether tiered systems need to invert
  their reclaim behavior (reclaim from the lowest node first to find
  progress there, then do demotion - rather than the other way around).

- Hot pages in dram 

  Also yes.  The comparison to make isn't only against a raw CXL node,
  but also against Zswap or Zram or Swap.  How does the workload fair
  on a system with 16GB RAM and 32GB Zswap/Swap?

  This is important context.

> ========== MLC Experiments ====================
> 
> CMD:
>    $./mlc --loaded_latency -j0 -c0 -b1g -k1-15 -W5 -r
> 
> Experiment Results:
> 
> 1. (Baseline) DRAM 16GB + CXL 32GB
> 
> Inject  Latency Bandwidth
> Delay   (ns)    MB/sec
> ================
>   00000  686.18   40137.5
>   00002  686.69   40124.0
>   00008  709.74   40362.7
...
> 2. (private node in default write protected path)
>      DRAM 16GB + CXL Private Node(Uncompressed) 32GB
> 
> Inject  Latency Bandwidth
> Delay   (ns)    MB/sec
> ================
>   00000  320.09   12186.2
>   00002  543.42   22726.1
>   00008  482.11   28385.2
...
> Takeaway: Our MLC tests show a trade-off between the two configurations. 
> During low inject delay, the private Node is faster. But when inject 
> delay goes high, the baseline shows better latency. Could it be the TLB 
> cache effects?
> 

These latency results suggest to me that the memory being tested was
always DRAM, though the initial memory fault would have been CXL.

i.e. even if the memory was faulted directly onto the node via
mempolicy, the very first write to it would have caused promotion.

If you dropped the write protection you'd probably see it equals the
baseline.

The bandwidth numbers support this.  Higher stall, but faster latency
means the migration was more beneficial for latency than letting the
memory sit on CXL.

Neat.  I'm not sure these results are particularly useful in describing
how a workload would react.

> --------------------------------------------------------------------
> Case 3 dmesg log snippet:
> 
> [   82.525741] page: refcount:1 mapcount:0 mapping:0000000000000000 
> index:0x0 pfn:0x5f5800
> [   82.525753] flags: 
> 0x17ffffc0002000(reserved|node=0|zone=2|lastcpupid=0x1fffff)
> [   82.525762] raw: 0017ffffc0002000 ffefc85717d60008 ffefc85717d60008 
> 0000000000000000
> [   82.525764] raw: 0000000000000000 0000000000000000 00000001ffffffff 
> 0000000000000000
> [   82.525766] page dumped because: unmovable page
> ..............
> 

Was this memory hotplugged via cram.c or did you replicate the code and
hotplug it another way?  If so, did you hotplug it as ZONE_NORMAL or
ZONE_MOVABLE?

For a compressed tier, it must always be hotplugged as ZONE_MOVABLE,
without exception, because otherwise it can allow a GUP pin or kernel
allocation that would eventually become permanently stuck there - and by
definition of a compression tier must be 100% movable memory.

~Gregory
