Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 443C131961B
	for <cgroups@vger.kernel.org>; Fri, 27 Feb 2026 12:51:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772196702; cv=none; b=F/FwVKUhl+Ty5iXCcr8xSYbcLIfaFZ2CaPYZjPWhJoaSJ+wDQnhs82XcX8Io8kRVtpIqo2QSALPD+BJmxs3UMXr3ysK6/+LZpahnJ9hMIE3Even7AwN3FziaH+2K5C8yMAcVgE3+iIClm210IcZnqPMnI8hclUnDMvvfUV2QFtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772196702; c=relaxed/simple;
	bh=UiOExHwzPgH+a46X6Lafnzd0iwNqcF99JpO1VfaFk6g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QkKOtPEV7IEAnhwmX7hE5MRUZQ+dSaDFSUfIvjI2s6S3jR2THWIjnjZZH7LdGvXjBxkftPh23J1Bzqf93T9+TsYw77gDpIMfvIKrs8Z0uJTg1GeK1GXnk4RvfcFQYmn+WDupziLzY3nFdmjepSy/CKd7E4YPCLKljPn3eVzY3fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=WnNnk6ta; arc=none smtp.client-ip=209.85.222.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="WnNnk6ta"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-8cb3e0093e3so190456785a.0
        for <cgroups@vger.kernel.org>; Fri, 27 Feb 2026 04:51:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1772196698; x=1772801498; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aJsL5ft8+uR36go2nZZ3KkNMsYpE/8dDd7y8kbPIygc=;
        b=WnNnk6taGLfSyse3NXarTcsKgYa9cign4AIBk6jLFihgslnu/ip9PoeXd0aLpRQOjD
         4Su8CqDUo40VEjt4MhjXyMgeLB7GpElOIhhHptbwOMYb86DfJJXU+JNSG5cFcmqtrvEq
         jzyEHuc7Evzb/SOoZXnywGvZ2pq1V6ew5UsIdX0MCsmeVvc75+UvT2TVY+W6Z/5Ir/ca
         BG4bUEea2pvYIQSX0UcjmUGrQsUEW6emjbJCqjYveT3UCC//KRSiDLKL6IKqmKcq2lNh
         SUuoW9LPPn33FLTZd+dastxxDZzch7J0/+zKHAvPkJ7OcECChyP2WARTCkDZOTYtsNKn
         J+Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772196698; x=1772801498;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aJsL5ft8+uR36go2nZZ3KkNMsYpE/8dDd7y8kbPIygc=;
        b=A3uPhp1CcZPMxjpJeYbBAwwYGeFYXsd35Ro4KhcLiC+PUkAqMqAOoP5BpOkqL5oXdK
         gHmLiOqWzYkzSc6v9cOyFb4FA/VLfK9FEEL1qp/egokUXknS+KqJxLAPfClYU1w1FBdN
         U3qmct25ZARinJgrwh9XVHX3oy5jEVgc3+IHOLe95RbOKjObYiBWpjfxioPWt0fgp3uY
         cI0esYFHpvlqXNCeQOYQsMP7FzQj/AFnuYoOTeuZteJQwzR4bj9vKgR7kxBW9OltbdG7
         98YLK8jW6fLYB0+ohAQLJkgp5Y8EE5KPm8jfXJdUF4HkVFLnPxL1NJRimhhoyQdQqdns
         4NHg==
X-Forwarded-Encrypted: i=1; AJvYcCUUXW6WQOAGZije0i+p3FwHolYr6v0hFGor5lSGS8gbcNDAiwXNVebLHcI5ojNaRhZLiuL8QdWk@vger.kernel.org
X-Gm-Message-State: AOJu0YxBgIThArHLGtoC6jUPVPvUawCAV5VAK1pkhAAkBrY6OALzXYek
	gF4t1/GVxxZnTBgfjLUor3qdOT3A5nJfR0oeVSjZOAmam7kf4s8DIZ7vTX7jHQBiYMg=
X-Gm-Gg: ATEYQzyQbMezsUFbI85UYty/Sa7b3uTuC1+xW2G35PWrtIis9aeFqHUdUhP7v6nbFgQ
	20tsk1YQYzUcbZyUOOSwClbwx2gyvqWCRBOTqazoY8lk6JUl7zUVi2Z3kA+HMTfcxvM6ss3Qrzd
	bK8S44WPg8U7kkQlv/J2i7B3P/KE/nXOPS8c8nlq6TeI7/raraZbZaM7llNFb7yJeNm1HSuVKiO
	2lmfan8EBY/kqKzhayg0bjaAqs8V8P6kYwOUslQhAJoBQxMxYJR8HlKeZivVZJbGZEKRjQfJ5aO
	W4YG4RLyP1lP6sgGFgQ9JA+QOodBEvaB2+ruvHykn9iJSYcNQyA6fmV0Y3dceQkOSrD6Y2fr4Je
	w3oj8PA0whxBFpiu0jfqCIl1vrDm3kXSlYdQLorbOt86bikyhJJ7wDO0/VTpeSw2mtIL7o2uKBV
	5+3MnzntjzNs3u+ja5dz9oXA==
X-Received: by 2002:a05:620a:318d:b0:8ca:3c67:891a with SMTP id af79cd13be357-8cbc8e0515cmr303454985a.52.1772196697812;
        Fri, 27 Feb 2026 04:51:37 -0800 (PST)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8cbbf68b014sm472521085a.21.2026.02.27.04.51.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Feb 2026 04:51:36 -0800 (PST)
Date: Fri, 27 Feb 2026 07:51:33 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: Hao Li <hao.li@linux.dev>
Cc: mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	vbabka@suse.cz, harry.yoo@oracle.com, muchun.song@linux.dev,
	akpm@linux-foundation.org, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] memcg: fix slab accounting in refill_obj_stock() trylock
 path
Message-ID: <aaGTVWumz4jYEx9L@cmpxchg.org>
References: <20260226115145.62903-1-hao.li@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260226115145.62903-1-hao.li@linux.dev>

On Thu, Feb 26, 2026 at 07:51:37PM +0800, Hao Li wrote:
> In the trylock path of refill_obj_stock(), mod_objcg_mlstate() should
> use the real alloc/free bytes (i.e., nr_acct) for accounting, rather
> than nr_bytes.
> 
> Fixes: 200577f69f29 ("memcg: objcg stock trylock without irq disabling")
> Cc: stable@vger.kernel.org
> Signed-off-by: Hao Li <hao.li@linux.dev>

Oops. Yes, I suppose the contended case is quite rare (this is CPU
local), so I'm not surprised this went unnoticed for so long.

Acked-by: Johannes Weiner <hannes@cmpxchg.org>
