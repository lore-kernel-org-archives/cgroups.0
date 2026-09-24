Received: from canpmsgout10.his.huawei.com (canpmsgout10.his.huawei.com [113.46.200.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9364D430CE3;
	Thu, 24 Sep 2026 09:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.225
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790242133; cv=none; b=VohrNFWwyNzRzTnucwfrQqq56gbbL8sbDt0AMheNjJrma2goplRfuTkpXyXo+2dO+81beVOYbqtAfehI0o3j1y5Ntq10Mjf6tzid9g9IqzJiCVGpn0WHvaZThtKWqrPZAViq6BcIIS22Pdx44+z81iAnyzWHkcANHZGEGi+iLIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790242133; c=relaxed/simple;
	bh=OYE/TYuJFLnqD116U3B2S7jj30mMpoum0h40my/JVPk=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:CC:References:
	 In-Reply-To:Content-Type; b=t5aKDxjU3RPGkaQ936sj7mFCmU9frX7VVRyQAI4qOU7iJX2P3VrQ13e6gTz6OHDXnmOY0e4fhzMKGjcSQYdofjoN+52BVL/8dvwq+NqWV1voZIK1dwr0G73hOEdgGqC+8/N8i6OmqGW4wIzinOIwvdbZVbt9TwTWYlSN5cnyYJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=QIeFFGxa; arc=none smtp.client-ip=113.46.200.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="QIeFFGxa"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=0vgJBFcAarvZPPjPRuyQRtOiNZIDP2Jdgbmv47TJbwY=;
	b=QIeFFGxaGPCo0/SVEk68hpIKgYJMMzL4hRClLXtJ9qdII7iAVJ3g/G+Hn+GzFD+ilOWqW0rOi
	ooAg/zA7gqo/+L8HIYMBhPQPKa7rEIr1+DL1rP2BYsQthDBu0T2yevDfTMTSSofa7KtRGj08+bM
	I8JZzXgNw1WolVRaEHq5jHU=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout10.his.huawei.com (SkyGuard) with ESMTPS id 4hr7W71sC4z1K9D2;
	Thu, 24 Sep 2026 17:16:35 +0800 (CST)
Received: from whupemk100010.china.huawei.com (unknown [7.152.184.41])
	by mail.maildlp.com (Postfix) with ESMTPS id 625884057A;
	Thu, 24 Sep 2026 17:28:41 +0800 (CST)
Received: from [10.67.109.91] (10.67.109.91) by whupemk100010.china.huawei.com
 (7.152.184.41) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Thu, 24 Sep
 2026 17:28:36 +0800
Message-ID: <5a88421d-10ef-4fca-9acb-85a27a3c1173@huawei.com>
Date: Thu, 24 Sep 2026 17:28:35 +0800
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC -next 0/5] net: charge socket memory budget to memcg
 upfront
From: Cai Xinchen <caixinchen1@huawei.com>
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
 <d8c12b4e-4ff2-4c62-a40d-d67bb4680a0d@huawei.com>
Content-Language: en-US
In-Reply-To: <d8c12b4e-4ff2-4c62-a40d-d67bb4680a0d@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 whupemk100010.china.huawei.com (7.152.184.41)

And there is a repro

#define _GNU_SOURCE
#include <arpa/inet.h>
#include <errno.h>
#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/stat.h>
#include <unistd.h>

#ifndef SO_RESERVE_MEM
#define SO_RESERVE_MEM 73
#endif

static int fd = -1;        /* receiver: SO_RESERVE_MEM + RX charges */
static int fd_tx = -1;        /* loopback sender */
static struct sockaddr_in addr;
static volatile int stop_flag;
static long n_opt, n_opt_err, n_tx, n_tx_err, n_rx;
static int mode = 3;        /* 1=A only, 2=B+C only, 3=all */

static void pin_cpu(int cpu)
{
     cpu_set_t cpuset;

     CPU_ZERO(&cpuset);
     CPU_SET(cpu, &cpuset);
     pthread_setaffinity_np(pthread_self(), sizeof(cpuset), &cpuset);
}

/* Thread A (CPU0): random page-aligned SO_RESERVE_MEM targets.  A
  * random target is almost never equal to the current reserved value,
  * so nearly every setsockopt performs a real reserve or release
  * (sk_forward_alloc_add RMW) whose window can be interrupted by the
  * NET_RX softirq charge. */
static void *hammer(void *arg)
{
     long n = 0, err = 0;
     unsigned int seed = 0x9e37;

     (void)arg;
     pin_cpu(0);
     while (!stop_flag) {
         int val = (1 + rand_r(&seed) % 63) << 12;

         if (setsockopt(fd, SOL_SOCKET, SO_RESERVE_MEM,
                    &val, sizeof(val)) < 0)
             err++;
         n++;
     }
     n_opt = n;
     n_opt_err = err;
     return NULL;
}

/* Thread B (CPU1): loopback UDP flood.  Each sendto() enqueues to the
  * per-cpu backlog and raises NET_RX on the sending CPU, so the RX
  * softirq (skb charge -> __sk_mem_schedule -> sk_forward_alloc_add)
  * runs on CPU1 -- truly concurrent with thread A's detector windows
  * on CPU0 under KVM.  sk_setsockopt serializes setsockopt callers via
  * the socket lock, but softirq writers do not take that lock: this is
  * the same collision topology as the original sockmap verdict pair. */
static void *sender(void *arg)
{
     char buf[1024];
     long n = 0, err = 0;

     (void)arg;
     pin_cpu(1);
     memset(buf, 'x', sizeof(buf));
     while (!stop_flag) {
         if (sendto(fd_tx, buf, sizeof(buf), 0,
                (struct sockaddr *)&addr, sizeof(addr)) < 0)
             err++;
         n++;
     }
     n_tx = n;
     n_tx_err = err;
     return NULL;
}

/* Thread C (CPU1): drain the receive queue so charging keeps flowing
  * and every freed skb's udp_rmem_release reclaim pairs against a
  * charge that may have been lost to a race. */
static void *drain(void *arg)
{
     char buf[4096];
     long n = 0;

     (void)arg;
     pin_cpu(1);
     while (!stop_flag) {
         ssize_t r = recv(fd, buf, sizeof(buf), MSG_DONTWAIT);

         if (r > 0) {
             n++;
         } else {
             usleep(50);
         }
     }
     n_rx = n;
     return NULL;
}

static int cat_file(const char *path)
{
     char buf[128];
     FILE *f = fopen(path, "r");

     if (!f)
         return -1;
     if (fgets(buf, sizeof(buf), f)) {
         printf("[*] %s = %s", path, buf);
         return 0;
     }
     fclose(f);
     return -1;
}

int main(int argc, char **argv)
{
     int secs = argc > 1 ? atoi(argv[1]) : 30;
     socklen_t alen = sizeof(addr);
     pthread_t ta, tb, tc;
     int one = 1;
     FILE *f;

     if (argc > 2)
         mode = atoi(argv[2]);

     /* dedicated v2 memcg so memory.current is observable; recreate it
      * each run so the balance starts clean (a leaked/deflated balance
      * from earlier runs would poison the results) */
     rmdir("/sys/fs/cgroup/repro_rmem");
     mkdir("/sys/fs/cgroup/repro_rmem", 0755);
     f = fopen("/sys/fs/cgroup/repro_rmem/cgroup.procs", "w");
     if (f) {
         fprintf(f, "0\n");
         fclose(f);
         printf("[+] joined /sys/fs/cgroup/repro_rmem\n");
     } else {
         printf("[!] join memcg failed (%s), continuing in root\n",
                strerror(errno));
     }

     fd = socket(AF_INET, SOCK_DGRAM, 0);
     fd_tx = socket(AF_INET, SOCK_DGRAM, 0);
     if (fd < 0 || fd_tx < 0) {
         perror("socket");
         return 1;
     }
     setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &one, sizeof(one));
     memset(&addr, 0, sizeof(addr));
     addr.sin_family = AF_INET;
     addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
     addr.sin_port = 0;
     if (bind(fd, (struct sockaddr *)&addr, sizeof(addr)) < 0) {
         perror("bind");
         return 1;
     }
     getsockname(fd, (struct sockaddr *)&addr, &alen);
     printf("[+] udp rx socket fd=%d on 127.0.0.1:%d, mode=%d "
            "(1=A only, 2=B+C, 3=all)\n",
            fd, ntohs(addr.sin_port), mode);
     setsockopt(fd, SOL_SOCKET, SO_RCVBUF, (int[]){ 1 << 20 }, sizeof(int));

     if (mode & 1)
         pthread_create(&ta, NULL, hammer, NULL);
     if (mode & 2) {
         pthread_create(&tb, NULL, sender, NULL);
         pthread_create(&tc, NULL, drain, NULL);
     }
     printf("[*] running for %ds ...\n", secs);
     sleep(secs);
     stop_flag = 1;
     if (mode & 1)
         pthread_join(ta, NULL);
     if (mode & 2) {
         pthread_join(tb, NULL);
         pthread_join(tc, NULL);
     }

     printf("[*] done: setsockopt=%ld (err %ld), sent=%ld (err %ld), 
recv=%ld\n",
            n_opt, n_opt_err, n_tx, n_tx_err, n_rx);
     cat_file("/sys/fs/cgroup/repro_rmem/memory.current");
     cat_file("/sys/fs/cgroup/repro_rmem/memory.stat");
     return 0;
}


