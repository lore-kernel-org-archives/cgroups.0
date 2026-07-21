Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5D77407576
	for <cgroups@vger.kernel.org>; Tue, 21 Jul 2026 18:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657790; cv=none; b=OB33RT2iSc+eepjF2DaF3CTJP7eX6Oq8fsoNoiiKt6+IIp9e23s6AfRScHv6ICcRts7xUbSiG0UEI4vsTshSAyjt9Fpyqgv2sij5I0VM/czCLNwvBK7bRzkvAT51B5jlwxOwb+s3BXte0HwvkMPJQtOQVYjrA0wsAGoNtSJt0DE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657790; c=relaxed/simple;
	bh=oFlvw3giOtGQsSkXQn6VVdx6osu4tro2T3RPW7SBhU0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YQCtezcZ/SOWCOq3rg05b7r80aRDbuJoTY/k4CY2PFHherfWHbvo/nDbEbzQi8zRjnFlT3Hgi5oFhj114l48bmBpNy9Z8RZEnLG7KrQoVO2HWMeyMmdpEftvwv/d7GeDYoi2GvFc98Mi6kHVT8cD6wJSnNn2ZScGmh7tZI8ssmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=lWiMqNe1; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="lWiMqNe1"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-51c2a818fc4so99165621cf.2
        for <cgroups@vger.kernel.org>; Tue, 21 Jul 2026 11:16:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784657788; x=1785262588; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tK6CpaworNApxpcs4ZRJbHY7w08bgOkmP8ipHWd1tq8=;
        b=lWiMqNe1aGdlndmF0DEIX11ekT+kppi6ZCsdKP+nARwmUcbPRB2RiqFp9CcVZlrCMe
         a7iQJIUlHGgwrTlgeBPrEB9RYw65vbDnpQS/W6FXlBeixFMzdS/zMQMhcf9prwyKh9Tg
         zZM1P1+WyYLol3M86HhbDS8lLf0qvp8NnbVepemntzhrmA+vdbVuvJTjusRGwuudCrDN
         IJnhW0U1qCJ9qu+q+c/HoRATkAolbkeQ7YmmUklTRfiHMdfAYBd7KPK3bsHOQiTqkD7y
         nQk7+E507U93KpaB3JodhTTR0dnlAPaEgPrkM70sUwYbhPsJOnuOLMGTZLlANx5BWdjy
         4gWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784657788; x=1785262588;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tK6CpaworNApxpcs4ZRJbHY7w08bgOkmP8ipHWd1tq8=;
        b=TIvLdEhZu699/1WY1FfBHVSfKDTLHm7NG3HsptYtASGQjY/EvN9uoEn+qP7hU75jYl
         xkWbBsT9LXrG7LsAVStcumFLKH/rwzpYGdICGZH1vrvEun79CR9s56jj9g/xEF6vCEn9
         gZGtJ1U0Y9xxorMjsSNofBbunEkWEP5/Oo4FrDkK3H4Uw7SnYHkHA3+fR51vnWD5HHyE
         4U9i4R36PCXqLM33+gO1Wrv5jeRbZ6XMNj5ju0HoRAak13CQ8rAkmjXvU2vLEWupSQNe
         +kPyrmxUStupg2vKI33CSMBcXV8GEoL1dgC650KNlH2FrtXERLQv08g1glxRf4OTG/8+
         psBQ==
X-Forwarded-Encrypted: i=1; AHgh+RrOyD4fRVQDiSFhxUn4M8Ce94FV/1NYn9WJr7pYCcMtOIc4CX7s2Wccb9xOAiXPhSmfoKmBS+WT@vger.kernel.org
X-Gm-Message-State: AOJu0Yx0HqyZkxoE286qB4RQvQfIZU1X2Hk3QWcCxx9YerDO8X69/GV1
	fvonEMhXRz6oljhIMNan2mWOiMl5OagwzWICE7MWHBXqiJJwyDDTFYmLEjhR6T32R+c=
