Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 153E73939C9;
	Tue,  2 Jun 2026 18:34:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780425266; cv=none; b=ATxXrXDz+N8k6OhTA1DoGX5KTPk6aWzup8xb+qLuGAVJ9lJURgrHY+EjvPSKMFna5WI8LnoV644LL4OVAGEYTNgu3flGxXxPf3ILa9O2hz6ugUhA7K/wq8CLY4a6QmgkfUtDrOzGIxoB8dFtP+/3Y15Xru36ako8T5TqkqxqeoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780425266; c=relaxed/simple;
	bh=UvAFOrEJ9rVai8ttmGCzo7ViaDMyasXrSoxT0mvoo+E=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=J58MdtsJYzfOPH7nHQ3S13TRZ3r1tDePi5erG353uUnpJ/WlNTpwuSNDr3/kbTEXxBODqCyPkYutqBmEUlwrXIUZD/l51OSgGhg4z0iW6esc35xFgsWGSUj5HBa1K1kMsTVYYnobuzE65Y/uxfvyG1js03Qm5fdaChIvsfnZvgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Lo2I1hw1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Lo2I1hw1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83F281F00893;
	Tue,  2 Jun 2026 18:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780425265;
	bh=UvAFOrEJ9rVai8ttmGCzo7ViaDMyasXrSoxT0mvoo+E=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Lo2I1hw1I3B5N9riFWQINDoW1kVjJ41lM2MvjGXhyJlck5Gw5EzYSTFdT60hHiJl2
	 Wh3j3SdUVf1JhwJye4rUAPKDr/3e1cX7ZyzGgFEOb3yks3/+25ypu7gbVpTpaftU9P
	 VUo45C8iLv8LoWR6Mlvc/ik6NOzKfaD7uJ3C/zWihJCWQZFlL+MoOC0s1qDPaatj+z
	 Ik35Td5W5U3uPAYkK0rAxP7XbU3nYrPhwigPFRmyN76j+PtGf+eR7tWm1YdXLX7g3I
	 bn5Z+xyI9S5nDSZxKOLEZlYbE/vkzesVM/KrBOZBkRbmBby8/Re0cITFm8BSlp5byA
	 8Q9Zv8LztuIeA==
Date: Tue, 02 Jun 2026 08:34:24 -1000
Message-ID: <99e251a1003f30586d8a64841747996f@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@kernel.org>, Bert Karwatzki <spasswolf@web.de>, Johannes Weiner <hannes@cmpxchg.org>, Michal Koutný <mkoutny@suse.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Petr Malat <oss@malat.biz>, kernel test robot <oliver.sang@intel.com>, Martin Pitt <martin@piware.de>, Aishwarya.TCV@arm.com
Subject: Re: [PATCH] cgroup: Migrate tasks to the root css when a controller is rebound
In-Reply-To: <20260601190256.1815778-1-tj@kernel.org>
References: <20260601190256.1815778-1-tj@kernel.org>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Applied to cgroup/for-7.2.

Thanks Mark and Bert for the reports and the testing.

--
tejun
