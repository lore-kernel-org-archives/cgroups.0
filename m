From: Abel Wu <wuyun.abel@bytedance.com>
Subject: Re: Re: [PATCH RESEND net-next 1/2] net-memcg: Scopify the indicators
 of sockmem pressure
Date: Wed, 12 Jul 2023 14:45:26 +0800
Message-ID: <987f7855-8b1e-ad1a-29d3-8511ccaa00b2@bytedance.com>
References: <20230711124157.97169-1-wuyun.abel@bytedance.com>
 <20230711204537.04cb1124@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <netdev+bounces-17058-gl-netdev-2=m.gmane-mx.org@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1689144338; x=1691736338;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=y8WhpdF8/RW8zGFH/BZgsqEuwmUxTSnkz6bmGMUpKLg=;
        b=W/GvKFglSlPxZ7GDe3SBJk00S68EMh1nVTwsJAwhPkQ3MT365bsUjoqdqE+/sA7CSN
         NRbg4zl/wx1Ls0jXTms3+eFHtQJyUHaiDmc3++U9grS799Xvv+6VfZ7rUTRs7OMQTQAB
         FWp2o073tH2I2V2BGGYkcvq9X9akSwkleCwtv4Cgn9Gl0v/0cXvmNCmhRYQdPENheFEs
         xGjTHkxJaBaShbI/QBVm5k2nSoBimFca0JrTPTEOBCnwYyet961sXcDsDzRAZpzsM6Db
         MLVmvFZEDnKOJT+7M+5szD2mCWMufCAeW02SnLCg9kpv0jB3gHFFeTNQKSCl0J7aqjAE
         5n8Q==
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Content-Language: en-US
In-Reply-To: <20230711204537.04cb1124@kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Jakub Kicinski <kuba@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, David Ahern <dsahern@kernel.org>, Yosry Ahmed <yosryahmed@google.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Yu Zhao <yuzhao@google.com>, Kefeng Wang <wangkefeng.wang@huawei.com>, Yafang Shao <laoar.shao@gmail.com>, Kuniyuki Iwashima <kuniyu@amazon.com>, Martin KaFai Lau <martin.lau@kernel.org>, Alexander Mikhalitsyn <alexander@mihalicyn.com>, Breno Leitao <leitao@debian.org>, David Howells <dhowells@redhat.com>, Jason Xing <kernelxing@tencent.com>, Xin Long <lucien.xin@gmail.com>, Michal Hocko <mhocko@suse.com>, Alexei

Hi Jakub,

On 7/12/23 11:45 AM, Jakub Kicinski wrote:
> On Tue, 11 Jul 2023 20:41:43 +0800 Abel Wu wrote:
>> Now there are two indicators of socket memory pressure sit inside
>> struct mem_cgroup, socket_pressure and tcpmem_pressure.
>>
>> When in legacy mode aka. cgroupv1, the socket memory is charged
>> into a separate counter memcg->tcpmem rather than ->memory, so
>> the reclaim pressure of the memcg has nothing to do with socket's
>> pressure at all. While for default mode, the ->tcpmem is simply
>> not used.
>>
>> So {socket,tcpmem}_pressure are only used in default/legacy mode
>> respectively. This patch fixes the pieces of code that make mixed
>> use of both.
> 
> Eric Dumazet is currently AFK, can we wait for him to return
> (in about a week) before merging?

Sure, thanks for providing this information!

Best Regards,
	Abel

