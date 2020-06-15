From: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
Subject: Re: [PATCH] mm: memcontrol: handle div0 crash race condition in
 memory.low
Date: Mon, 15 Jun 2020 16:09:11 +0100
Message-ID: <20200615150911.GD157916@chrisdown.name>
References: <20200615140658.601684-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=I3pYBTJCH1fWxzUVivyIxWA31KHjVQXjnfV1c/iHSQ8=;
        b=aPeEzEq8Bmncf5GDxG4bKMbLMmpAo3LrvR3mDRIGWrMYi8m0weo1We6uJeEyp/OCdf
         /K4tB062Vr1+uzaRvdUPls1EMMG+6mqPlTcGG+J0AVYmUhkuQd4uuhW8AEwLZcc4EZoB
         CSGBuXP88a9JMP/xuTmLWTkbgT6ick7fAsj5k=
Content-Disposition: inline
In-Reply-To: <20200615140658.601684-1-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Johannes Weiner writes:
>Tejun reports seeing rare div0 crashes in memory.low stress testing:
>
>[37228.504582] RIP: 0010:mem_cgroup_calculate_protection+0xed/0x150
>[37228.505059] Code: 0f 46 d1 4c 39 d8 72 57 f6 05 16 d6 42 01 40 74 1f 4c 39 d8 76 1a 4c 39 d1 76 15 4c 29 d1 4c 29 d8 4d 29 d9 31 d2 48 0f af c1 <49> f7 f1 49 01 c2 4c 89 96 38 01 00 00 5d c3 48 0f af c7 31 d2 49
>[37228.506254] RSP: 0018:ffffa14e01d6fcd0 EFLAGS: 00010246
>[37228.506769] RAX: 000000000243e384 RBX: 0000000000000000 RCX: 0000000000008f4b
>[37228.507319] RDX: 0000000000000000 RSI: ffff8b89bee84000 RDI: 0000000000000000
>[37228.507869] RBP: ffffa14e01d6fcd0 R08: ffff8b89ca7d40f8 R09: 0000000000000000
>[37228.508376] R10: 0000000000000000 R11: 00000000006422f7 R12: 0000000000000000
>[37228.508881] R13: ffff8b89d9617000 R14: ffff8b89bee84000 R15: ffffa14e01d6fdb8
>[37228.509397] FS:  0000000000000000(0000) GS:ffff8b8a1f1c0000(0000) knlGS:0000000000000000
>[37228.509917] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>[37228.510442] CR2: 00007f93b1fc175b CR3: 000000016100a000 CR4: 0000000000340ea0
>[37228.511076] Call Trace:
>[37228.511561]  shrink_node+0x1e5/0x6c0
>[37228.512044]  balance_pgdat+0x32d/0x5f0
>[37228.512521]  kswapd+0x1d7/0x3d0
>[37228.513346]  ? wait_woken+0x80/0x80
>[37228.514170]  kthread+0x11c/0x160
>[37228.514983]  ? balance_pgdat+0x5f0/0x5f0
>[37228.515797]  ? kthread_park+0x90/0x90
>[37228.516593]  ret_from_fork+0x1f/0x30
>
>This happens when parent_usage == siblings_protected. We check that
>usage is bigger than protected, which should imply parent_usage being
>bigger than siblings_protected. However, we don't read (or even
>update) these values atomically, and they can be out of sync as the
>memory state changes under us. A bit of fluctuation around the target
>protection isn't a big deal, but we need to handle the div0 case.
>
>Check the parent state explicitly to make sure we have a reasonable
>positive value for the divisor.
>
>Fixes: 8a931f801340 ("mm: memcontrol: recursive memory.low protection")
>Reported-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Acked-by: Chris Down <chris-6Bi1550iOqEnzZ6mRAm98g@public.gmane.org>
