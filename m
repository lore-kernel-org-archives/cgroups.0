Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.171
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794892054;
	b=wxzEUB0Dme79+m5ZKFFe49qFwboi+A9+p8w1j5rJ7qlfTZ9XuABP0uGIqsPTaPSfXmNs
	 Rm1bU/g4m7kGb94U53kXCzF0QUH0tNKPEdImSd7AqCig6wFNljGyJBE0R5V6DEhN14YNF
	 aJhC9Ve9/5VDtdrN/rq4uP50Mb113rJtnVlbEW6F/ufYX0zIsio94CHUbG1DZymp/xus9
	 /RvaRRA57XCYOElLhvTIVJGBiq64CYmln+urfdNdpSCXr24vt9X69rTd2Kr96x5M7Ij5d
	 q37lF8qYN4SvCWFt97eOLKGjZ6NjHWyRyljjjF50ooDIBwrLJf/3aqddaLdrkTRka4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794892054;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Message-ID:User-Agent;
	bh=OTaK1OORIix+uAUUdAoZK7UrfRWre+LYMnS9mqriEQs=;
	b=JPsFCszcxGhfZ1NHF/vlEMALCemLculPHKa/EKzoEghQ4IWo/0SucIAmTgk8HGcaF7nP
	 8hTFtZYQyHtXuGTMhr8DsLjssxN93oxWlosVZPuUVlK1Ak2Le+H5FcH99mMifyVinJ9i4
	 psFxsns8MMu7pcFzo89GOJywXYm36tQ12KC7tUgrCNA+2YD8HI7gbTCmml92u0r9xWSbT
	 YEIwhYWxLZ86h9zCHfjCUureYgGsQplyk+Dl4U3LkNHZU/No/wecksK1LuzRdpW/zBDBH
	 7CKtjB8JDHveJYjncc6haUDzqI/QZrmxMWDXhsqjYSxUJFxY3yR1etsptFc16P2wnbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chrisdown.name;
	spf=pass smtp.mailfrom=chrisdown.name;
	dkim=pass header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=fc7Jj+2H;
	arc=none smtp.remote-ip=74.125.82.171
Received: from mail-dy1-f171.google.com (mail-dy1-f171.google.com [74.125.82.171])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4B8606A323
	for <cgroups@vger.kernel.org>; Tue, 17 Nov 2026 05:07:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4E4B8606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=fc7Jj+2H
Received: by mail-dy1-f171.google.com with SMTP id 5a478bee46e88-372bdb942dbso3811495eec.1
        for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 21:07:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794892053; x=1795496853; darn=vger.kernel.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OTaK1OORIix+uAUUdAoZK7UrfRWre+LYMnS9mqriEQs=;
        b=fc7Jj+2HFcah6/+Ou7mReMEtkQkYkpONafrhLeeua17q3EG5Sv0J1fhcSFqUoDhStH
         jPwK3FZRvpqjKadyIBoLwwTy+9PnJiS7ToO7Ktwtd/1rQN18gn/FEyyMH0zK2syHEVQq
         nCvSr4wQ56TSLbfAXAVN5v49lGR6p05Lrws3s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794892053; x=1795496853;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OTaK1OORIix+uAUUdAoZK7UrfRWre+LYMnS9mqriEQs=;
        b=xINJjzMlp7b/A20VTbNUG7tlVxlCaeM6qdhGlOSQz7RX7rjLC7InPvyn2smwn+9DDi
         5hnpq9IsRWNEI1k5+x/iyyxUEvm6VkqbqGrp5LCmXVF51pa8DLNZH+q13M332U/2GUhZ
         D7Fj/2tQmotRPyoLIdZJnOSj0/Prz4yqo+BBkwdim7gBXvoaRmaHhlvzTHL0aaYBRM7J
         zU98OcC2+zaGMp+N7bj9uKVPsRJkhAFA5ze8Xj4r7CJYRxFhnqSWo9jw/78JUvk80Ihy
         XlBTSt9weW7bONc+CP0ZRqLA3WunnfH2LJ2R3zPL3JRnhj3hdfgZDz8ojAmbgqMTzAOS
         JJlw==
