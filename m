Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC95144780E;
	Thu, 24 Sep 2026 09:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790241951; cv=none; b=osjLp1H+uLCoPNTrn08baZljY69Kisc9gcaAJiJAa2y8M8L9tSxPzaLjSstqay5HJlOiLmxK4A+1LVQWlexj+268QYCMCo3NHJbDuNE9auMEJ0qQ05TgTrXqy5y2P/kn3wZ3I+A0aKU2wlioBEbdjVUKGtfd/xor7dVG2Nr/X4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790241951; c=relaxed/simple;
	bh=4uX2DCeyU/gj5TAVOdte+2gkTbpIhw/EGKEofaFszQY=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=sY7fiKUbdUeZg+URT49h4BgOs2/U/RD96Ki2GVGBoHSAhdqqP5VXK1M7GLbO8xny0UB6Q0F2yB+fFl2MxOjjpNbIIshqlqQFtJ0+su1+dNKLMkYwcP0oc9JoDvFAlxWbGrv/zf8Fvu6FYc24A4lhx/n/u6ltdmLA6f/ORgWzzw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=oujNsmgU; arc=none smtp.client-ip=113.46.200.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="oujNsmgU"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=bDikpWMchPRZnYe6ZTjPxkVDUAVMs72pAdd9atbppWw=;
	b=oujNsmgUBwdI/eT1H+Qs5F7p2O9MDX6RLH5o2hJQlaLXAb/j6LdmuAxKAUikKwjx4ELt2b2y2
	lgUdHwxOESQ7bGcylb6iraoXxxUeyVASQYTIWGMFuLFmCa9f6T1UfMS9oTgO2W7hua9cXwHXMQz
	TcR+D/VUrVG60YNnOWDC2RI=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4hr7Rh5MhQznTVd;
	Thu, 24 Sep 2026 17:13:36 +0800 (CST)
Received: from whupemk100010.china.huawei.com (unknown [7.152.184.41])
	by mail.maildlp.com (Postfix) with ESMTPS id 91E8840586;
	Thu, 24 Sep 2026 17:25:40 +0800 (CST)
Received: from [10.67.109.91] (10.67.109.91) by whupemk100010.china.huawei.com
 (7.152.184.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 24 Sep
 2026 17:25:36 +0800
Message-ID: <d8c12b4e-4ff2-4c62-a40d-d67bb4680a0d@huawei.com>
Date: Thu, 24 Sep 2026 17:25:35 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC -next 0/5] net: charge socket memory budget to memcg
 upfront
To: Eric Dumazet <edumazet@google.com>
CC: <tj@kernel.org>, <hannes@cmpxchg.org>, <mkoutny@suse.com>,
	<corbet@lwn.net>, <skhan@linuxfoundation.org>, <rdunlap@infradead.org>,
	<kuniyu@google.com>, <pabeni@redhat.com>, <willemb@google.com>,
	<davem@davemloft.net>, <kuba@kernel.org>, <horms@kernel.org>,
	<ncardwell@google.com>, <matttbe@kernel.org>, <martineau@kernel.org>,
	<geliang@kernel.org>, <mhocko@kernel.org>, <roman.gushchin@linux.dev>,
	<shakeel.butt@linux.dev>, <muchun.song@linux.dev>, <cgroups@vger.kernel.org>,
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<netdev@vger.kernel.org>, <mptcp@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kselftest@vger.kernel.org>, <lujialin4@huawei.com>
References: <20260924080219.1036588-1-caixinchen1@huawei.com>
 <CANn89iJVGmYwQerOixGurH6vw-GtvSAQq6u6zSNZoyZrcEx6Jw@mail.gmail.com>
Content-Language: en-US
From: Cai Xinchen <caixinchen1@huawei.com>
In-Reply-To: <CANn89iJVGmYwQerOixGurH6vw-GtvSAQq6u6zSNZoyZrcEx6Jw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 whupemk100010.china.huawei.com (7.152.184.41)

Hi,

Thank you for the review.

We found that sk_forward_alloc is a plain int updated by a non-atomic
RMW (sk_forward_alloc_add(), where even the read side is not
READ_ONCE), and its writers span three unrelated lock domains:

   - socket lock, process context: SO_RESERVE_MEM and TX grants
      (__sk_mem_schedule(), sk_forced_mem_schedule());

   - receive-queue lock, softirq: UDP RX charges and the
      udp_rmem_release() fold;

   - no lock at all: sk_mem_charge()/sk_mem_uncharge() from
      skb_set_owner_r() and skb destructors, and the sk_mem_reclaim()
      fold itself.

Any cross-domain pair loses an update.  A lost charge is still
returned in full by the matching skb free, so it resurfaces as a
phantom surplus in sk_forward_alloc, and the next fold hands it back
to the memcg via __sk_mem_reduce_allocated() ->
mem_cgroup_sk_uncharge() - an uncharge with no matching charge.

