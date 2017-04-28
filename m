From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup: fix spurious warnings on cgroup_is_dead() from
 cgroup_sk_alloc()
Date: Fri, 28 Apr 2017 15:27:47 -0400
Message-ID: <20170428192747.GB19364@htj.duckdns.org>
References: <20170428192656.GA19364@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8fXvxa+RRzIr4ylmLim1G7Ew/NXZqD6j62gOm1OhOw0=;
        b=Mxxk3zyoCoN4JkMC186rvxNd/8h1PytB+hlz9uCPQx3gLeAjUJeQVHJeCrqf9qha3P
         jSx8YI3XhBhyDhrBsvTZKp8DxJ3xEijA1eVfcmN+gtJAeuej5gUiRYFk8/Rm2DeeU5dH
         5vbvV9YOeCe28zO7zSK85LLQKMoH0TyWksxJyj9T5/NlXZiT8az5HtncFJeM6RYjehr+
         aQCTWtNCaG1NUW3GQ2gASmqqQEvIjqBKLEqv6k4c1gBR3ay7qzD34nAwJbiQFi0p8M5r
         do8gGQDaLgldIdxt7q60ZiQRiXoLm0KEJmzn41T9bM8dbeB1LJou5czb6VvtQuo9CKaO
         ae9Q==
Content-Disposition: inline
In-Reply-To: <20170428192656.GA19364@htj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Chris Mason <clm@fb.com>

On Fri, Apr 28, 2017 at 03:26:56PM -0400, Tejun Heo wrote:
> From dea830eac23836d55fc3e57c034cfc4c49c84469 Mon Sep 17 00:00:00 2001
> From: Tejun Heo <tj@kernel.org>
> Date: Fri, 28 Apr 2017 15:14:55 -0400
> 
> cgroup_get() expected to be called only on live cgroups and triggers
> warning on a dead cgroup; however, cgroup_sk_alloc() may be called
> while cloning a socket which is left in an empty and removed cgroup
> and thus may legitimately duplicate its reference on a dead cgroup.
> This currently triggers the following warning spuriously.
> 
>  WARNING: CPU: 14 PID: 0 at kernel/cgroup.c:490 cgroup_get+0x55/0x60
>  ...
>   [<ffffffff8107e123>] __warn+0xd3/0xf0
>   [<ffffffff8107e20e>] warn_slowpath_null+0x1e/0x20
>   [<ffffffff810ff465>] cgroup_get+0x55/0x60
>   [<ffffffff81106061>] cgroup_sk_alloc+0x51/0xe0
>   [<ffffffff81761beb>] sk_clone_lock+0x2db/0x390
>   [<ffffffff817cce06>] inet_csk_clone_lock+0x16/0xc0
>   [<ffffffff817e8173>] tcp_create_openreq_child+0x23/0x4b0
>   [<ffffffff818601a1>] tcp_v6_syn_recv_sock+0x91/0x670
>   [<ffffffff817e8b16>] tcp_check_req+0x3a6/0x4e0
>   [<ffffffff81861ba3>] tcp_v6_rcv+0x693/0xa00
>   [<ffffffff81837429>] ip6_input_finish+0x59/0x3e0
>   [<ffffffff81837cb2>] ip6_input+0x32/0xb0
>   [<ffffffff81837387>] ip6_rcv_finish+0x57/0xa0
>   [<ffffffff81837ac8>] ipv6_rcv+0x318/0x4d0
>   [<ffffffff817778c7>] __netif_receive_skb_core+0x2d7/0x9a0
>   [<ffffffff81777fa6>] __netif_receive_skb+0x16/0x70
>   [<ffffffff81778023>] netif_receive_skb_internal+0x23/0x80
>   [<ffffffff817787d8>] napi_gro_frags+0x208/0x270
>   [<ffffffff8168a9ec>] mlx4_en_process_rx_cq+0x74c/0xf40
>   [<ffffffff8168b270>] mlx4_en_poll_rx_cq+0x30/0x90
>   [<ffffffff81778b30>] net_rx_action+0x210/0x350
>   [<ffffffff8188c426>] __do_softirq+0x106/0x2c7
>   [<ffffffff81082bad>] irq_exit+0x9d/0xa0 [<ffffffff8188c0e4>] do_IRQ+0x54/0xd0
>   [<ffffffff8188a63f>] common_interrupt+0x7f/0x7f <EOI>
>   [<ffffffff8173d7e7>] cpuidle_enter+0x17/0x20
>   [<ffffffff810bdfd9>] cpu_startup_entry+0x2a9/0x2f0
>   [<ffffffff8103edd1>] start_secondary+0xf1/0x100
> 
> This patch renames the existing cgroup_get() with the dead cgroup
> warning to cgroup_get_live() after cgroup_kn_lock_live() and
> introduces the new cgroup_get() which doesn't check whether the cgroup
> is live or dead.
> 
> All existing cgroup_get() users except for cgroup_sk_alloc() are
> converted to use cgroup_get_live().
> 
> Fixes: d979a39d7242 ("cgroup: duplicate cgroup reference when cloning sockets")
> Cc: stable@vger.kernel.org # v4.5+
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Reported-by: Chris Mason <clm@fb.com>
> Signed-off-by: Tejun Heo <tj@kernel.org>

Applying to cgroup/for-4.12.

Thanks.

-- 
tejun