X-Gm-Gg: AfdE7cmFWNOtWVvGVlBQf8O6mjtg0g8QFSM/WyJJMyQvVeZEByU7AGnowWEtCXoNi5y
	jVJpa42BXf9lt3cEubvzwH6bv7EPXhLfHAKbW4Tu8PFjV7aWU+e1PAHdy0lr+t5lbj0onim5svi
	5shP07B+mkieLKjqk3rQetiam2FmKUscxs2tli7etEyuE7kDjFMLU818Zv1+Y9BRtssppADp5pL
	pdlxgiWEb9JGBVKjiy6Y351laAEAKTrA5FHl6hGjfmwp3FwpNXPJaJgD/AAPrg84Onbp3MWSaxB
	5vkbt32O0plYUxdImY6tUZVdbgxH7I/2yRFyqr+1LWRmJqiKQBC0aiMzH/XuP4KcJIcubC280PT
	CaNL0Zh78CdYVvxKBssWKUTJssCnj/1kd06rC9r8+qjSB1/pFRyio9i/DSiKlk1YboL1WCrMIQP
	smQsa25KMro73cVs5TmT43HQgmE3k0Ispji5XZ5UoIOY9oEMbY/N/YrI0e2nFwAUN9auZd
X-Received: by 2002:ac8:5845:0:b0:51c:7b12:600a with SMTP id d75a77b69052e-5213e881e44mr171868611cf.86.1784657787636;
        Tue, 21 Jul 2026 11:16:27 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-527d066fa6asm463921cf.6.2026.07.21.11.16.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 11:16:27 -0700 (PDT)
Date: Tue, 21 Jul 2026 14:16:21 -0400
From: Gregory Price <gourry@gourry.net>
To: Balbir Singh <balbirs@nvidia.com>
Cc: linux-mm@kvack.org, Zhigang.Luo@amd.com, arun.george@samsung.com, 
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
	kernel-team@meta.com
Subject: Re: [PATCH v5 00/36] Private Memory NUMA Nodes
Message-ID: <al-2D_7NcwMxqmsM@gourry-fedora-PF4VCD3F>
References: <20260720193431.3841992-1-gourry@gourry.net>
 <6a7aaac3-e70d-4063-9c84-e643db1488e0@nvidia.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6a7aaac3-e70d-4063-9c84-e643db1488e0@nvidia.com>

On Tue, Jul 21, 2026 at 01:46:01PM +1000, Balbir Singh wrote:
> On 7/21/26 5:33 AM, Gregory Price wrote:
> > 
> > Patch Layout
> > ============
> > The series is broken into two sections:
> > 
> > 1) N_MEMORY_PRIVATE Introduction.
> >    Introduce the node state.
> >    Opt those nodes out of mm/ services.
> > 
> > 2) NODE_PRIVATE_CAP_* features
> >    A set of mm/ service opt-in flags that augment private
> >    nodes to make them more useful (i.e. reclaim = overcommit).
> > 
> >    NODE_PRIVATE_CAP_LTPIN for private node folio pinning
> >    NODE_PRIVATE_CAP_NUMA_BALANCING for private-node NUMA balancing
> >    NODE_PRIVATE_CAP_DEMOTION for private-node tiering demotion
> >    NODE_PRIVATE_CAP_HOTUNPLUG for opted-in private nodes
> >    NODE_PRIVATE_CAP_USER_NUMA for userland numa controls
> >    NODE_PRIVATE_CAP_RECLAIM for opted-in private node reclaim
> > 
> 
> Looks reasonable, I wonder why USER_NUMA/HOTUNPUG is an opt-in?
> 

Ideologically: Private nodes default to fully isolated, why should any
given feature be special?

Concretely: 

User-numa

   Some devices don't want the user to have control over placement.
   I have been working on compressed memory, for example, which only
   ever wants to be used as a reclaim-demotion target.
   
   (The reasoning for this is another thread, i plan on publishing
    my research on this this year)

Hot-unplug:

   Some devices can't necessarily handle unexpected migration, and
   hot-unplug is fundamentally a migration.  So the HOTUNPLUG cap
   actually means "hot-unplug can execute migrations".

   If the entire device has pre-drained the memory (all memory is free)
   then unplug works - it's just not very hot (no migrations) :]

   Maybe a naming issue?

~Gregory

