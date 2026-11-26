Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795695460;
	b=zfrkaGNgaiGZONkYJUdMpq5mWe3o2IsJFn3q/w7QM2tqsOftpxpVwDSSr7lYZDN1ye0B
	 8NfApdAEcg59NaN+tjADd9FPmgZMEx8cvhSM0K+NAFB+qRtgsXrTYmtcn4cCQ6/MaYQl6
	 IAAyFPYFRONDvPtoqm/lA5sxJmQJtoyW9s+ltr7UH8KISaTHoATQjdck2yqBifhXVgsbA
	 aLNvC3MJuFgC7Qf9hoiyTGvrtIRaOBfJ7VZDLfIBFg+uklSsS7U/FwVunkVql+0qPc0t9
	 ewhEcXHIArMXO5wWbI6PBBf8q0uwDYFxyo21JCHWV9g5XQ7108p3GE2vvh8mW5RliqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795695460;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=wN00pFpWYZ+wwYrOlZbOLfT6UmtgD8JPARqSG6SJcEk=;
	b=1VIwKOpXbVmiBTGcCW+SToCPCH88pIRzpqqZZNYpKAFeFmSteeSVKtZSU/EdSRWXHRsv
	 xGQ2u7prVIPamTAANfsfPEeJpNJAxwyYhrpSR9eoWoE5DGzJ+7t+RUq4i0AdLGmC5BFTy
	 ZGVFg0XxoGuW+9PB2LyybbHrnIMp3Wb504XPl7brK3jmXBdtLuJlyfu+G1P20oM42rft0
	 D8cpLDZXkVo4QV2SwwrFhbiY9+qWo21meZVer5+YRziSpMNflVHBKa2nxU096HcYV4hz5
	 by5Czz6iG7eSlKN+VkLrHQvZT3jkhZw0tJDkxIbFwovCalI9UEqPvYM9whR6Ry3YTpQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PsP6tBH6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6353E606A32A;
	Thu, 26 Nov 2026 12:17:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PsP6tBH6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 686C31F000D0;
	Thu, 26 Nov 2026 12:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795695459;
	bh=wN00pFpWYZ+wwYrOlZbOLfT6UmtgD8JPARqSG6SJcEk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=PsP6tBH6WtJZo9kBDkDcEo7nK21a3g4G9TlxSzx0CNHO9D/uWT3dqnv97vsZqueAU
	 mAOw9bnIBGt70+0KcN6NWNpZNckqHovgV7cF7F1f0CZMiV+KLeQCIV+8+4Is/98yRQ
	 ITgxwR2Z+rE2Xld+Bl7PQf4flKc6Z9D0sU/ZyiB+dsgE7cvtPDlu2iuR4wANLv0Ch8
	 29QHEtPvksIKOLAM0rvqDROlz5KdwAR9XizUF/W57CgYtrc0tcBBDrLXq1NpkH5rWu
	 Zv4teHyCKusuLxTB+behTb5z6NUBWT/NEaSyyi+zLfOak6qjkHkFqXsJ0UZ/qt09wK
	 Ri/w8g0JSvDvQ==
Date: Thu, 26 Nov 2026 02:17:38 -1000
Message-ID: <f188775aea9580f9ab2b477788503434@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, Greg Thelen <gthelen@google.com>, Greg KH <greg@kroah.com>, Ming Lei <tom.leiming@gmail.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] mm/vmscan: Fix legacy memcg reclaim deadlock against filesystem freeze
In-Reply-To: <17d0d1395c0237d201a1abb2473d51f5@kernel.org>
References: <17d0d1395c0237d201a1abb2473d51f5@kernel.org>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hello, Andrew.

Your follow-up, "mm/vmscan: scope freeze writeback skip to the reclaim
target", applies on top of this patch and tests fine here.

Thanks.

--
tejun
