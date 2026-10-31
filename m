Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.251
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793407555;
	b=B0igZXlRqRPSUIeVjiPECZ4VEuIb0oKdXih8h+fsGLlpUqEaxygZrdPZrOKy0cEyRhiS
	 tFH0g7ZpShfHG3rVDm22evHFvmm9Tfzbe+T+jiEk9DnWvFnRC4mO2RlCof0xdn43KVlCd
	 flrLxCEYO3prDcFkaLDYt18GFP7hzqrA/veLFPdAuSJKjHtkq375J3CIPkfqoeQXeuZBx
	 KL1KGCj3sAmnkn88nz+ZPXRobllkujJzkAVT1gWT36dWXAVbYKY7SCLSKF4EfVOj0YmG6
	 kb2rcAT4NiXuebUTTTHSfsh+1zHLrapMf7IJ6uHL8lSAWqZlKJX9Whw+IG69c3xrTNg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793407555;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Content-Type:Mime-Version:Subject:From:
	 In-Reply-To:Date:Cc:Content-Transfer-Encoding:Message-Id:References:
	 To:X-Mailer;
	bh=N347scaieRKnfZAxwyIlV4lZkQNr3Gsi349x5S8E61Q=;
	b=ZT+WAWspRalMrl5TqQIublLSBLCebIjDOpC+gworQVL1ftuZhD9mx0IqoZ5oTPvTxq0s
	 qJCxTpxVWycJXemT15m1ZpveHxDsRbsvEgu16QUZPpo1T7ee6FzU+CNgTkS0qaDZ94YEB
	 C7vAeJ9WEePSwi+J5nG/rQFqJgweO831GAuVLmFotrIhF1e00DNehKDfQ3+kaMMasFKUW
	 9zgAGKHhwclUyd/+n9qBDrtKOzKC1UD42wAoNpTZI+s/wPOEUKpruCd4JSLL6cZSGVXD2
	 7DElvhAnfXdiD4NBLDnQK+/bCxX9QgIXv3I32uqKGAYopVtbFhq1rxWcr4qpWk5PBIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ELCL6CDm;
	arc=none smtp.remote-ip=95.215.58.251
Received: from mta1.migadu.com (out-251.mta1.migadu.com [95.215.58.251])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C57A7606A31A
	for <cgroups@vger.kernel.org>; Sat, 31 Oct 2026 00:45:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C57A7606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ELCL6CDm
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=qzhoW8hkYHWNhkLmB736TkASUeOo7ZLmpURHWLLr858=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793407552; v=1; x=1794012352;
 b=ELCL6CDmUwhiuWeB1YbP9LifjMZgTavMPdRceeYAFvZ5GxRaLMxa2FSRkJh9ZZmqWGwKgXW4
 X59vrrAJx7sg1ot0ONKm2Gl3fbczTJll0c1txdFkjawCH/g8JknSfdI72pBgwpn9LUAwZgHmsYD
 4u9hs3Re3R/GgZOJnRzFolOo=
X-Envelope-To: cgroups@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id 59289533df5a5a2f;
	Sat, 31 Oct 2026 00:45:52 +0000
X-Mizu-Trace-ID: 59289533df5a5a2f
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH v2 1/5] memcg: move memory.high enforcement out of
 try_charge_memcg()
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261030205418.341214-2-shakeel.butt@linux.dev>
Date: Sat, 31 Oct 2026 08:45:32 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Tejun Heo <tj@kernel.org>,
 Harry Yoo <harry@kernel.org>,
 Meta kernel team <kernel-team@meta.com>,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Michal Hocko <mhocko@suse.com>
Content-Transfer-Encoding: 7bit
Message-Id: <F94627B5-26E7-4F9F-ADAD-395026632C45@linux.dev>
References: <20261030205418.341214-1-shakeel.butt@linux.dev>
 <20261030205418.341214-2-shakeel.butt@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
X-Mailer: Apple Mail (2.3901.100.1.1.12)



> On Oct 31, 2026, at 04:54, Shakeel Butt <shakeel.butt@linux.dev> wrote:
> 
> try_charge_memcg() does a lot. It charges the page counters, reclaims
> when a limit is hit, may call the OOM killer, and at the end it checks
> and enforces memory.high. Move the memory.high part into a new function,
> memcg_enforce_high(), so that try_charge_memcg() is shorter and the
> memory.high code is easier to read and change.
> 
> The code and its comments move as they are. The only difference is that
> the new function gets allow_spinning from gfp_mask itself.
> 
> No functional change.
> 
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
> Acked-by: Michal Hocko <mhocko@suse.com>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.

