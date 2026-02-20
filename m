Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C5F15687D
	for <cgroups@vger.kernel.org>; Fri, 20 Feb 2026 22:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.186
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771625775; cv=none; b=p5jftExQM6uU4tdZu1Zq8+TxhgrFsuIHi6jhAvsj1LcYI7KEN8y0ldwtXQLIk8j0u7BZ5NlNaFTqyHEu9tsgPa65rMvBOiNBmOtoypPhgPDFdMKw+S5KgObYtUf9uIbOzBl8T1f1EH/t1K+Hx/SBMqBz7c4/dy8ymLzBiNQblZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771625775; c=relaxed/simple;
	bh=PfOeiV9WOK8c5/by9GAg1W6HNo7ZArvYyx/QgFJrCbE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=L60GbtwIn3fC5tbkdYrKOykKQWJF6vDtXzuLqNVQzrXR4UqwlCtB4WXXXoDU6YvpQ6ylNTXWwTjKh3+hV7ghgl5xJN84EHDYdnfuUZdzM7vwv+OrNHcchrH53A79AbAbLZJpi5VqY+zLAlSYKfN1HO/4BFY2WvotyqFMzu8ZLTI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vViFFMUV; arc=none smtp.client-ip=95.215.58.186
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vViFFMUV"
Date: Fri, 20 Feb 2026 14:15:57 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771625761;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=oN9Hwb2fDdGaeGEROxnaLAHfHNiKuB50PSAzDDIdOn4=;
	b=vViFFMUVuOkaJ4qMiikS9Cp26Jq4iqN+qAgwNc1HT4UH05JIwJ6izCa70vjKe5e9a8B5Zf
	mmIWVE3entV0vscEA6V2Z8FpPLkKK5BwW1t9eDq5zpMU1kmAlva21vEMYXZ0E8VjjCE87c
	5qbt1YjED4y4hF5dW/yET5fssFrUge0=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Uladzislau Rezki <urezki@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Michal Hocko <mhocko@suse.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: memcontrol: switch to native NR_VMALLOC vmstat
 counter
Message-ID: <aZjdCfE1tww_WKwh@linux.dev>
References: <20260220191035.3703800-1-hannes@cmpxchg.org>
 <20260220191035.3703800-2-hannes@cmpxchg.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260220191035.3703800-2-hannes@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT

On Fri, Feb 20, 2026 at 02:10:35PM -0500, Johannes Weiner wrote:
> Eliminates the custom memcg counter and results in a single,
> consolidated accounting call in vmalloc code.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
