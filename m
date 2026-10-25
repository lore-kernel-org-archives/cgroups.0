Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.80
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792913166;
	b=VwoXu4a7E4zMFt1jjFMIMzFIok92OVqRXRLsntYCQgqG/jPNqbkMnrIoPwrq13PhnGvM
	 gGbAvd/PbNiE+TNizCdKMoTBGcv63CyTwQFhFuoOUGmlHxeb9xbb5RNhkj5+7gX7meymt
	 KscElcdF9vCTj+ODocvWQQWGg7u/dg6hcDdRX7Mnh4xA0mGL6QqSdmGZbMXQLQvsczD3T
	 K9Vy9gqZb/BcpQrXIuzfftynCNSQOvVrqhf3SWWzaSDOL8jr62TqzO3oxdUaAIYeZiYjT
	 GgBtkG8ExdCk50RVXKbQvOB1RY7vqE2o3f/waubC4VpyIi9WS3QN6oLXhew8PFNQc2Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792913166;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=j9KSsqg4A137dhfxHCtQJ3v4H0Z3Fv0RGgyT9sIdyTM=;
	b=vEc/49Y2xR+ELriSNicJfyvnMZnrGNiI8EaTgmMzoNEDPhHd6VcKEZRR30ZoXmBwyWdI
	 mvwwPfQQpf0rJp/rS7TLE4J/CBkcVgcpNWSnBhG5aKjvEwsalGyyqpip8HLxwgxdlLqQG
	 M1KTFtf/5AN7+DybqoyPhT56vtpDuzbe39NGG78BZzFHXX4esAenuQaUFdaPlUL0uxCKV
	 w6S5z6qnuAxUoH918POKLI4eq4gWrAcIdT7Q7KtTCUSEXylVfgA0bCD1GWZwB3EeJzQe3
	 3vJq+hGIZ8ooPwSkMjYOxtaF2t7WVfW6dfCKdTNPHfRSooNaTB5v1SSO4fd9g4qHmrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=SrylrmSI;
	arc=none smtp.remote-ip=91.218.175.80
Received: from mta0.migadu.com (out-80.mta0.migadu.com [91.218.175.80])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46F4D606A31B
	for <cgroups@vger.kernel.org>; Sun, 25 Oct 2026 07:26:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 46F4D606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=SrylrmSI
X-Envelope-To: cgroups@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=EX8dlYfY5NSf0gGAQukKQCIqou6iNOsLwD+U7YkkxHM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792913161; v=1; x=1793517961;
 b=SrylrmSI51G99gfF6hP20BW1YezhxVFD2E9TcQm9rb+kJyGod8R9UFeYM6oOD81yF6EmKP2a
 Cc7uTvxq0o6eOPxCE4pAEqTqOXP3yM9Z7W4JamGMlFNRx6/ZfN5JtJTLvu3e35ENVW7M1jFEBZL
 wR28/ZW6JvosYCN7CyRmoWgg=
X-Envelope-To: cgroups@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 483da7f721b1c77a;
	Sun, 25 Oct 2026 07:25:59 +0000
X-Mizu-Trace-ID: 483da7f721b1c77a
X-Migadu-Flow: FLOW_OUT
Message-ID: <c9df96da-983e-4803-9082-472f5294d50e@linux.dev>
Date: Sun, 25 Oct 2026 15:25:46 +0800
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
Subject: Re: [PATCH v4 7/9] mm/vmscan: pass scan_control to
 mm_vmscan_balance_pgdat_end
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
 cgroups@vger.kernel.org, bpf@vger.kernel.org,
 Ridong Chen <chenridong@xiaomi.com>
References: <20261019034426.2354049-1-ridong.chen@linux.dev>
 <20261019042308.2372396-2-ridong.chen@linux.dev>
 <CAGsJ_4z7u_PtSkjm+kH7JX_ZZDLSnGr1teHq6By0ovgB23O8_w@mail.gmail.com>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <CAGsJ_4z7u_PtSkjm+kH7JX_ZZDLSnGr1teHq6By0ovgB23O8_w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 10/25/2026 6:24 AM, Barry Song wrote:
> On Mon, Oct 19, 2026 at 12:24 PM Ridong Chen <ridong.chen@linux.dev> wrote:
>>
>> From: Ridong Chen <chenridong@xiaomi.com>
>>
>> balance_pgdat() passes sc.order and sc.nr_reclaimed to
>> mm_vmscan_balance_pgdat_end as bare arguments. Pass the enclosing
>> struct scan_control instead and read the fields out in TP_fast_assign,
>> consistent with the other reclaim tracepoints. highest_zoneidx stays a
>> separate argument: it is a balance_pgdat() parameter, and
>> sc.reclaim_idx may differ from it by the time the end event fires.
>>
>> No functional change. The tracefs event format (TP_STRUCT__entry and
>> TP_printk) is unchanged, so tracefs-based consumers are unaffected.
>> BPF programs attached via raw_tp/tp_btf see the new TP_PROTO and need
>> to be adjusted; tracepoints are not a stable ABI (see
>> Documentation/bpf/bpf_design_QA.rst).
>>
>> Assisted-by: LLM
>> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> 
> Could we combine patches 4–7 into a single patch? The changes
> seem a bit too scattered across separate patches.
> 
Sure, I split the patches just to make them easier to review, since each one 
contains only small changes.

-- 
Best regards
Ridong

