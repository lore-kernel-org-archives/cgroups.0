Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.85
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793638377;
	b=kvVr9FUWZFJj8zhkQtcgNK3VcCUp1ADsFj+XRn7347ACufsrR93kxn4ZUh1d6bFJ3Ku0
	 fXauqlQecuRGcobYzl9LPo2OCZaDujCJwganBH2vlmlHj3mFo69P+8N/7BZXG+7pOjxkF
	 5hylS8QYTDiMxCmuk9BgTm6IBy1bpuHfXHAyRDufPQjnCY7ZJY2OpcxTngT3n6nn8+nWp
	 YS1a5vEEYA3FGiSWhk+XKTE3WnkRZIckLeVuHkHBSEgqLujz9r6zL+JU8yLbxlm3RgRSN
	 NGHDBGPfhi+gsH58UGBZhMFArf94uHEmlZGMVJklCQnnfEOpYZFeNhVY2kYVTbS/eqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793638377;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:From:To:Cc:Subject:In-Reply-To:
	 References:User-Agent:Date:Message-ID:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=1TWlg7KRBcE3RU/NzvFLK7aD5NUhim3refNRN/QiCaA=;
	b=uaQe8GSPVEu3caMsfg6UTOoffSOmYA/HDPAdQRkTJz92DQOUX6s4BYQNsv9zIDIhUPCx
	 n0O50aNmJJlApwfyNezvAx0pCwp2RFncIt4zgW3MyfRzCKRFck/I0qpsBvBCxABFX7lLu
	 p0fJnX1LhpzGeRAfxjqZGJaMy7gbIFHVVz/L6jnfACP62+y9j8ctXGTtAx6SUiJDLu+/X
	 Ivtw4hbh1/mjmEqKqZJYpzd8mE1PSJeJOfGfJrDO+tRoucUJRiCwDYh0mRbp3R4vK2MQi
	 0Eitq1Vg/QVXoIKEklP2SIWfxj+P6H3VvUcDWQajKG0pQ8UGQRxM7t7yP3i+tDt5Vzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="ML7/UnYw";
	arc=none smtp.remote-ip=95.215.58.85
Received: from mta1.migadu.com (out-85.mta1.migadu.com [95.215.58.85])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67C85606E021
	for <cgroups@vger.kernel.org>; Mon,  2 Nov 2026 16:52:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 67C85606E021
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=ML7/UnYw
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=1TWlg7KRBcE3RU/NzvFLK7aD5NUhim3refNRN/QiCaA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793638373; v=1; x=1794243173;
 b=ML7/UnYwMPEquYAY5EDZj9SNyn3NruDTdhc8P8QW/LUX4zBFeuZomybTfcUZVxNWuVE3d1/B
 yuTJem48rHWO9gzghsG5Ir68XyQRbXzdwXYitKImfpU6SmZPrj6mcMkuIxyQlUyNAp94V4QpuWR
 VxK6L7O8lQUK8qO9VejwCFXY=
X-Envelope-To: cgroups@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id d321dfeaab60ca30;
	Mon, 02 Nov 2026 16:52:53 +0000
X-Mizu-Trace-ID: d321dfeaab60ca30
X-Migadu-Flow: FLOW_OUT
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Tao Cui <cui.tao@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>,  Michal Hocko <mhocko@suse.com>,
  Shakeel Butt <shakeel.butt@linux.dev>,  muchun.song@linux.dev,
  cgroups@vger.kernel.org,  linux-mm@kvack.org,
  linux-kernel@vger.kernel.org,  Tao Cui <cuitao@kylinos.cn>
Subject: Re: [RFC PATCH 0/3] mm, memcg: isolate deprecated v1 state from
 struct mem_cgroup
In-Reply-To: <32e80536-64e4-4ae3-a7da-4a37ed415f0a@linux.dev> (Tao Cui's
	message of "Mon, 2 Nov 2026 21:03:05 +0800")
References: <b36ab4a7-b692-49e8-92b5-1dc4d76dee00@linux.dev>
	<0BEF7489-16EC-44EE-847B-A6AA380BE11F@linux.dev>
	<32e80536-64e4-4ae3-a7da-4a37ed415f0a@linux.dev>
User-Agent: mu4e 1.12.15; emacs 30.2
Date: Mon, 02 Nov 2026 16:52:44 +0000
Message-ID: <7ia41p9341lv.fsf@castle.c.googlers.com>
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Tao Cui <cui.tao@linux.dev> writes:

> Hi Roman,
>
> =E5=9C=A8 2026/10/30 14:05, Roman Gushchin =E5=86=99=E9=81=93:
>> I believe we want to delete this code sooner than later, why would we re=
write it before that?
>>=20
>
> My assumption was that v1 would still be maintained for some time
> before its eventual removal, and the goal was to reduce the coupling
> between the remaining v1 code and the shared core structures during
> that period, rather than to rewrite the implementation for its own
> sake.

I understand. But personally I don't see big issues with the current
code caused by the v1 stuff. Maybe I miss something...

The proposed changes on the other hand create difficulties for those
who use v1 and maintain some local changes or simple backport upstream
fixes. Of course, it's not a reason to not change the upstream code if
it's justified, but in this case I'm hardly convinced.

> If the expectation is that the remaining v1 implementation will be
> removed in the near future, then I agree this work becomes much harder
> to justify.
>
> Am I being too optimistic about how long the remaining v1 code is
> expected to stay around?

Well, Idk, it was considered deprecated for quite some time already,
so maybe announcing that it will be deleted in a year is reasonable?

Shakeel, Johannes, Michal, wdyt?
