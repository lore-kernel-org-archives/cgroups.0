Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 389353BE17C
	for <cgroups@vger.kernel.org>; Tue, 16 Jun 2026 11:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781610313; cv=none; b=HZQaI4y4+Q1IIfpb+zcvXaDkN+fUkS0rd7ENuMhkSOkUludcZXcG9AUjcRyca+oH8VjD4r3p/ss7BOQ7PZJdKLRzqy/fDj1BXDnaP6RQMA0H8WNorcc0OCehlYvsFuZ8en5aIjec1LxNRAg2lKijxQWobbA7kRhPknyr6Ue3zro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781610313; c=relaxed/simple;
	bh=XW/W70UCJPXlo6BQSu3fiF2BX0RKImaQD7G1BvfPpF8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CRKbglwHtgMY6RsfmuyivW0xtEWQkNPqt0HUFgO57gh8pl04pWVdnFsy7+Yh5FAjEoZGjY/rhonKLhxb36LCFbtu7FtxS57fdvBgT6waKEknhMsqIEx+XuoXyVNimgIaHdcbSZmWXvwvgHYrzbjCFfz7BRl3mRhFgNfGOc6lK3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=n6JMByQm; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="n6JMByQm"
Date: Tue, 16 Jun 2026 04:44:53 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781610299;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NzBAgympJtYUEU+5A/fuaOCbTXFBDK/+39XU8Cb2Gw0=;
	b=n6JMByQmgnXBs9uYwcuDjqLOej3/SSY5IJg6+zETivRa94jrYvges1yy88DGQpfnU1wfTC
	JtgEGCDMOXGGdJ2z6k+EbIOVRclJsdyL6GJduFnKXhLtBKGlu/g57kP39Qc+frioDcNjsK
	/b0ZHxnp2a5BUzcROVXUjY28bc3A0SU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: YoungJun Park <youngjun.park@lge.com>
Cc: Yosry Ahmed <yosry@kernel.org>, Hao Jia <jiahao.kernel@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, mhocko@kernel.org, tj@kernel.org, mkoutny@suse.com, 
	roman.gushchin@linux.dev, Nhat Pham <nphamcs@gmail.com>, akpm@linux-foundation.org, 
	chengming.zhou@linux.dev, muchun.song@linux.dev, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Hao Jia <jiahao1@lixiang.com>, chrisl@kernel.org, kasong@tencent.com, baoquan.he@linux.dev, 
	joshua.hahnjy@gmail.com
Subject: Re: [swap tier discussion] Re: [PATCH v3 2/4] mm/zswap: Implement
 proactive writeback
Message-ID: <ajE2zScfb2yznbGf@linux.dev>
References: <aictKA0XWMWbxFdN@linux.dev>
 <CAO9r8zPvCaCqvoUhPdAN5Oi_Sj0mK-t7DJhOOz3Xf1DT-Wrgcw@mail.gmail.com>
 <aieUQUBHI+E3uNPW@yjaykim-PowerEdge-T330>
 <airzE7jD9UtyR17J@google.com>
 <aisEWnb3pzmVC4dl@linux.dev>
 <aiu06fbV7rWqY0Bm@yjaykim-PowerEdge-T330>
 <aiw2p5ANjsQUCIHA@linux.dev>
 <ai5y923elCSZp41j@yjaykim-PowerEdge-T330>
 <CAO9r8zOVqbJEaBqTHw=r2bYw7Lm1tO0TU9QuG+eH1rfqcTAJJQ@mail.gmail.com>
 <ajCgzNIPLhjTRSXR@yjaykim-PowerEdge-T330>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ajCgzNIPLhjTRSXR@yjaykim-PowerEdge-T330>
X-Migadu-Flow: FLOW_OUT

On Tue, Jun 16, 2026 at 10:03:08AM +0900, YoungJun Park wrote:
> On Mon, Jun 15, 2026 at 12:55:09PM -0700, Yosry Ahmed wrote:
> > > In that case, the internal logic could stay roughly the same rather
> > > than counting via a page counter. Something like:
> > >
> > > 1. Change the interface shell: tier.*.max — allow only 0 ~ max.
> > 
> > What about a single interface as I suggested to remain consistent with
> > memory tiering?
> 
> Hello Yosry!
> 
> I agree. As I was implementing the interface for seeing feasibility
> , I reconsidered it. Since swap tiers can be added or removed at runtime, 
> having static memory."tier_name".max files seems unnatural.
> 
> A single interface like `swap.tiers.max` would be better. We can use a
> flat-keyed format (similar to io.weight. same as you suggested)
> 
> echo ["tier_name"] ["0 or max"] > swap.tiers.max
> 
> I am now leaning towards this is a better direction than what I initially
> suggested (memory.swap.tiers and memory.swap.tiers.effective).
> 
> Considering other reviews and Shakeel's reply, I will update my swap tier
> patch accordingly.

I like Yosry's proposal. Let's go with that.

(I am travelling, so will be slow to respond)
