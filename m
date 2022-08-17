From: =?UTF-8?Q?Gra=C5=BEvydas_Ignotas?= <notasas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: UDP rx packet loss in a cgroup with a memory limit
Date: Wed, 17 Aug 2022 19:50:13 +0300
Message-ID: <CANOLnOPeOi0gxYwd5+ybdv5w=RZEh5JakJPE9xgrSL1cecZHbw@mail.gmail.com>
References: <CANOLnON11vzvVdyJfW+QJ36siWR4-s=HJ2aRKpRy7CP=aRPoSw@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc;
        bh=ZzWIdft1LnhkRbZTFfhN1f7gdRwWYlGR0s/Ag8XFV2k=;
        b=DeqC758FI7bRuS5XrOE1k7OVYHsd0L1EtiY14Q6VteXbHP6NAzcSVjte/26VPrlGNd
         XZFDx3F/M+oNmg45xAMqyr3W+G1cul21ZpkuA2+7Ls5hQRWcq5FIyL6edMnp62aPSGvU
         Vo6b0zgAsZVAcm3H+lVmHpJaQwKrL1/3Wxnk+kvUNE8HFK6YGIftHu2qcLtEpyWV866O
         gwTkC/ULGLMwyUa0ri41udQjRtZ80oMaIV1Q18HOAp8Yk8HEEAy0NDNMfs/1y5g4QT3s
         yA0uFCnKvjmkl/xnOUSJXGWcXEsP+Nz3Z5LCSRTi8hjz4OxqaDBDhyvqQ5aTVXs/pf1Z
         nOiw==
In-Reply-To: <CANOLnON11vzvVdyJfW+QJ36siWR4-s=HJ2aRKpRy7CP=aRPoSw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

On Tue, Aug 16, 2022 at 9:52 PM Gra=C5=BEvydas Ignotas <notasas-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> =
wrote:
> Basically, when there is git activity in the container with a memory
> limit, other processes in the same container start to suffer (very)
> occasional network issues (mostly DNS lookup failures).

ok I've traced this and it's failing in try_charge_memcg(), which
doesn't seem to be trying too hard because it's called from irq
context.

Here is the backtrace:
 <IRQ>
 ? fib_validate_source+0xb4/0x100
 ? ip_route_input_slow+0xa11/0xb70
 mem_cgroup_charge_skmem+0x4b/0xf0
 __sk_mem_raise_allocated+0x17f/0x3e0
 __udp_enqueue_schedule_skb+0x220/0x270
 udp_queue_rcv_one_skb+0x330/0x5e0
 udp_unicast_rcv_skb+0x75/0x90
 __udp4_lib_rcv+0x1ba/0xca0
 ? ip_rcv_finish_core.constprop.0+0x63/0x490
 ip_protocol_deliver_rcu+0xd6/0x230
 ip_local_deliver_finish+0x73/0xa0
 __netif_receive_skb_one_core+0x8b/0xa0
 process_backlog+0x8e/0x120
 __napi_poll+0x2c/0x160
 net_rx_action+0x2a2/0x360
 ? rebalance_domains+0xeb/0x3b0
 __do_softirq+0xeb/0x2eb
 __irq_exit_rcu+0xb9/0x110
 sysvec_apic_timer_interrupt+0xa2/0xd0
 </IRQ>

Calling mem_cgroup_print_oom_meminfo() in such a case reveals:

memory: usage 7812476kB, limit 7812500kB, failcnt 775198
swap: usage 0kB, limit 0kB, failcnt 0
Memory cgroup stats for
/kubepods.slice/kubepods-burstable.slice/kubepods-burstable-podb8f4f0e9_fb9=
5_4f2d_8443_e6a78f235c9a.slice/docker-9e7cad93b2e0774d49148474989b41fe6d67a=
5985d059d08d9d64495f1539a81.scope:
anon 348016640
file 7502163968
kernel 146997248
kernel_stack 327680
pagetables 2224128
percpu 0
sock 4096
vmalloc 0
shmem 0
zswap 0
zswapped 0
file_mapped 112041984
file_dirty 1181028352
file_writeback 2686976
swapcached 0
anon_thp 44040192
file_thp 0
shmem_thp 0
inactive_anon 350756864
active_anon 36864
inactive_file 3614003200
active_file 3888070656
unevictable 0
slab_reclaimable 143692600
slab_unreclaimable 545120
slab 144237720
workingset_refault_anon 0
workingset_refault_file 2318
workingset_activate_anon 0
workingset_activate_file 2318
workingset_restore_anon 0
workingset_restore_file 0
workingset_nodereclaim 0
pgfault 334152
pgmajfault 1238
pgrefill 3400
pgscan 819608
pgsteal 791005
pgactivate 949122
pgdeactivate 1694
pglazyfree 0
pglazyfreed 0
zswpin 0
zswpout 0
thp_fault_alloc 709
thp_collapse_alloc 0

So it basically renders UDP inoperable because of disk cache. I hope
this is not the intended behavior. Naturally booting with
cgroup.memory=3Dnosocket solves this issue.

Gra=C5=BEvydas
