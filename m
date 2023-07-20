From: Abel Wu <wuyun.abel@bytedance.com>
Subject: Re: [PATCH RESEND net-next 1/2] net-memcg: Scopify the indicators of
 sockmem pressure
Date: Thu, 20 Jul 2023 15:58:49 +0800
Message-ID: <d114834c-2336-673f-f200-87fc6efb411f@bytedance.com>
References: <20230711124157.97169-1-wuyun.abel@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <netdev+bounces-19368-gl-netdev-2=m.gmane-mx.org@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1689839944; x=1690444744;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QCBG10jWmv8n11PUl1At+mRhQs+STyCHC9Y8ykk98hs=;
        b=Nnu9yXWnT11QAdbQ9GUhYKZSFFcUk0bsZdtUNqUMHxBWMFa6402Ny2yH5iQxEZhGtt
         Kz3XRv01VgrqlGSpLQm7E8BKzJTbIbnZkymzLZbp9YmpoHsQYwRejn13SBbT7IrQTO6U
         SSKMw0RKNd+ruoF1X7gd4bGzDUdn3VZamns/FpVKcyZVE8bZfh3ZB7SkwGWidjmpWE2S
         z1eYV6E/QnugvkY/taUn0a53MkAB3OHG65tL3psRnBqx/L04+GCvHT8xrBnv01/ZpdL0
         kXwHSiBUs/WAYR8ArUnjYyaQ6W/MAMWTQXpvjgTEogO5unsJNpTbyHBzDOtgtGFpgt0g
         Sp/Q==
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Content-Language: en-US
In-Reply-To: <20230711124157.97169-1-wuyun.abel@bytedance.com>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, David Ahern <dsahern@kernel.org>, Yosry Ahmed <yosryahmed@google.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Yu Zhao <yuzhao@google.com>, Kefeng Wang <wangkefeng.wang@huawei.com>, Yafang Shao <laoar.shao@gmail.com>, Kuniyuki Iwashima <kuniyu@amazon.com>, Martin KaFai Lau <martin.lau@kernel.org>, Alexander Mikhalitsyn <alexander@mihalicyn.com>, Breno Leitao <leitao@debian.org>, David Howells <dhowells@redhat.com>, Jason Xing <kernelxing@tencent.com>, Xin Long <lucien.xin@gmail.com>
Cc: Michal Hocko <mhocko@suse.com>, Alexei Starovoitov <ast@kernel.org>, open list <linux-kernel@vger.kernel.org>, "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>, "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <linux-mm@kvack.org>

Gentle ping :)

On 7/11/23 8:41 PM, Abel Wu wrote:
> Now there are two indicators of socket memory pressure sit inside
> struct mem_cgroup, socket_pressure and tcpmem_pressure.
> 
> When in legacy mode aka. cgroupv1, the socket memory is charged
> into a separate counter memcg->tcpmem rather than ->memory, so
> the reclaim pressure of the memcg has nothing to do with socket's
> pressure at all. While for default mode, the ->tcpmem is simply
> not used.
> 
> So {socket,tcpmem}_pressure are only used in default/legacy mode
> respectively. This patch fixes the pieces of code that make mixed
> use of both.
> 
> Signed-off-by: Abel Wu <wuyun.abel@bytedance.com>
> ---
>   include/linux/memcontrol.h | 4 ++--
>   mm/vmpressure.c            | 8 ++++++++
>   2 files changed, 10 insertions(+), 2 deletions(-)
> 

