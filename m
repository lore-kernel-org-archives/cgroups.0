Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD70275AFB;
	Mon,  2 Feb 2026 16:17:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770049061; cv=none; b=m0p1KTl0utIEJMdBBGjfCfs/HOHvq8U2OqsauYnDYx638+etbkGcoHgGegOoZlN0EuDZrq9j/5utMTz23LjfmepU4+Sq239qN8cLVFlf/Fn4+ICOYPEXw9uka9HwSg6llsh2fntryfR8YQmx/mK4yKrPzihAopZONIgemshNar4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770049061; c=relaxed/simple;
	bh=4DUaVHOZIT+oa1d4uf2KYUHKJZwxY6Iopd49aAtgbZY=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=Bs4aQPnP/ldoE6a4y4ExMhAkHe8LrmBuqP9Zswspd3gaPQFSvUh9x0vRX5sDhlMejOpgyZBeuPpqPZKOvaTKu7Vq0H4a825pM6awVVeiEIMw2lWUD+4WZne0N47AijKdqFfNriggYfvuKVL/dDNMgXomsNoeb6aP7aDBEPcteOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CAjMJOlj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CAjMJOlj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 156D9C116C6;
	Mon,  2 Feb 2026 16:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770049061;
	bh=4DUaVHOZIT+oa1d4uf2KYUHKJZwxY6Iopd49aAtgbZY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=CAjMJOljPkx7H8FbX58xHXHo/IEsPG9+nmSOEniqmmqq6GjqMwUFxMIT5uWYqx/yI
	 6q507EUDuv7NtIOsqrPdhxhaNnTDishBQVtKeQccyArioR8goj2jPnJdgZRPtX7AOO
	 8WovY20Cuomh1EbCFzHx12HvdInuEUUQtcCzhGLIOZwo3wIc/39EIkshOKIElv62nJ
	 7hMF1AIcTZHnCCTixbJIPdg09gOHgd8QeROot4CannnCUmf0z2UZ6WuV2T+LY6E6bx
	 0GRVTu8/TdauRsZeC3Goh61jIS76eBs6ilfQdwEsGPYalv8p14vMYTRMYExM/zoip4
	 44UCrVqH+jvQw==
Date: Mon, 02 Feb 2026 06:17:40 -1000
Message-ID: <a3f6882172c7a1d1e335259675cc8ff5@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Chen Ridong <chenridong@huaweicloud.com>
Cc: dev@lankhorst.se, mripard@kernel.org, natalie.vock@gmx.de,
 hannes@cmpxchg.org, mkoutny@suse.com, cgroups@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
 lujialin4@huawei.com
Subject: Re: [PATCH -next v2 0/4] cgroup/dmem: bugfixes
In-Reply-To: <20260202122719.414466-1-chenridong@huaweicloud.com>
References: <20260202122719.414466-1-chenridong@huaweicloud.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

> Chen Ridong (4):
>   cgroup/dmem: fix NULL pointer dereference when setting max
>   cgroup/dmem: avoid rcu warning when unregister region
>   cgroup/dmem: avoid pool UAF
>   cgroup/dmem: add argument checks in helpers

Applied 1-3 to cgroup/for-6.19-fixes w/ stable tags added.

I dropped 4/4 as we don't want this kind of blanket input validation
unless there are specific reasons to do so.

Thanks.

--
tejun
