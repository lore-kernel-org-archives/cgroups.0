Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794240290;
	b=l1D9c9esFSoPrrskNIuWxpB7mmJQeqh32X3P81eZnCa7rpaCAd+P9cY7Mzgbjqg0m6iV
	 PuES4m+i0nf4YP9q2ezC7U1KwuCTezTKyTdtTxLGdd92/IZJtmuxJ7ahJfZ7gL78V1vVP
	 vEj0IjXbDcgnwAGIWCiy2SIxTXcZhy8v0eOFQrishlhlwvx5JNemHqocgXIoNXK1cGURk
	 KcgGbEwCA/FesqOK7ynofdrW+aR1H5M5RX36ptgBPfr2OGiGGAlGtUgXgU7vnO7n/8TE0
	 Ydhc3wc/ePI35RO8vAj1cmHglRKekHI2GFKCiWfA+wS4tz0Ej5lKlMfHeDD+7Pezx+A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794240290;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References;
	bh=B8e5HKLQPjiewefcw3UmEbt8O+zGd5jVIMRqzWZmXx4=;
	b=Vj8WHPn4dRlRGKb+mBiAaa/9roM9/X8Pflu+aJajBLls1P5wxQkA3X0rfdTskJXM74Dc
	 MPS05h2evYQsPkYQlO5NFw4P/G7Tn2kg6opXwsAL1NJfFL+HXyRWzP9cPgDEAG5MzuHDK
	 TFaM0DHAJRbKYMeSRm5Nrm8FoKuHpxFfQ3xyT80TcJmlh5hMIA58ScdCHMVwBwW/IlfXR
	 f7hHJtik9Jd/mRmqUBuSJobCjyvoINFXNxGmeC0/s/+U3/aaU2MWHOPde5hbNJbdtFd33
	 L+WzrpJWc+W41ygmeCqaMpO/3/abIAk2WeP+C6RywU76e+NzM19ng+t/M0fb+pJejlQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HK7HaYQ9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6237606A326;
	Mon,  9 Nov 2026 16:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HK7HaYQ9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30E461F0089F;
	Mon,  9 Nov 2026 16:04:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794240289;
	bh=B8e5HKLQPjiewefcw3UmEbt8O+zGd5jVIMRqzWZmXx4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=HK7HaYQ9cr4qa4ccweRAjlbd0uwRGRXknkcWlqbZGuA3kH48Kzlk6mbk6SmZfP49I
	 NZxRTAeUHvNw/oyktGM8GpaTYSWidRIAxZiUmTG2608SpQvc2VKiPf+kVmw7XWe1U6
	 7IjhbEKNyjFePpV5zPbqyW/AEUj2MuSjomR91UzR3LLpMp4k/6zWKz2d+0pIxjFgkL
	 Z6R6kzxVrslOe/ROyncXQ+bPefJmfzuM3bKRRJHKJhgz9VEWLieDBxW22sYJb2oeNG
	 6WtlXWME+dZWiJz2w2bhrkrN54I+fbByJ1Odi3MvSu7EoUXmHC1Byoq2pqWQ0f5MGe
	 1OoTjUBcoAC3g==
Date: Mon, 09 Nov 2026 06:04:48 -1000
Message-ID: <2df6537f1f290e99038cfab7fa36310a@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Wilson Felipe Pereira <wfelipe@google.com>, hannes@cmpxchg.org, mkoutny@suse.com, shuah@kernel.org
Cc: mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev, osalvador@suse.de, david@kernel.org, yosry@kernel.org, nphamcs@gmail.com, chengming.zhou@linux.dev, cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] selftests/cgroup: convert cg_read_*long*() helpers to s64
In-Reply-To: <20261106185520.290139-1-wfelipe@google.com>
References: <20261106185520.290139-1-wfelipe@google.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list

Applied to cgroup/for-7.5.

Thanks.

--
tejun
