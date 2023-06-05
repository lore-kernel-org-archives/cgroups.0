From: Abel Wu <wuyun.abel@bytedance.com>
Subject: Re: Re: [PATCH net-next v5 1/3] net-memcg: Fold dependency into memcg
 pressure cond
Date: Mon, 5 Jun 2023 19:52:10 +0800
Message-ID: <2a45da69-b164-0a4f-eb45-fe57f301bc4b@bytedance.com>
References: <20230602081135.75424-1-wuyun.abel@bytedance.com>
 <20230602081135.75424-2-wuyun.abel@bytedance.com>
 <20230602202549.7nvrv4bx4cu7qxdn@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1685965938; x=1688557938;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JyOkEllK607lv9MCxWlko/8/h878DjdboSx2KDG6rPU=;
        b=eabMDt3oXuyeHqL6H95VDxv5qnDlp7C/hXkIKi9mE5RBAoY3t66MibAVJ1OyJOW3RI
         LESpN9wTXsuJaXmyQk+hrcImYockzT2vENkn0uB59YWGFQT7hU0htS22r94rGoWZJ1YS
         eoMFe+spUeV1gW22xOKgrGgYhj/hXExeWe7dvKuanyNNdN57KqW3msbApkAjrVNHxOtH
         2EV24MAFpyA7wBZbT8EjHQGq6521MTjFuENHeMbCjF6EV2PW0DHne8ZVihA3/f7CW1fQ
         8Bv+F4Ee4r1/xl5PFWZJhZqmG6IGRtjbIuE4DZGEOct1kfALIIWaFsW2cZWi2tbimrFI
         H4JQ==
Content-Language: en-US
In-Reply-To: <20230602202549.7nvrv4bx4cu7qxdn@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
To: Shakeel Butt <shakeelb@google.com>
Cc: "David S . Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Muchun Song <muchun.song@linux.dev>, Simon Horman <simon.horman@corigine.com>, netdev@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On 6/3/23 4:25 AM, Shakeel Butt wrote:
> On Fri, Jun 02, 2023 at 04:11:33PM +0800, Abel Wu wrote:
>> The callers of mem_cgroup_under_socket_pressure() should always make
>> sure that (mem_cgroup_sockets_enabled && sk->sk_memcg) is true. So
>> instead of coding around all the callsites, put the dependencies into
>> mem_cgroup_under_socket_pressure() to avoid redundancy and possibly
>> bugs.
>>
>> This change might also introduce slight function call overhead *iff*
>> the function gets expanded in the future. But for now this change
>> doesn't make binaries different (checked by vimdiff) except the one
>> net/ipv4/tcp_input.o (by scripts/bloat-o-meter), which is probably
>> negligible to performance:
>>
>> add/remove: 0/0 grow/shrink: 1/2 up/down: 5/-5 (0)
>> Function                                     old     new   delta
>> tcp_grow_window                              573     578      +5
>> tcp_try_rmem_schedule                       1083    1081      -2
>> tcp_check_space                              324     321      -3
>> Total: Before=44647, After=44647, chg +0.00%
>>
>> So folding the dependencies into mem_cgroup_under_socket_pressure()
>> is generally a good thing and provides better readablility.
>>
> 
> I don't see how it is improving readability. If you have removed the use
> of mem_cgroup_sockets_enabled completely from the networking then I can
> understand but this change IMHO will actually decrease the readability
> because the later readers will have to reason why we are doing this
> check at some places but not other.

Yes, I agree. I am trying to let networking get rid of this macro
entirely, but get stuck on inet_csk_accept().. :(