We first tried to fix it with locks, and hit three walls:

   - the socket lock cannot be used: its holders free skbs (e.g.
      tcp_recvmsg()), and the destructor's sk_mem_uncharge() would
      need to re-acquire it - recursion.  That is why these helpers
      are lockless in the first place;

   - a new per-socket spinlock serializes the RMWs but not the bug:
      __sk_mem_schedule() publishes the grant before the memcg charge,
      and the charge may sleep (GFP_KERNEL, memcg reclaim/OOM), so no
      spinlock can cover both steps; a fold in that window can still
      refund pages whose charge afterwards fails;

   - such a lock would also sit on the per-packet charge/uncharge
      paths, exactly the hot path the cacheline layout around
      sk_forward_alloc was tuned to keep cheap.

Are there any good solutions to solve this problem?

On 9/24/2026 4:26 PM, Eric Dumazet wrote:
> On Thu, Sep 24, 2026 at 9:36 AM Cai Xinchen <caixinchen1@huawei.com> wrote:
>> The memcg socket accounting currently charges pages to the memory
>> cgroup per grant (__sk_mem_schedule() publishing forward allocation)
>> and refunds them later from skb destructors.  The refund side folds
>> per-skb "was this charged" snapshots back into the socket balance
>> under concurrent lockless RMW, and races there can drive the memcg
>> socket balance negative, ending with:
>>
>>      page_counter underflow
>>      WARNING: ... mm/page_counter.c ... page_counter_cancel()
>>
>> This series flips the model: a socket is charged its whole memory
>> budget (sk_sndbuf + sk_rcvbuf + sk_reserved_mem) to its memcg when the
>> budget is established or grows, and refunded when the budget shrinks
>> or the socket dies.  Grants and per-skb charge/uncharge stop touching
>> the memcg entirely, so the racy refund pairing has no code left to go
>> wrong: refunds can never exceed charges and the balance cannot
>> underflow by construction.
>>
>> Tested: full arm64 build with 0 warnings; each intermediate state
>> compiles (bisectable); tools/testing/selftests/cgroup builds clean.
>> Runtime validation on the workload that used to trigger the underflow
>> is pending.
>>
>
> Charging sk_sndbuf + sk_rcvbuf upfront to memory.current is not
> viable, especially for servers handling large numbers of connections
> (e.g. 1 million TCP sockets):
>
> We specifically went in the exact opposite direction in commit
> 4890b686f408 ("net: keep sk->sk_forward_alloc as small as possible")
> to make sure idle sockets hold zero forward-allocated memory and
> non-idle sockets hold less than one page (4 KB) in sk_forward_alloc.
>
>
> 1. Massive phantom memory charges and false OOMs:
>     With default sysctl_tcp_wmem[1] (16 KB) and sysctl_tcp_rmem[1]
>     (128 KB), 1 million completely idle TCP sockets immediately charge
>     144 GB to the cgroup's memory.current while holding 0 bytes of
>     actual packet buffers.
>     Worse, once TCP autotuning grows sk_rcvbuf / sk_sndbuf during a
>     short burst (up to tcp_rmem[2] = 6 MB and tcp_wmem[2] = 4 MB by
>     default), TCP does not shrink sk_rcvbuf or sk_sndbuf when the queues
>     drain and the connection becomes idle again. 1 million long-lived,
>     mostly-idle connections would permanently pin hundreds of GBs (up to
>     several TBs) of non-existent memory in memory.current, forcing the
>     memcg into constant reclaim thrashing of real page cache/anon pages
>     and triggering premature memcg OOM kills.
>
> 2. Overcommitted caps vs. physical reservations:
>     sk_sndbuf and sk_rcvbuf are per-socket upper bounds that are heavily
>     overcommitted across sockets, not reservations (unlike SO_RESERVE_MEM).
>     Comparing this to vm_committed_as is flawed: vm_committed_as tracks
>     virtual address space overcommit globally and is never charged to
>     memcg's memory.current for the exact same reason.
>
> 3. Broken memcg limit enforcement (memory.max bypass):
>     __sk_mem_raise_allocated() drops mem_cgroup_sk_charge() completely,
>     while sk_memcg_budget_sync() ignores charge failures ("the new budget
>     is used uncharged"). When a cgroup reaches memory.max,
>     sk_memcg_budget_sync() fails in sock_init_data_uid(), tcp_init_sock(),
>     setsockopt(SO_SNDBUF/SO_RCVBUF), or autotuning, yet sk_sndbuf and
>     sk_rcvbuf are still raised. Subsequent skb allocations in
>     __sk_mem_schedule() will then allocate real physical memory without
>     charging the memcg at all.
>
> 4. Unnecessary struct sock bloat and hot-path overhead:
>     - Adds 8 bytes (sk_memcg_budget + sk_memcg_budget_lock) to struct sock
>       (even when !CONFIG_MEMCG).
>     - Acquires spin_lock_bh(&sk->sk_memcg_budget_lock) inside
>       sk_mem_reclaim().
>     - Every TCP socket creation charges rmem_default + wmem_default
>       (416 KB) in sock_init_data_uid() and immediately uncharges 272 KB
>       in tcp_init_sock().
>
> If you are hitting a page_counter underflow race in socket memcg
> accounting, please share the exact race / stack trace and fix the
> underlying accounting bug rather than charging uncommitted buffer limits.
