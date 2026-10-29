Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793294041;
	b=aUT6+d8lcUluFDhb/01V3+xhroXXk5rkEHMcJLLrbvVSS/y2Xt09lX0+/BHP56aEklqq
	 AADTHbeZrIyZRbDeWJNvAPobcohq34wuCzigq4oUkp/LmaCIkX/lGnDuJ9/8Bx2oRK1VD
	 kUsq2dWr2Q09bAbqYR3soomJ0NdazsIOVsS+GuOigLo9d9rWePmYNVKktGcGVAlAytWE/
	 PL9eQaBBZ/d5PiHBuW2VZLmB5mrJcnNM+KAPQKX5a0AXzOrC+Cv74vMAxlhSUimbK1Umx
	 dMxLFDaSG1d5uwuy4Y5JpC2HTP//5+BIkokxgPPs+oSsDhDo5mDP3v3NplD1T/o7mFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793294041;
	h=Received:DKIM-Signature:Date:Message-ID:From:To:Cc:Subject:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=S3Gl2OroIqDa23QeZD7GwfXWPordKgg+mwTbLTbPPpU=;
	b=3oU4jVI70EQNrQrGbBn0T5LEDrTkgzTFKwS1jNMSTldLBruE6jvJw8eYzL7JNk5NglEE
	 Pp/gAdAPuof2m5EM3UQlpYTsVrVraIrVlbGPJDjFjiuejz1roTbwHdmrPuFDH6ikGi8dE
	 bk8bqpb71FAoOdIdguDUfO2W/CFaiFuS+fx/8Gypl609X4U//6jbM94OdfgcQymxdiyTS
	 g4sSRLWjcEPfH8ZEnrGdER/RGgIBfSUl0eLavYI77poX0C5sbThhi4nvaPsUGnvj8c9aK
	 URs57Jx8cGbf613jG/UXbkYvaAklYIReTYzoMAarS3zvwGv6We4vpKEG7Un7vTQzgdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="dklw/hck";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12A90606A31A;
	Thu, 29 Oct 2026 17:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dklw/hck
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F0D51F01824;
	Thu, 29 Oct 2026 17:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793294040;
	bh=S3Gl2OroIqDa23QeZD7GwfXWPordKgg+mwTbLTbPPpU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=dklw/hckDPqsP3hbKsG8Z0lkLe3LYbM85KdYJM5+G3JM7SDYhNoXiSjJ/atqqiN7p
	 EToWWos9Xpco8uzVCQXZQLnGAwTdSA3urq7yTrD43sQsWT/rbVgnpIt+prM+mwHz5o
	 Lq48GClWoVIB/Bivil290QKWWKFoDpIyswQGAP2qqn9ZdC5+P14Nl2hG1lTw78xCDE
	 AIdNPRv/gvPNDZW5eC4Lf1hLpyMLegSLhvin7u/WbrrbChurosRJHtyhmDXP7dE1Xn
	 Fi9Sor2YHrpwjF+/t/1lm1saU8O0JcoI01y3jrD/F985awygGl/umaZ7EZtlNewoTd
	 dz5TkdeAGwetw==
Date: Thu, 29 Oct 2026 07:13:59 -1000
Message-ID: <1aa24cac216bd57faf861684ed93edc8@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Zhe Liu <liuzhe1@kylinos.cn>
Cc: josef@toxicpanda.com, axboe@kernel.dk, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] blk-iocost: account flush sequence latency only once
In-Reply-To: <20261029092424.764545-1-liuzhe1@kylinos.cn>
References: <20261029092424.764545-1-liuzhe1@kylinos.cn>
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

On Thu, Oct 29, 2026 at 05:24:24PM +0800, Zhe Liu wrote:
> +	if (rq->rq_flags & RQF_FLUSH_SEQ)
> +		return;

Can you please wrap the test in unlikely()?

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

--
tejun
