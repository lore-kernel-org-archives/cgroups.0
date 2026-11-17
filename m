Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794913914;
	b=weW/8JJNp2SkG74lCXF5G4hasMaJBTq31JhmGvra0eTOyXBbGi2nIilG7SNoNusptmth
	 qDJI50u7xiVrHuBy+Um5HCbWARnMrCJCUlpVGKB3z350M1RSTYIzP44Hp1ZchuLlo75KT
	 D27UEeew1zvVGly3S08XqwGPiCrZ8+8m0yBjFG3nLAxp0LR/xhSjULY32XJV5l9QcjQPv
	 u5lKfOTxJ/EAx1y93JQQqK7g32tdpJJTNB7qovWqByyKlxjJ7bP5YRJ0fQ/U9Dr6TMCFB
	 fuma67vuN8vMwZ2Avsdnv8iYRHP+O+5TmzvjWHheeP4/Wc+KvICRb8xoYtS1uZIfrZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794913914;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=Kn42LlYA1UZYSbOfHBABnjOJ0sk0wIks9BO0RA5nM0A=;
	b=F+Mb4+0wuEyhZKHQ4GQ2B5ZRjFGJwXJSfaMb7ObURtb4sZermAcWjYqfqzXnYKK190Hs
	 rGqd+ABHW4gaPySZpVvJ8c5DanZZLuqyOgTCe3lQENBjhK0/YAnpNdHBlVICn6MW1KY9q
	 eyCHAMAsiU2AI5LU+d4jqqBarAHJsXb4cWZBauCm9dayf0QB9Uruif5YSAO0xClGwGty+
	 b1jhFZUeUiW8YkQBsk6Y0cqv43nfeLxmI9oroaiNJMbRJolIWFBTfEayaZ+N3dEQewf2u
	 mPA/LPqNCQc9u/jyGevXTW3mZXRYoIFzthZ7l/at2hly32FpIL4LaG32va4nTpqBu7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Xoti1UPF;
	arc=none smtp.remote-ip=209.85.128.44
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36021606A330
	for <cgroups@vger.kernel.org>; Tue, 17 Nov 2026 11:11:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 36021606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Xoti1UPF
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a2d6d01ecbso28602095e9.0
        for <cgroups@vger.kernel.org>; Tue, 17 Nov 2026 03:11:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794913911; x=1795518711; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Kn42LlYA1UZYSbOfHBABnjOJ0sk0wIks9BO0RA5nM0A=;
        b=Xoti1UPFBkdCRg1wJtWTgJebl78EAyum6NLyeXMBjInnZaQf/BDLrKBM4H5EV2pAbF
         JwJa9I/jgNtrlVjyDfXH5ba/6o7AuiKyQ6j2vsMKPhcKxey8wg2AgZRFgIXcX2+I6ahJ
         SHmQBoXdxhciovY1Ye5hau4B4nfWWhCOUYdqWwcOKyv775YEbeaQMZu9o8mbR5ruwqO/
         6ytdBWC5TgHiIiHDmqq5edAwW89whsEt/RPFB75zzGVVfDAU4nghMIT7Hq0vdnedX+FT
         QvSs1iDc+mCxnxCZgWLgStG72s039JqZc6jQpztIauhYdyvksGa2irDhTqAOYCLGgRTy
         ls9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794913911; x=1795518711;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Kn42LlYA1UZYSbOfHBABnjOJ0sk0wIks9BO0RA5nM0A=;
        b=dUrcMvFzNkL1f9PO7gR4m2cKae5/qEXPgada4y4CaLMT5JN4UF7fungWNn5a73ZU3U
         ntMzptcipXkAQ3Y0m0iGpfFAx7ZrCIJKhi9p55v96zTSojQ0UXTJ6UWS7QiTIAYPJwLt
         Szdy+mFoyvp+/DiGjgFHAlwsbBgVlH3z5LfQtfAhiIG0rFGN7TNp87ElImnFg39qRxi4
         jMBK762dv8ZTHIEe6aGQ7hxLHj7CwXPqMFowQQ0UoD6l5Mq2S6oWmW/W/S1cGtQwEdT/
         l8yFHUHfM4Yte8+W+nf+H5Z81XBrAhHbAdPgEBK/ZslaZTAqODT403ZnuJKb+5Ho1ZEq
         37tg==
