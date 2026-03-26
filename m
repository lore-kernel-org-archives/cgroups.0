Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA8C325716
	for <cgroups@vger.kernel.org>; Thu, 26 Mar 2026 14:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.147.51.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774533900; cv=none; b=IW28HBURS6o2risUIuQt5/8fIWJTCf546/4seV649Qt/9lkCVwtRVDS0yNaCHjGSNMFrLbY90CsQygeknukH6pPojOPWAAj5EtYSPJnkL1F+WIgRv9Ej/PJ7hVYwOyIpZJyPm2GFOeCuzPKucVWiLrQ4MHFBfpj24zV78UZqGn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774533900; c=relaxed/simple;
	bh=52OLmTbVYKGyzAV0NA+076bhmIAgFOm/FYWAMDS5P34=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fGlcnw0rPawusWda2V+TXFJskIZS1kMKmm2xfRQHO5dq+bX+W3YbjWOXO9yQuZwxitVMnucv2IbQw0sdCNWDFsDta7IM75s33/Tpi4L2ixO6jx4pnyeUZSwMW0fyZ7Gp5NzR7Q8OvJJKFEAA2AvqHNzOwpYRfovBabi+ev03Gik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com; spf=pass smtp.mailfrom=lge.com; arc=none smtp.client-ip=156.147.51.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 26 Mar 2026 23:04:54 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Thu, 26 Mar 2026 23:04:54 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Li <chrisl@kernel.org>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, baohua@kernel.org, gunho.lee@lge.com,
	taejoon.song@lge.com, hyungjun.cho@lge.com, mkoutny@suse.com
Subject: Re: [PATCH v5 0/4] mm/swap, memcg: Introduce swap tiers for cgroup
 based swap control
Message-ID: <acU9BjGRgGDRWQ4X@yjaykim-PowerEdge-T330>
References: <20260325175453.2523280-1-youngjun.park@lge.com>
 <20260325162003.136dc86796eb124d3c7210ac@linux-foundation.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325162003.136dc86796eb124d3c7210ac@linux-foundation.org>

On Wed, Mar 25, 2026 at 04:20:03PM -0700, Andrew Morton wrote:
> On Thu, 26 Mar 2026 02:54:49 +0900 Youngjun Park <youngjun.park@lge.com> wrote:
> 
> > This is v5 of the "Swap Tiers" series.
> 
> Thanks.  I'd prefer to hold off until the next cycle, please.  As I
> mentioned in 
> 
> https://lkml.kernel.org/r/20260323202941.08ddf2b0411501cae801ab4c@linux-foundation.org
> 
> Also, AI review had a lot to say, Please take a look.  Should you do
> so, I'm interested in learning how much of that material was useful. 
> Thanks.
> 
> https://sashiko.dev/#/patchset/20260325175453.2523280-1-youngjun.park%40lge.com

Hi Andrew, Understood. 
I'll address the AI review comments and run syzbot CI, 
then resubmit for the next cycle.

Thanks,
Youngjun Park
