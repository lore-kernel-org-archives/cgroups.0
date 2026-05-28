Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7788B3FF8AA;
	Thu, 28 May 2026 15:55:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779983707; cv=none; b=eJh3t/BLUgDkqqk+O024eN+udXxz7nNfoag1k7ytV1dd5OLHayhUZWwcxbeejzouiIs/oKP7LMRVVmd7hzMrN7oViw38MKp5nbq8zvprgaMVE0PVTB+TeoUiQ7wqkNGSkHCr6N7IZiJI0D8Dif7LfDvrGnsWNtiMOSg6ZgDy5tE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779983707; c=relaxed/simple;
	bh=/EBK9Za3dzKeST6xzL+uhXsqga85E68iUDnkuLoGL9Q=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=PUP8BuMTNqMSMkM3UitOp3TgKn1KOLia8+zdF7GF+xsfmFeibK3s+2CN3FBuSv0sA/5SfEXfyowFMGw/s8SZHCqp2W50hJf4qDCG7kCizxov5pZxhxdDlLJqVgMWrfG+7Nn1POymt5YHup8iCpYVq+ny3b6cLq245u30Bzb9Jss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WiU94tYJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WiU94tYJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2966F1F000E9;
	Thu, 28 May 2026 15:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779983706;
	bh=/EBK9Za3dzKeST6xzL+uhXsqga85E68iUDnkuLoGL9Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=WiU94tYJr9FK+OilplGdffxFTtJ0XCiz9Jj7IV6RgxQ9Fz3GioEYe7zggcpIy4kNG
	 c0BgocTXj4VGLRgR0bFxFbl0ECF7OnToIcubSg9GP2Slgyh0Y6A3TmD7BBa9wXFHSS
	 4yxEP0vxbsF3Wm2eCi/0m7E8Uf/85tzuVFhDnsB47kLx0ZL/68mjQRkjTkyKDqzpcz
	 L4yBJhN8T0iLV+w+AtRjDOHF9zDfQ1H95CbQuOhpb/3HVEO3OyLU1KUu33DhXeGsll
	 tibKvOxt4yeY8er1ymdMz5A9icOaJQv8wwNQroZbf0NR/pPxibddQ3bifsMXLLT5Uj
	 n7bsFSK7kE5dw==
Date: Thu, 28 May 2026 05:55:05 -1000
Message-ID: <dd21517999367504dbc5aa9dbaf4946d@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Ren Tamura <ren.tamura.oss@gmail.com>, hannes@cmpxchg.org, mkoutny@suse.com
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup: pair max limit READ_ONCE() with WRITE_ONCE()
In-Reply-To: <20260528042839.28472-1-ren.tamura.oss@gmail.com>
References: <20260528042839.28472-1-ren.tamura.oss@gmail.com>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello,

Applied to cgroup/for-7.2.

Thanks.

--
tejun
