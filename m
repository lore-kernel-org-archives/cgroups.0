Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A022EDD40;
	Thu, 30 Jul 2026 18:35:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785436504; cv=none; b=bKiPGLD7tlF0rV1AK6YfghEfHyIa8gdaz5U2NWUl74pYeOgylEHJl/t6NZlOjRzDAkoDC4YnMlOPESDvit/7SySJqDAP4AK1l3rw/ZPT/RomWnuYJuibggAlXnoWhpME/YUX8stEOxuRCIqv4ImEQeBjjkI1s2s/Lk7E/RbFXJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785436504; c=relaxed/simple;
	bh=2ldMrhV1ugKVggGGxGNHKWoq1NXNyzXemeVaKlQ0DTs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Lt+Fk58czG02YGeITxH7D1T5DtABgkE50XshjWNlRNtqbKDlYRXwFYCANjBe8Tw+0plEm6UauLuVUol5R+uk/D2qJdyBHmMzDf14z4rCBFRRcrfV7Oxs33RzRortQhBIzjaSi0DZDXOrVau0+m6gQKMbNg91GgJxXtMiCeDZ32c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=htitda2P; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="htitda2P"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4h9yYL6GL9z1XM30k;
	Thu, 30 Jul 2026 18:35:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1785436494; x=1788028495; bh=2ldMrhV1ugKVggGGxGNHKWoq
	1NXNyzXemeVaKlQ0DTs=; b=htitda2Pa84jRhL0ptF2wiOxirvBOO4OcUCa7oa3
	ccO96JGKk2alZ+Z/av07dlQHemaffkVJn4+zTNeoxmCGnIRwcWNLELdIbGqJoXHD
	0AthCXGyaI3SiSgHv1Bx8tfiCxP5v/OAPcyDeWcAE6f6EZVTlxaSmP9aOztQ9URc
	1t7KWDRCy2PpSVVDbA4OeIEmrERTS6Q6m7YckeUpEx3HBzAPV62a3/K7DxT9v6K8
	1Q/SNOOspTDX/5txICnz9Lqv5o++kTHegRzlxnK2JXGU6zThCsBWTcgJb/I7hAEG
	cbP4+8xeOu+3rzyFNcInOEgRCb9Niva6J70DihtEyRdiYg==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id uwqm6bYaInKa; Thu, 30 Jul 2026 18:34:54 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4h9yY44G6Cz1XM4TB;
	Thu, 30 Jul 2026 18:34:48 +0000 (UTC)
Message-ID: <87d2c139-8020-4b04-af4c-eae0f61f5301@acm.org>
Date: Thu, 30 Jul 2026 11:34:47 -0700
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rdma-next v3 07/14] RDMA/srp: Make the SRP sysfs class net
 namespace aware
To: Jiri Pirko <jiri@resnulli.us>, linux-rdma@vger.kernel.org
Cc: cgroups@vger.kernel.org, netdev@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-kselftest@vger.kernel.org, jgg@ziepe.ca,
 leon@kernel.org, parav@nvidia.com, mbloch@nvidia.com, cmeiohas@nvidia.com,
 roman.gushchin@linux.dev, zyjzyj2000@gmail.com, shuah@kernel.org,
 tj@kernel.org, mkoutny@suse.com, hannes@cmpxchg.org,
 alibuda@linux.alibaba.com, dust.li@linux.alibaba.com, sidraya@linux.ibm.com,
 wenjia@linux.ibm.com, yanjun.zhu@linux.dev, cui.tao@linux.dev
References: <20260716132316.1495242-1-jiri@resnulli.us>
 <20260716132316.1495242-8-jiri@resnulli.us>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260716132316.1495242-8-jiri@resnulli.us>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/16/26 6:23 AM, Jiri Pirko wrote:
> Tag srp_class by the RDMA device's net namespace so SRP hosts derived from
> same-named RDMA devices can coexist across namespaces.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

