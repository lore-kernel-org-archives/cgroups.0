Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1222FB97D
	for <cgroups@vger.kernel.org>; Mon, 20 Jul 2026 19:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784577527; cv=none; b=c5tb8l5rDTmBV7L5E7Bw7t/2kRLPA9eAiY/v66zIbjgM5RwfyKckv9F0WYwVsJaEwHU6qYU9cn32ARQxZxIcXGIZrfl40uy1H/I2kE71jQlEUoDEAl6t+g+Szt7+viwqyTItT/mZ+/qRCr6skr7fPYva/TPE3fn9CW1Tl9K3ENs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784577527; c=relaxed/simple;
	bh=3vaHX55eRnwF9/hLAZDG/1AlGi77ds9PDEh9RAs84vA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BrD+6NLv9gBHVhXeXJKe4JOBNCi06p5zRz+2AuYl6CBSINmrmYZ599z+K2RTI3hM8bpsbjUSl5GuWbCoz4alZp+exfT82cV3dGe06vbzH1XvXjtf1+gAppfiT8EqdRKYyBbpLLef4vPcJCA31L2LGN3eV8pTybddZUfcPqCN90E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com; spf=none smtp.mailfrom=osandov.com; dkim=pass (2048-bit key) header.d=osandov-com.20251104.gappssmtp.com header.i=@osandov-com.20251104.gappssmtp.com header.b=BM4cTztP; arc=none smtp.client-ip=209.85.214.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=osandov.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=osandov.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=osandov-com.20251104.gappssmtp.com header.i=@osandov-com.20251104.gappssmtp.com header.b="BM4cTztP"
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2cc7a269ca1so23833935ad.3
        for <cgroups@vger.kernel.org>; Mon, 20 Jul 2026 12:58:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20251104.gappssmtp.com; s=20251104; t=1784577525; x=1785182325; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HcwVCKMCsgSSFOSFUSeqAhsycxUaPnb4s9hCiCZnUoQ=;
        b=BM4cTztPMJJD0uY+NMQ9ELzMqGkiCh6qicngOVR2KhUSfYH9FRqes86stK9v7OHDT3
         hoX3DjJaqdsToWyh4UUzsCDzwDUH162xijujAr4RtTimNrjHXAHs8WZ47Yehx0JdWsoH
         ihg9aM0DSZJktXNmeoYevgDWzBssSbnuKLRHh2sHX0cwldP+dP2dizMWVkj5xGrZcb6g
         acvIiyAZst4J17qM9pcp+C70AjjOXq4FF6siqTeP3XFLlUhT2VglOMAuvvlxti9yVmCL
         Z5vfiuE+zgq8a+0jwef7L3rZvk9xxWG37SVLxSfiJfDbBhI+tC7FBtqX2aFhGChsREWB
         X+bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784577525; x=1785182325;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HcwVCKMCsgSSFOSFUSeqAhsycxUaPnb4s9hCiCZnUoQ=;
        b=JAK1FhcdjCg2XWDsebVPA0CyBtJvS7SMiiF4xl2A8/dJUgffnlYuFxiYvmT1KjLGqB
         Jo5SWZIAgkn7TQj6Pj3EtqxCGT9BPdLcSpYZtNISjim5f0qEjcJOsABXDYn0bbimPHYn
         dV9G6PJ8prenb5f25DqZ3kMEOCU/yKWUMqxVIzpZIf+crG9jHvIYBrfm/2afi/YaR1Dx
         vp7gaUUdNRGx9Q6WtGFeFGa+NjQFxr6imSEIbYliPaQWVsFkrg6nqTx3e0QFGhtIXeWu
         vHgVVoqMQ77ttksvfGXbF1zp7QouGfCsRl2LtdNhMEDiYBzU/M63OFSCAN+ZtWKyUOj3
         RQlQ==
X-Forwarded-Encrypted: i=1; AHgh+RorAOAXftN6q77m1YG/DesBMzC9ZnXtc/CZWy1DIUj8zw2YFAc8bF5UIny3hS0SRnnfEM2Z0h99@vger.kernel.org
X-Gm-Message-State: AOJu0Ywo+uWrhgLUSawRnjY612IbitRx/Nsog4FvIR3Q1M7Ieg2Au19F
	Vywcn8GlmB3qOSGV3GVkxhOMU8LDmZe2N8t0BjPPm4zUtomEpcxqw6lGPsB5/l/6h24=