X-Forwarded-Encrypted: i=1; AL+hErEelZNYwQYHd50wfqDb0hr1bD4x9Okxiq2+kqREoU8OAXkPZjD9zYeVVC73awc7EaWFlrgog2C2@vger.kernel.org
X-Gm-Message-State: APuU4Z9ViL/3RDUwe23SawYibtYoerxCNTO8D2BkGoLGRYr684iYk62T
	Fhw0a1ywqb5oMlQyts6bjEaVFO3n+OQGzVdqB6oVMIkgJCzITblEx7AI
X-Gm-Gg: AYBFou0p/7cClKqNLEZ79LdMpVRsHVSY8TN0R163Imcy6628MaCcjdtIO0a9ypBtY0T
	jOnaWykakN3kJxHCUDUb+NRJzIvI48gY83KLvTSPXeLRiUQ0N+GH1+7ur7WZO9lhN+hcd9x+Yeq
	cL6GJ3q1twEpyriEvt7vIAoVb011ttGAbAtsRLMhS2WMj9+Tb+W4Dwhr+HLUXzYlgsHAt8Mee+/
	xJJlOqiAo40A0wb+gMK2poKnVozfAqd1pCTgFdw/KgcFxjmw8SZK7Zpo7PkdKTeB06aKMb+lMQH
	BanDNnYltqH6Bum9gjW7ED88n64QRPzkhCyeK/cZPEnkpxOs8vfaFkq2yLecNFMnbrjaqlyGBqR
	7ZcSVOUJYxIT2HVq7LLVEsgQjx6w6twnlpJ5R0bbnN9evokVFqW4wL4qGUhTTz6XjSvE1+Ir5ce
	RUkkU5/r90LgFi0cRFL28lLD384s/VmLk+ATWPS/uwATWdRZDGHPZFEPIhIVJzc4T/Ra37r8zAA
	S8xoeCx0QKX49pe8aIuQp5hxSfIIrfEb2Xob/79vGRAp5D9uqIiZhmqEd/6OhBFRhVGsD6X43TN
	0Gw4vyH+bSn16LQwim9QqDldQc6POhvkjiHOm7/cdRorqFSaqeuXdIr19cepVsKFhQV1E7MwsUp
	PBXl/HHO7VPMfOKKE4w==
X-Received: by 2002:a05:600c:4ecd:b0:4a2:1655:87db with SMTP id 5b1f17b1804b1-4bb5599d31bmr293588205e9.0.1794913911432;
        Tue, 17 Nov 2026 03:11:51 -0800 (PST)
Received: from lima-fedora (eduroam-269-3-018.epfl.ch. [192.33.199.18])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-49d673ce75fsm20642423f8f.55.2026.11.17.03.11.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 03:11:50 -0800 (PST)
Date: Tue, 17 Nov 2026 12:11:48 +0100
From: Mihail Mihov <mihovmihailp@gmail.com>
To: K Prateek Nayak <kprateek.nayak@amd.com>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@kernel.org, 
	longman@redhat.com, chenridong@huaweicloud.com, juri.lelli@redhat.com, 
	vincent.guittot@linaro.org, dietmar.eggemann@arm.com, rostedt@goodmis.org, 
	bsegall@google.com, mgorman@suse.de, vschneid@redhat.com, tj@kernel.org, 
	hannes@cmpxchg.org, mkoutny@suse.com, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, jstultz@google.com, qyousef@layalina.io, 
	regressions@lists.linux.dev
Subject: Re: [REGRESSION] core scheduling latency with idle load
Message-ID: <avwzqWkw9dJMYlkw@lima-fedora>
References: <20260605105513.354837583@infradead.org>
 <20260605124052.227463677@infradead.org>
 <avt_mdiPQ5gwAisa@lima-fedora>
 <add0d6ee-c28d-4274-b8d1-58638abac47a@amd.com>
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
Content-Disposition: inline
In-Reply-To: <add0d6ee-c28d-4274-b8d1-58638abac47a@amd.com>

Hi Prateek,

On Tue, Nov 17, 2026 at 03:52:15PM +0530, K Prateek Nayak wrote:
> That said, perhaps se_fi_update() could itself be optimized now with
> flattened pick. Could you try below changes a try:

With this on top of v7.4-rc3 the reproducer gives:

  kernel              no cookie  cookie
  v7.4-rc3            53         3290
  v7.4-rc3 + patch    53         54

(p99 in us, same machine and config as in the report.)

Tested-by: Mihail Mihov <mihovmihailp@gmail.com>

Thanks,
Mihail
