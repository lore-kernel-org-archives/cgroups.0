Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11E9C1F76B5
	for <cgroups@vger.kernel.org>; Thu, 24 Oct 2024 16:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.185
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729788629; cv=none; b=BodBWK4udMgsIgxVjTfaUWRNyKO3NTtmTat3RB35FvfD/ZgsYpfLfOTLF2V7Jxi+mIgyKo+Shv2w5I3NJVmjKBq85ntJqTNV9O+mGMW/JI2Oce2rgasTmwuczX7ghCK4+pzvZuQfaKO5H9NPc19da+IpB3GQRgNXqMpjV+gx+mE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729788629; c=relaxed/simple;
	bh=lH2c5MTCgmWU7Jab8kbmWSKpcuAt3EU2GOozVCLvH4E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oOjPgupAW312sjw0lkZLmX0v51vcesZcxl4OeoMx1IHJkFqzmSY+IhiUX9XCjeKBDYwFflOSMm+O/hfmJRiLQpuV0tEJ8yOUOncWhxPTzUt3frMHgdvmmbPN6G1Z1ECpx6tg12SJwk9WZsh1Q1R68200EqSvrdzv6nQEfpvk6OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=G9yUDjJA; arc=none smtp.client-ip=91.218.175.185
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="G9yUDjJA"
Date: Thu, 24 Oct 2024 16:50:18 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1729788624;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=OeZM9yMBCK67FT6NRmlAdBpBCb9n0TPy/A/c+hpymoM=;
	b=G9yUDjJAJ8HdV/aWA9F/WhsvdPGxPrCuR8aWHa2T0p3qyBGYm6ltG1MnfOxaxhumE+y2wW
	s3Lha+FFSxPVsRn0FAj5COupNrHSq6ba4sFMvYHGEqtJ2cVEE5z/QhQ5f0ayrShcOiXmIk
	c6105932qGB2kYgeErcgtb0cTclNoAs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-doc@vger.kernel.org,
	Meta kernel team <kernel-team@meta.com>
Subject: Re: [RFC PATCH 2/3] memcg-v1: remove charge move code
Message-ID: <Zxp6yv8ayAk30avF@google.com>
References: <20241024065712.1274481-1-shakeel.butt@linux.dev>
 <20241024065712.1274481-3-shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241024065712.1274481-3-shakeel.butt@linux.dev>
X-Migadu-Flow: FLOW_OUT

On Wed, Oct 23, 2024 at 11:57:11PM -0700, Shakeel Butt wrote:
> The memcg-v1 charge move feature has been deprecated completely and
> let's remove the relevant code as well.
> 
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