X-Gm-Gg: AR+sD13RLYXHSl/N3Pz4NWpFl67AaMifojlAO9NAgLbt29CZQWPjqKWJYpgx/UhSLE2
	c+Hjg6M+zzm6DhXH3X4ZXXvwkb7vGFH5+VOWPA7ZvcPf+531XvU8l6A4n+jEnWlCvD3doQz/e1x
	a1YpDBeENOApk5rwnqnaru79VQriFULR5cJB1WBwHDfAN0yweMy8cusm32Vnmb65ZuGvOddkppH
	mYg2oEMWZKknLS0OVpxKHYqLS1PlbEE8fLLxngfaSXGjOstgHohWftFzTmuWoFlVsbwhy8PEPAN
	bTb3sYoo1yf+pw4fGB6tac2cO2teXsEMZtZTDDQZHpHler+nvH6jqTn9EiQm2OQ1xnMQd9ZidFF
	v21kj8SjEvHKNASIfXWlOOlHAFxfNyH4t9LQE65zwMuZe6F1uWO72Wd197PQMawlXxxP88leb/C
	caKpLcMFqX21EBzzDN
X-Received: by 2002:a17:903:1905:b0:2c4:397:dd7a with SMTP id d9443c01a7336-2cf80472f4amr2950035ad.4.1784577525668;
        Mon, 20 Jul 2026 12:58:45 -0700 (PDT)
Received: from telecaster ([2620:10d:c090:500::5ee8])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3142a1e348bsm41134232eec.25.2026.07.20.12.58.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:58:44 -0700 (PDT)
Date: Mon, 20 Jul 2026 12:58:42 -0700
From: Omar Sandoval <osandov@osandov.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Ye Liu <liuye@kylinos.cn>, Hao Li <hao.li@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	Stephen Brennan <stephen.s.brennan@oracle.com>,
	SeongJae Park <sj@kernel.org>
Subject: Re: [PATCH RFC 05/12] mm/slab: abstract slabobj_ext.objcg access
Message-ID: <al598nIY_tliPubo@telecaster>
References: <20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org>
 <20260715-b4-objext_split-v1-5-9a49c4ccf4c3@kernel.org>
 <976e4d7b-24d6-4047-a405-e86c2feb45d3@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <976e4d7b-24d6-4047-a405-e86c2feb45d3@kernel.org>

On Fri, Jul 17, 2026 at 12:00:29PM +0200, Vlastimil Babka (SUSE) wrote:
> On 7/15/26 12:10, Vlastimil Babka (SUSE) wrote:
> > In preparation for changes to the structure, abstract access to the
> > objcg field with a slab_obj_ext_objcgp() function.
> > Rename the field to _objcg to make an unexpected direct access a compile
> > error.
> > 
> > No functional change intended.
> > 
> > Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> 
> Hm sashiko finds [1] that this is breaks tools/mm/show_page_info.py
> 
> But I think it was already buggy. get_memcg_info() is supposed to return
> memcg info for a page but in case of MEMCG_DATA_OBJEXTS there's no such info
> for the whole page, there is only for individual slab objects and it doesn't
> know which object so it effectively gets the first one. I think it should
> just stop handling MEMCG_DATA_OBJEXTS, but that's a fix that should be sent
> unrelated to this series.
> 
> There's also tools/cgroup/memcg_slabinfo.py and that I think has been
> already broken with memalloc profiling as it assuems slab.memcg_data is
> still a raw struct obj_cgroup * and not struct slabobj_ext.
> 
> I think it will be easier to fix it at once to handle the layout after this
> series than trying to fix it first to handle the pre-series layout and then
> update it with every relevant change.
> 
> [1]
> https://sashiko.dev/#/patchset/20260715-b4-objext_split-v1-0-9a49c4ccf4c3@kernel.org?part=5

FWIW, if these scripts were in the drgn repo with test cases, these
breakages would be caught by our CI and someone (usually me) would fix
them up promptly :)
