Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794107974;
	b=lrbqYONqTQke6J4+kDBCqttrcLsleDliK2fwMD4vMcPWhp4TohNmQXS4PznqD5PrPkQV
	 S47XsvTyb35vCAgu/HqnYgvaQMsSSk7ZE/gxZLlMl8xj1YVVC2VYLhMO29YwzIKcBj2MS
	 GgM6BEfy4Q3FhkNV59MO9xKsg1WPCBE3E7udwHHyuv3W4CFU8OfJOFyTHa8M6aYwuneuY
	 G+Ty3Kff9Ve3KsX9s1lSedR2vXdVPya+3cwqCROxw06cpQd63T8WjWFKaMDixmuNoGv6H
	 sTnxTJ0I+EgMHKv6WOjBwKCSHYeIyYVfB1nohmWPPIhPeubu3QXRwTMmd+9CQQ0H43Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794107974;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=U6DLFlcbi1+1eg52kgp9yC9/Uu8qOaRC/eauhKtdYFw=;
	b=I+ysrT5tRTaJAoR5FNdysi4Y1mCGyKaNAq6pKiW94Pb9P8rPwEZRsmUShUOtGImfdWmk
	 25iee/geouMStDpQu9XfLh0ol+lWtnyRZFLPdXPMaTQBxwpleUGuqW5xpywarFFtgc05s
	 3pkjGkd2tRzRvUJsOr7RnlsdcmRQKZyRyTJUDe+6k7lnJRCy+R+3s6WLrfpS4zyHyavZ4
	 apaLUz00/gzW4hMhiRs5K6K74XGSY8ONdCWFdrOX5r+7wZhBsqe53dg8hWQ/+trBn5uPr
	 cKoaWOO+m9ZKc4OMzmvGrXdLZ/ZaQhDGFKX1ZoZXR9gw6MzfAuZDMK/gfhhGwtzs6KQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chrisdown.name;
	spf=pass smtp.mailfrom=chrisdown.name;
	dkim=pass header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=viP2cPCz;
	arc=none smtp.remote-ip=209.85.214.182
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4B3606A31C
	for <cgroups@vger.kernel.org>; Sun,  8 Nov 2026 03:19:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3A4B3606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=viP2cPCz
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2ea138a3497so730605ad.2
        for <cgroups@vger.kernel.org>; Sat, 07 Nov 2026 19:19:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794107973; x=1794712773; darn=vger.kernel.org;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=U6DLFlcbi1+1eg52kgp9yC9/Uu8qOaRC/eauhKtdYFw=;
        b=viP2cPCzbkUz+X3QzbH2tTJwhuY9cFphK1tDdoWqtLoRTY9RojjKMgu1VZbQHgIapA
         AuyynEdlpk7o+voMko2dFlGaLSlsnTIdpVgy5BrY0nSHCzk8b/5f2u+IQ7rFOVSQu2ZU
         SiKTcK5xSVvTL+xUPGa56wy2m4RtbGrVnCE50=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794107973; x=1794712773;
        h=user-agent:in-reply-to:content-disposition:content-type
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=U6DLFlcbi1+1eg52kgp9yC9/Uu8qOaRC/eauhKtdYFw=;
        b=RJVSKcnbE17ecOoA2yUVN9fbKBuwAKmgvIWBY3wAr9KqkoDCANhMEfD0S7QILnEqXF
         PWrPwHoAcJCXDs8IqrwXZJ9JdJELBMtunHdck3Rq7dAoFgpiQfitg+LjYm3itWbT8SzY
         H9FfilgPt2Rahqd0F3zYIe8hYYUV90QDqr8YNVRb+w6mRh1VsVGFgFBRd6z6e8ZbA0hH
         IOLqhOZI4QewL5YOjiiIdt/6gfSkuDTb9DFFXOB4BDWDfYsuMXoCYaDjZQA7eWGpK0nM
         I6lBiDvpAB1Pu5WOs/w9k2ZO3Q8zMw64MKfO544wLV9kMhaJahMdVE1zcy7nHkFM7z3Z
         GX2A==
