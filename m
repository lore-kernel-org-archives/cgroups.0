Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794892060;
	b=mQL2MyLXbCW76G8aNy9G0XXQ8Sj+deB7hLQLvzFQJSUFL/BGxQ4iXclXG+X0/GsF50WU
	 eqvmA4A1rHVsG11yQSYnkWn6OpDd7pjTrB8SPuMT+fkUCEbm3UFBIe235g/z/IvgZcdwm
	 zPzsnmEuZf1yqvMt1Dh/9yZyMwwPgg6qQfyYKY/WhMb4ZsBKXyYbPwvWAjn5DIl58lx/l
	 a7uz+ecteUv5JTlD9tqmI66Ovr7pJ/607i+N1whZKl/IVnXwKiv/ALJ7jPu3FlAz59V3B
	 oYEiqbpz9RMIK5SCvSvW+tjOWt/KDKLHQ4nPrc6jbiCk8navI6uv9+ybwrTFTnpGuVg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794892060;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Message-ID:User-Agent;
	bh=ADwlNPhiE/91inMKJBN21Al9f4VOhautzJBcYAYagsw=;
	b=h4IDZd14t70ovQ8hRB7vGAG1PknjAot1OKByCXe+ANsUWyUW4P18GxVrt1P6NjhgzGIh
	 Y4N1adq/3UF1kugOa+hSw16krfA8FdYoYguhWUc4NX9jIPrn1qfaQIJ6akETquoQ4Yvvs
	 dUYzjXBynP5MndI4i66oh/MWqm56m4sDZiFSqHwDxuy+aAhorJ/Jl1ksCJmNbcqcgt6ii
	 2VstjKpOXdYkyQG9Eqs6JnW2UbwAA7FQuqnXe9nocBFE8COW0Eu8FMTRzy2UpInDKCpLX
	 BgnOdx7NvEIBJT/YREJ7in3w0Ugyx9pfaRZQA05dOnspXFfx8uaHwZauNOmS7GDTLQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chrisdown.name;
	spf=pass smtp.mailfrom=chrisdown.name;
	dkim=pass header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=hgoHQ0SY;
	arc=none smtp.remote-ip=74.125.82.172
Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD68606A323
	for <cgroups@vger.kernel.org>; Tue, 17 Nov 2026 05:07:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ABD68606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=hgoHQ0SY
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-36f8cdd30beso7053037eec.1
        for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 21:07:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794892059; x=1795496859; darn=vger.kernel.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ADwlNPhiE/91inMKJBN21Al9f4VOhautzJBcYAYagsw=;
        b=hgoHQ0SYes/h1txyms3jW8cCiTB5RQh6UG4ghvwflXFK1K+9hsdF29iONmG9Zabjyg
         FvBjZIlv3B/Cr22WEiNr9JXpL5oK//+bijLguZWsVWM4kVSsfBO5wQiPGWPT+Pm6GTNQ
         mSZ7dH2MyNwfs+Db6NQC6vduH1GovWzEs2rVU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794892059; x=1795496859;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ADwlNPhiE/91inMKJBN21Al9f4VOhautzJBcYAYagsw=;
        b=L72pmQ9eOr7CX5ekhAro0gS6uDCVZj8fr3QQNugYgiSeiELVvm1lhDJSlj6iNLQGu6
         0fz5GLS5I3wLtYZVsAsZZM+eucRsJITmwi8A+QfEigrx/EbFAevB0eJcDwRULdtJuzMI
         gypurbOCSW70wpEewKy+epVgXzUYnFMZB6ZW5AtSC0TjmlipiMRJS/OSVuDKpt/I5qQt
         TRb34K6j7D0cglmdvUJ/ti77r4J836FY08bM1VbZ6MoNa/Zy+zA3h8dYU4Z5AJM6nPwB
         +aBem5MLkM3MhcymL5ynyexPyTA7Kq4Qo3rMRwWLyCtifvF7gU4upXCI5LzBDI/bIqhX
         CzKw==
X-Forwarded-Encrypted: i=1; AL+hErGM1m0G7zgHNojyCYjLUbL5Yw8SOs/Z0byvod5QhP4O12VrwSXVN/phwfADZW/X+/1LA2ZSiwwI@vger.kernel.org
X-Gm-Message-State: APuU4Z+rZwvYskSfCxli2I5r3QOMwQNaE/QMxCNbYGpjjf5arDjPZQDT
	vhOSGx8yH3psR2XuZitGlbORGH//V5zclyRngSFQRPM/Zm2sVU++G6tqhCK0XRru7TY=
