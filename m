Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88894423EA4;
	Thu, 24 Sep 2026 16:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790268163; cv=none; b=QA3LKWOmWwW7zxdKrQBXGScNza+fJvn09YdKe44xT7Ue9OIeLaPgoRniu1HqqpemzWXhm0CHPccTAgBG6/APBWVbuX/mY8FfIXwtbhFlZyZX2cOl7+qA9FXUIzz/naVjSZB6ENdpdMT9CwSTr9f9rWMSCOXwLvjtv9JFemjgVXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790268163; c=relaxed/simple;
	bh=dpbpYZ5+lgTe9XC4Cj5HD4BLbPsEeIu1ToCXwC3XR6M=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=A/l/mG1QGihmqowMdkupzba5g2+fkKQTsHpozqC/kit+UdkN7vW2L/0X1c0jVxtz2Mz0WYZjCxJCYjiX1gKCX9PPWlFrKPXnvlKDlfRbO+fapFNEIUA8ShmkgQzUYfIkf3BsJcUYHw168bSxUbvZODm/vILQ1+L9VEovSx4mPts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kbn+lorB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kbn+lorB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0F631F00893;
	Thu, 24 Sep 2026 16:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790268162;
	bh=dpbpYZ5+lgTe9XC4Cj5HD4BLbPsEeIu1ToCXwC3XR6M=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=kbn+lorB7GI2kogrG1WpRUupqUsGaWtsUxrf3BZ9HLFCpgwo9lQT/3fRCauvA+akH
	 B3YrIU+rLDHMC2QKDe+zcv2KlIJnEbYIcezCxmP4Un/X6cuTH1tYCRNTCRfh4nQrDA
	 TMDMAUCu0suCpmRevLhIJpY4bHmNoAywFLKJLg++7asnsFN8fGwsh2QtyWcp6KwKsZ
	 GzPojJ8R6DxQTwPmlw1UqAKegtVb19NNzjP/Sz1QLbJruDCUz+OZoGKlBN2GslxRXG
	 yTlQyvHOjAGkg4a1Pre2kb5d781BfejPGQYwC22UPAhp4dEwkUxpD+r7ShiePxT6D5
	 xHwoAY5kjJ/AQ==
Date: Thu, 24 Sep 2026 06:42:41 -1000
Message-ID: <843f8193c544cb6bcda128cc106a9027@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
    =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
    cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
    Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: Re: [PATCH] cgroup/pids: Restore pids.events notifications in local
 mode
In-Reply-To: <20260924091536.63572-1-guopeng.zhang@linux.dev>
References: <20260924091536.63572-1-guopeng.zhang@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Applied to cgroup/for-7.3-fixes with the comment rewrapped and stable cc'd.

Thanks.

--
tejun
