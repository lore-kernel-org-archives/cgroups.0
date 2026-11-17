Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794953878;
	b=fys/i1Q7ked4+32RH4nZtz+Sfky6N6kGFteyovWnoqPO2fD8Q9iYW5A4fXaHzwiV9Hbi
	 zinmipKCcVa55/QRrGhHq0ANJFrDqUtGOdeGUbspaYPc5v7HbgIcp4YvtgLMoLDCrfH37
	 vyDVm+gL4T3lNPcA7emnLI4FhSno90+7BHna7414UKQfCVXV9BZoAkcBc3ygF34La5iOp
	 JgC4knCVhfhU/Ra7/VPaVdGpXLor/lY2UbF59rEQhrgr8w+rmFpZF6r3hV637Jp5bnEGH
	 pelI15PJ/XARy92rm7n22uJ/9GkLfc9/3VUvGWa3kJckdk9a4hI2jftgKuQquRrfqUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794953878;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Message-ID:User-Agent;
	bh=IjjsahCYIJUHZbHsxd03sCHundy4Xa36e/V5rB3U47I=;
	b=oGl54BCRMj4pAadzmM5B8YdC8VaayFicQpOsmu6X/oJcO4cKojgjnck/fkwI8kNzL/9L
	 vVwtvqsKTG6Tx4c1Oyw0T6aOK5ExJyzaJnHa3FlNYBQHX3lmB73zzoS+NqXIUt1F9v+RI
	 neis+xFdtybgeg8OyIz/dcLveTJYr0rjvdwH/cWDp+uq7ZbHEn95FOEovZ1F9SGdaeM51
	 Ft+Xy3I/C4/JRS+AtxINYs1n0FToGzGozYtpuM29wNrmxYdUkk2Hx6otjLe8PFkG47Zvl
	 T0vyq+yc/cIkUv1WrSGPBxBjoSNksCQYaHLL6bdkdo4+XchkTKOjfJVq//wME9pr41g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chrisdown.name;
	spf=pass smtp.mailfrom=chrisdown.name;
	dkim=pass header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=vAydZqIF;
	arc=none smtp.remote-ip=74.125.82.179
Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00744606A337
	for <cgroups@vger.kernel.org>; Tue, 17 Nov 2026 22:17:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 00744606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=vAydZqIF
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-36dbde64409so731084eec.0
        for <cgroups@vger.kernel.org>; Tue, 17 Nov 2026 14:17:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794953877; x=1795558677; darn=vger.kernel.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IjjsahCYIJUHZbHsxd03sCHundy4Xa36e/V5rB3U47I=;
        b=vAydZqIFP/9rlDRfkh7lLpdcKlXJwK4WQj7ppIcnljq6+mFmRKvyCgleijxuGji2yA
         Rt/up5m4ZjEM9kq4DunuqjOBuhYfWfGNQe4zXdst99NlYP9sOB2qfNFtshRwgldZeles
         q4Ic+Gdrj8IjiyAEaBxFVaVRzJuKTgMZdiXuQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794953877; x=1795558677;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IjjsahCYIJUHZbHsxd03sCHundy4Xa36e/V5rB3U47I=;
        b=AQkgordZAxFXDLDg+3905EeCPkrHLAuAm7Qk19A33P7KRIY7svFBa0/qf6tC/Q5LJl
         2or2+9FFolntEOz+KwlcDgUnk2+CbPZ7V9IEU6/scsGtO+T9WxEM3/nxdzfkuGKlk5P6
         gL/qh+9ownKH/QO2xLJW3Nnn+oThixM7EZ3utb70ATXXxHwL/S4t6owCR4Ui8NfYEluf
         g8Y5jmmtgGVvylqrsIR3+6upcN3TNUA31uQhHJ+mNMkPrn+Kr5PBdViAJnQ9ZQjaKynK
         gjQdcfP6aPxAujJsM7MwrOq7Zohgt7PcnS9QA4+XhYQ/Ox2NkoHW5IkEg7/GzlTlWJgj
         eV6A==
