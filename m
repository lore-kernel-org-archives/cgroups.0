Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792616364;
	b=MsA1KgZY93zQSWNTMgiTboL1NDdWYyFmzkiYAInJU+EdzEw8oMx9YtVFIfVZksPtT2tA
	 7w/Vgveo7bsohhUuazg3HFSa+S2r3bXPi3qQYG/5NhHxlcwvZLvaAjOCx2sGdq8Mg4yCp
	 0pCnBzak18lLPX8IzgU+lq1fv2klKkihdUyUBqKqc7y90uHp7rVro0Pf0gEafmNt7XJWX
	 TN3glHWo2jsJmlVe5I5NQjLxyf3UM5jeGeBMOJaVnsGIx2BrwvBsS6VNE078ZOsw0gGIx
	 M9U7mcsk9l1u/Ny1w+XipCtgRexaN0UZBZoVV6CCFEXsLNQ+zneolol1mlNA1zKFqiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792616364;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:X-Mailer:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=sc3hIjuqm2HqdSWjRIWRDLuVUuAq4OcILp/mjVvlhDk=;
	b=z3F6kN6vMdTLZQkouJqIqF6RHX7rUo90MyXs1x+ii4iYseBTFN9rEURp5i51mxlyz44P
	 iEiX1kGVXZ3SSggASiJPbNVnOOYGtXBtu+GYKlpQmtMKuHVzeo9MG8/LY1PYr0Ii5oUOB
	 vbyK4h3QeyzJqY7F4fWa4aj/0h5nZV0SKFhOjd0ILVOabVNk/k20mwurXRR8i70zs6xFA
	 vWBnEuX5gqDNUtl1ohAJYcFtAYZBows8OHLzPQ7kDoU33VMNtRLkdQ8cFclbXcsjXXo+K
	 iRweSyuMLeVtnkYF3gISOSjsnQeKPDDpRFUH27sFthtfPUIl900dOzX2W3jBJf/1jwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--nhuhuan.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=ZMNsh3Jh;
	arc=none smtp.remote-ip=74.125.82.197
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E18606A328
	for <cgroups@vger.kernel.org>; Wed, 21 Oct 2026 20:59:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 90E18606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--nhuhuan.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=ZMNsh3Jh
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-35c3c370b17so1839728eec.0
        for <cgroups@vger.kernel.org>; Wed, 21 Oct 2026 13:59:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792616358; x=1793221158; darn=vger.kernel.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sc3hIjuqm2HqdSWjRIWRDLuVUuAq4OcILp/mjVvlhDk=;
        b=ZMNsh3JhlJhhgQmcGS+0lnv4PQ1jkXPwj/Swdqa5ZVbur6eSeM3Fa8DjhDGsrQASA9
         9thPSUOrzIJiFKz8HmF36RGFQfzfjXxadMsGq8wo4+TCNxiib64SG2G6HqHbWOpVjLAS
         EsYouMOnfhfHiQGbZ65Q7zFHBKhHyvGA4LiGHuACdF1/D0hwrdeBt4EZqImdHIQuer8W
         3eZfDmFhEaAoiEe0vD3o2frHLu1Bh+MwtXLR2sbNmu5cntokFsetboebwJZVWMtI65AZ
         /xtfEoB7lBErngBGxt7g3ScYFih1k75BH/8Q26w9DM1IJPr3K/ZsJG6uaqoKkllZ87S+
         yxDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792616358; x=1793221158;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sc3hIjuqm2HqdSWjRIWRDLuVUuAq4OcILp/mjVvlhDk=;
        b=YfwzMXpUviE1aRvVXaeqJVVZ26Sit7viuPKVVGlygE4rB1NBkwRdJw+9EeDjT/8cEr
         qusthCftQX+xGby3ef4G2xHXx3W9Av5jHCknAeAp7NdyXOFMS8AlQuCGDbTR+AZfZTA1
         jNynpKhp+iWjv9YybXhoHMqPxEKUXO2Zv6hKW7QFlzqG925wCFmagO3TzPJZgkkmeXV9
         cH7CQIfmrtEPVqSqnQNkZR40LZRu08ZCE1RxZDb1t17/mCcOVBd41Gjo3P/Swh2SrQ8g
         8CXAhbOEbbN4DvmiLFfWptK2LSpeS06y9CXq5hSRbJTOL/9HOF7XQNY+hrEK60wDHjz0
         z64Q==
X-Forwarded-Encrypted: i=1; AKwUvBwWK0SC1LBJcnit3rnnfUUKV6RW65dJYkKhC4psDziHPJyJA5JFNuBE8SdQ82gEokk5C4uHVRNl@vger.kernel.org
X-Gm-Message-State: AFq9FYLMXTT28erAdt4uRasBhMJ2gKOQqvXCkvOvK5w0ILlO0iahN/4a
	7oAylOOeW5c9UnsH9bshgHq02ZoPPzuLD/shFhYCMz0bpGPbo0uK18FyFbJmb+0+15W9+6tg8Xj
	eOcNhfTf83w==
X-Received: from dlbdx6.prod.google.com ([2002:a05:7022:e06:b0:16c:bd18:1ee2])
 (user=nhuhuan job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7023:a8b:b0:143:72b1:9004
 with SMTP id a92af1059eb24-190a87a3b70mr4075424c88.45.1792616357026; Wed, 21
 Oct 2026 13:59:17 -0700 (PDT)
Date: Wed, 21 Oct 2026 13:59:16 -0700
In-Reply-To: <7e998cd5-57e0-432b-a8e0-676a5b773436@kernel.org>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
References: <7e998cd5-57e0-432b-a8e0-676a5b773436@kernel.org>
X-Mailer: git-send-email 2.56.0.218.g1ec904b173-goog
Message-ID: <20261021205916.584370-1-nhuhuan@google.com>
Subject: Re: Path forward for Virtualized Swap?
From: Huan Nguyen <nhuhuan@google.com>
To: david@kernel.org
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, cgroups@vger.kernel.org, 
	chengming.zhou@linux.dev, chrisl@kernel.org, corbet@lwn.net, 
	gourry@gourry.net, hannes@cmpxchg.org, haowenchao22@gmail.com, 
	hughd@google.com, joshua.hahnjy@gmail.com, kernel-team@meta.com, 
	kunwu.chan@linux.dev, liam@infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	mhocko@kernel.org, mkoutny@suse.com, muchun.song@linux.dev, nphamcs@gmail.com, 
	qi.zheng@linux.dev, riel@surriel.com, roman.gushchin@linux.dev, 
	rppt@kernel.org, ryncsn@gmail.com, shakeel.butt@linux.dev, 
	shikemeng@huaweicloud.com, skhan@linuxfoundation.org, surenb@google.com, 
	tj@kernel.org, vbabka@kernel.org, weixugc@google.com, yosry@kernel.org, 
	youngjun.park@lge.com, yuanchu@google.com
Content-Type: text/plain; charset="UTF-8"

Hi David,

I'd like to join this discussion as well.
Could you please loop me in on the meeting invite?

Best,
Huan
