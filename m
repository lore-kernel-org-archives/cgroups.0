Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB3DA37FF6F;
	Mon, 28 Sep 2026 20:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790626638; cv=none; b=Wp628mDi/bi67uVLZaMtIUpaKt9fQgjgt2+Hgcm5L1aCkThfITScHpevAoA0OjT5f0keuHBLSwBkwt7oYmRQ8dcmInWKGUbWV3FtZpvQEF8n8Sq/R/8s8LO6v+73s0xxFtuKlB+ESawo4fbT5SBiHXu6uCvSRIJAjqUyuNYsoO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790626638; c=relaxed/simple;
	bh=xXIUexn4Je0YcK/ni6N9UfltQIEQV02i+femQibTGu0=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kJE6zE7n+tKfdOm/3lethgc6lAQ5x6yBLwn1PBCMRTRFpesQd6fpHLMbTxxl0oyp4IfupB1/i+DZx/YXl2bn78FDs29ALdO783Iwk3NuljfuefgavUdzcjfMCV2ZN02DHP0HmqOopNqBrPxpt4x/ndxHG5QKCH4N89Sjvu/J7AE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z+bR129a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z+bR129a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 626271F000FF;
	Mon, 28 Sep 2026 20:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790626629;
	bh=xXIUexn4Je0YcK/ni6N9UfltQIEQV02i+femQibTGu0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Z+bR129aiNlKjMZC4NzYHb5EOvetb0thzZ8ZrL1hBqse9B7T6mNulSjTKeP3cANIF
	 6E/TMmpLnPOY7QWnz/fijQ4VAxdXQKSa+ksIO9E97gj+FFwABJokqhryfpn1eWVZ2L
	 UxdIdsZtKggdcPJsi0kGY+vh8Gow90Q56dKp0OGhFqnCobewM9roVWDIG88LX/xzRF
	 bILLt1Olx+cqdA+UuBLY9tjvQ/eHiivcylt3PMvthFKrTQVyhLuF7//eMT2xHEcsV7
	 RU1SqnoE/o1Ywzw33OxwsLaR4GfGkzSuBT093FvIsrIK8KbrxNveUuN4uLY0YlAZBP
	 LP/J/Z7A7dL6w==
Date: Mon, 28 Sep 2026 10:17:08 -1000
Message-ID: <dd150273475fc44f5e4214b1bfa413a2@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Vishal Chourasia <vishalc@linux.ibm.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests/cgroup: add settings file with a longer
 timeout
In-Reply-To: <20260928200034.1769120-1-vishalc@linux.ibm.com>
References: <20260928200034.1769120-1-vishalc@linux.ibm.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Applied to cgroup/for-7.4.

Thanks.

--
tejun
