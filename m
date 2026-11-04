Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.62
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793755773;
	b=0z32YOVTQILc4CLG/hX4mDuUEXiVhz0athOaU8ZkiZPKxLs1zs4VM1+Hdgv7+OR02oXJ
	 0Pilf7zMj7dSihrGxtpRTrCcInfDIrO7BeJS0NpY1Z6Hk/gZhXZtGnsr2G1DyJ/uJss58
	 oXAqvtX0mgfF0ao+WVQivvJ4LiCVgC8u7d23OqJSnVaC/WYFXuy21QqOaBPePZyn7mvku
	 BpwK4idBV8YJ78n71euMEY4nxL9oVrD7UCWQAs+9CzEw4xhUFCiDRcckIUJuyKv1WMyDs
	 5T5pblXWVPJ7T2kFkvE61a5voudng4Rqi1Rn/8Q9rHcDwQGQ99uc6Ge5TLByfqNkLfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793755773;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=CE0t5hOROhr+8knZGqTWCAomcPgxGmzw+Md6f9Efdfw=;
	b=tFkuIVs3k4rr0QOelr0MeFhMBQVh1YpmLtoQdDtRswYVVy5Z25BiiGnzBvHK0ZUfJuCE
	 o8oeKjst1rlVPFgAzpi/v2FQ4leQ31yttge+WwrdzyD9ekodagGHTWSrCTYSetISXaC8N
	 4PLkk8pgMW/hXRLwmlk+AbjUcmqorQXMmnvnyr+uS/dNwDwTdXdsl19cTFTPZ8o52L92V
	 fgA66WkcjkAV1GrGePC9GSht5Y1cAuo9vLjdyiD8eiV7r6/S73W4XhutoCXn+0GVhVwMj
	 CMvPfk5ibfwYS2lyizJtB2c/dBy74MIJDAb09k8PWGySwWxHUsu/Efm14E5RBFdxKIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	arc=none smtp.remote-ip=91.218.175.62
Received: from mta0.migadu.com (out-62.mta0.migadu.com [91.218.175.62])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75846606D809
	for <cgroups@vger.kernel.org>; Wed,  4 Nov 2026 01:29:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 75846606D809
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=QwlcNBQAVDxk0/AvVL+NWkQwGw6IW0hqKl+WZhIVwVQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793755765; v=1; x=1794360565;
 b=o3nkAPqoiAhQCuG7W+cYJPXVqRbfmnABmAgU+ifZRUe+hpALHAZdbLU71L1/bypKy1hCRZel
 LrXg8QFqzflrTyf3WsCyaOUfD0hqrsfE7HFQUcMd5CRxhTZ3TmZ3IyBnoia8EK1s6VZ0g9JteeF
 u9uGQgAu7/aT6Re0f9SxG8j8=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 59a6eb213e4c26de;
	Wed, 04 Nov 2026 01:29:25 +0000
X-Mizu-Trace-ID: 59a6eb213e4c26de
X-Migadu-Flow: FLOW_OUT
Message-ID: <dd07c949-eb56-425a-8b1f-ceda118d3a5a@linux.dev>
Date: Wed, 4 Nov 2026 09:29:17 +0800
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
Subject: Re: [PATCH v6 7/7] mm/mglru: add tracepoint for inc_max_seq()
To: Barry Song <baohua@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
 Masami Hiramatsu <mhiramat@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Dave Chinner <david@fromorbit.com>,
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Kairui Song <kasong@tencent.com>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
 cgroups@vger.kernel.org,
 "open list:BPF [MISC]:Keyword:(?:b|_)bpf(?:b|_)" <bpf@vger.kernel.org>,
 Ridong Chen <chenridong@xiaomi.com>
References: <20261103025610.3738894-1-ridong.chen@linux.dev>
 <20261103025610.3738894-8-ridong.chen@linux.dev>
 <CAGsJ_4xCTSctcPcC7X6Dx4zYaOycaPqs0DG7AaxB55wx1Afwpg@mail.gmail.com>
 <9cabcddf-d807-4a36-84f1-5bb06ea72aac@linux.dev>
 <CAGsJ_4xXDZjhN+NkvtN+vAp8Bokack_JdNgP=nGPQtHUX8_rqg@mail.gmail.com>
 <f5137dbb-b0ed-44ea-a23f-5c848315a68a@linux.dev>
 <CAGsJ_4zNZynkZn1mb+nT1n6dq4n399VC8Lbo5Sv92gioDfPxUg@mail.gmail.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <CAGsJ_4zNZynkZn1mb+nT1n6dq4n399VC8Lbo5Sv92gioDfPxUg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 11/4/2026 2:28 AM, Barry Song wrote:
> On Tue, Nov 3, 2026 at 8:23 PM Ridong Chen <ridong.chen@linux.dev> wrote:
> [...]
>>
>> Hi Barry,
>>
>> Agreed, I'll go with option 2. Two things I'd like to confirm first:
>>
>> 1) To report the reason, should_run_aging() would need to return it
>>    instead of a bool, e.g. an enum like:
>>
>>     enum lru_gen_aging_reason {
>>          AGING_NONE,
>>          AGING_NO_EVICTABLE,     /* eviction is not possible anymore */
>>          AGING_MIN_GENS,         /* better to age, eviction still possible */
>>     };
>>
>> Or just report sc->priority, swappiness, max_seq/min_seq and the
>> per-generation nr_pages, and let users derive the reason from them?
>> The former is more direct, the latter keeps should_run_aging()
>> unchanged.
> 
> Right. We can let users infer the reason from max_seq,
> min_seq, and nr_pages in each generation. This shouldn't
> be difficult, especially since should_run_aging() may
> change. We don't need to spell out the exact reason.
> Just present users with the overall state of the lru_gen.
> 
>>
>> 2) try_to_shrink_lruvec() has changed quite a lot recently, e.g.
>> Kairui's reclaim loop rework, and your swappiness series also touches it,
>> including the aging part. Is it stable enough now to carry a tracepoint there?
>>
> 
> Yes, I think aging will always be needed, regardless of how
> we change the code, so this should remain stable.
> 

Thank you for your patience. That makes sense to me.

Will update.

-- 
Best regards
Ridong

