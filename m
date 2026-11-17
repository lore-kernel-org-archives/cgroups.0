Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794892057;
	b=FQYSnbF9MKaUmDKnhhzfh7mVh+onU5cFZY2IQEfO9Nq7+Eyvl+afXia+ensZgye1iSgv
	 Q+ZCrzb+qWz/Ke9zQBjVH2H2on5DLhrdxWcb075yks8E3V6CHVQ99MdDraQUeQtNJbOu1
	 DLTqFTtCl/ybbEQdevc/FFCYmDeCe7+uJ9Khu8ntg+Jr0TdHus4x4srGcikdd5MWdkNaE
	 nTF8D1xU2z+02mpxvACpsMB+GIJtiQJ44hWKBHjiK+DupccVPrnHX3MPemsgnNd6X8Tbq
	 CRW+bIt43uCPFjt1WWXLf76RYZ7dNVh16zRndpKHbaHR8f/jZaRhWVsla2pKCUBCDlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794892057;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Disposition:Message-ID:User-Agent;
	bh=pSTje/Yh5JU+r8doUCnbpH2HQ4u+A7cqXKEYIOCxoqE=;
	b=xebd3mNxfLHQgBEEbeGjGf4IaoxbAO4icVEoWmFvM/rfPH4ezvWVJefQmTpnQmxY6yoa
	 Qaoqu835d6zq8tuQhrOPWw8P1otVvCfZa8X8yioaTdijjO/D7wOu19bU/dEhJ/l5ETUAb
	 EDgZVif52jhv/BMbe5McadMvJE6IyoXleFFlmF8EuFByoxoMGlBTyAKAn9AHzCuit4yBe
	 BgSXiB+fOa2bUwpnDA4Tkp8TkacNu9uvw6LPxCRX7VOcQAASl34qKc36kk9zbLhoJPdQJ
	 ylQzuKPpjIhC606EpSfcnDLgqZF+1A5DJBX1jlrCJQ67SOc3aq8zrno6e02ZOP6afJA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chrisdown.name;
	spf=pass smtp.mailfrom=chrisdown.name;
	dkim=pass header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=jeJ7fkKr;
	arc=none smtp.remote-ip=74.125.82.172
Received: from mail-dy1-f172.google.com (mail-dy1-f172.google.com [74.125.82.172])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E06F8606A31C
	for <cgroups@vger.kernel.org>; Tue, 17 Nov 2026 05:07:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E06F8606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=jeJ7fkKr
Received: by mail-dy1-f172.google.com with SMTP id 5a478bee46e88-38190551625so231967eec.1
        for <cgroups@vger.kernel.org>; Mon, 16 Nov 2026 21:07:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794892056; x=1795496856; darn=vger.kernel.org;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pSTje/Yh5JU+r8doUCnbpH2HQ4u+A7cqXKEYIOCxoqE=;
        b=jeJ7fkKrgN1B5BRMaKSzTtdXM14ZLTCtjCLVO5DpqzPYPb0keENBX+TfuPKaqX2pJi
         ZfpJlbf3XTlFrdnFwoJqBH60Vf6Ib2C35BN+U+jtfF202iieqfG0JMmEMxCxPzmC6iDM
         +kNLahq+iouIfxvBLCGO/7gBd65tFTbjbHyTg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794892056; x=1795496856;
        h=user-agent:message-id:content-disposition:content-type:mime-version
         :references:in-reply-to:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pSTje/Yh5JU+r8doUCnbpH2HQ4u+A7cqXKEYIOCxoqE=;
        b=jFKRmD1QRCJA7VG8NBZ4gbUspvBczxz1KbhM7jgBg/bSrtABhAp2nSD5oGzUtGXVdV
         19I+VHO3kTYwBJPgdZNO/IGg2u3q5stqyPmGzRB+k5fAxUvMC/lRJF00fyeTtaCahaf1
         L3lZsR/coLZwT+/5H74N/FH+QLA82VmJiw89qz40WfYCWIUbDoZ6EzrRD7MtmPKouD55
         3T1uMfQlonI8XsNlLYYkBN3zqzfUkxs5hiBKLC1AjYNe3rG3D/5SHPxFgScof5e10Zxx
         VbE73qzUJ2p5hSVLvTkdOKNJ71UE0Uy8SFY44xgM9+MS7i4mMl4fOS9rRtIoEd0Zkbrr
         iAHA==
X-Forwarded-Encrypted: i=1; AL+hErGCVM/X1NFsNNbYWpEvf1eKcUWqE9A1ju+88GHDV3CEkGT+ozJhXwpsNVvLUHxzn7o8RLh3Rv8j@vger.kernel.org
X-Gm-Message-State: APuU4Z8lfYlhb8Ak4bH3/KH77LQJ3b5QVzTg6zbXVkFniO9wJCMSaXCi
	DcVQLZPuMFvSVkEbiWBmYaiHsOGhfKfxx7tCZSnvellBVgkBRANg7qaOG5TY99RfjV8P41FPN1F
	BlPSwhZu5L5K4