On 9/24/2026 5:25 PM, Cai Xinchen wrote:
> Hi,
>
> Thank you for the review.
>
> We found that sk_forward_alloc is a plain int updated by a non-atomic
> RMW (sk_forward_alloc_add(), where even the read side is not
> READ_ONCE), and its writers span three unrelated lock domains:
>
>   - socket lock, process context: SO_RESERVE_MEM and TX grants
>      (__sk_mem_schedule(), sk_forced_mem_schedule());
>
>   - receive-queue lock, softirq: UDP RX charges and the
>      udp_rmem_release() fold;
>
>   - no lock at all: sk_mem_charge()/sk_mem_uncharge() from
>      skb_set_owner_r() and skb destructors, and the sk_mem_reclaim()
>      fold itself.
>
> Any cross-domain pair loses an update.  A lost charge is still
> returned in full by the matching skb free, so it resurfaces as a
> phantom surplus in sk_forward_alloc, and the next fold hands it back
> to the memcg via __sk_mem_reduce_allocated() ->
> mem_cgroup_sk_uncharge() - an uncharge with no matching charge.
>
> We first tried to fix it with locks, and hit three walls:
>
>   - the socket lock cannot be used: its holders free skbs (e.g.
>      tcp_recvmsg()), and the destructor's sk_mem_uncharge() would
>      need to re-acquire it - recursion.  That is why these helpers
>      are lockless in the first place;
>
>   - a new per-socket spinlock serializes the RMWs but not the bug:
>      __sk_mem_schedule() publishes the grant before the memcg charge,
>      and the charge may sleep (GFP_KERNEL, memcg reclaim/OOM), so no
>      spinlock can cover both steps; a fold in that window can still
>      refund pages whose charge afterwards fails;
>
>   - such a lock would also sit on the per-packet charge/uncharge
>      paths, exactly the hot path the cacheline layout around
>      sk_forward_alloc was tuned to keep cheap.
>
> Are there any good solutions to solve this problem?
>
> On 9/24/2026 4:26 PM, Eric Dumazet wrote:
>> On Thu, Sep 24, 2026 at 9:36 AM Cai Xinchen <caixinchen1@huawei.com> 
>> wrote:
>>> The memcg socket accounting currently charges pages to the memory
>>> cgroup per grant (__sk_mem_schedule() publishing forward allocation)
>>> and refunds them later from skb destructors.  The refund side folds
>>> per-skb "was this charged" snapshots back into the socket balance
>>> under concurrent lockless RMW, and races there can drive the memcg
>>> socket balance negative, ending with:
>>>
>>>      page_counter underflow
>>>      WARNING: ... mm/page_counter.c ... page_counter_cancel()
>>>
>>> This series flips the model: a socket is charged its whole memory
>>> budget (sk_sndbuf + sk_rcvbuf + sk_reserved_mem) to its memcg when the
>>> budget is established or grows, and refunded when the budget shrinks
>>> or the socket dies.  Grants and per-skb charge/uncharge stop touching
>>> the memcg entirely, so the racy refund pairing has no code left to go
>>> wrong: refunds can never exceed charges and the balance cannot
>>> underflow by construction.
>>>
>>> Tested: full arm64 build with 0 warnings; each intermediate state
>>> compiles (bisectable); tools/testing/selftests/cgroup builds clean.
>>> Runtime validation on the workload that used to trigger the underflow
>>> is pending.
>>>
>>
>> Charging sk_sndbuf + sk_rcvbuf upfront to memory.current is not
>> viable, especially for servers handling large numbers of connections
>> (e.g. 1 million TCP sockets):
>>
>> We specifically went in the exact opposite direction in commit
>> 4890b686f408 ("net: keep sk->sk_forward_alloc as small as possible")
>> to make sure idle sockets hold zero forward-allocated memory and
>> non-idle sockets hold less than one page (4 KB) in sk_forward_alloc.
>>
>>
>> 1. Massive phantom memory charges and false OOMs:
>>     With default sysctl_tcp_wmem[1] (16 KB) and sysctl_tcp_rmem[1]
>>     (128 KB), 1 million completely idle TCP sockets immediately charge
>>     144 GB to the cgroup's memory.current while holding 0 bytes of
>>     actual packet buffers.
>>     Worse, once TCP autotuning grows sk_rcvbuf / sk_sndbuf during a
>>     short burst (up to tcp_rmem[2] = 6 MB and tcp_wmem[2] = 4 MB by
>>     default), TCP does not shrink sk_rcvbuf or sk_sndbuf when the queues
>>     drain and the connection becomes idle again. 1 million long-lived,
>>     mostly-idle connections would permanently pin hundreds of GBs (up to
>>     several TBs) of non-existent memory in memory.current, forcing the
>>     memcg into constant reclaim thrashing of real page cache/anon pages
>>     and triggering premature memcg OOM kills.
>>
>> 2. Overcommitted caps vs. physical reservations:
>>     sk_sndbuf and sk_rcvbuf are per-socket upper bounds that are heavily
>>     overcommitted across sockets, not reservations (unlike 
>> SO_RESERVE_MEM).
>>     Comparing this to vm_committed_as is flawed: vm_committed_as tracks
>>     virtual address space overcommit globally and is never charged to
>>     memcg's memory.current for the exact same reason.
>>
>> 3. Broken memcg limit enforcement (memory.max bypass):
>>     __sk_mem_raise_allocated() drops mem_cgroup_sk_charge() completely,
>>     while sk_memcg_budget_sync() ignores charge failures ("the new 
>> budget
>>     is used uncharged"). When a cgroup reaches memory.max,
>>     sk_memcg_budget_sync() fails in sock_init_data_uid(), 
>> tcp_init_sock(),
>>     setsockopt(SO_SNDBUF/SO_RCVBUF), or autotuning, yet sk_sndbuf and
>>     sk_rcvbuf are still raised. Subsequent skb allocations in
>>     __sk_mem_schedule() will then allocate real physical memory without
>>     charging the memcg at all.
>>
>> 4. Unnecessary struct sock bloat and hot-path overhead:
>>     - Adds 8 bytes (sk_memcg_budget + sk_memcg_budget_lock) to struct 
>> sock
>>       (even when !CONFIG_MEMCG).
>>     - Acquires spin_lock_bh(&sk->sk_memcg_budget_lock) inside
>>       sk_mem_reclaim().
>>     - Every TCP socket creation charges rmem_default + wmem_default
>>       (416 KB) in sock_init_data_uid() and immediately uncharges 272 KB
>>       in tcp_init_sock().
>>
>> If you are hitting a page_counter underflow race in socket memcg
>> accounting, please share the exact race / stack trace and fix the
>> underlying accounting bug rather than charging uncommitted buffer 
>> limits.
