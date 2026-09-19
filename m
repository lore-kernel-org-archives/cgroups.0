Received: from mta0.migadu.com (out-112.mta0.migadu.com [91.218.175.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A1ED321420
	for <cgroups@vger.kernel.org>; Sat, 19 Sep 2026 02:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789785865; cv=none; b=YLbSLmFAUn5EsLmTAAoUidrARFvClDvTPdyN7CGe/s0FLLBTWJAhWk53jaiLMdn7FxiyYLxlENVpN5Pskpi3yMmFnz8c8jiM/hT4KkFDM4aYtvVOWegJ9jKlYqvC6S6t87jgzoP038UmPKlZKGEvHtRYCbQU2PmeTWGCPpG8obg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789785865; c=relaxed/simple;
	bh=2IjYtgG8aEGlrkRaCldCU7rxmh7eS04P9nOParu7/Do=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=GLPvF1OmwaMrqljHY5ylUF9HFUUKn9hAVmzJ0LrXB3H7aCcJW+3Z4XR7Q5rqchBF5nsMF5Gk/9PWB+cD4nw/AOAsR8asEbj6K9ZxylV5jSPSxBIJ4ASiydJebQvFdPo4burLKd/cdUqiw1Do31a0RmxdzeP/bteNKB8iYUlKxhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=vZaGl9Ju; arc=none smtp.client-ip=91.218.175.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="vZaGl9Ju"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=2IjYtgG8aEGlrkRaCldCU7rxmh7eS04P9nOParu7/Do=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789785859; v=1; x=1790390659;
 b=vZaGl9JupkK+ONnb+50e/8KNP1V9VaQ/7SPP+U3m/p9clcug27cnVaWO3927wNUzzX8imRLZ
 s/TYN0O7CklWeDamZ0VKO7MQr0Jf2iWb7QcnAANsTpWqQ9Pw32CF9AbW4OgHaQ4QwSDSlmP9WNc
 Cd0ZvfFm7ooqYUzBczhhf57o=
X-Envelope-To: cgroups@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id b49c6a9b1f2ef0af;
	Sat, 19 Sep 2026 02:44:09 +0000
X-Mizu-Trace-ID: b49c6a9b1f2ef0af
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH 2/2] memcg: remove unused mod_memcg_page_state()
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260918165601.1014666-3-ekffu200098@gmail.com>
Date: Sat, 19 Sep 2026 10:43:56 +0800
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: 7bit
Message-Id: <75CD82DE-A4B4-47D5-9D1D-01009077A16F@linux.dev>
References: <20260918165601.1014666-1-ekffu200098@gmail.com>
 <20260918165601.1014666-3-ekffu200098@gmail.com>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
X-Mailer: Apple Mail (2.3864.700.51.1.1)



> On Sep 19, 2026, at 00:55, Sang-Heon Jeon <ekffu200098@gmail.com> wrote:
> 
> Since commit c466412c73c3 ("mm: memcontrol: switch to native NR_VMALLOC
> vmstat counter"), mod_memcg_page_state() has no callers.
> 
> So remove it.
> 
> No functional change.
> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>

Acked-by: Muchun Song <muchun.song@linux.dev>



