Received: from mout-y-111.mailbox.org (mout-y-111.mailbox.org [91.198.250.236])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8AB28686;
	Sat, 16 May 2026 05:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.198.250.236
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778909168; cv=none; b=NRSxVcUrruQYowc5Gi+dVnhFg4QhSwKY+HoarFqYodRNKxz5+hCtiqki6c7NW9jdcHcMEn7y+pwCkpII1SBnD94bh5z2wwcnhQmBItNSPJ2q5xgVxvWkKOFUgNDvBE+H5MVbW0uAxR+T4pXbDuwQMJEFVhMNPt/F3Os/L9LH/rM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778909168; c=relaxed/simple;
	bh=iwUYzr2lrolxIDfAr6znil4ophVl9S+LKNuwid7LDJQ=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=gdaEn3wgYax53OJnxwVeFV0OFZ63lsWHJQIRacWKCMaY6Vt6jaCmHV6JCi59YBqmUV9fYs3/hTVoAmkTi1KN9UdrtzyGBsHNukaTnGHRjbgBPoaZb9VGl/ZAROsKbSAQEcwmcUP5zkFSiKCFm9rA+IM5zslJSk9wo6E99Bh1IQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org; spf=pass smtp.mailfrom=mailbox.org; dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b=ssRnF9MI; arc=none smtp.client-ip=91.198.250.236
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=mailbox.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mailbox.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mailbox.org header.i=@mailbox.org header.b="ssRnF9MI"
Received: from smtp102.mailbox.org (smtp102.mailbox.org [IPv6:2001:67c:2050:b231:465::102])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mout-y-111.mailbox.org (Postfix) with ESMTPS id 4gHXbb0c6qz9ysd;
	Sat, 16 May 2026 07:26:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mailbox.org; s=mail20150812;
	t=1778909163;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=F4GZ6MzR9uTlRIX3lPL2dZhubaWDGRqsi2Ca8/5K4dQ=;
	b=ssRnF9MIscuQ4wWXAQ1oXk1ERW6mlP6fIr4vbxt0jJnVyhoCiJzoUWKBQlz8sGhweNOweK
	NkzwlpgBm0PGuUpDnr0vCiX4qEbNAtNT3UZc2mcJwU9EN5dk47rfbIn5gisCtbNzss3tBH
	Mt7IkXazqZzLk21svQ6bp8xrBAZDJJE+nYHN7GBkZgg8kB+N4Cz6ACQd8tZ5/B7eDNi17m
	YHMe02CNtyAV/EYr+c0/G7yuT87mbvWqUJXfEDfwjc+ujJUwWkthdtHAoaPcc+844pHIPd
	NpSy39H0whduKzQM+tBqz5XIy50et7jdJViTZEFnKssAyVpNUVFAVtFpX+NyEQ==
Date: Sat, 16 May 2026 13:25:58 +0800 (CST)
From: Ming Qing <a0yami@mailbox.org>
To: Tejun Heo <tj@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
	cgroups@vger.kernel.org, bpf@vger.kernel.org,
	linux-kernel@vger.kernel.org
Message-ID: <86414803.635817.1778909158261@app.mailbox.org>
In-Reply-To: <agdJWXRZF_pRgggt@slm.duckdns.org>
References: <20260515122952.59209-1-a0yami@mailbox.org>
 <agdJWXRZF_pRgggt@slm.duckdns.org>
Subject: Re: [PATCH] cgroup/rstat: validate cpu before css_rstat_cpu()
 access
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-MBO-RS-META: ciwhgpiigxy7udfhb38dkrp8dmbq1xen
X-MBO-RS-ID: c702c497082c168aea0

On Sat, May 16, 2026 at 12:27 AM +0800, Tejun Heo wrote:
> Can you please add this validation to the BPF kfunc that's exposing it?

Sure, will do. I'll split out an internal __css_rstat_updated() helper 
and keep the cpu validation in the css_rstat_updated() kfunc wrapper.
Internal callers will be converted to the helper in v2.