X-Gm-Gg: AZFdTZeDXlVaRR0gxiTc6rHswckXCWMgqhmbWs3EzwIbqnleDiWySOemxtSa+sSsk/W
	SCUPB4c5jOaFesSC+ZZYjq2HA0Tidp81R+NtxMjEUbPIOhsYgUefQaU3f1RxNYMxsi17TSoamqJ
	8Vq59QVUfbCQUFtxlEk5B4x1H5JTZg8Alc90rG7f6SOWdrfNfK//YAr1USOSVPsC29HzvkVayqB
	H4PDEGyfxpIetLXOzqe9vQbuJPts2mIGX7ypLsy6POd0mjg61QfciCPqk3Kxoa49qJoHVTckQWw
	tcYMHpxVRCDwuhA/0TfySQnx0hY+ynpwGfLE1PJ1ny6bFQN1T0SxXLjWF4fRT6kveDPJ6Yt8CvW
	q5V4r54LHErokve0sREyg5jQGM41e7060DzZ8Zt+1mYI9w7gpPNZMVM5ybDsbrAKlG1kiQ4Din9
	E6GeW22X74lIsHE3m+tdj40BGNF2TGq4OwzVy39n3LiL20gFOjtzqml/m2KPipOlJ9Bm5szM3+G
	PuWM7X/bY7+RixczLINXQ5rSOsctImcrXOS7HfLbSXM5U21xu0pz+u1TgPcr55jIPrNoJ8Dev7c
	mdN+UCkHuarX9phUTlYTddqXCngPR4UmfyNXwnvP+A+sI1dFc1J+XEhnkd55dKanLPQ3EZpL3LS
	a6d9BJ53SBJ4M6kQs77aiBnXoSMJOcWLNjXdyA4s6Dmd+j0JnFwnk2NfVeYx7WECSjfrrDOmBUb
	9Zkah45JYmS9o4T16S2Kig2+OvHwfG1kSDuKpAa72Sur3htOJvvDIBCaav1O2hEoRu
X-Received: by 2002:a05:7301:4d16:b0:36a:1d6a:596b with SMTP id 5a478bee46e88-379675feb32mr13056956eec.29.1794892058695;
        Mon, 16 Nov 2026 21:07:38 -0800 (PST)
Received: from [172.20.0.3] ([172.56.235.113])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-381a55555dbsm1325716eec.10.2026.11.16.21.07.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 21:07:38 -0800 (PST)
Date: Mon, 16 Nov 2026 21:07:35 -0800
From: Chris Down <chris@chrisdown.name>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, yosry@kernel.org,
	mkoutny@suse.com, shakeel.butt@linux.dev, hannes@cmpxchg.org,
	mhocko@kernel.org, roman.gushchin@linux.dev, muchun.song@linux.dev,
	nphamcs@gmail.com, chengming.zhou@linux.dev, sj@kernel.org, ljs@kernel.org,
	linux-mm@kvack.org, cgroups@vger.kernel.org, damon@lists.linux.dev
Subject: Re: [PATCH v3 3/4] mm: workingset: skip the root memcg flush in
	workingset_test_recent()
In-Reply-To: <20261114002822.1043378-4-joannelkoong@gmail.com>
References: <20261114002822.1043378-1-joannelkoong@gmail.com>
	<20261114002822.1043378-4-joannelkoong@gmail.com>
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
Message-ID: <avvhF41RlOQSYFq6@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)

Hi Joanne,

Joanne Koong writes:
>-	if (flush)
>+	if (flush && !mem_cgroup_is_root(eviction_memcg))
> 		mem_cgroup_flush_stats_ratelimited(eviction_memcg);

Not a big deal, but in the v2 thread you mentioned you would try a
mem_cgroup_flush_lru_stats_ratelimited() helper for this, per Michal's
suggestion. That still seems like a good idea given this skip and the one in
DAMON rely on everything read after them staying in lruvec_use_node_stat(),
and at least speaking for myself, keeping the root check close to the list
in memcontrol.c makes that easier to see. It doesn't need
to hold this patch up though, and I've tested that refaults in the root
cgroup no longer flush, so either way:

Reviewed-by: Chris Down <chris@chrisdown.name>
Tested-by: Chris Down <chris@chrisdown.name>

Thanks!

Chris
