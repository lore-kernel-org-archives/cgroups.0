Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793410735;
	b=hylUzcs6B130NFrPZ0Z+uTSmvJXp6cuA63PGhWxUo/ds2qI75cMnZ6qxw5QGDGGJznLI
	 WezBu1E2cgG7Cj4n0DOLyPRx+75QKe2ee3RGEKE0+b/sgnD0BlTzQpDTDEkfGqJk5un1+
	 M/pzRJq2KT774RNul2XzhnY+xY2+vw5bXExkWDdIBP86VIOG+ivsmyW9xDsPUt/lqfplX
	 ZxBiTj6x2ZAZbdysCN10KRr4+NTQeY8SAQmjl6G0Ieue1ekbT9nR8AhCICmh5NWgCQLYa
	 igE94mtm3ZXLUr11ZTHMPZ4T/HRB59aZA7qEH5UE0TFNwyLXGPbO+eTXGmHYTR0fjtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793410735;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=YF9JeAjw7ywzUc5725kV5oNhe84X6aq4bRPeCdn4wqc=;
	b=Xah3VRZtQYZYqVFMJ6fx+azpgN6Je11JCUVJwQcUv9dEm3+Gx1qtEo4WQcU50McrULyg
	 ywGt7MQkcR2Cw89MR4RhymiTc833r93HASaTxtS1qvSEUwFP0MJy+96GqXLAE6fUSxIeJ
	 1twSwvbiF3eR8+tV/DOChku8+z1s21X664CsdFAP755YwHyhVuHdA0ah0D48Tbzo/ztg0
	 NiKbjDlDVXlTL06LmyLjguVlHo4Jj6zx4LqbVkRUe1qtq7yf+4UhC24dcFqytn6xVWVgw
	 T2qQ320swKtrBKLcEYdK6gi3J1MPXLZB5GAX6i6YOL1uxBKLz/anf/L+rOYoF0H2HzQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LT4pTZHV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B28606A31A;
	Sat, 31 Oct 2026 01:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LT4pTZHV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0709F1F000C1;
	Sat, 31 Oct 2026 01:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793410734;
	bh=YF9JeAjw7ywzUc5725kV5oNhe84X6aq4bRPeCdn4wqc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=LT4pTZHVscN+EITJPxmbM4Y25TUXjJlFxE8rpz+EmrA4EvFYMBuw3Wnw+209zhHby
	 yn+/LHmPjpTrI24PCJSEPZi0Jd0kQ4PM35VFOinGZ4e24QUC/km+jHQyNgxK4vpPVp
	 kRdy9pkgqjfrvRAYdYFZ9esyHscFE8q8EZTtZ4biekypGogqrJDsRhPXldIeCMPKqE
	 OUjQjhBuawBOKePpETi5oVrpSORg26tYZpp0O9Nj7WBMt7RvlhmSOvEagVy59gVNBw
	 sSRrdD/PgcqrsvpR6E9xD+RyZ5ekosJbwg+pjHo3LHWJUfnCl3OdFSPB7RfTTw2YVn
	 nO8b60JDG7a4g==
Date: Fri, 30 Oct 2026 15:38:53 -1000
Message-ID: <9a22597fa0533c7f1c1a5afe4553e1c6@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Shaojie Sun <sunshaojie@kylinos.cn>
Cc: Waiman Long <longman@redhat.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup/cpuset: Drop redundant no-cpu check in partcmd_update with newmask
In-Reply-To: <20261030131408.1054507-1-sunshaojie@kylinos.cn>
References: <20261030131408.1054507-1-sunshaojie@kylinos.cn>
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

Applied to cgroup/for-7.5 with the following tags added:

  Reviewed-by: Waiman Long <longman@redhat.com>

Thanks.

--
tejun
