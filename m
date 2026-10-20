Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792518065;
	b=uJ72/pQPVKAmVpLiiaXlS5iDiCH1BGH90hQO2hlHIYv75lFKiJkkIfjxn/Sx+UjEqB1i
	 Dby7rq0U0WvnfbMfFkc/bkebzdoLaYEz7LqNJa32FXoAkPSeUWQuSOJJvpY8JLt1xWNGs
	 BKiVR+K+xWqNvrGmk0EWLCRZXBQTYZ7zEw8H5Sdx/jLwL9DugB8hwwu79ObyDniQoPQ7j
	 MYf/9oIUsImSFpC9aaHebfMoyIXXHucsM88+qHeol3kSEsiv5gBmZ+MNSqzHH14Q1Z78x
	 cBcn1XI4UDncOOl8v8N1TEcnI4G6ynknCYs8jcWRt71iKLPW3TGnA0rG7a1qOq/60Tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792518065;
	h=Received:Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=oWXp8S6+lnKG9OXZefu0eIGH6M8O+T3jLj5fDgMXlD4=;
	b=yJYCciFzS5/z8o/KLd8bl6l7ouqKXCPD5G8nyN0CND99TlGjOZeh2f2NQPw1ILTqnxgc
	 bPciro5hXEntzdDFMD8d4+X4/pebRPQ+wOQkKi/VsiT/xqwkFwXVPAaZrs+JTwu1OcsM1
	 tTc2qVhdXlaFlN9SNqDy299hgOUc5xlXxh6nnJRdRRfJR3xSKMMgfDShFYlxU80I4Vrkw
	 zvQG2nVktw9pCrUy+4dZgPafWEDE4iZeepatRroxSih781IGKm7ZM8B0s4XRvU3ypsZA5
	 sNBEYRCC0U5HIGibTjyfC3g5GvPBlhriz6JDUftGPuQ00B45vocbXnTm0FRaUatgFog==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74128606A324;
	Tue, 20 Oct 2026 17:41:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 243701F000C9;
	Tue, 20 Oct 2026 17:41:05 +0000 (UTC)
Date: Tue, 20 Oct 2026 07:40:34 -1000
Message-ID: <c2ce2760ebb79da3de5526b0df9e33de@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Daehyeon Ko <4ncienth@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Koutny <mkoutny@suse.com>, Yi Tao <escape@linux.alibaba.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup: serialize migrations of newly forked processes
In-Reply-To: <20261020035759.3110170-1-4ncienth@gmail.com>
References: <20261020035759.3110170-1-4ncienth@gmail.com>
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

Applied to cgroup/for-7.4-fixes.

Thanks.

--
tejun