X-Gm-Gg: AZFdTZcH5+isIssb/TtwHFOq//XYRSzZs/+E0vKiWCLbpU6sBslKuhthg0I+Epi5+YC
	0+t50cof+IJ6F8gzf0E2aYaQoH7+znnc5sb0lP4FgsHls/tHj3dYF+JcMDd/Nq3HOljZjbEVCkw
	fNKupGAJrDFUL1MYX3aKVhjeLGwcVyMyJjEhdB47VLnWpu4IDuXrKdlSiT+0fhw6OzcAK0UiLCy
	PMfOOfOS5kRsWwNxTp8IZr5coywjT9f4JBgaQihA5FZRuYWlrBX0/apQFRzJ3PickCIvQ406uAP
	cxYsTZqaKw1cqu40IsR1i70diGt/GMMe63ed2TzvHhADA2pFkv6/iioh8i5CdxeLT3BxGJK3lh6
	uFv5KHQtP/o40JXLtirvwlfzIZXFPrESLmMGqXIk2K87rRUHIqIMl7PZ8bQow8ydZEm1jem9E9/
	PtBTLPxiIwuM0tqWa1bhjG6eqh9yM7QGioFE0iGKL7BApniXfkpjkuhzZiSCdzGOY2Jh+KHPxNG
	9sid521HdoxllMFtkcaLJ+b0/k8NVKz4Oq9Sl5gj8NeLsW+Z1wC1r0JJnvU2+HTcul9oVjBy3Ha
	nJvu/YVxl6uQDbjfSWqWqCSG9i62fuvpDXSgHUPXFVs6Sn/nAypYTbzlUBEdU3roj+MY0aqAAqh
	gfs26jaqIuCG6hRGhBDRgGD2zhwTgRlgmyb4ICXMI/rYLo5Hv2a2BcheoqEK8EHIXaHqPQ/vXK7
	O03gaFbJW1vTcmI5xF0kaoJcipnrUy6NmjPuPrYavM/30/PXyqBWjuLMZzKNbuyXpS
X-Received: by 2002:a05:693c:2a16:b0:369:fa21:ba0b with SMTP id 5a478bee46e88-3796721cfc1mr11998596eec.33.1794892055979;
        Mon, 16 Nov 2026 21:07:35 -0800 (PST)
Received: from [172.20.0.3] ([172.56.235.113])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3797f98b9b2sm37051807eec.6.2026.11.16.21.07.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 21:07:35 -0800 (PST)
Date: Mon, 16 Nov 2026 21:07:32 -0800
From: Chris Down <chris@chrisdown.name>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, yosry@kernel.org,
	mkoutny@suse.com, shakeel.butt@linux.dev, hannes@cmpxchg.org,
	mhocko@kernel.org, roman.gushchin@linux.dev, muchun.song@linux.dev,
	nphamcs@gmail.com, chengming.zhou@linux.dev, sj@kernel.org, ljs@kernel.org,
	linux-mm@kvack.org, cgroups@vger.kernel.org, damon@lists.linux.dev
Subject: Re: [PATCH v3 2/4] mm: memcg: read root lruvec stats from the node
	counters
In-Reply-To: <20261114002822.1043378-3-joannelkoong@gmail.com>
References: <20261114002822.1043378-1-joannelkoong@gmail.com>
	<20261114002822.1043378-3-joannelkoong@gmail.com>
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
Message-ID: <avvhFAxBcPk5Q6pW@chrisdown.name>
User-Agent: Mutt/2.4.3 (cc9e3943) (2026-10-09)

Hi Joanne,

Joanne Koong writes:
>The exceptions are the kernel memory stats (slab, kernel stack, page
>tables, secondary page tables and vmalloc), hugetlb, and
>WORKINGSET_NODERECLAIM, which counts reclaimed xarray nodes (slab
>objects). Their node counters also count memory that isn't charged to a
>memcg, which falls into two categories:

This still describes the v2 denylist. With the allowlist, the root memcg
also keeps reading rstat for NR_ANON_MAPPED, NR_FILE_MAPPED, NR_SHMEM et
al, and some of those differ for reasons outside the two categories here,
like swapcache being counted differently in the node counter, for
example. Could the changelog say what is on the list instead? So that
would be the stats that only change through mod_lruvec_state(), with
everything else still reading rstat.

>+	case PGROTATE_ANON:
>+	case PGROTATE_FILE:
>+	case PGREFILL:
>+		return true;

NR_VMSCAN_WRITE isn't on the list, but prepare_scan_control() adds it to
WORKINGSET_RESTORE_ANON, so once the root flush in reclaim goes away,
root reclaim would mix a live node counter with a stale rstat value.
Unless I'm mistaken it should go here as well.

Once those are fixed, please feel free to add:

Reviewed-by: Chris Down <chris@chrisdown.name>

Thanks!

Chris
