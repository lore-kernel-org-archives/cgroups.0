From: Jiri Slaby <jslaby@suse.cz>
Subject: Re: memcg causes crashes in list_lru_add
Date: Mon, 29 Apr 2019 11:25:48 +0200
Message-ID: <2cbfb8dc-31f0-7b95-8a93-954edb859cd8@suse.cz>
References: <f0cfcfa7-74d0-8738-1061-05d778155462@suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <f0cfcfa7-74d0-8738-1061-05d778155462@suse.cz>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, cgroups@vger.kernel.org, mm <linux-mm@kvack.org>, Linux kernel mailing list <linux-kernel@vger.kernel.org>

On 29. 04. 19, 10:16, Jiri Slaby wrote:
> Hi,
> 
> with new enough systemd, one of our systems 100% crashes during boot.
> Kernels I tried are all affected: 5.1-rc7, 5.0.10 stable, 4.12.14.
> 
> The 5.1-rc7 crash:
>> [   12.022637] systemd[1]: Starting Create list of required static device nodes for the current kernel...
>> [   12.023353] BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
>> [   12.041502] #PF error: [normal kernel read fault]
>> [   12.041502] PGD 0 P4D 0 
>> [   12.041502] Oops: 0000 [#1] SMP NOPTI
>> [   12.041502] CPU: 0 PID: 208 Comm: (kmod) Not tainted 5.1.0-rc7-1.g04c1966-default #1 openSUSE Tumbleweed (unreleased)
>> [   12.041502] Hardware name: Supermicro H8DSP-8/H8DSP-8, BIOS 080011  06/30/2006
>> [   12.041502] RIP: 0010:list_lru_add+0x94/0x170
>> [   12.041502] Code: c6 07 00 66 66 66 90 31 c0 5b 5d 41 5c 41 5d 41 5e 41 5f c3 49 8b 7c 24 20 49 8d 54 24 08 48 85 ff 74 07 e9 46 00 00 00 31 ff <48> 8b 42 08 4c 89 6a 08 49 89 55 00 49 89 45 08 4c 89 28 48 8b 42
>> [   12.041502] RSP: 0018:ffffb11b8091be50 EFLAGS: 00010202
>> [   12.041502] RAX: 0000000000000001 RBX: ffff930b35705a40 RCX: ffff9309cf21ade0
>> [   12.041502] RDX: 0000000000000000 RSI: ffff930ab61bc587 RDI: ffff930a17711000
>> [   12.041502] RBP: 0000000000000000 R08: 0000000000000000 R09: 0000000000000000
>> [   12.041502] R10: 0000000000000000 R11: 0000000000000008 R12: ffff9309f5f86640
>> [   12.041502] R13: ffff930ab5705a40 R14: 0000000000000001 R15: ffff930a171dc4e0
>> [   12.041502] FS:  00007f42d6ea5940(0000) GS:ffff930ab7800000(0000) knlGS:0000000000000000
>> [   12.041502] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [   12.041502] CR2: 0000000000000008 CR3: 0000000057dec000 CR4: 00000000000006f0
>> [   12.041502] Call Trace:
>> [   12.041502]  d_lru_add+0x44/0x50

...

> and even makes the beast booting. memcg has very wrong assumptions on
> 'memcg_nr_cache_ids'. It does not assume it can change later, despite it
> does.
...
> I am not sure why this is machine-dependent. I cannot reproduce on any
> other box.
> 
> Any idea how to fix this mess?

memcg_update_all_list_lrus should take care about resizing the array. So
it looks like list_lru_from_memcg_idx returns a stale pointer to
list_lru_from_kmem and then to list_lru_add. Still investigating.

thanks,
-- 
js
suse labs
