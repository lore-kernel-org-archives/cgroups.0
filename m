Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794280670;
	b=bAdbfhwiArG4Lc69s/TXn1cXdc3ZZcoSkdSTK/tk7Pwxfvj8+75XSYL1OJ0M/nIs2W0T
	 DaYITIWNvkxioDsRXjd9/NRRH6JVS/Aw/YEPLRYakY4kg3BCuKxzzBld6U3rBeXMrkk/m
	 R0N8YaZGg9RKVhU7UMukXne8rAGNvrhzpXWCtsA3mG8Csp2+7kBRw5DpJpHL5EXBjSYuE
	 OVVCBOkyvvP0pgeoWwaA6Y4BLUHpJPmlVvrkaC3cgI3aoBAr3STOhu1Fy2bbhZqSFioeG
	 fewAt0DNlNcbzq6yEjQeCHQoN2iKKdjVlWtaoMUDr/qSxhV2ouiAz2ia82/08NSJg8g==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794280670;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=DY0x3Q1cjK/pWVa6jRiEqiywRACTTD4vdqT0Fn0+Enw=;
	b=DLD1Dvqx74bETOE7l38YOIujoGyFSxZhEqE8v4B+hekKT1ezUM0NbbN7tDs1uWRpEZQO
	 ApgdDwPDblQjSEABYYazYG3JvU8w1bAIc7XvFWMJfFyu/iwhwWmdAoxpCIzSY0v6+id0j
	 kIYAkJEKyZclnBtqVCeZbhv7yJ7iHfJ2CGF+F5p6ISMPg1anc3dgobPdsB+96ARdcnmkj
	 kMsbvUI8/ByLc0DarKgBDdjdADADFZZzw+oK+BF2ZxS9M1GVdj0/C12SYeRkBK2IRGgtD
	 zc71jpl7Yfiggc2Y9MAmVQsFHqHfKhOVT/3G6VFu8B7tUjoH6PMg7P0u8CqViAAL4qQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=shopee.com;
	spf=pass smtp.mailfrom=shopee.com;
	dkim=pass header.d=shopee.com header.i=@shopee.com header.a=rsa-sha256 header.s=shopee.com header.b=hwlug512;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.82.47
Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBDCB606A31C
	for <cgroups@vger.kernel.org>; Tue, 10 Nov 2026 03:17:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DBDCB606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=shopee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shopee.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shopee.com header.i=@shopee.com header.a=rsa-sha256 header.s=shopee.com header.b=hwlug512
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-1b3a05f8b5bso2405271c88.1
        for <cgroups@vger.kernel.org>; Mon, 09 Nov 2026 19:17:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794280669; cv=none;
        d=google.com; s=arc-20260327;
        b=q9y+JUSsHZBPl/xQeNa2GJ+4jzWJnQ6axNpUNOB5s8KsWqfRjztHe9uHcRAeUREjqn
         UkSkfond778UnoghwaxwRkQb7SeLm6SD3w5uPKNrbfVT40xKtx3hL+GhbIqE2aHw8RDf
         i7+8NkU0uHGbnTlf0f8d06tGWiLTEtU9x7G1EkJmDHOmiMxgakzqkH3UaluN0mQdaYln
         YCCXYm2a574gwQlaIgBcti7HJ1xQ0kzbSTgkCbJi8tV3OUSEg1YbozkhLXrwtrXjh7Uo
         hdQkL3upgxn/rodcVkSxmwzRDRGUTWEWCmjZPHdl9tCqe+GV2xFP1siq7tnzrxjyprBS
         Z0nQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=DY0x3Q1cjK/pWVa6jRiEqiywRACTTD4vdqT0Fn0+Enw=;
        fh=wf/mzfDRWvZmZwIPztpKwP6Ob0G67/aPrbccFUiNBL8=;
        b=M9q/w4FtkM54byqmz0WFjN5yfY79016Dmm7HEpwvL7jZF9R/qNIY2HaC9OM6D/pmvI
         56iBEVT05FxLKUzJFqGTyJD3T4laaaZODRCf8Ksc0SRQYJjzktQSGmaVNLwiR23Gzlow
         FiaEeTBfEfKCxTJdkmP3/iBlR/vE+IbgaqQhcveneQXDCXFUMK+wGhtC/FuFpRurfd34
         weUzt9jwtqS85VkDiTm5LgBQrrELAUyOEMh3u1JjpE0tS5AolY26V6MY/27Yz3QSXz49
         Ivf0iovZRt7iNzA93K9YqtrxqtC+rm29bHatPn4zq2gPnNayCn4SOS+g6OhFuV6BJ5wO
         OT3g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1794280669; x=1794885469; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DY0x3Q1cjK/pWVa6jRiEqiywRACTTD4vdqT0Fn0+Enw=;
        b=hwlug512V39UWgIVYDbscunUdwqURuICey4XvY9cv88MfiYJvReTic8ckU6JXkFkW0
         g7/neGwr64k839thdRs8UeSl9YqoUUZFeXbdgSRAIcv/Nc2mywiiXl0LChpB57CUgZ+2
         fDm1fidkpT71sT3l60g/AymXCuEUOU0GajDy1liKm+vjNIkumZaIUT1V//iJdqB+RuOJ
         RE+tQXoXPcEnobPPSf97earNMYkvYuGcM0vUJzhCmI9vBi92ux45vTOOTwVniLBdF1hx
         E08YJ+ZT3vNt0leyflv4msiFLP3WE3qUKpMYgowwmY8RhvYiMmx7/M84fxAhmh9otnxJ
         7FyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794280669; x=1794885469;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=DY0x3Q1cjK/pWVa6jRiEqiywRACTTD4vdqT0Fn0+Enw=;
        b=hrTg4jspoWzEpofeN9TzeUxGGcXsSocufPoCkxvPhGNINGXQPw6K+TbboL/uEUV7rx
         EoKnm2vlHj8mCMRssM1q9jBHkDWy+AGH/dNz8WjQ2o2pdvHY5gbSmKM7V3bKrVST539E
         D0oVx/RahRxlMrybA52euRx2dGKyPm7CVQNZdw/hyHwvdX+muAzvNSjNgCwvaoS9H77U
         f4+4LVC0VXk0w7o+iEKrmHEvpV0YdkoR1x7jrw+H6MRm+XI+gAydjY0zNMAloso1rtft
         4EWV6D6JplJeDQORACvy5fTi8E8acwGkmtN9Tum/PRje29m+NuxwuFqRbTT8kEd+LJqo
         IsOQ==
