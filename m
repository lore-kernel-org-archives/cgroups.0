Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E6741DE885
	for <cgroups@vger.kernel.org>; Tue, 29 Oct 2024 05:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730179667; cv=none; b=VH5QjdaWpivASZq4XXPl0NfRTp1XhuYYUFJRNHz0YDj3dbGtEZnIsGhaPvVLCP2Mv3Opmpg4/Zr7++ntLYnfmnLkMDl7Rsbd+cecY/pCQ0SgoS15WCxKu0X4TiV9Qhic7rqEWwg6Y69Su+8jaF6FvBcQbfJk1hyKXmKAibo6sjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730179667; c=relaxed/simple;
	bh=4uQslaRJswLc9ylbj/XKC4tF+/W9TnMfgaNSGRWNHsE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bK2TeNqKh3F2c/QRDmpXFnTENTbMs/5lVHQzoqIcV9vYhRpLlxg7hsVVhhjpGcA2qURvLPAevOZf9rg3y9FcJuZLukTDQFcE1rEM+phRauLXSPZ+OgFl8EsfQ7HU2/cy0uzzY1sZQLo5l0XGvXPQYhmdtikNmzjvzutdjPFOkxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qmpL5MGr; arc=none smtp.client-ip=95.215.58.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qmpL5MGr"
Date: Mon, 28 Oct 2024 22:27:37 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1730179662;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=wKNZWyOR633H3Q9cqULJEaRjShUPrpvltT8e9LGW2oc=;
	b=qmpL5MGrnncuajqpLOwqNoW0d3uj8G5QVsM4JLpDOm+5PMnahM4ukPDdm2w1Eykd/gDU09
	BMgSDp+/ccM6UL4JvRoLK4AUivr4fjpcMKu/L2S6Z4ateumNrbA3WHmfpV33kcuVNGGHBx
	93NFeL3ArIwr1jEL1JSUtyTk6kcr7iE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: JP Kobryn <inwardvessel@gmail.com>
Cc: hannes@cmpxchg.org, yosryahmed@google.com, akpm@linux-foundation.org, 
	rostedt@goodmis.org, linux-mm@kvack.org, cgroups@vger.kernel.org
Subject: Re: [PATCH 2/2 v3] memcg: add flush tracepoint
Message-ID: <rdeztomb4omq4khjzmpeiqb5lggl4mqjqu3txop4zwzakp2vo3@4emyypk5hzuu>
References: <20241029021106.25587-1-inwardvessel@gmail.com>
 <20241029021106.25587-3-inwardvessel@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241029021106.25587-3-inwardvessel@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Mon, Oct 28, 2024 at 07:11:06PM GMT, JP Kobryn wrote:
> This tracepoint gives visibility on how often the flushing of memcg stats
> occurs and contains info on whether it was forced, skipped, and the value of
> stats updated. It can help with understanding how readers are affected by
> having to perform the flush, and the effectiveness of the flush by inspecting
> the number of stats updated. Paired with the recently added tracepoints for
> tracing rstat updates, it can also help show correlation where stats exceed
> thresholds frequently.
> 
> Signed-off-by: JP Kobryn <inwardvessel@gmail.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
