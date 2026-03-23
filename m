Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0560726F2AF;
	Mon, 23 Mar 2026 17:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.97.179.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774287440; cv=none; b=u9cxjec6qJhEbKEHOhB/JVOvi4r7fio5dH/1wilZyAfXaNiZIsqwpcwdXgPxw+LM52J4jmJkyWYhF7ILDMq1nivObcIb7ebvAAUxROO2drjNOZkLLPlCxYjTFbzL+T/KJkBpvvFnpwQHnIi5Ff+nnx7VK0i/Bwwow7U+pLRxud0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774287440; c=relaxed/simple;
	bh=puX5TgWvejyiLt5zpT1fl1p3IhIcHcMCHEhk+lKbi74=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bhZjP4NrPttmM2Fn8/VORQvxPJ6VSHSOBtI1AiG5fns/VJEyiJm30HFe1zRSr4GoO/FA5WO434kJ0Iocsk3kVVjNt9kFvk0l/nxn2c/iQjhCzDEON3FHeRcl/kKIg9CY5z6MinSHg8KgKl3wVNFsj5i99GbTweq8Up7tJaWyZWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=lYcAXcDJ; arc=none smtp.client-ip=213.97.179.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="lYcAXcDJ"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=6jsp5pl6BE8AiZ+2bUPvf03tn1StSlT2dkeyW+GDIIA=; b=lYcAXcDJ2E0KqgmaGG9Dncypon
	sKaX+qqRNMQkrQi66KUIK88RtztRuSB4Bv0qxrKG7PCX2otW9+cVnye1NaS2ZKi3102XYFKBST4r5
	CcrmvigIFemAPeFSuTiXJIE18d4ASnyGaVvHzgseZf/rpSsi/I9LebgP+JXpStmfpE1girmbFaoFy
	0Dmzux80wj1oD2EBMGleGsVuSQ14rxxH+svV/T+eATIF6MxsW9Z0nSn5uDwK9YRytaYbmvd0Rcn5z
	iOGTLnm0OE2KtpH4GYHTfVIB1AyJfhYtp2ws8c8g6UHhfXZhZoxvtBSWdzGNG24mxqWHz34ZIK4AP
	QVtBZHWw==;
Received: from [177.180.73.242] (helo=quatroqueijos.cascardo.eti.br)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1w4jD9-004ynB-Cy; Mon, 23 Mar 2026 18:37:08 +0100
Date: Mon, 23 Mar 2026 14:37:00 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
To: Maarten Lankhorst <dev@lankhorst.se>
Cc: Tejun Heo <tj@kernel.org>, Maxime Ripard <mripard@kernel.org>,
	Natalie Vock <natalie.vock@gmx.de>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Koutny <mkoutny@suse.com>, cgroups@vger.kernel.org,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	kernel-dev@igalia.com
Subject: Re: [PATCH v2 0/3] cgroup/dmem: allow atomic irrestrictive writes to
 dmem.max
Message-ID: <acF6PMV-aezq3dWc@quatroqueijos.cascardo.eti.br>
References: <20260319-dmem_max_ebusy-v2-0-b5ce97205269@igalia.com>
 <b099d9248df084fed8d4252e3c6fc485@kernel.org>
 <88f89d75-1e1f-4457-8c1f-57e934c251cc@lankhorst.se>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <88f89d75-1e1f-4457-8c1f-57e934c251cc@lankhorst.se>

On Mon, Mar 23, 2026 at 05:46:28PM +0100, Maarten Lankhorst wrote:
> Hey,
> 
> 
> Den 2026-03-21 kl. 20:27, skrev Tejun Heo:
> > Hello,
> > 
> > Generally looks okay to me. One comment on 3/3 — the naked xchg() in
> > set_resource_max() needs a comment explaining why it's used instead of
> > page_counter_set_max() and what the semantics are (unconditionally sets max
> > regardless of current usage to prevent further allocations, since there's no
> > eviction mechanism yet).
> > 
> > Applied 1/3. Maarten, Michal, what do you think?
> 
> Yeah probably drop 2/3 too since there is no longer a case where setting a limit may fail.
> 
> Kind regards,
> ~Maarten Lankhorst

Actually, this can still happen if an invalid region name is given.

So, one could write:

echo -e 'region1 max\ninvalidregion2 max\n' > dmem.max

And even though setting the value for region1 would be applied, the write
would return -EINVAL.

Cascardo.
