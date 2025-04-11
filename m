Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E37CA1A841A
	for <cgroups@vger.kernel.org>; Fri, 11 Apr 2025 00:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744329624; cv=none; b=h1rdcZCWHzQJKTBUDGCVdLIbqkbwqkTDnti3BKvidni7VPtApK7WgYNYcKl42veSMZGOXZby6lDWYdooFspXnjEJPxZxfLA4/vl/yhEBL5vvyjlmvBo8biMSdheZPVoe+6uXKAp7s7H6HLFn037jgTv3diLV65pMhtQcOzsvVOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744329624; c=relaxed/simple;
	bh=6sWCEwfn1sFr1IFbEijwYkuh53sbb6VptPWgsOJyegI=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Eo8vmvyr/K1Tlk2OVp2dRqTkvKpqJTqblGXZj2+tP41Tpp0yvs/HfYcyZmEYJma/bDL2+/4CV/v8if79abEK6VlMY5GSgmo1FyWIvk3QO5YxIF96CQOXjnAKdEMVHdMy+W/nbAdoyjscQWkFzR/e7q56BHzauZwqZKJNTJbRZdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cc3gI6SW; arc=none smtp.client-ip=95.215.58.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cc3gI6SW"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1744329621;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=6sWCEwfn1sFr1IFbEijwYkuh53sbb6VptPWgsOJyegI=;
	b=cc3gI6SWNxqIlRHMfU9oR1gCq3DQMclPD/cDnfL6YU5rubUDPvq69lcgct8IMymJW4gu1W
	3DOJQdehp9lhfOr80Ul3R8ON1naeuk/W+eSIDRGJP6Jp5QJ5uYKpOHPD3lszWXwA6u/odY
	4xFF7keOj3XPWdGCrYo6e/qcEQJcf/E=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,  Johannes Weiner
 <hannes@cmpxchg.org>,  Michal Hocko <mhocko@kernel.org>,  Muchun Song
 <muchun.song@linux.dev>,  Yosry Ahmed <yosry.ahmed@linux.dev>,  Waiman
 Long <llong@redhat.com>,  Vlastimil Babka <vbabka@suse.cz>,
  linux-mm@kvack.org,  cgroups@vger.kernel.org,
  linux-kernel@vger.kernel.org,  Meta kernel team <kernel-team@meta.com>
Subject: Re: [PATCH] memcg: decouple memcg_hotplug_cpu_dead from stock_lock
In-Reply-To: <20250410210623.1016767-1-shakeel.butt@linux.dev> (Shakeel Butt's
	message of "Thu, 10 Apr 2025 14:06:23 -0700")
References: <20250410210623.1016767-1-shakeel.butt@linux.dev>
Date: Fri, 11 Apr 2025 00:00:15 +0000
Message-ID: <7ia41ptz1sa8.fsf@castle.c.googlers.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT

Shakeel Butt <shakeel.butt@linux.dev> writes:

> The function memcg_hotplug_cpu_dead works on the stock of a remote dead
> CPU and drain_obj_stock works on the given stock instead of local stock,
> so there is no need to take local stock_lock anymore.
>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Acked-by: Roman Gushchin <roman.gushchin@linux.dev>

Thanks!
