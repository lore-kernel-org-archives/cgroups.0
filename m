Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793983037;
	b=ZCsDamA1I4k9N2Dt98laO57RrxPbk7D6irICkwz7Gs2oEPaDqv9VOYWLrwWkV2jHzDy9
	 7kove1U4I3uFl3+DTgJn8xFN6wizTODqJ4m00IvIEg+FidF5ghAxbMOs8HI0Stfhpimcw
	 kFBAPQTrZF/3QXfvL0dk4ui621I9wQuS33in6ZkRabaHGnjJ8Lo1rNgWgMM9dM91eH634
	 w/1QDZnvIa2d2hSOOq2MN5nvcj10RYt98Q9zfF0oj6bmLRf5mhhLRpJ+mSi87wlmIvUME
	 Or3GkkpMI3aZXgt5MXlSi6zgUAfw8adfO5obt0mAJJHn7tGxTKJlG2G5+rN98P4gG6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793983037;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=idKupkFOoEuI1D0I9K3dkmHCv5t9EIMzKRFHoVTiEGg=;
	b=UrfzthlBgK9ci0t+aA0pfnB8e1eTi2+S4HI0SskUceyHVLKO/xIpCDL0o4lPd8GhT21X
	 7oharDEtDob+4xBffukUj8nYdCA9+oBkFF0fYO8oUZKtwPkt3T0AzccG3D7vehwKcsRi9
	 JTasVn8ePCzPLX+bKoJ263AgiI8I0L8wZxItu46CM70gIM6KtLIJGX6Jieo/ruN3Cs857
	 1uvEmg8WxHofRx2rj5uvVat2rAA7bFBItIOqto0ShFV0AdfHNr2qHEVFAODZvI5Ae3c9/
	 QS/o3m18fZ7drqYRvk776+9TNOnPaYYLQ3sDJXkyDG7wGoE0FN9jDEkyOAZ70eQpoOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AVvc8Do5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 689A9606A326;
	Fri,  6 Nov 2026 16:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AVvc8Do5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDE5C1F0089F;
	Fri,  6 Nov 2026 16:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793983037;
	bh=idKupkFOoEuI1D0I9K3dkmHCv5t9EIMzKRFHoVTiEGg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=AVvc8Do5DhEJTvinbNvofpF85d0AnFK5LxSpPNKEK/+RJYxjclOcUMGpO59IMsc6K
	 +l4jcD4d6K9LdExlJpzhCjb6xl4STFFJ0IvJ9zg1OsaKXefPClXEb5AifDXB/m5x4c
	 nwQUqEimaX3EavfRkgtWMSEh1hSzVyo11Qif4bCJ5K4GJDVcN7z2e/+QFgWANs3cH+
	 JpEdlDOiQquvPkJrqUEhRgbsRiAqs0GE0rchsRlfhyj1fpPP/NFNl0xL5Zbd+LAdaE
	 YUz3VR9AmQLl/gkN3WmsaseMVSnvkxZuhMNqDWExC3nfrBNvR1Youvs8lKsDdbc54Y
	 vrclTcUH6+Rjg==
Date: Fri, 06 Nov 2026 06:37:15 -1000
Message-ID: <e53ad4ab8640b5e95bdfaa916da884f1@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>,
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Mani Tofigh <mt4022@columbia.edu>, Tao Cui <cui.tao@linux.dev>,
 stable@vger.kernel.org
Subject: Re: [PATCH cgroup/for-7.4-fixes] cgroup/freezer: Fix exiting tasks left frozen forever after rmdir
In-Reply-To: <20261105191951.3409248-1-tj@kernel.org>
References: <20261105191951.3409248-1-tj@kernel.org>
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

Applied to cgroup/for-7.4-fixes with the following tags added:

  Reviewed-by: Tao Cui <cuitao@kylinos.cn>
  Tested-by: Tao Cui <cuitao@kylinos.cn>

Thanks.

--
tejun
