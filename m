Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794892062;
	b=jTe0xAfjuDFXWYfUlyT1UtebP6P7xzdUdABSWDpzDeHuNlLEhsTtjv0HLhwUoe5jYvSH
	 39kfaEE6Wlvj6Sus+9xGnuJjjcZpcBAG7ha1uNhLmFtNpyAmoAU0XDEANa+CxzaRR6D84
	 XIIpuiSShFHCsdmoNGxbW9YBkc4i5vMj1TeT2DgTGKLx1jvDdCKlWUsk+5TcPVUc7xLnb
	 zLOddAP6Gwzbr9TJAnsJZDNrleYPiVyecthxeiojphQTdBFudfASeFyAB9GxTSTKZxUIY
	 WsnZEwYIIrrbZkJ4ZFxA492gWFCkc+K+L+KP72qXBQn04nEXfDqAD14A1fx6pw221ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794892062;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Message-ID:User-Agent;
	bh=erZtH4IJMudy7WQUbT7BdWCH9j2OmGrPuCsVrI+Funw=;
	b=4cCaYWyIg/gugRD48Euo5Lo4+bmP6z6Lx6CZ1R6nZwRwpaZQzYV2h0s4Ks/ivp11988N
	 gx4AJvTp6pxCiVKU6EjQXvEDPHN9lZ0N85SnzjU61Ij00VLPc7b0Hz+2AclbnPk+EeCDk
	 Ew2Q2JwytlEcvXAZ60gEQzhBSFdoWDNuy5J/PBYhJOtxkgFkLFK6sn49+ChDpV6Ayyw4G
	 fDDhQ+SM5zVuDBl3gfbSxXoz2gLw++N1OUxTi95/Ulf4ePGbxZ+ja2sQiAg8Hs7n8LtBw
	 AK1ve14JYZAfDEJvyTuoXCjPgygwEbKkdaZM35DPsMM97OyUOu6JSJsKjGr2P9PQWfg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chrisdown.name;
	spf=pass smtp.mailfrom=chrisdown.name;
	dkim=pass header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=kDJalYGa;
	arc=none smtp.remote-ip=74.125.82.181
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D99606A323
	for <cgroups@vger.kernel.org>; Tue, 17 Nov 2026 05:07:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 89D99606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=kDJalYGa
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-36f8cdd30beso7053109eec.1
        for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 21:07:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794892062; x=1795496862; darn=vger.kernel.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=erZtH4IJMudy7WQUbT7BdWCH9j2OmGrPuCsVrI+Funw=;
        b=kDJalYGah/KtbmZ2wtascJniSuHLlgKvpmT6qZOgrrzm21LczEDzLz0aUr2tA9Nigs
         L7vgosxIxyW80BNJpe9PTxhXLJQKBPAlK+NwsV5zw8nEHvfTfmAwgEwd/l8UPSFj5nFa
         q6sS5k9sSlJigkkHO3aJnwLGF+tO5V4C+GVvA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794892062; x=1795496862;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=erZtH4IJMudy7WQUbT7BdWCH9j2OmGrPuCsVrI+Funw=;
        b=XjsQS4R35iZkI7WF0e+o3OVW4tFs+BBl5tEZF1hh9s8PPq7ov5twQf59CjUZTA++Rx
         lr3Bfbk/X8zukqoir4f1Hdbth1aJaSq+T387BZmaUm2Fos2Nj6KAE1skY7y9GpwFjxxb
         JfrGTAmO9E0t/cqj+YJ6fwyA7zMNBgYfYdMNZZu/yjVuLPLIw6lY7lVWzLzW1mW1Yamm
         yIyVjT3ARmVeMDLVhGUsxs3dcRwkEcZZxV9+Cx24Hk/WbtQGJEaRV7bHdFJqeLUvlB31
         401hrnlJebnqbGoIfuFOl6XSmfTta5rmPsz4y+zw3KfGPTU2z2YYIbXx5RvqkK4hixg5
         txDw==