X-Forwarded-Encrypted: i=1; AL+hErGEa394AEQVM3YbMzg2I6B4UlYKRW8OtfL37nsp7GFCEmZDq3r/pn1CnIPWybdHEHcgajSxLUA6@vger.kernel.org
X-Gm-Message-State: APuU4Z9gijx5f/cR0Fv0ej8mmESFx65EB4c15iaAK+nqzPWJMLv+l5xx
	heI2JSFKBXgXMyz+SfSKGL7CTu4gwqHoAt3HEiCzB39MHmZkjk2Su3VWFJb/KTKKgGjV60V0E9+
	oAat0L6n0PqYVaKkEGhqrzA8ID0p2ptwJ9Rifk3AZ8w==
X-Gm-Gg: AYBFou2B/HAAttVbLMXN5WCRXUb71fTDRjPsp9ynJ9+7uuyAiLW1ezHtovPHj6J7iSh
	HhIQXkWdXa0HUrwCnOo1z38Ir2fXWsnn3JbiJB110Q+yCOLKYdhNQqw3NTyOWXeTKK+50GVUV57
	ErtjHg+SnVPIBQ/domaChNWw1WGmRkbknxEhHMDkc9OjPT5/pXkUF6EJfHbWsKTKAl8H5HpaC7L
	6kSz3Bk2JL41CfgPOtdP6Lbz04qDZkLwEhBpLbenrtf/wqP7Bg8ckQyVGcWel0pm9ZMWh9D4x/O
	tIt2at+NrPBZPI5fb9BrtG980HFLVMamFG/H8W+4QzR55vCs5s+lWoIdwJwNGbfHR/i0M7OalaQ
	OLCeFgbYAiAG36D4+DII2grRqurhe8s6Ntohf1g==
X-Received: by 2002:a05:701b:450c:10b0:149:49c:233 with SMTP id
 a92af1059eb24-1b3b603e878mr1944541c88.27.1794280668922; Mon, 09 Nov 2026
 19:17:48 -0800 (PST)
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20260911032905.63683-1-mingyu.he@shopee.com> <aqRXqcynCx88D2QK@linux.dev>
 <CAAoBcuS=sqOAPFr9Gda9aTwuCMHMPzBMEee8qvPNHtNxrRWKuw@mail.gmail.com>
 <asy_L2s1TNcN7bOK@linux.dev> <CAAoBcuS5VJwsYyw9=77SaBUf3N1hL8NfRtGwpBhmyUUhT4+T8w@mail.gmail.com>
In-Reply-To: <CAAoBcuS5VJwsYyw9=77SaBUf3N1hL8NfRtGwpBhmyUUhT4+T8w@mail.gmail.com>
From: Mingyu He <mingyu.he@shopee.com>
Date: Tue, 10 Nov 2026 11:17:37 +0800
X-Gm-Features: AclHuK8HAaIrM0LQouKy4b9klf3zI6EsjDz59qge6Fr9-5V5H_IdiVz2kr1PIPU
Message-ID: <CAAoBcuRfhFf4p5qfWZnNs5=4foeE6jtGFggG5XHmMi6cXwje9w@mail.gmail.com>
Subject: Re: [PATCH] memcg: keep propagating stats updates to ancestors
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Yosry Ahmed <yosry@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	littleswimmingwhale@gmail.com
Content-Type: text/plain; charset="UTF-8"

hi, gently pin this email.

Thanks!
