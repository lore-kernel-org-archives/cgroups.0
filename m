Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AF652FFF8F
	for <cgroups@vger.kernel.org>; Mon,  1 Jun 2026 04:00:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=156.147.51.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780286442; cv=none; b=dgHqkr0kYTW1eZCj5DPNRFoIOF6BC6Jd9+zlwmsHfnHQ//asMAS++XvGxNWTySwAWZCO6+6BqrcFOvlhnXsfr5EHAyYbcltaRb5dw7qnf5HD6NHlbr1Gt3pYHjyahMabIZNnxI47ojLqKo72UuEGmCwDzghvpRPunv5upDJtmAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780286442; c=relaxed/simple;
	bh=WgFZQ+wK8o1QcHeoNW8CCuvknLnlIeU3YIghVswuZlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PTavwfdqNienbPtrx4xmsRwfnabZiCmkfq7zgDrUHG3ZomstYlcdTxyE7gAhI8gjQTCxksD8bIqxPscyC0To6UkWvxS1CPzrL7Fkcx9HZLXtrXFDxKX4TzYh2InAdNmwCrqrmEbHGWMpofav3vPOh9FS87BXH2EJL1BgMn1SmDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com; spf=pass smtp.mailfrom=lge.com; arc=none smtp.client-ip=156.147.51.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lge.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 1 Jun 2026 13:00:32 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Mon, 1 Jun 2026 13:00:31 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: chrisl@kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, kasong@tencent.com,
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev,
	baohua@kernel.org, gunho.lee@lge.com, taejoon.song@lge.com,
	hyungjun.cho@lge.com, mkoutny@suse.com, baver.bae@lge.com,
	matia.kim@lge.com
Subject: Re: [PATCH v7 0/4] mm: swap: introduce swap tier infrastructure
Message-ID: <ah0D3x/586U9GKkL@yjaykim-PowerEdge-T330>
References: <20260527062247.3440692-1-youngjun.park@lge.com>
 <20260527133651.2ce806fa542a82eca5ff66d6@linux-foundation.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260527133651.2ce806fa542a82eca5ff66d6@linux-foundation.org>

On Wed, May 27, 2026 at 01:36:51PM -0700, Andrew Morton wrote:
> On Wed, 27 May 2026 15:22:43 +0900 Youngjun Park <youngjun.park@lge.com> wrote:
> 
> > This is v7 of the swap tier series addressing review feedback.
> > The cover letter has been simplified.
> 
> One question from Sashiko.   Minor, but easy to address.
> 	https://sashiko.dev/#/patchset/20260527062247.3440692-1-youngjun.park@lge.com

Thanks, Andrew. That is a valid concern and definitely needs to be fixed.
I will address it in the next version.

> I'm reluctant to add a new feature patchset at this time - we have a lot
> already and we're at -rc5.   What do others think?

I will wait to hear others' thoughts on this.

Thanks,
Youngjun Park
