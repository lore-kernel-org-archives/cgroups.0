Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 864294014B1
	for <cgroups@vger.kernel.org>; Mon,  2 Mar 2026 14:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772460955; cv=none; b=ff9ZdkaF0QxU8dtapz4vF3IFAZh+kKrF51fDfR3hALHnPg0M5Ql+3ssdV2EgVKOnWC96+3rYjubwXbB6sXIY+FHKw6nW55FPl9XdMsTwraPSmpuzyA53640jJSjUFUs72NHkYYHuErlsTu/4ISCytrLrlMBEk2mmHGyyjVSApJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772460955; c=relaxed/simple;
	bh=KIsFIDvd0JO4zb9rQ7koT4BxFd5V++oEZyikGV2lFsc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fOdZbHea6ONji48HQ+McugFd/s+JhOb09YEmOMHvj4lg2StyHeBBXiVJwzEQBpEPlikkd2WFxVtgxfdtMw6sVFfq4o8PKscuVpjq9hlHNzfdRx8hnet5BuykvQVDAJlR1zyXhP/3+iWH1nyl8y2SiFYKEpTy047H9njw0bpCXHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XB1pfTP5; arc=none smtp.client-ip=95.215.58.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XB1pfTP5"
Date: Mon, 2 Mar 2026 06:15:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772460952;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z/EVA7c5dM/CMIsC5H/wd0QWQksrsEBgYswy6gN4Re4=;
	b=XB1pfTP5+/ixFozi8gJbJackW08qw1bJDmRZcbeMcPTwK+lYX/rPcssduU7Prdja5dbtRP
	9NWUyq14HBut2Cm59kPT4u1eEB4Wy0xZ5XB2qE7wEdgY917rXr7vFOMS2qqiCSEnTV/djD
	Yb7eQhEYVbKmZmf74r1qrW969/xBeKQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>
Cc: Dave Airlie <airlied@gmail.com>, dri-devel@lists.freedesktop.org, 
	tj@kernel.org, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, Dave Chinner <david@fromorbit.com>, 
	Waiman Long <longman@redhat.com>, simona@ffwll.ch
Subject: Re: [PATCH 07/16] memcg: add support for GPU page counters. (v4)
Message-ID: <aaWZrTZGsxxjbBYv@linux.dev>
References: <20260224020854.791201-1-airlied@gmail.com>
 <20260224020854.791201-8-airlied@gmail.com>
 <ee914ffb-5c3d-4d41-abdb-5ed02db326c6@amd.com>
 <CAPM=9txUuS-qzA+gX2DvTuYR2OZ79RG86FuDA6czkpuJ_SR6KQ@mail.gmail.com>
 <4fddf319-50c4-40ab-9e36-04d629a8855e@amd.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4fddf319-50c4-40ab-9e36-04d629a8855e@amd.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Feb 25, 2026 at 10:09:55AM +0100, Christian König wrote:
> On 2/24/26 20:28, Dave Airlie wrote:
[...]
> 
> > This has been a pain in the ass for desktop for years, and I'd like to
> > fix it, the HPC use case if purely a driver for me doing the work.
> 
> Wait a second. How does accounting to cgroups help with that in any way?
> 
> The last time I looked into this problem the OOM killer worked based on the per task_struct stats which couldn't be influenced this way.
> 

It depends on the context of the oom-killer. If the oom-killer is triggered due
to memcg limits then only the processes in the scope of the memcg will be
targetted by the oom-killer. With the specific setting, the oom-killer can kill
all the processes in the target memcg.

However nowadays the userspace oom-killer is preferred over the kernel
oom-killer due to flexibility and configurability. Userspace oom-killers like
systmd-oomd, Android's LMKD or fb-oomd are being used in containerized
environments. Such oom-killers looks at memcg stats and hiding something
something from memcg i.e. not charging to memcg will hide such usage from these
oom-killers.
