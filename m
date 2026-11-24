Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.215.179
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795506564;
	b=nLQhSjXn3sF0N6sOxfU+cpjXbnWLE/8m8OicFhA8iF7+D5HPBqQl7cQHpz8Vk1OsYzD9
	 2i8XhDznctPCxJ27QZY2DEbhfI9HjM3egbhTRrod7rblRkxCj0poAV62l/PLBv0jAuh82
	 Q9NBlkY4jIAE1qVZFtnWUru4TDHl8piMQL7vgHLvZ7B6vcLoNA35hc9ZbOEXHZwYFrQlK
	 XhMvmuImT1ssMyncqpsI+wFJ9kD9S5l7f47loqnY+/vRRCX/AmA9QjaBt3RSE+UMmhi38
	 BAWkmv+qdw9g34+buTTPCxv1K+AAMgfesGx2rIn+kc+FdhYz29BxXzRu5JUwg04m7ew==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795506564;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=n0TL+yVGklLLhrdLGL0kexane9if3aUzjRd+iXnFC4k=;
	b=i05lpcuWFM2bJoST2JVPBPdSmsRGOjha6T4wePxQUP+cpnhls6hDrcX7OiO7GGosVycA
	 V90DMhAZ+G0DN1tyv8swCMwAwpRs8DOVLpgvBYOdWCQ75nnQU3eku+eR5jSB9TIQ22avD
	 rJz/8aLVbFbbPjptLTtDQf1HmAJCMhMth1qxtelDPkgLGZ/mxDeP0LESxH0WELZOe7rFl
	 JdRdao9mK7vRMNMEZifvlZs8Oeg8WDgiLLm+GYhbIRy4YAWFYlKWXOep/h7AoXtuNw1Da
	 4cRL1OLYjOQd83T9bmLntwAoZxQ29LotfD4Qc6IB6iEoZwcTX99QQvRdvGUduDkSjLQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=shopee.com;
	spf=pass smtp.mailfrom=shopee.com;
	dkim=pass header.d=shopee.com header.i=@shopee.com header.a=rsa-sha256 header.s=shopee.com header.b=W3N2DPRu;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.215.179
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6C32606A321
	for <cgroups@vger.kernel.org>; Tue, 24 Nov 2026 07:49:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E6C32606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=shopee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shopee.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shopee.com header.i=@shopee.com header.a=rsa-sha256 header.s=shopee.com header.b=W3N2DPRu
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-cc758830601so3229853a12.2
        for <cgroups@vger.kernel.org>; Mon, 23 Nov 2026 23:49:23 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795506563; cv=none;
        d=google.com; s=arc-20260327;
        b=ki2184xTU08aWO3VllR4Josm1qZZaA9XE8RFkKMJMiC7ZcP8gCFoNvOQ6i38MJaVmT
         w/91weDAT5Jv3Cjc/ufhQ4/OVJjuHlwdod0mkddOxvKPAYLbHKaGrN4JxAX2+9HsUwa+
         DFARhmpOThO6REzqD0/3nGeySnvrrCFjQncG07gQ4jOMYSkDGWjo4xr08w49UuXrlsAf
         0fnWchNUMLeVmkVzYWiXGk/eHuQYw23PtBleRS8GVcii2mIfwZz+dD2KxpQWHdhVyN8n
         TWOhLa1Wr2De839odVzMKkRHIvw1AE8eEWbzbS7a1sv9kbt60J0wCqrW8g3GRq8DoSKU
         6AjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=n0TL+yVGklLLhrdLGL0kexane9if3aUzjRd+iXnFC4k=;
        fh=Rij0zG1ON0wEyzCXiyJ3pcafwhvF9C93YNr+iUTkewM=;
        b=NelUcX1s4izbFUml/wkEpXMvb3JFImXg/C9fANyY5K+m5u17PYPjcAr7hNyGNw34j2
         Pl8gnH4MNJiQAFUvBVZ8mwbHWfZBQdSSLiD/zwaN8EoqG835gGeHS36M2Js4dmXlmgIV
         HmiXAo8w0kPyBqxL0YFogmX3e/xivz2+2M2iTRK35KYQREUBF0E/NqXGePVLIeCwJCz8
         9u47sw8PDwhcqTJkmgBhxDLWguJxHrCnbh1BTauXV1LrRmD4gih5dG2Kxb06vo5UXd+/
         FVugBqgI/JZ0qXPZM6HcAXgiZ5kB0ZZfs9lfHutLiC4y0bD0XEEKYgIRE3prmXlIymhF
         GhTQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1795506563; x=1796111363; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n0TL+yVGklLLhrdLGL0kexane9if3aUzjRd+iXnFC4k=;
        b=W3N2DPRu78zip6w6cR2gB/Gd4UNMZrAzgVamoAKhxOpJOQUxf//vbnDLLla34M0YnU
         /xLFRNrfDGME3JfNZa2mVS8WH8HsZZF1NkblmUveHIT2bJsM8r3f0Zhibsuc3lXyX423
         GKnEE5ySn5JCo9Wa85HaYBlQRm7r0mJACt9fycayTaPkdd79tN3DuaZpCxy4a3Ya3k5J
         2iWxz6Ow3IARcBsU1+vEudxxSuiAu7AkBja794dPTdlTjllgVlLKkeBCzlgGMEOs2IE9
         QepU2hgVtwsR2aW/uRVFBFzfHnCDLgNL1SmHhFUV3NGAq8mzufBGU7aNJsxyG1NDQW8A
         bKNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795506563; x=1796111363;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=n0TL+yVGklLLhrdLGL0kexane9if3aUzjRd+iXnFC4k=;
        b=vnn3WBjrP7EGuOX/QiO1H+1czo4DZf40I4nU092iALsholZHHdNCoV+ybwhTiRYpwE
         m+CpqushK71ksjEVyJnKbSP/m47lXtBE95pfZH23F4/vOc/uE/O8J6U0sDZwpEW+yyB5
         xj30JgsNuOxgb6MfYwtLbIJ2N4MZ7Dnb0I7ruFYbl9onEje006LVvkKIzwzXey0Wan4D
         maJG9Yuzm7GwWvbXRZz5SLDiq4hjdv/CooP1AWkWgSmhBwNt5Ks/dxl5hM7YNA9Z5Q++
         vVPkOk7Th5BcCptjLKYIxGXOpm/MKFaTZm2pcTFUHrtL+3kyR6JnPUsML2x20ySxgh0a
         zvZQ==