X-Forwarded-Encrypted: i=1; AL+hErG7K2wjQg9bcz4/yJiVke6x11zhZoKvQTqG4TioBFwipl/Czor/iOe0FYUCWZ3uR1h4IyGq3Mac@vger.kernel.org
X-Gm-Message-State: APuU4Z9nrr4fOOPlxnyz7Mk39+hyM/ztFbLn0aCIEBh+IhqjrILpfwzk
	29MBPsAnSh+rLNJ+ceIaqeHpsFN/lGyGfxA4GPx2SKVkAvzauosDbs7Bz7pRz3yaqj8=
X-Gm-Gg: AZFdTZc4MGE2sRVKzs8cpyewMdDZiaJAlP8V3GXLTdy3mlk+iXCV3yNMuumSNspGaKD
	CNyk3m6mDeEpxRqwVoO8f9HDnykLS0j/Lo1OBMUIpjgeNG+DuabtD7ukCURbA/YjhL8tZxqRZ49
	GEXYl3ZrKwuICvHbcSODv1h6QK3h0MrSBzf/FYiZrl7prQyXCT4Ha43vmKqBOuqIWIwq7sE3tcR
	SG2WkLYneU3Ox55GBB9TDjJTUTjdko7TpniWPzoFgwNX7QIrSRv7Cuc1RK8AvpdQBmYaaxdzCrN
	jx+T+8raTr1PPsXXHBfdIcODhrMBhXYSmKUTlm9jzR4Hq+cid2biiv3dDOK+qZhZUscUVVC2Pbv
	XYVFXiJDy5p71WiWWoaND2X+Qd1N0minFdplEBoL2cfQ9usBmsaYGEy+fVk8dDLnTFACeqpzE+5
	cq9CQm5v5RcodbdUrDzuOZgIR+x0iSVPIfOa9YNS4Yu+BJqZovw06vua7DJfmlwWbal3ENNe/4g
	CBqDZFohcxG7pAGzRwVJP2gL5d5NgPU5gyWG/Af6SHDfAomS1N06ejqkbgLCw0RMV21QhP3QpI8
	Ye6xa7Q7w6J5p1YWnqybMHzAALKXHtMCd7reVBFGThUg3uzy1TVktILceZ9DEeODHqnhZwy0h9Y
	dKIBWUDxCdt64Fbb9HpLz9Zq2Bu23mHeAExar+ZX9VayzfRz9EXNvdCTYJrmpyjEmheElMVlLtC
	5vSHTN54wmgh9nj0+Un3YhketmsN9XTSIOtTjy3U7b4b2ikWa9WMXmamqgLxBxXj2c
X-Received: by 2002:a05:693c:6383:10b0:380:d1bd:ed2c with SMTP id 5a478bee46e88-380d1bdeeadmr2109515eec.27.1794892061684;
        Mon, 16 Nov 2026 21:07:41 -0800 (PST)
Received: from [172.20.0.3] ([172.56.235.113])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-380e031f3e5sm7128627eec.12.2026.11.16.21.07.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 21:07:40 -0800 (PST)
Date: Mon, 16 Nov 2026 21:07:37 -0800
From: Chris Down <chris@chrisdown.name>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, yosry@kernel.org,
	mkoutny@suse.com, shakeel.butt@linux.dev, hannes@cmpxchg.org,
	mhocko@kernel.org, roman.gushchin@linux.dev, muchun.song@linux.dev,
	nphamcs@gmail.com, chengming.zhou@linux.dev, sj@kernel.org, ljs@kernel.org,
	linux-mm@kvack.org, cgroups@vger.kernel.org, damon@lists.linux.dev
Subject: Re: [PATCH v3 4/4] mm/damon/core: use node counters instead of
	flushing the root memcg
In-Reply-To: <20261114002822.1043378-5-joannelkoong@gmail.com>
References: <20261114002822.1043378-1-joannelkoong@gmail.com>
	<20261114002822.1043378-5-joannelkoong@gmail.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Message-ID: <avvhGYhjBrOzAmT_@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)

Hi Joanne,

I've tested that this works well.

Reviewed-by: Chris Down <chris@chrisdown.name>
Tested-by: Chris Down <chris@chrisdown.name>

Thanks!

Chris
