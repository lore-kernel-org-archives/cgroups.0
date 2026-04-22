Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19FDF347FCD
	for <cgroups@vger.kernel.org>; Wed, 22 Apr 2026 17:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776878083; cv=none; b=G5tI4fimC8717g6fXxS5f8jGy09/QJM/toKiTmlXd2jk94ihh6mCTs4Atl5dclWC5WVHViTodELx2XzXuzreqDUbCqOyqbL1jJ7D9pf8GXVncj1WSIx7lK13PUk4Jpi1OhfDINhMKZ6MtUBOxZVPYT5hPmpAlTyaDZgxzNT13JY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776878083; c=relaxed/simple;
	bh=o0+9WwVH9DEn6iOXHcPgitSgIKpQsEhT9gZ5Gg+ZEZ4=;
	h=Date:Message-ID:From:To:Cc:In-Reply-To:References:Subject; b=PDm69fWBr2N9pkIwBheMzhaeGEiwQevanDbny1h+uMspWSjXgsklyvX+eUmmDPpZHMhJQcPTPvQl+p3EjHJDj0jbUpukcEsu89PcGrFGMrBXCng3zraLGAkAdPmgckBBW62eaioZ/+cYAIzPNBZ7LEka7ZKn3R/qf07hngxf2xM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DyLCM4Ew; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DyLCM4Ew"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6979C19425;
	Wed, 22 Apr 2026 17:14:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776878082;
	bh=o0+9WwVH9DEn6iOXHcPgitSgIKpQsEhT9gZ5Gg+ZEZ4=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=DyLCM4EwnJ4YB/q0QSCK2rCKiH5XcjtbRp1F3K09bT7RmSkuQ1Pdv7Qohx9Cxc/CZ
	 yPteO4hUV+1D8Z7XACPRoY9y6YamyiYNd3Am/triDPdNo65AtN776yXw4A039pLPjk
	 n5l95fcLr92VuWWsMlvd0Q4tH0mUIwGSTvnjlOojvFVDLvG6CTq6MDLd6cPbiKoxXf
	 Dxv8pNI+i1pOPoW902TTMquiNkC0jaOMptxnToTd5vnH40bH0ThIzp25+osIN9sEun
	 V7yo5UA/OiZCbSIIfAce9kQdBPtXbi9w3LkvkUSsvg2PMwTsCvEi5vsiQSw3BJrtos
	 rAa4RQbXKbIBg==
Date: Wed, 22 Apr 2026 07:14:41 -1000
Message-ID: <32f69d774f9aaac90d588567e1fcd880@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Petr Malat <oss@malat.biz>
Cc: cgroups@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>
In-Reply-To: <CANMuvJnpVSHNJ1=6Auw7zYnZ9w32J0mn+dw6PkdXi-WDU4Lrqg@mail.gmail.com>
References: <CANMuvJnpVSHNJ1=6Auw7zYnZ9w32J0mn+dw6PkdXi-WDU4Lrqg@mail.gmail.com>
Subject: Re: [PATCH] cgroup: Increment dying descendants from rmdir context
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello Petr,

Thanks for the patch - the fix itself looks good to me. One thing
worth clarifying in the subject and changelog: the counters this
patch actually moves are cgroup->nr_dying_subsys[] and the per-css
nr_descendants walk, which surface as nr_dying_subsys_<name> and
nr_subsys_<name> in cgroup.stat. The top-level nr_dying_descendants
is already incremented synchronously in cgroup_destroy_locked() under
css_set_lock, so it's not the one that was racy.

Could you respin with the subject and description updated to name
the actual counters? That'd make the intent clearer for future
readers.

Thanks.

--
tejun
