Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E5673909BB
	for <cgroups@vger.kernel.org>; Mon,  2 Mar 2026 21:46:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772487962; cv=none; b=YgPswczhpm6tXbaN5ga7CahPw6N/qrCcSFdmpPzF4KECHk+mPhKoHN9tn0x8V3HOAZf+Hak8DK+hGusORTO6hiyXn1V0IAfchPcmLa7yize4aoG6xETQ47Cy5GycZB5j42ot2deEUxtApcMNELllP8AaVmTXAOle9S2Xli7AfL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772487962; c=relaxed/simple;
	bh=wXHhn6ZoS8JUSONF3HYovEzRkxi/E3tYjri2t88owms=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n8bSNpuyjSp5QTM07WHkcmff3Put0GM+8j1fwCZo6omPP+MZ+ohJwTM9QXnw0bdso8b6BtLzq1N2EZgIirkoIw3opDfRs/8n/AnFgHxhLHV6ZTn9OCRpkmxogDK05jTwiRZ6U+RuTXXXKV21zLcvc/R+Bo7YDsDCu7ZVgJzK6HA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=fABwRMva; arc=none smtp.client-ip=95.215.58.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="fABwRMva"
Date: Mon, 2 Mar 2026 13:45:51 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772487959;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=eWrrIMuFzFwLJQr7vT24Bua4IinIlHw+xQt+HPa/8Pg=;
	b=fABwRMvajmtIARyCH1jW/c9bR3kNPE3aPVy/raO7xPGcGSGwHN/6h39tTeSmVlfJaradFH
	yJxESNa/1T6vGn34+9Uu3SarzkEMqOkc5m7apPDHsOA5VuF5+Xg1axf8wozZaaHAuMt0To
	S13crEIR2Rk0dLAdTPfaMxJhSJz6a9s=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] mm: memcontrol: split out __obj_cgroup_charge()
Message-ID: <aaYE9EaBvz3monjr@linux.dev>
References: <20260302195305.620713-1-hannes@cmpxchg.org>
 <20260302195305.620713-4-hannes@cmpxchg.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302195305.620713-4-hannes@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT

On Mon, Mar 02, 2026 at 02:50:16PM -0500, Johannes Weiner wrote:
> Move the page charge and remainder calculation into its own
> function. It will make the slab stat refactor easier to follow.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
