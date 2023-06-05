From: Abel Wu <wuyun.abel@bytedance.com>
Subject: Re: Re: [PATCH net-next v5 3/3] sock: Fix misuse of
 sk_under_memory_pressure()
Date: Mon, 5 Jun 2023 16:34:21 +0800
Message-ID: <c35446b4-5e7f-3c3c-6d42-80e9721e5169@bytedance.com>
References: <20230602081135.75424-1-wuyun.abel@bytedance.com>
 <20230602081135.75424-4-wuyun.abel@bytedance.com>
 <20230602205322.ehxm2q2mbg5laa5s@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <netdev+bounces-7914-gl-netdev-2=m.gmane-mx.org@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1685954070; x=1688546070;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q2TZNl5uXZLERatZxawVlXcspibbKzrKFt5URrysKFA=;
        b=U/Hst64/q7IHCQs/aCEtc3h12jUOv/3Y2satYoV0hCyFNe9CWPhRhu183waaiEP5uR
         aZmQTEH4L6MF9GYV+hyLL1o8qbBVOKnNoDNnpLn6KS7JaqGyHAkQYz5hRbiyeGR2QSNT
         Pnu/K7PjQrckFxYiLZw2zoQdNuymJbpeIcVKUdreIIWWmokWZDWZBGq5+fpFIFaZcJoF
         lAks66nEknd7hFtUXWchztjRFSMISb7BU7WRaUqN2jz429GQjfDgbCE/PeMek2nIjacq
         R1tCcKNfK8mh2cNcAuY5v62xB7lAK3mmKNguLr2Kbx/HHTGlQVSelgbLfQUI38crs4zX
         aUOQ==
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
Content-Language: en-US
In-Reply-To: <20230602205322.ehxm2q2mbg5laa5s@google.com>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Shakeel Butt <shakeelb@google.com>
Cc: "David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Muchun Song <muchun.song@linux.dev>, Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On 6/3/23 4:53 AM, Shakeel Butt wrote:
> On Fri, Jun 02, 2023 at 04:11:35PM +0800, Abel Wu wrote:
>> The status of global socket memory pressure is updated when:
>>
>>    a) __sk_mem_raise_allocated():
>>
>> 	enter: sk_memory_allocated(sk) >  sysctl_mem[1]
>> 	leave: sk_memory_allocated(sk) <= sysctl_mem[0]
>>
>>    b) __sk_mem_reduce_allocated():
>>
>> 	leave: sk_under_memory_pressure(sk) &&
>> 		sk_memory_allocated(sk) < sysctl_mem[0]
> 
> There is also sk_page_frag_refill() where we can enter the global
> protocol memory pressure on actual global memory pressure i.e. page
> allocation failed. However this might be irrelevant from this patch's
> perspective as the focus is on the leaving part.

Leaving prot pressure or not under actual global vm pressure is
something similar to what you concerned last time (prot & memcg
is now intermingled), as this will mix prot & global together.

To decouple global info from prot level pressure, a new variable
might be needed. But I doubt the necessity as this seems to be a
rare case but a constant overhead on net core path to check the
global status (although can be relieved by static key).

And after a second thought, failing in skb_page_frag_refill()
doesn't necessarily mean there is global memory pressure since
it can due to the mpol/memset of the current task.

> 
>>
>> So the conditions of leaving global pressure are inconstant, which
> 
> *inconsistent

Will fix in next version.

> 
>> may lead to the situation that one pressured net-memcg prevents the
>> global pressure from being cleared when there is indeed no global
>> pressure, thus the global constrains are still in effect unexpectedly
>> on the other sockets.
>>
>> This patch fixes this by ignoring the net-memcg's pressure when
>> deciding whether should leave global memory pressure.
>>
>> Fixes: e1aab161e013 ("socket: initial cgroup code.")
>> Signed-off-by: Abel Wu <wuyun.abel@bytedance.com>
> 
> This patch looks good.

Thanks!
	Abel