X-Forwarded-Encrypted: i=1; AL+hErH0xfaK06MCugULbR3RTK/18capDW3B4MjogyuXoflAxvHjXbvuTBbRvukV0CCcV5PeCXUYPgRw@vger.kernel.org
X-Gm-Message-State: APuU4Z/rQECnwzHGgWd3w+tObflM1IMXBb9tbIbu5EzP9+IVG7aenL3w
	5cWNBw9COeyoumJqpU7oVteF22TnkcFdnW79imly7hgGCeol+oAhD7xwZaYT+nK4rR8=
X-Gm-Gg: AZFdTZfos1nW+VKmZ5lgtRDpwb1WTF5ZuioKJACD3j/DfUSEB/HuDx8Dqc2AhondKpu
	PM57IE2dGolY/QC7F/84nguYMCGJ4w06YRxcPx1EiXbuRvWapc6E55KtZ55CBjvRE9LQs9BEZKR
	aybgFONVcpMAXXcbW4kC2T1m4zBKDodWA/rodmd9F0ECA0mL/kDpcIrMyOJjAybvgDFMIp3gOcC
	D7ytYNfZIzRCV7Ply6SGIvtC+PZ6YRqFk4q84EnRopFqxVdK7f7hKJ8ohgJMdtvY1hD/NT0lVId
	f4Tk1c9SRrpn/9POX20vgqdeuCVt989OugBWkveUe8BeaDBDowoSYogCE3ONw9foh35d6+wotWi
	BjraC+Un2yW31I+vjj8pv5eTp8HcvVgryyyEoGFJw846GW0cGWpj7VDsCESyMsu2JwYMoL7uTLD
	9OhE07kv20hrcFm2YRHGdtYexyZ0CQWCMRRmpjG/E3Dbt6zvLngjwI9q8rv99KkkhSZZJ7neCx7
	SIcSM5ETotxvxsrirg6CoEhEgTHSQDJevGJO06IO2y294DjhiRnH/mEE7lfgOCrLUH1lws86OYC
	Rex4J+KcMP4YG7a4vm1Y/CSNlNwRnjWiRM4JXlinqYYB1LTwG4m23YAQywR8DIo5Ko13SPOrhwo
	QXAwNzCz1nyEbKLX1yc4a8f2bkKAPud3oLKfdv0AleaXFNohw6upxpC0EMh37YfJQs+SUtjIsEv
	sGzGlj/xpyompLBdd64UW80NWy9dRpnn4h/2Ao5t2qigN7IRf7RQSUU3QHBt7RVddA
X-Received: by 2002:a05:7300:cc82:b0:36c:9b35:5d46 with SMTP id 5a478bee46e88-379681c811dmr12718279eec.26.1794892053330;
        Mon, 16 Nov 2026 21:07:33 -0800 (PST)
Received: from [172.20.0.3] ([172.56.235.113])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-38116afd7f7sm3833544eec.17.2026.11.16.21.07.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 21:07:32 -0800 (PST)
Date: Mon, 16 Nov 2026 21:07:29 -0800
From: Chris Down <chris@chrisdown.name>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, yosry@kernel.org,
	mkoutny@suse.com, shakeel.butt@linux.dev, hannes@cmpxchg.org,
	mhocko@kernel.org, roman.gushchin@linux.dev, muchun.song@linux.dev,
	nphamcs@gmail.com, chengming.zhou@linux.dev, sj@kernel.org, ljs@kernel.org,
	linux-mm@kvack.org, cgroups@vger.kernel.org, damon@lists.linux.dev
Subject: Re: [PATCH v3 1/4] mm: zswap: fix shrinker count for the root memcg
In-Reply-To: <20261114002822.1043378-2-joannelkoong@gmail.com>
References: <20261114002822.1043378-1-joannelkoong@gmail.com>
	<20261114002822.1043378-2-joannelkoong@gmail.com>
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
Message-ID: <avvhESdjPdJ2lDlf@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)

Hi Joanne,

Thanks, I've reproduced this and the results are definitely much better now,
in that with this patch it now writes back pages for a workload in the root
cgroup under memory pressure.

Reviewed-by: Chris Down <chris@chrisdown.name>
Tested-by: Chris Down <chris@chrisdown.name>

Thanks!

Chris
