Received: from mta0.migadu.com (out-120.mta0.migadu.com [91.218.175.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47062321420
	for <cgroups@vger.kernel.org>; Sat, 19 Sep 2026 02:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789785887; cv=none; b=BGAnPzoHzQWMN+DyXNJ/A56gFeB19Fk92vVqSDZoaSmMapOjHWRGbkf1XtGz2OK64CJm+7/G1RsskFE9bLfpTIITIrAu4qBESUAGZ9tq4d4+oN5NjtvsTTJUMRNfb4kNZeqOKX0CV5jLevMmUAdIWirsG6E4tzf39sU/nr5tW18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789785887; c=relaxed/simple;
	bh=gZMNTW6sgM4aJk8DzB4CH3HxK4yTRxgEOhMVRmrJvLU=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=BPL/G4zgJvyt88OAmr6+yCMzy+//LjiAzKdR3pVWMPEO4YusrvGRKvzCZVWz8iJIKdE0R3EK8dpfDyCZ3tMgASiNjDCaaL+JI4iYs5s+t+ebcQjHPk5XQbsYGHgxHDAqymH9evCxNExF01DOqmQGWFL4RqrL7tuIVcOnbrTuSK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=WPxn8+J6; arc=none smtp.client-ip=91.218.175.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="WPxn8+J6"
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=gZMNTW6sgM4aJk8DzB4CH3HxK4yTRxgEOhMVRmrJvLU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789785884; v=1; x=1790390684;
 b=WPxn8+J6+DuIp1hrAvHCmAY3FbO9Dvf3irtMYRvQPr+d6+TMmIVFF0rVnSWRoywPCJ1VevEz
 6VfPS0c0fxvnld7650Yy6B1FY+NfxjfXFmdYnrYxuwtbRCBCNZ1ndqn8vs3Yb3OdriQROU3e9xF
 0lp2iYaEDTXmHOGA775BzlXQ=
X-Envelope-To: cgroups@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id 0b1a70147224a31d;
	Sat, 19 Sep 2026 02:44:44 +0000
X-Mizu-Trace-ID: 0b1a70147224a31d
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH 1/2] memcg: remove unused page_memcg_check()
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260918165601.1014666-2-ekffu200098@gmail.com>
Date: Sat, 19 Sep 2026 10:44:26 +0800
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Content-Transfer-Encoding: 7bit
Message-Id: <3A433465-3F87-4268-9B1C-73DEDBEB6A90@linux.dev>
References: <20260918165601.1014666-1-ekffu200098@gmail.com>
 <20260918165601.1014666-2-ekffu200098@gmail.com>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
X-Mailer: Apple Mail (2.3864.700.51.1.1)



> On Sep 19, 2026, at 00:55, Sang-Heon Jeon <ekffu200098@gmail.com> wrote:
> 
> Since commit 90f095b816e2 ("mm/page_owner: use memcg_data snapshot to
> avoid TOCTOU in print_page_owner_memcg()"), page_memcg_check() has no
> callers.
> 
> So remove it.
> 
> No functional change.
> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>

Acked-by: Muchun Song <muchun.song@linux.dev>


