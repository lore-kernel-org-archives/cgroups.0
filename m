Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D49D4BB297;
	Wed, 30 Sep 2026 23:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790812075; cv=none; b=ChYkeqqiDWcRtSrLrFosjn6uphyAoH6fvMvJrciXALBYkg4gvAykmJO/UGbVF6Y1QDlQnvmgwhIZ/l2UYjFhHY/+V9D05/f8aYjNEQyrTEAr8gJskQExrSbC8XGaXYqmlNyUep3Ynv8YUCInKKFJZBM0g2H8inV4q/93f7OdJlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790812075; c=relaxed/simple;
	bh=4VoGU1NwqBGtSmcV8S/OrxbuIr6TwzH3SwjGst9fLaI=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=p44r+YTEpnidndm7X23p3Mb2hsHDINgcqDGRy54phzGTPW34yM4ikLUi2uRpBh8gyK7g3MWDlVLs4u9UlS/XlzzQux+uIoCIawmUft5ZXcOYO6War474p2dhb06+AF+72pX9flp1QO2qYGb700J9Cr9vzK7SUIbNtzHpGjDnspI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d7ieJHZM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d7ieJHZM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14E9D1F00898;
	Wed, 30 Sep 2026 23:47:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790812074;
	bh=4VoGU1NwqBGtSmcV8S/OrxbuIr6TwzH3SwjGst9fLaI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=d7ieJHZMuZIspp/qHUGuPRgbW3kqQbvaX4Harj8GfK5vpFiErqLepEz+/n3wicf4W
	 c36rqw2WE67lPuOkpzT2mYXpp9/tYi8JR2eAIC1mCebtOsZdbIC5bASBDb0q7Vm8KX
	 dA4QR+6fjaw308D77caTNORnM2kMAKdxPK0H5pNYVw6rslyhoZDOSgWy/qgRTq7UrM
	 Ix2S6yldloetxjDrS2+qXcsN3oHLVpW1fGz6DjpXWogugTBQDSHh8fPA6S0gRAyYz3
	 uZQMDlVsYIe3J9r2jGOzZOpqvI2zSEATN506Ipn3LT/N8Vkq8Bs1Mq+Z1zapo8AXqZ
	 92vhxfs+Xc6Kw==
Date: Wed, 30 Sep 2026 13:47:53 -1000
Message-ID: <1ed2e00f25c6735c84870faf72aa0237@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Ren Tamura <ren.tamura.oss@gmail.com>
Cc: hannes@cmpxchg.org,
 mkoutny@suse.com,
 shuah@kernel.org,
 cgroups@vger.kernel.org,
 linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests: cgroup: preserve command arguments in
 with_stress.sh
In-Reply-To: <179074810121.139422.1170111592692928081@gmail.com>
References: <179074810121.139422.1170111592692928081@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Applied to cgroup/for-7.4 with the Fixes tag dropped and the subject
capitalized.

Thanks.

--
tejun
