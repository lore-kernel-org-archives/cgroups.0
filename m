Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9BBC17555;
	Mon, 11 May 2026 01:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778464014; cv=none; b=Df6N0wC+lYvpZctE2A1Z2U5EPX33iRGsvc2b/IYME5Jk33p6YpYtO/65zffmvtzlOLUagf0Klv/pepWCLhzq0IdHHiALSjhZDhO43uAkIkvJu55JTKtLSHOSwLattgYFNZGTqgilcUC8hDr7t44TdO+2PcO6Duzy52UDmp8HZRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778464014; c=relaxed/simple;
	bh=gHX8SpJXTygTiACEpPlwK4PNbVPnp6HjiQ6tG04hNT8=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=EaqjapBfIgeZJsBcQJC2HDxrCD0AxlZSRliFMu8p/nlbVvEISqAYWXb24M1MMiCyXxqGLY8FYPTo0oATdyQ8cJ7ZPSho6vv0ivD6tSgc8uGM24SHXGzXKsl6hQQe7hYpN3mUAwuPrqOAOGQu8wZv/GnGavjReexw5y8uVwOaRIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hI7DyGDF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hI7DyGDF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62B65C2BCB8;
	Mon, 11 May 2026 01:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778464013;
	bh=gHX8SpJXTygTiACEpPlwK4PNbVPnp6HjiQ6tG04hNT8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=hI7DyGDFCiRZeHHgubmTnvnWfkz7cur69oVffvTxaLmyKWSePR+RaVmdkmK59Ia7t
	 G2XZcBs2Xv3XUB8644XQK3934j9GV++cT4Ri14AksHp/XeuYKQsWwGUYTPVoDF1qch
	 cfqecAUBjI0fOSUECPf+BW2g66e+ofLNirU3rJRfnt2JxTOgUvcFrMmd/TsN7b9rg/
	 Gxizfc+7X+JSOe/uuDSCocOndIiXjX7SZObJAfMw+rJFOzvGcckwE17Txuc2VqJN1i
	 B1ozvF7+h+P7L0Dx3We01Fs0OErTWHcyB54675qJWFSHcJ2FOMUwuFqVohtVagkeF6
	 n2NMas2Pelbuw==
Date: Sun, 10 May 2026 15:46:52 -1000
Message-ID: <c6b89ff53b603350fe53b0d47f3399ed@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Guopeng Zhang <zhangguopeng@kylinos.cn>
Cc: Maarten Lankhorst <dev@lankhorst.se>, Maxime Ripard <mripard@kernel.org>, Natalie Vock <natalie.vock@gmx.de>, Johannes Weiner <hannes@cmpxchg.org>, Michal Koutný <mkoutny@suse.com>, cgroups@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup/dmem: return -ENOMEM on failed pool preallocation
In-Reply-To: <20260511013150.7235-1-zhangguopeng@kylinos.cn>
References: <20260511013150.7235-1-zhangguopeng@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello,

Applied to cgroup/for-7.1-fixes with Cc: stable@vger.kernel.org # v6.14+
added, as the bug is in released kernels. Also capitalized the subject.

Thanks.

--
tejun