X-Forwarded-Encrypted: i=1; AL+hErGgru6ig9o9BOlo6TEgLUdTHdpg6ecCeHFh6PeWgJrqneGLzTxQ24AwNTAj1Mp1gFhsusU1Bbk6@vger.kernel.org
X-Gm-Message-State: APuU4Z8SkvvR34YCyf7F0Tid4vjd0Er/2eemmkk+WDcjgo8XYjunrt64
	o0bxVArM8pRL0Jh5PjLfDRHjx7nNBn4IZfBH/hKbGh8bT5LSFZz1FVIY3EenJvd7p7GKyU/qfFr
	4Q9iur9pq0RyraJB8WMPLuKpM9DS8KP6h2BIIzM4j9w==
X-Gm-Gg: AZFdTZf3tzCo+D30tYz3Fu5e33CZfid/FdUUCZmqCbTUhPZ2A/qPAjGllqjNDE9w1xk
	UoNWpU5SsnoSvDr//8894Q7q/ImG73ncdW5tfBVYE3ZL6xDA6Dn/c18VCU7Lo1/eWGLBapLSCBg
	t8/nWfbfnE3VmVkJPkfjWBtytCev/GrQIQGnmUPizExC/n9o98cHO/dU6540WxIy5QXJISMBNfx
	O1ErbHqKx/iQ1MmLZLa8TxuMv1RvuwRIQMkqJc8Y1sFaFQLh0jR+F4cvlF/qXxMo0/f46mIdzT5
	fsVLvpB0Y7VKwA1AV8Qp0miet2Z3ibkQrWkuBqLdlCSX7ZnjDYqwH33sAx0nt4tT5NY0quE84US
	Z5WPHvFo861dH7OHTrkqumL3OxryXGL4Jm5S6
X-Received: by 2002:a05:6a21:6104:b0:3de:456a:6e07 with SMTP id
 adf61e73a8af0-4014db601a8mr15842288637.46.1795506563336; Mon, 23 Nov 2026
 23:49:23 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261112041348.66915-1-mingyu.he@shopee.com>
In-Reply-To: <20261112041348.66915-1-mingyu.he@shopee.com>
From: Mingyu He <mingyu.he@shopee.com>
Date: Tue, 24 Nov 2026 15:49:11 +0800
X-Gm-Features: Aa3M54ryVpMrYWVp8M6ME5vLlNPZfM6KixdhXQemQYg3UvT2_MftgFTVs9Eosq4
Message-ID: <CAAoBcuSen--oRubdaC3OPjmt4zCL2WDDU7-nbqPPReeMfvmyTg@mail.gmail.com>
Subject: Re: [PATCH v3] mm/bpf: Always flush memcg stats when explicitly requested
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, linux-mm@kvack.org
Cc: Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Yosry Ahmed <yosry@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	littleswimmingwhale@gmail.com
Content-Type: text/plain; charset="UTF-8"

hi, gently pin this email, thanks!