X-Forwarded-Encrypted: i=1; AL+hErEVTobpTQYw4gn/+cYz4Egiv9PBg4ByG8C6Z0hey4f6ZMCv32ThK7crcuVsS2c7xR1c2MBvL+Hk@vger.kernel.org
X-Gm-Message-State: APuU4Z/k0uxI//nbC/feiJfUc6FhKHkiIn4FcR4ZQM2M1XA5CW73j97s
	s43Rq+a/ciMEJun9DknPAqU/YAN9G3+cbGdMpeTBFXNV0tLgdrXzpvqNoBlsrLcKj18=
X-Gm-Gg: AYBFou1Li5/hUlO4ugfGq8L2v9v2CvjYasID3Y2p+XYDkt8RA1zIneORqAGytM7xeWr
	K1ZfNB4ebhxqB60WByzt3CAkHErkT33+YeRKiAm+c89XsLTIw6ayrlwTFS7k1iAksDYN5z0NesM
	Chw45jS/VGa/6UU4OzMlWGRM6r9UQQIaZ8421pCpHw9AZ5qJyZKFsyBfRsimZVOfVsbgkbjRB1i
	+3dKQx+R+rLcDyIaL5jxyCDy7qCWT2gVHx0J9FucSkFtb4tSUDrj4VZ8HgiuWEAxTC0b+hrZ8gu
	b8IqhwelQd0sJjHccWRjiq4dnN9pytWJmNgJEJNWqNv2QIEde6r8FlwHkZA+nzz/onJtOtsDjeN
	dCorBxNAqU0kdvfAqrPerAk6Bk9ZNaH7DPnufniSX1N2saWD27ZT3WwOvkpHFzhYcpz8fX568Pn
	IJZQfH8BvX+BoL05EKhRp6f0y92j+xeOBmvkRUmRTqr128QL7VPFxU9uUeBKZclZUPWu+S7lxhH
	dVpzTlYIcuqTKoBdssLGKzI26+iHZZ2VAwUXEi/CYsUcS15ZhjKNn/dkkNCWOO++wH47ASRecMf
	YC5JcR6NsGSEz/eDYr00U4QbwU34T3KT+5ZgqEdS8ceeB1NAUFaK7pW7a8/fmtg8aIpaxF3ayLS
	ojLLyTw6ZfNzO5EiIWt0Ft4YksJRwbfgsFXCCOQvDmXg9MnUevDdlusN5LqSh6/AuXRo8Z4126F
	qpFKjMCym8ltIrPHP8RyNBKrrpcPzs0CLY44kdPS5EQZT9OPy3JS6gKA==
X-Received: by 2002:a17:903:3c50:b0:2e9:3f41:4212 with SMTP id d9443c01a7336-2ed8375ee02mr4790015ad.13.1794107973499;
        Sat, 07 Nov 2026 19:19:33 -0800 (PST)
Received: from localhost ([50.175.87.158])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed815e7416sm1411875ad.17.2026.11.07.19.19.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 19:19:32 -0800 (PST)
Date: Sat, 7 Nov 2026 19:19:31 -0800
From: Chris Down <chris@chrisdown.name>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>,
	Serge Hallyn <serge.hallyn@ubuntu.com>, driver-core@lists.linux.dev,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH] kernfs: Build paths in linear time with respect to depth
Message-ID: <au_qQz3C1yNFRLOL@chrisdown.name>
References: <au_pnu4s141ylqHD@chrisdown.name>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <au_pnu4s141ylqHD@chrisdown.name>
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)

Chris Down writes:
>Fixes: 3abb1d90f5d9 ("kernfs: make kernfs_path*() behave in the style of strlcpy()")
>Cc: <stable@vger.kernel.org>

Note, I am not sure whether this is worthy of stable. But I have noticed that 
in some cases this build time can be pretty substantial with these locks held. 
But on the other hand it has been like this for quite a while, so maybe it 
doesn't matter :-)
