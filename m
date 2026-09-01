Received: from mta1.migadu.com (out-64.mta1.migadu.com [95.215.58.64])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2877023BD1D
	for <cgroups@vger.kernel.org>; Tue,  1 Sep 2026 00:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.64
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788221444; cv=none; b=mkY5AwNhvs+gkBA9lxzQG69306TxNaqb6edcuGosOKMpPCgOFdFh5M7REnoN84ZVHBYijBZHs83US5qTDpd/q6v+Fn4ijYrjrGZ7hqpzoex1J4ZwpumxIwBmW7oPDHmfXttmc11FlHFlIx6IB6ZwHv+YE5VOajpYVKk8hwrv6PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788221444; c=relaxed/simple;
	bh=VQbX7qhToOCvYZznvKl5y3u5IYIy1k7DJaMvEMrWF3o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q0apbHt56XyPg+jDrYIsnPCuHTAgUx3Gnutb8HfVLdDlHBRyqYKPnHGWpvarxCX9ogNN3weNnbsfb8VdDIbxpA+OpxUqtw34prL5pU8U4SZTRWHUgI7cbN432V4mdqv0aH7ieU8iVIQDA5/BjItrAaHUgi2pY0+CbOtgPteRewg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=SKJJ3Wb1; arc=none smtp.client-ip=95.215.58.64
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="SKJJ3Wb1"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=VQbX7qhToOCvYZznvKl5y3u5IYIy1k7DJaMvEMrWF3o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788221439; v=1; x=1788826239;
 b=SKJJ3Wb1HujSZQSBqPuzVTR/xJGO1tdDt880sMmlpXUZEantBEzeHhnlcfOtSxPZwbKHcCFN
 uZ2j4wQjhFYmtuxLnMhjv2WCJvMDFh6S2XD6L1HLzmhGmZAyk3qhO+wlAZyMHWgqPD15xuKmXVM
 UuV2JXP0GvzSLw3esOCf5mtI=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 69816a8805fc6742;
	Tue, 01 Sep 2026 00:10:29 +0000
X-Mizu-Trace-ID: 69816a8805fc6742
X-Migadu-Flow: FLOW_OUT
Date: Mon, 31 Aug 2026 17:10:24 -0700
From: Shakeel Butt <shakeel.butt@linux.dev>
To: David Stevens <stevensd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: Don't call schedule_work when no spinning is
 allowed
Message-ID: <apYXCL_GJs9Ovu0v@linux.dev>
References: <20260831234339.280376-1-stevensd@google.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831234339.280376-1-stevensd@google.com>

On Mon, Aug 31, 2026 at 04:43:39PM -0700, David Stevens wrote:
> Memcg charging can be done from any context, but calling schedule_work()
> isn't safe from an NMI. If memory.high is breached from a context where
> spinning isn't allowed, use irq_work to schedule the reclaim work.
> 
> Fixes: 3ac4638a734a ("memcg: make memcg_rstat_updated nmi safe")
> Signed-off-by: David Stevens <stevensd@google.com>

Did you hit this issue or just code inspection? I assume this is the
done_restock code path.

> ---
>  include/linux/memcontrol.h |  1 +
>  mm/memcontrol.c            | 12 +++++++++++-
>  2 files changed, 12 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 8170bb8066a2..036d973ceca6 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -219,6 +219,7 @@ struct mem_cgroup {
>  	spinlock_t	 peaks_lock;
>  
>  	/* Range enforcement for interrupt charges */
> +	struct irq_work high_irq_work;

Instead of adding more complexity, let's just return if we can not spin on
done_restock path.

