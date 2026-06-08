Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F247832D0E3;
	Mon,  8 Jun 2026 16:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780936666; cv=none; b=pS6DpFRZEDcRbNzR2u0iyzWmWEIat0NaZ0tLAfBXZ568sN5IVx+7XJn42wAIqBCvQpCpfAtT1vRdLJPXO+dq33Nn4cCADQQOjVG0AghowacwbbTjGseSSBO1pGLvVu7o2fqyQk7B4n/7rzyzJHfvHKO88x+5GypNr619rIoDVpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780936666; c=relaxed/simple;
	bh=XluZQvNJwzIdMIShW1d7zjlSPj+Xxx0P+P7C2V7SFJY=;
	h=Message-ID:Date:From:To:Subject:In-Reply-To:References:Cc; b=NVWIvBAnJq6QvKzxxRXkL4d0Av/qoCunc8gyKw+kXRIUXo4iaWByXDWq7Mor2WmJqVmhZaq2o/79IVzIMw/etqjAAFBFnftOzn/U11fJQcL7wZUDrtF/lxncbtO+JxnAdQYTKQdizcWlAIBbmj/+p49Qu3bqieiYYdqxZuG1YwY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=I6niaMOg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="I6niaMOg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6D561F00893;
	Mon,  8 Jun 2026 16:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780936663;
	bh=92FbV1Okgp8r+Sh0xvK1D17MGvbjqqbutVZw89jzoNg=;
	h=Date:From:To:Subject:In-Reply-To:References:Cc;
	b=I6niaMOgfMIa88cpbcCXUX3j+YvXFwsh9XGbccX6l0LeHNv/xkywkv/qht1Q9fhFw
	 ekHpDl5UVYTdQoTTaEDaZ1FoTtqFNx37Gc0pn2U9bLj3f6wHLem7LML+vUn/g/bj9W
	 2h3wcp1xFYtaqP6Rx9JuaC64BZ349WKcIuuPNYHHjQnBQEfzoqoNCrd/cjg+u3CaHb
	 a+ceDefpIbZ8xhGztkedW31HSolGi/eLoc5QkePpzFXp36SOxkUly8uSU64qxwR/n2
	 qtXlECxZ/8ZmR7dhVciV5joBE5Rmw7idY9fX279f3wModnbhlmaaxFRehqAF+77wna
	 qXbKU2bwn13bg==
Message-ID: <17557800bc330c00d686411486959af4@kernel.org>
Date: Mon, 08 Jun 2026 16:37:40 +0000
From: "Maxime Ripard" <mripard@kernel.org>
To: "Eric Chanudet" <echanude@redhat.com>
Subject: Re: [PATCH v2] cgroup/dmem: accept only one region per limit write
In-Reply-To: <20260608-cgroup-dmem-write-single-region-v2-1-b0cd6c4ccf1b@redhat.com>
References: <20260608-cgroup-dmem-write-single-region-v2-1-b0cd6c4ccf1b@redhat.com>
Cc: cgroups@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, "Albert
 Esteve" <aesteve@redhat.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Maarten
 Lankhorst" <dev@lankhorst.se>, "Maxime Ripard" <mripard@kernel.org>,
 =?utf-8?b?TWljaGFsIEtvdXRuw70=?= <mkoutny@suse.com>, "Natalie Vock" <natalie.vock@gmx.de>, "Tejun
 Heo" <tj@kernel.org>
Content-Transfer-Encoding: 7bit
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>

On Mon, 8 Jun 2026 11:53:51 -0400, Eric Chanudet wrote:
> Accept only one "region value" pair entry for the dmem.max, dmem.min,
> dmem.low files.
> 
> This changes the UAPI that otherwise accepted multiple lines for setting
> multiple entries in one write. No existing user is known to rely on
> 
> [ ... ]

Reviewed-by: Maxime Ripard <mripard@kernel.org>

Thanks!
Maxime
