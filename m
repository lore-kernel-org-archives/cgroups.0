Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A13E332601;
	Wed, 24 Jun 2026 21:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782335599; cv=none; b=erzDG/etjQot6PSTlk67JUFt5boTF+3I+SFDrFEpYMiwl2TUYT0XLcoM6mBx8faXgbTKcm4cGzv9K4t6LVINT7FYvjeQ9tws2ukUGqHq5HI0iJ7oN6rNgCtqAU6n2DyXLtElcyjRvaSgkZ/s/ajq+nEdYEXjG788X1LZA5xvsSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782335599; c=relaxed/simple;
	bh=IgkyJKi60WXCmh17XYm05cccG/GD8qQaAxSY1ZxWgM8=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=ecdZfdjgg/sDtS/ICxJkam3pubTMUtmTGy0tYfTGIMnmJjDK16MzUZ+PHz7MuXI2KZhtlMcj2wRkHN7GAzo9TkwLbVLDUnOet7/9sZMG/GKzDw+kYldq9w2Fq2YF9/gDtDrxF1nYhETie8h/qBAJmn+IyhiUccDs9zTJ1tmuO9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hpzzEt9e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hpzzEt9e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB07D1F000E9;
	Wed, 24 Jun 2026 21:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782335598;
	bh=IgkyJKi60WXCmh17XYm05cccG/GD8qQaAxSY1ZxWgM8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=hpzzEt9edeDrlb7Mk8cyLl1l6MhjfKjiybrLe2+TuN0uxIv+OYYcMxIJQjtup8H3P
	 Wet5axQ42CRxu9hhnOKO7qzp1PFxxH78i110/dhpdUHjtO/a5UfKzhLHQfuS5W6duT
	 caYCoAh7gbUCaZrUKS0i0MGBfcY2aMPK/B53jjeimk5Ksq7ussfSa9Cny3cETdtsEz
	 HTVuEkuEaYg4OPBbtCqbmPWNCHDyrU4A2rGYDUn1ji/BGBB6d4Zsamtt9p4Wq/+JWd
	 ZemW5f1dUd5RWGcDIFlzyI28aPsb2+HLC/CV5p0MkU/p1vKKbcgYPZ1sv1olGEPvTl
	 n1udYq6ux4vGA==
Date: Wed, 24 Jun 2026 11:13:17 -1000
Message-ID: <b9eb3068c2d01bca8b19927351395ba9@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Zenghui Yu <zenghui.yu@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 Michal Koutný <mkoutny@suse.com>,
 cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup: Fix a typo of the function name in comment
In-Reply-To: <20260622110708.15593-1-zenghui.yu@linux.dev>
References: <20260622110708.15593-1-zenghui.yu@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello,

Applied to cgroup/for-7.3.

Thanks.

--
tejun
