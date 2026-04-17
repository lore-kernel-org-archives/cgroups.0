Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44EC3D3008
	for <cgroups@vger.kernel.org>; Fri, 17 Apr 2026 17:37:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776447459; cv=none; b=QmFLDMTV0WxgDDiUTnGCRfl8palmX9U4PTxS8fL5U+0FdN1trj6oBxedXKHy+X8NbRWMrlHpzC3WFi/OXud/kDZSuUqqrQw+LHaeXPJalF6MmWbkrpyR9nNHyCB/oEyOVwVBj7eVed0GsjOMUa25gs8lKZx1NL0T98j0FD1EP9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776447459; c=relaxed/simple;
	bh=UScojqXTSjWLmywHUY7uE9UBQNVESgyJRXxoaWRNSBE=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References; b=uq/kiGfcHc/6JSn1tg4PUQj28OvvWDbzSR21QRdATnj7jkYV2HUfTEkXowzVK873JCCW04ghdwKc01YVaelwh4SE7EFUEzzZGLef5U70cJ6uSX9gh2K4rDO2bcynbswTSzRGGFv+9JoecThpVL+CoaGi1ldMPXw2VrercmFHqxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YVMCN3B5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YVMCN3B5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6887C19425;
	Fri, 17 Apr 2026 17:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776447458;
	bh=UScojqXTSjWLmywHUY7uE9UBQNVESgyJRXxoaWRNSBE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=YVMCN3B5G2Nr07gsU7eEq/d1TNRYkL9DxvjSl+BzXOvboz1HuR7n31WpNrITk3xpZ
	 xYW/bpnsgYcsBPrOvfSqFxMX1nCQ1Qw3+gZrqHx1f6ox3+4I3Mk1aQfWeYvUZqZua/
	 jScJHaoFHuexXjhtgf8mGb6sge5MEe7AVmIKc4OmvKg/xo4ZdAZn1khAQBhyClSHZL
	 pbQY2cWMAfZ1TgBn6dKIzjk41XAP6lzJYSQ04fVRmVy9Z+OlWpNLqC5xp+uLo5Uma6
	 ejt2UwecYhpoKI4JSeP0zyHCpKumzpzcb7LTGRBVlzlYvRvsfrBxSuTBlda0RNxO1J
	 XDF0G7dZGNADg==
Date: Fri, 17 Apr 2026 07:37:38 -1000
Message-ID: <b739e918a3d0c0f0c4b129078f9196e2@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: cuitao <cuitao@kylinos.cn>
Cc: cgroups@vger.kernel.org, hannes@cmpxchg.org, mkoutny@suse.com
Subject: Re: [PATCH] cgroup/rdma: fix integer overflow in rdmacg_try_charge()
In-Reply-To: <20260414015327.306721-1-cuitao@kylinos.cn>
References: <20260414015327.306721-1-cuitao@kylinos.cn>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

Hello,

> cuitao (1):
>   cgroup/rdma: fix integer overflow in rdmacg_try_charge()

Applied to cgroup/for-7.1-fixes.

Thanks.

--
tejun
