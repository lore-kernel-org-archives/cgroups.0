Received: from mta1.migadu.com (out-107.mta1.migadu.com [95.215.58.107])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98D2354763
	for <cgroups@vger.kernel.org>; Sun, 30 Aug 2026 00:53:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.107
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788051209; cv=none; b=TEMdU+sVrlCUYidNlc0F5ZGKKpo7qIf4Pi/yLsIknVlGGgC1RWkbedDm5X5+m9Nl1+N4pWf+eCxJL2V4Yy2ZvJy7Q8629jHX3nxpLY+e4bLBTe/ttCJSzv2ZX8gZ0iGIDx95Tpvg6EHEfUY0eO7cqBcGvV74NNghWdzZCxMxev8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788051209; c=relaxed/simple;
	bh=fszXetNW+2890fJc/nTMASrc22mNEoZ8RTNdl5L3LRo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=azXgmGxO4j2uoDLxu1stFSJld97Tuxuy9jY6EV6JFyZYWdmzmq0Q2JGdg9Nd914TJf2wGCra+dAeJwaYrxuyUicmH9ro+G5DXUHODNv/rBZUtojABV4utLdwgqQmPs3/k8ZBlvMjb9eUw2Shl/ZiLcF5Gyg8tzL/Y85HRfTGpHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Gn1MZAVE; arc=none smtp.client-ip=95.215.58.107
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Gn1MZAVE"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=fszXetNW+2890fJc/nTMASrc22mNEoZ8RTNdl5L3LRo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788051205; v=1; x=1788656005;
 b=Gn1MZAVEFDsEiZmnB/XwDduREr+NWTNJ0Da9MP88K4q3StgmO/LiYUjjheFq/fU1YWBeBwyS
 /9qmm3feoxocvd/M87c2yItvkn3O/s4MjqpNYDYiFVMU+qots2yC2dEc/F8z2lpaLZz+6q5NYlk
 yjYqQLsc9PZ+0RY8IxRrzBWo=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 176b837cecade791;
	Sun, 30 Aug 2026 00:53:15 +0000
X-Mizu-Trace-ID: 176b837cecade791
X-Migadu-Flow: FLOW_OUT
Date: Sat, 29 Aug 2026 17:53:14 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>, Tao Cui <cui.tao@linux.dev>, 
	linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	hannes@cmpxchg.org, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	Tao Cui <cuitao@kylinos.cn>
Subject: Re: [PATCH] mm: page_counter: reject empty string in
 page_counter_memparse()
Message-ID: <apN-zc_5SIEkdzB6@linux.dev>
References: <20260817042652.74136-1-cui.tao@linux.dev>
 <aoMzchLCCz5hiFHp@linux.dev>
 <aoQNtIRvqXRh-x4u@tiehlicka>
 <aoRz72_zdMai_RNV@linux.dev>
 <aoSLxSBUPbEqimJq@tiehlicka>
 <9bd74181-2ce4-4d69-a353-614685559ceb@linux.dev>
 <aoVUlFdZYLFn_gvJ@tiehlicka>
 <20260829174220.204771edba7c52511dc08641@linux-foundation.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260829174220.204771edba7c52511dc08641@linux-foundation.org>

On Sat, Aug 29, 2026 at 05:42:20PM -0700, Andrew Morton wrote:
> On Wed, 19 Aug 2026 09:00:36 +0200 Michal Hocko <mhocko@suse.com> wrote:
> 
> > > Whether that benefit outweighs the compatibility risk is not mine to
> > > decide.
> > 
> > And I am still not convinced. I do understand your frustration from the
> > debugging the issue. In any way, if other maintainers decide this change
> > is worth I will not stand in the way.
> 
> Shakeel seems OK with it.  Other other maintainers are being aloof ;)
> 
> I'll queue it for now, along with a note that additional poking is
> needed.
> 
> A v2 would be nice, please.  Add details about that production incident
> and make the requested update to
> Documentation/admin-guide/cgroup-v2.rst.

V2 is already out and we decided to make it a documented behavior.

https://lore.kernel.org/20260826021753.197871-1-cui.tao@linux.dev
