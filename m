Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19BC83C661D;
	Wed, 27 May 2026 20:36:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779914216; cv=none; b=rRog9XPNCJOg9pPhBPVwO5SLfd4G/Z265n7mXAZtZm91cnkLLV6ArDGlushwgyxSb1s3N7uY+zR+nLbzwQdRpNU9BrUtvyjlUxtvUyJ6ycC/00xrtjASXnKX5E9AfKMyNXqQe4mlwq+ogCul8oWh6DGTOvmGah9fYUg0AfrQbSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779914216; c=relaxed/simple;
	bh=ivUTafxW7EUYHVzuAj524XGfbtSrkHr+Zd+VSWRd/Zc=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=KwwF1IEvRSbHjV6d1us4fjBtV88a0Ef0D8hy6noKuoAoqp3AY8P00KFc8EJHavkf6mGwoaCVxIbjbfQBLcJPMWCs+r5RJNhPpG8dSglyLzFuluoadkiKvG1aJij3lVYwwdd6+tqSvzZIYsHt6hIOnJB5srRElWUqpzXROc/v1pU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=uO0kMIEC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="uO0kMIEC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F41091F000E9;
	Wed, 27 May 2026 20:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779914212;
	bh=zoqeZwG3y/DBbZTflYJmnprqIV3duVrLDa/AW8PkbO8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=uO0kMIECI+ZA9S927s3ybqIf4C88FRCgd72kPKcPaZoajjn9zvOEn3ySaNm+LtO6q
	 fvAQQYcklDxHuiAL+BcXbr8jVHUg3oZz8TJJL4p9sRE0SVVRjoWB+jXBaPSILloafl
	 WpntFOChULwcpyxhpmx18DOfzp5atrrnU3pruI3E=
Date: Wed, 27 May 2026 13:36:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Youngjun Park <youngjun.park@lge.com>
Cc: chrisl@kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, kasong@tencent.com, hannes@cmpxchg.org,
 mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
 muchun.song@linux.dev, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 baoquan.he@linux.dev, baohua@kernel.org, gunho.lee@lge.com,
 taejoon.song@lge.com, hyungjun.cho@lge.com, mkoutny@suse.com,
 baver.bae@lge.com, matia.kim@lge.com
Subject: Re: [PATCH v7 0/4] mm: swap: introduce swap tier infrastructure
Message-Id: <20260527133651.2ce806fa542a82eca5ff66d6@linux-foundation.org>
In-Reply-To: <20260527062247.3440692-1-youngjun.park@lge.com>
References: <20260527062247.3440692-1-youngjun.park@lge.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 27 May 2026 15:22:43 +0900 Youngjun Park <youngjun.park@lge.com> wrote:

> This is v7 of the swap tier series addressing review feedback.
> The cover letter has been simplified.

One question from Sashiko.   Minor, but easy to address.
	https://sashiko.dev/#/patchset/20260527062247.3440692-1-youngjun.park@lge.com

I'm reluctant to add a new feature patchset at this time - we have a lot
already and we're at -rc5.   What do others think?
