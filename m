Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AD293F4851;
	Thu, 16 Jul 2026 17:17:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784222236; cv=none; b=R1S9ztxaJx4bNGyfwTwbrBv8XcbB7uznw1LWnV//8iG3m+hkLpD9hqkB8YIjPLya0swqZV/QqhC901JE21q5C9VgntgLOrEFpuBbuX1jDkZLoBuvP5HliuU5by3l55lF0tmJUFSxJvtrTIA9FQX+w5B+ZQbikta8SzgrBFT4l/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784222236; c=relaxed/simple;
	bh=hHizop6TFz7B43wKQB8RZz3TZNBsJRkMr9GmKG36umk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MJ6fjODL+wygNuHVUemMKSH0lJd2I0e3NKTg3SrjKSO4IS8YVpxDCSeThEKSHQAWlSPc0OoWBQL+6AxoV/aDs2ghiNB1zS0M4TAJmhYGZ8OLNhYKr55GFb2aMVPFj4vrLRI6TEePlfS6L548rr6g3VNtgKBpLWOe/vaPxOVwAkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=MSTdP8go; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="MSTdP8go"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4h1KTw3ZFKzlh2rk;
	Thu, 16 Jul 2026 17:17:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1784222224; x=1786814225; bh=hHizop6TFz7B43wKQB8RZz3T
	ZNBsJRkMr9GmKG36umk=; b=MSTdP8goCsorPsMX6woQbcDKwvnBCSBvqtwI2ceB
	p1NIRDqWpN0GZzmJm6189asE5Rclk2SgN/m+OmEtXN6BtrsslLlio/J+EHE4zaoT
	Dnz4aEtLdyRtcS+5cxEZBL+61n6eSA7eXTParsI0H0C7Sj2WEryb0aj1XHdTTQkV
	RSiS32GFptW3f/+6e4aHPxnyx9eNmSy+2DkmfIt58xPsZaw3VXD6oUa6SGBqwiUY
	oE9UT5eEickzaUq0lT2Ffz1twnwtAwbUlCgVXTzML0YouO+KbjVzOhmDt9UbWwMI
	SicwHEKfsHoxisiH2dhquhwareIWn6685k9znMOpglIUbw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id FT1UPYR79nwg; Thu, 16 Jul 2026 17:17:04 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4h1KTp39FSzlh2s9;
	Thu, 16 Jul 2026 17:17:02 +0000 (UTC)
Message-ID: <1832a339-a7f9-4c2f-b95f-22cdaed41a42@acm.org>
Date: Thu, 16 Jul 2026 10:17:01 -0700
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] blk-cgroup: avoid 32-bit overflow in root io.stat byte
 accounting
To: Tao Cui <cui.tao@linux.dev>, axboe@kernel.dk
Cc: tj@kernel.org, josef@toxicpanda.com, boris@bur.io,
 cgroups@vger.kernel.org, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, Tao Cui <cuitao@kylinos.cn>
References: <20260714063118.1153083-1-cui.tao@linux.dev>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260714063118.1153083-1-cui.tao@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/13/26 11:31 PM, Tao Cui wrote:
> Every other sector->byte conversion in the tree casts to a wide type first
> ((loff_t)sectors << SECTOR_SHIFT in bdev.c, (u64)max_sectors << SECTOR_SHIFT
> in blk-settings.c); do the same here.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
