Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4CB243376
	for <cgroups@vger.kernel.org>; Wed, 15 Jul 2026 14:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784125010; cv=none; b=h0eWrVMiZLzxyjIFZloD23s+8OG10M/k4jT36GBbKuQTojuO2WlqrNAnm9mdRzEQxtiGoYQmTkMH3vttwLwV3LPtSkmz8Hyx7G+/6r9vKQSKNMceTynK8nOMBeEc392xMsS+wiVXTKfW0ajlHmSGARHKW+hIwHWwzCIb+ina+uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784125010; c=relaxed/simple;
	bh=zQHM3QzchOFIv9Rpou7rLuSS0PcEoJv/CFYU6JmRYjk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JG2bxN516pt4mEVH111xkDf4lb2MhoFD1h3VsQUST7y51Qp+u5lBhvsjNGecbu4YMmufuUYKcrPaO7C4Dbp3MjlU23Zcq+2McMWocR/jOTGCzslcn7FFhxOKrNDOtRoyo/btGgebTu/a33blhag0FC7e10KRBg8Tr2V1B7OJIow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=cu28IpWG; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="cu28IpWG"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-493c19bad03so49230495e9.2
        for <cgroups@vger.kernel.org>; Wed, 15 Jul 2026 07:16:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1784125006; x=1784729806; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1MJNOxKF1qvbceJ+OqaW7oAQYVVR7sf9h12hLrWd+LY=;
        b=cu28IpWGF51mBEvbTAk9RaqauHFPi4sBYVIc9TtHiNOTEw60jA5LQ5vT63S9cUwd1U
         qVxROL68AAEWcCaIFVeVj6RDZo7j4mgr7oeARqiqHaJXMA3tv21UBDhdD6IBgKj2KSQj
         vrlCwyBtuY/c7IBS0fL+E9BlKdbKhWr28eCdYLNwkSbhXYvbxFpDVuSCBL9YCGX4+0PU
         RuzPGmqkVCNLa3jYOjot9++MoXwRrlsgmzbpJ/Fuc0ECW4LklOo8qNuBbqDJL8NB705P
         0Sa2Af4S2A/UMWyhGsRoNaRF2qjdofokg7pq3spAqAwTcTWrwG0ogtXbQx+hx+k3+Zdo
         WUhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784125006; x=1784729806;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1MJNOxKF1qvbceJ+OqaW7oAQYVVR7sf9h12hLrWd+LY=;
        b=IbBnb13be0itK1Lsx9oGFRyCfx+Ok2oaVBJyZjlOkCldBvKWvXihQkcS1THJg1K/Hz
         0bvDX9cHa+Ea4fGCuxbQ3JV388vftJvTM6Gcb3f026poy6GEmb2DTcFkWJDGTgclkMrf
         CiPLItSw8CSgfl3UBsmzg/hkoFZZWl0cRYV1Nqn7YYETqYnZIGpmdjHTF3XGnt1M0r7x
         6Ot0quSKIETFFXh1HDQG27HwQXxTXIsFkWpigxp9N7v7jqUquoOSWfJrs8mwKsblR7qN
         e8owk4L6/3EwMFejV1ceRO8phBc1U4Ae6t7e5PvWesQu5bNYlczfcoeOkzaEIS1TnOsJ
         HBqw==
X-Forwarded-Encrypted: i=1; AHgh+RrI8sqY2P6OzV8ZCBEe8yqvKXZQASHiRnjm4ngKOKWZrdzENoEdmXlH06aY+Up2kB18dAiRP2La@vger.kernel.org
X-Gm-Message-State: AOJu0YwuOcccCq+louTKXb8YYc9awQYTckweUHEpJIl7o8jqyt4XI1c+
	IPOF3TwReuL5R2ACvlMkOgha5j2iVgnYorS/XpSruki4h3JrBq1yLBQilrqQ5SeDmZo=
X-Gm-Gg: AfdE7ckWrOp0/rc+asbunoSbwv/ljBznwJ0brqeKuVEUhRKr4J+gBqGYn794p/Xrdnx
	Opy0VswxHpeEbVpNfcFzWHAIE5TJ27lpcKOHkY3OMkgK23QUvzr51lp6NISTW3OrbwA8iMh/9bN
	q4ACuiT8dkyG26sF8X+2Ij2WiQrE0YGwSP2s7JDTLc6zDks3k2OBpcMJcCvrzK9ugiK7kUEZhOs
	Xlg8CtIlr6iUdUtqp0UVMsD0nicWTB0HWm7vPe3FYVRJivKZ/IlPaIzt2QUciwf9M17XARqXnun
	TYyWCO8aU3GdKN59U/xUJRe4gMQJvFyvRovrut4nVNsVs3IvEzpdZivHp9YYv//UCRM6vn1OYdI
	I3WpQb/eAmVy2bENPSPwoy0lLEm/dG7Y4oOXkECk3EQthF8lWVrkDBlRKkIgbPqob4xRCjlNzlX
	OvESBt/BPJJZaw3g==
X-Received: by 2002:a05:600c:6298:b0:490:e5c1:b8bf with SMTP id 5b1f17b1804b1-4953c16458emr36915115e9.13.1784125005577;
        Wed, 15 Jul 2026 07:16:45 -0700 (PDT)
Received: from localhost ([2a02:8071:8280:d6e0:1353:8eb8:c84a:b6d4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4953c6fe0c6sm53336375e9.1.2026.07.15.07.16.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 07:16:44 -0700 (PDT)
Date: Wed, 15 Jul 2026 16:16:43 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev,
	axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
	chrisl@kernel.org, nphamcs@gmail.com, baoquan.he@linux.dev,
	youngjun.park@lge.com, roman.gushchin@linux.dev,
	muchun.song@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
	rientjes@google.com, kernel-team@meta.com
Subject: Re: [PATCH v2 2/2] mm/vmscan: reduce lru_lock contention via
 vmstat-derived scan-balance cost
Message-ID: <20260715141643.GQ276793@cmpxchg.org>
References: <20260713163443.3562378-1-usama.arif@linux.dev>
 <20260713163443.3562378-3-usama.arif@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713163443.3562378-3-usama.arif@linux.dev>

On Mon, Jul 13, 2026 at 09:34:17AM -0700, Usama Arif wrote:
> @@ -323,6 +323,10 @@ enum node_stat_item {
>  	PGSCAN_PROACTIVE,
>  	PGSCAN_ANON,
>  	PGSCAN_FILE,
> +	PGRECLAIM_PAGEOUT_ANON,
> +	PGRECLAIM_PAGEOUT_FILE,

Reclaim generally doesn't write files (anymore).

You can use NR_VMSCAN_WRITE for the anon counts.
