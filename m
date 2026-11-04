Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793806518;
	b=xnVnSMD0eIN+t4d1x4gF10vBxqhlDPnGLlShToMdpMXD1NUIm4zmZ6aMVXMEPTnym6Hu
	 e9MmBojL+qIBtqSi3Y/krbiI5Sp34p/OMJnRPIXuno94ygdSQezSHA+a66phoKvaNa4D0
	 c9MOu+kYEyx0sVpmabT7XHhSIXP9IRwBmA7xvkPSoVJX12UR15K6bkQUq/XAQ4+2Hi6CA
	 yxWv6nGAYeCFWTt+veIKmoLocUNWNtbzU+okCPZdZK17GsIbAV7SbK/RVPupjOCSAL/mV
	 WR6RzPMv263CCONmdZYroiehGXmlIyinMzLyhU1ZxNtOQBJ7LkpDIVa0Nue+d7wrsjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793806518;
	h=Received:DKIM-Signature:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:Content-Language:To:Cc:References:From:Autocrypt:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=qP1iq0olN33Pbj7s1LpnKxEDc19GAI3fREIGaO3xv2I=;
	b=M8QIU5hX/tm9PjS6nRBnhpnlbHqfYbD4szF1eSRmSYP9dopkbrP54cPtxmTfGl8/pefQ
	 aNDe9XRzO7wLKxoC1EAV/nCFnn91lp6Co7BIoqhYIIPbxW2wdXQFcpZ2m1r6SAOsDiK2m
	 PSRaqtXAm3dZEr2dkjL0xCBteXPeExt+6mLHRM/RwoHQ6u4+2lI8urM3vkD/8A9gmKmLj
	 4IlJMo47qK/TZK9eNMZmejKUwHwAEIkJLWpGfXUqIQ3YIqzwigDw3oVikMnB1V9E66P8I
	 jp6NuCE2i6ejxwyPb50boZGAMfegfjD7uChSQ9MdpLG/kBlvo2sdRzOBl9eFMJIDw7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dVUnZZF2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B3E606A31B;
	Wed,  4 Nov 2026 15:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dVUnZZF2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D86331F00919;
	Wed,  4 Nov 2026 15:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793806517;
	bh=qP1iq0olN33Pbj7s1LpnKxEDc19GAI3fREIGaO3xv2I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=dVUnZZF2JbbWHkh7TlBjyQ+8ZqlC0Kbnm95XH1obnujxhf98eX7KvMnOQMGreH9qn
	 bYG0x3iMgD5BXGdksHjkl3dvtZ36XlxCMqVl0pQWAK0foVkfzjK03N4TSpPSH/sZRY
	 Y2IRcQOAyWBrY2Lw8Z0n8TxpHgTKrUEF3ZSSY78nszazsxWCX3upfrgGE3Z5fuSzH8
	 1sDRmbxV12YJa3bE94Ckwh6lK8P5UkC9Z1tPgyufH30swBcuFnOw79xxxtcCauARhV
	 xZ+MxXxCJWOdWf6scPuXKnMsgJwA/BkxPQ/odsXjiA3DUsgv/DTE+IiC4jyNidJaLK
	 J1H+oE37KddgQ==
Message-ID: <6441429b-eff2-485b-acf3-26c3034910ae@kernel.org>
Date: Wed, 4 Nov 2026 16:35:11 +0100
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Post: <mailto:cgroups@vger.kernel.org>
List-Help: <mailto:cgroups+help@vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
List-Owner: <mailto:cgroups+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for-next-fixes v2 4/5] mm/slab: fix a deadlock in
 memcg_alloc_abort_single()
Content-Language: en-US
To: Alexei Starovoitov <alexei.starovoitov@gmail.com>,
 Harry Yoo <harry@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 kernel-team@meta.com, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 Sashiko <sashiko-bot@kernel.org>
References: <20261103-kmalloc-nolock-fixes-v2-0-19167cfe4779@kernel.org>
 <20261103-kmalloc-nolock-fixes-v2-4-19167cfe4779@kernel.org>
 <DMLSN9VHK0P3.2A97046A4YXGY@gmail.com> <auo5G__ac1qA9JRs@thinkstation>
 <DMLVUTB5J1RJ.2QKOUW6UB04ZM@gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <DMLVUTB5J1RJ.2QKOUW6UB04ZM@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/3/26 22:11, Alexei Starovoitov wrote:
> On Tue, Nov 03, 2026 at 12:21 PM Harry Yoo <harry@kernel.org> wrote:
>> While this is technically true, this relies too much on the current
>> implementation details and makes the code hard to follow.
> 
> Fair enough. I don't insist.
> 
>> Patch 2 is an independent bugfix as-is already. We should really stop
>> open-coding slab_free_hook(). That ended up missing init_on_free handing.
> 
> Right. No objection to patch 2.
> With patches 2 and 3 the !allow_spin side of memcg_alloc_abort_single()
> is an open coded kfree_nolock():
> 
>   kfree_nolock()                    memcg_alloc_abort_single(!allow_spin)
>   --------------------------------  -------------------------------------
>   memcg_slab_free_hook()            -
>   alloc_tagging_slab_free_hook()    alloc_tagging_slab_free_hook()
>   slab_free_hook(!allow_spin)       slab_free_hook(!allow_spin)
>   free_to_pcs()                     -
>   defer_free()                      defer_free()
> 
> I don't insist on kfree_nolock() there,
> but can we try free_to_pcs() before defer_free() ?
> Like:
> 
> 	if (likely(allow_spin))
> 		__slab_free(s, slab, object, object, 1, _RET_IP_);
> 	else if (!can_free_to_pcs(slab) || !free_to_pcs(s, object, false))
> 		defer_free(s, object);

Why not try free_to_pcs with allow_spin as well then, and improve
memcg_alloc_abort_single() for both contexts?
