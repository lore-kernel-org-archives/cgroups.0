Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 938EC4AD7DB;
	Wed, 30 Sep 2026 23:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790812074; cv=none; b=no9d+MpCAihi2zIwsJK1CE6H2ticbzjDhppPY4jKFT/CJwcsfMLiuLobpcz++cK3qGo/RU7N34SE6lyYDzAIc9ZyCf3iO9cO8yZTRxRuuPfcGxNC96I243PuGFus1HBrUKVJdHa7GdtrcGElzkEtWQO2w1Wxkr2xwi32IuX4SSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790812074; c=relaxed/simple;
	bh=4VoGU1NwqBGtSmcV8S/OrxbuIr6TwzH3SwjGst9fLaI=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=aguuZexqjDiRs6XDYz9xBM5rI+df2MCDFKT51Wa8Hccan8fAASsWFohTNcSAe3RxlKA9jCLGWBVulUwMXixyinYCCVvLVA/ec+iQ5f0ff3tHZBk8I9/RLeaVaZoGFaFAW+sCnD1HnQbyF/+kCVYqTI+JFF6mNjvoBSXTL3Y3vkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cqfsJYMr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cqfsJYMr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CF1F1F000FF;
	Wed, 30 Sep 2026 23:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790812073;
	bh=4VoGU1NwqBGtSmcV8S/OrxbuIr6TwzH3SwjGst9fLaI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=cqfsJYMrMp7i4hci3BhAK46ZFLySdulgHHi78ZS/cpzDDnY7HfaxfSvdVSvhuhaec
	 Ui1SdUADxOBNo8NY2LZXhkEbIGPinPgcFv2NjEVJW3KnTQIvnQeK1bhh3iWAgeRJFl
	 8QFXUbj+n9+pVE3bYv7p7KkIRWApazbKTf+9KBKFIoPTEQAG1s6gZLnOnTN2xL+yaK
	 BgLC2me9EEOX/RnRgExJhjKPwzn8lJafRc7zeEFbmS554wcSsQa1lMB0Q+BAH8amcB
	 y4c8UxwITeB1D3j1TJYn4Mx3g+Bffg6pzKIQafeGj1eoCEBXzCNhJhKeP6+fbuFIAr
	 jC+rGqH1HsvcQ==
Date: Wed, 30 Sep 2026 13:47:52 -1000
Message-ID: <37a3066e971a4a8657cc76159a226a28@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Ren Tamura <ren.tamura.oss@gmail.com>
Cc: hannes@cmpxchg.org,
 mkoutny@suse.com,
 shuah@kernel.org,
 void@manifault.com,
 cgroups@vger.kernel.org,
 linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] selftests: cgroup: enable the cpu controller in test_cpu
In-Reply-To: <179074810117.139422.8287518907118199923@gmail.com>
References: <179074810117.139422.8287518907118199923@gmail.com>
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
