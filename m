Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794598339;
	b=QJQAPkkYSmRTGQotYpOv3K/vhwVOjDwsau00AZriFX6xSVPeRiJT1ov7lcI+ei+BJx/Z
	 bRv5MuTGbAQnplA2iSdOl0FWnEjIatMTxJIzuh5G2AwjTYeLlFR4mlCxaO2CMMOgaCgyN
	 vn3qNzg0INsGa9mXl50v1pH6jH2SHUf7FPHplCJexL+qrEWdO7ocSLzFYls2YdhY1eg1t
	 V33pYJ7rkROk+edEbBWf0RKJ7238FxQfowLRzKcXCUzFtzLoRE1EQSuCiKlsHmK0LGwMn
	 /WvSIGS75XD3SD2wB7TUIMfcdr2piBQSQK6R6IH3s6efcdnsf/GwG+PXvnMuXq9fYOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794598339;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=vlYtW7lGGBceiqH8zpCpClgjmMHVNqVkBU2EiidEb0w=;
	b=INs2YixPeKURmAT932yzA51rqM0NqFnpTDAHiI3XpS0DHxJB5YSt+qOHX0Ixv3ZwSsfA
	 QzMULzAm8qCgWjdO7jAEGUCvv+yaYU/GGjmBl/rPR8FysN49eyK5embS+dtxIjbc416Ci
	 jxX660OD9Gb4enY3AfMdvAuV4775AhAOXgKPFG5agSKe0w0A83mWWsn2P7ojsLPi+QAw5
	 AglaN7sa4EgTsy6UsxW955+ljTjo+Crl55uHT1LF2YnLxFq9AGr9u4cehrc/QZ+1HxQaJ
	 MBWXOU0SD2kbfpk++6aggMxC6IKwfUB4Swn0qSAMAysWkfAj8QcM67dMS1I0sN0WIBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dJ5IQQo1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B31D5606A331;
	Fri, 13 Nov 2026 19:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dJ5IQQo1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EB051F000C4;
	Fri, 13 Nov 2026 19:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794598339;
	bh=vlYtW7lGGBceiqH8zpCpClgjmMHVNqVkBU2EiidEb0w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=dJ5IQQo1QVjxT57gn0VyN8+AXTTwp/Er8VX9BN6XqRGQO8jYFrdXWFgInT8c+fUti
	 1fzRWxRSwgkA0GDon6LPfh0mKwbp/wCf2A0DNXgsBgE14xum9mxaiDkKUY6kp0+HYa
	 iZh2TJzt6YO/MfQmcX/UHOkSDMWHCy+dwW8vFyeS12uJSFkQSIKDj4DkqBUuA2qZOE
	 HplK2Ln9q2NJsx3oXXJMKNlV0Dji83QeMkY2o4X3g1DEdFKfuSM2EGgLkEX/GJP+dr
	 dQfYGXA6O7I4lIoTe7qAUjYmC75oceQmsjuHdMDS1TTGWFEFs+0/u9Ic5tx215S3i3
	 6xGrbW4Lyzwiw==
Date: Fri, 13 Nov 2026 09:32:18 -1000
Message-ID: <15730b564fdd3033b97205c66446c78c@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Waiman Long <longman@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Shuah Khan <shuah@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, Guopeng Zhang <zhangguopeng@kylinos.cn>, Guopeng Zhang <guopeng.zhang@linux.dev>, Ridong Chen <chenridong@xiaomi.com>
Subject: Re: [PATCH for-7.4-fixes v4 0/2] cpuset: preparatory fixes and cleanups for partition rework
In-Reply-To: <20261112031931.2815548-1-ridong.chen@linux.dev>
References: <20261112031931.2815548-1-ridong.chen@linux.dev>
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

> Ridong Chen (2):
>   cpuset: settle isolation state when CPUs are given back to parent
>   cpuset: generalize the validate_partition() interface

Applied 1-2 to cgroup/for-7.4-fixes with the following tags added:

  Reviewed-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
  Reviewed-by: Waiman Long <longman@redhat.com>

Thanks.

--
tejun