X-Forwarded-Encrypted: i=1; AL+hErFbpsRllaqQvXZMdaEZoTRGFsc0hTv+spIrZU8evBsN6b5d5X5hedvI9SFq1bX/MyRxjx5VuEjx@vger.kernel.org
X-Gm-Message-State: APuU4Z8VY8+Adef0VwfSVMuUHsHc99mbtB/Z4Q4hwSlSym73AJ6f0ww0
	p109Da/HrkvpP5cDsQTUlhzF0CLRWsZOuLGza2xA4mOa3eIMq2ZDlEhoPtxvyiP6R2g=
X-Gm-Gg: AZFdTZfKxJ9USJ1F0VcK1nLnO8gwNp7OR/SC61hNxIQ6CNlOSPlFEDnC61vU0dR7SBw
	b629Mht2+Uip/w3RaNVH/llLKIUlwuZpIg5Y/ajm3MaSWFWypNlHqtc5hzGYzMPfr1cx3ORZf7I
	mraJie35QdaxVe+hIjjdoLsOBlzgL/6NepKoclCWZMvCrTHV68FY2RXCADiPNywf+Xl8Tcr7jUN
	6i6Kp8XaCtejx5P1FdYayyvMEAh4TGeMvmId8Ys+9VENPZDil2b4nHgZB9DcHXI+Dihnzw/aTO6
	Ls9PYTOnuG/6/iLNvULPAZeptv6sMLXNhIMLGKU1RtOuoGIAqFzjnQS75IhAWhHHKG5SP4J+mRR
	DHBVrtlAfLG9iLmjst41hBumTibWHVnmjXqld6Lq1IZOfU1I6O6m+v2LMQcbtxt79a7x+mFb7Tp
	rVu2uXv9a0cahm7CLemTfHvo6XJL1ZHfpCTD3jRWoV5NiiRfv4aq78inXWGAI7b0cQMyHczTwFT
	D+XuZCf07Y7M9n4PxqH5wR1GCJFKUeSVwTmvY9wRbodkon+LYQeXvOxFa0lXVPSCVNqRF3qua+j
	Tn6ow+V7oA31QRGJxCWKdp1bKjofglyj+FU0nuYSC8YQkkqqwLCYnmD7uPkxR2sdQd4OUCeFPn+
	yuMS51GdulvdCQtD7Rv/fKGcHY8VItUG0ga6CfaVS79fZURj6wtO2EHHhiSs1KJip+UhNO/MYYJ
	N6k+PT+5ax7TkPwlrXEslRbhvDfgfOG2NsH/m9mR9JzVBbUTn61QyegsAlIV7oqgBu
X-Received: by 2002:a05:7300:8a9f:b0:36c:9fa4:dc5b with SMTP id 5a478bee46e88-38280b39afdmr671672eec.23.1794953876891;
        Tue, 17 Nov 2026 14:17:56 -0800 (PST)
Received: from [172.20.0.2] ([172.56.235.113])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-382a72e52easm810151eec.17.2026.11.17.14.17.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 14:17:56 -0800 (PST)
Date: Tue, 17 Nov 2026 14:17:53 -0800
From: Chris Down <chris@chrisdown.name>
To: Hui Zhu <hui.zhu@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
Subject: Re: [PATCH 0/2] mm: memcg: fix memory.high allocator throttling
In-Reply-To: <cover.1794902513.git.zhuhui@kylinos.cn>
References: <cover.1794902513.git.zhuhui@kylinos.cn>
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
Message-ID: <avzSkT9-jsCrMoeX@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)

Hi Hui,

Thanks for fixing these, I've verified that these fix the issues
reported.

That said, Zhang Jiao sent a fix for the same two problems a few weeks
ago, and Johannes thought the overage cap there was a bit of a magic
value, which we have plenty of in mm already, and I agree we shouldn't
add more [1].

Could you please coordinate so we don't have two patchsets doing the
same thing?

Chris

[1] https://lore.kernel.org/all/auNrakxaET8qkuAn@cmpxchg.org/
