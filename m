From: Georgi Nikolov <gnikolov@icdsoft.com>
Subject: Re: cgroups iptables-restor: vmalloc: allocation failure
Date: Thu, 26 Jul 2018 09:53:20 +0300
Message-ID: <b0b46aee-7a66-2166-4f19-61e5e5c5dcfc@icdsoft.com>
References: <a1a4eb7c-e85c-dc6d-cfac-6d40af302182@icdsoft.com>
 <alpine.DEB.2.21.1807251241380.201050@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: multipart/alternative;
 boundary="------------366703332640353966D7DEBC"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1807251241380.201050@chino.kir.corp.google.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: David Rientjes <rientjes@google.com>
Cc: Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Michal Hocko <mhocko@kernel.org>

This is a multi-part message in MIME format.
--------------366703332640353966D7DEBC
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hello,

Servers are with 64bit kernel and 32bit userland.

here is the log:

[=C2=A0 485.467359] iptables-restor: vmalloc: allocation failure, allocat=
ed
2367488 of 3608576 bytes, mode:0x14010c0(GFP_KERNEL|__GFP_NORETRY),
nodemask=3D(null)
[=C2=A0 485.467871] iptables-restor cpuset=3D/ mems_allowed=3D0
[=C2=A0 485.468089] CPU: 0 PID: 18093 Comm: iptables-restor Not tainted
4.14.50 #1
[=C2=A0 485.468399] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996)=
,
BIOS 1.10.2-1 04/01/2014
[=C2=A0 485.468725]=C2=A0 0000000000000000 ffffffff81ed2b8b ffffffff8333a=
330
bb5cfe6a5a821e59
[=C2=A0 485.469114]=C2=A0 0000000000000000 ffffc90004aaba80 ffffffff811fa=
3ea
ffffc90004aaba90
[=C2=A0 485.469422]=C2=A0 ffffffff825e11d0 014010c000000000 ffffffff825e1=
1d0
ffffc90004aaba18
[=C2=A0 485.469735] Call Trace:
[=C2=A0 485.469941]=C2=A0 [<ffffffff81ed2b8b>] dump_stack+0x9a/0x10f
[=C2=A0 485.470159]=C2=A0 [<ffffffff811fa3ea>] warn_alloc+0x18a/0x270
[=C2=A0 485.470379]=C2=A0 [<ffffffff8124c9c1>] __vmalloc_node_range+0x251=
/0x470
[=C2=A0 485.470614]=C2=A0 [<ffffffff8124ccfe>] ? __vmalloc_node_flags_cal=
ler+0x3e/0x70
[=C2=A0 485.470881]=C2=A0 [<ffffffff8124ccfe>] __vmalloc_node_flags_calle=
r+0x3e/0x70
[=C2=A0 485.471160]=C2=A0 [<ffffffff81d7cebe>] ? xt_alloc_table_info+0x4e=
/0xa0
[=C2=A0 485.471395]=C2=A0 [<ffffffff8121a1ca>] kvmalloc_node+0x7a/0xd0
[=C2=A0 485.471618]=C2=A0 [<ffffffff81d7cebe>] xt_alloc_table_info+0x4e/0=
xa0
[=C2=A0 485.471849]=C2=A0 [<ffffffff81e57357>] ?
translate_compat_table.constprop.19+0x447/0x870
[=C2=A0 485.472197]=C2=A0 [<ffffffff81e57357>]
translate_compat_table.constprop.19+0x447/0x870
[=C2=A0 485.472514]=C2=A0 [<ffffffff81e57917>] ?
compat_do_replace.isra.10.constprop.18+0x197/0x370
[=C2=A0 485.472833]=C2=A0 [<ffffffff81e57917>]
compat_do_replace.isra.10.constprop.18+0x197/0x370
[=C2=A0 485.473230]=C2=A0 [<ffffffff81e57b7b>] compat_do_ipt_set_ctl+0x8b=
/0xb0
[=C2=A0 485.473465]=C2=A0 [<ffffffff81d643ea>] compat_nf_setsockopt+0x6a/=
0xd0
[=C2=A0 485.473701]=C2=A0 [<ffffffff81df3ad3>] compat_ip_setsockopt+0x73/=
0xd0
[=C2=A0 485.473936]=C2=A0 [<ffffffff81e2129c>] compat_raw_setsockopt+0x7c=
/0xd0
[=C2=A0 485.474208]=C2=A0 [<ffffffff8123750c>] ? handle_mm_fault+0xec/0x2=
40
[=C2=A0 485.474441]=C2=A0 [<ffffffff81cd3852>] compat_sock_common_setsock=
opt+0x32/0x80
[=C2=A0 485.474689]=C2=A0 [<ffffffff81d2ed6a>] compat_sys_setsockopt+0x9a=
/0x2e0
[=C2=A0 485.474926]=C2=A0 [<ffffffff81d309e5>] compat_sys_socketcall+0x41=
5/0x570
[=C2=A0 485.475197]=C2=A0 [<ffffffff820018bc>] ? page_fault+0x5c/0x90
[=C2=A0 485.475416]=C2=A0 [<ffffffff82000ae6>] ? retint_user+0x2b/0x2b
[=C2=A0 485.475638]=C2=A0 [<ffffffff81d30b54>] ? rap_compat_sys_socketcal=
l+0x14/0x40
[=C2=A0 485.475884]=C2=A0 [<ffffffff81002391>] ? do_fast_syscall_32+0xe1/=
0x2f0
[=C2=A0 485.476170]=C2=A0 [<ffffffff82001f03>] ? entry_SYSENTER_compat+0x=
93/0xa5
[=C2=A0 485.476414] Mem-Info:
[=C2=A0 485.476579] active_anon:79884 inactive_anon:103007 isolated_anon:=
0
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 active_file:54010 inactive_file:219014 isolated_file:0
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 unevictable:1822 dirty:22 writeback:0 unstable:0
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 slab_reclaimable:8637 slab_unreclaimable:25015
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 mapped:16094 shmem:2271 pagetables:1481 bounce:0
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0 free:3459 free_pcp:180 free_cma:0
[=C2=A0 485.477691] Node 0 active_anon:320376kB inactive_anon:412028kB
active_file:216040kB inactive_file:875844kB unevictable:7288kB
isolated(anon):0kB isolated(file):0kB mapped:64376kB dirty:88kB
writeback:0kB shmem:9084kB writeback_tmp:0kB unstable:0kB
all_unreclaimable? no
[=C2=A0 485.478457] Node 0 DMA free:7896kB min:44kB low:56kB high:68kB
active_anon:2324kB inactive_anon:0kB active_file:12kB
inactive_file:5228kB unevictable:0kB writepending:0kB present:15992kB
managed:15892kB mlocked:0kB kernel_stack:0kB pagetables:0kB bounce:0kB
free_pcp:0kB local_pcp:0kB free_cma:0kB
[=C2=A0 485.479233] lowmem_reserve[]: 0 1963 1963 1963
[=C2=A0 485.479483] Node 0 DMA32 free:5364kB min:5644kB low:7652kB
high:9660kB active_anon:317672kB inactive_anon:412028kB
active_file:216028kB inactive_file:871340kB unevictable:7288kB
writepending:88kB present:2080624kB managed:2015900kB mlocked:7288kB
kernel_stack:5584kB pagetables:5924kB bounce:0kB free_pcp:1052kB
local_pcp:720kB free_cma:0kB
[=C2=A0 485.480425] lowmem_reserve[]: 0 0 0 0
[=C2=A0 485.480612] Node 0 DMA: 38*4kB (UMEH) 54*8kB (MEH) 51*16kB (UMEH)=

35*32kB (UMEH) 16*64kB (MEH) 12*128kB (MH) 7*256kB (UMEH) 0*512kB
1*1024kB (E) 0*2048kB 0*4096kB =3D 7896kB
[=C2=A0 485.481173] Node 0 DMA32: 12*4kB (MH) 16*8kB (H) 264*16kB (UH) 7*=
32kB
(H) 6*64kB (H) 1*128kB (H) 0*256kB 1*512kB (H) 0*1024kB 0*2048kB
0*4096kB =3D 5648kB
[=C2=A0 485.481642] Node 0 hugepages_total=3D0 hugepages_free=3D0
hugepages_surp=3D0 hugepages_size=3D1048576kB
[=C2=A0 485.481975] Node 0 hugepages_total=3D0 hugepages_free=3D0
hugepages_surp=3D0 hugepages_size=3D2048kB
[=C2=A0 485.482309] 275972 total pagecache pages
[=C2=A0 485.482535] 0 pages in swap cache
[=C2=A0 485.482717] Swap cache stats: add 0, delete 0, find 0/0
[=C2=A0 485.482937] Free swap=C2=A0 =3D 1976316kB
[=C2=A0 485.483118] Total swap =3D 1976316kB
[=C2=A0 485.483300] 524154 pages RAM
[=C2=A0 485.483492] 0 pages HighMem/MovableOnly
[=C2=A0 485.483711] 16206 pages reserved
[=C2=A0 485.483889] 0 pages hwpoisoned

Regards,

--=20
Georgi Nikolov

On 07/25/2018 10:42 PM, David Rientjes wrote:
> On Wed, 25 Jul 2018, Georgi Nikolov wrote:
>
>> Hello,
>>
>> I posted a kernel bug https://bugzilla.kernel.org/show_bug.cgi?id=3D20=
0651 and
>> i hope this is the correct place to discuss this.
>>
> Could you post the full allocation failure from the kernel log?  It's n=
ot=20
> possible to vmalloc any additional memory due to the memory pressure, s=
o=20
> this is expected to fail but I'm curious as to the actual allocation th=
at=20
> is triggering it.


--------------366703332640353966D7DEBC
Content-Type: text/html; charset="utf-8"
Content-Transfer-Encoding: 8bit

<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
  </head>
  <body bgcolor="#FFFFFF" text="#000000">
    <p>Hello, <br>
    </p>
    <p>Servers are with 64bit kernel and 32bit userland.<br>
    </p>
    <p>here is the log:</p>
    <p>[  485.467359] iptables-restor: vmalloc: allocation failure,
      allocated 2367488 of 3608576 bytes,
      mode:0x14010c0(GFP_KERNEL|__GFP_NORETRY), nodemask=(null)<br>
      [  485.467871] iptables-restor cpuset=/ mems_allowed=0<br>
      [  485.468089] CPU: 0 PID: 18093 Comm: iptables-restor Not tainted
      4.14.50 #1<br>
      [  485.468399] Hardware name: QEMU Standard PC (i440FX + PIIX,
      1996), BIOS 1.10.2-1 04/01/2014<br>
      [  485.468725]  0000000000000000 ffffffff81ed2b8b ffffffff8333a330
      bb5cfe6a5a821e59<br>
      [  485.469114]  0000000000000000 ffffc90004aaba80 ffffffff811fa3ea
      ffffc90004aaba90<br>
      [  485.469422]  ffffffff825e11d0 014010c000000000 ffffffff825e11d0
      ffffc90004aaba18<br>
      [  485.469735] Call Trace:<br>
      [  485.469941]  [&lt;ffffffff81ed2b8b&gt;] dump_stack+0x9a/0x10f<br>
      [  485.470159]  [&lt;ffffffff811fa3ea&gt;] warn_alloc+0x18a/0x270<br>
      [  485.470379]  [&lt;ffffffff8124c9c1&gt;]
      __vmalloc_node_range+0x251/0x470<br>
      [  485.470614]  [&lt;ffffffff8124ccfe&gt;] ?
      __vmalloc_node_flags_caller+0x3e/0x70<br>
      [  485.470881]  [&lt;ffffffff8124ccfe&gt;]
      __vmalloc_node_flags_caller+0x3e/0x70<br>
      [  485.471160]  [&lt;ffffffff81d7cebe&gt;] ?
      xt_alloc_table_info+0x4e/0xa0<br>
      [  485.471395]  [&lt;ffffffff8121a1ca&gt;] kvmalloc_node+0x7a/0xd0<br>
      [  485.471618]  [&lt;ffffffff81d7cebe&gt;]
      xt_alloc_table_info+0x4e/0xa0<br>
      [  485.471849]  [&lt;ffffffff81e57357&gt;] ?
      translate_compat_table.constprop.19+0x447/0x870<br>
      [  485.472197]  [&lt;ffffffff81e57357&gt;]
      translate_compat_table.constprop.19+0x447/0x870<br>
      [  485.472514]  [&lt;ffffffff81e57917&gt;] ?
      compat_do_replace.isra.10.constprop.18+0x197/0x370<br>
      [  485.472833]  [&lt;ffffffff81e57917&gt;]
      compat_do_replace.isra.10.constprop.18+0x197/0x370<br>
      [  485.473230]  [&lt;ffffffff81e57b7b&gt;]
      compat_do_ipt_set_ctl+0x8b/0xb0<br>
      [  485.473465]  [&lt;ffffffff81d643ea&gt;]
      compat_nf_setsockopt+0x6a/0xd0<br>
      [  485.473701]  [&lt;ffffffff81df3ad3&gt;]
      compat_ip_setsockopt+0x73/0xd0<br>
      [  485.473936]  [&lt;ffffffff81e2129c&gt;]
      compat_raw_setsockopt+0x7c/0xd0<br>
      [  485.474208]  [&lt;ffffffff8123750c&gt;] ?
      handle_mm_fault+0xec/0x240<br>
      [  485.474441]  [&lt;ffffffff81cd3852&gt;]
      compat_sock_common_setsockopt+0x32/0x80<br>
      [  485.474689]  [&lt;ffffffff81d2ed6a&gt;]
      compat_sys_setsockopt+0x9a/0x2e0<br>
      [  485.474926]  [&lt;ffffffff81d309e5&gt;]
      compat_sys_socketcall+0x415/0x570<br>
      [  485.475197]  [&lt;ffffffff820018bc&gt;] ? page_fault+0x5c/0x90<br>
      [  485.475416]  [&lt;ffffffff82000ae6&gt;] ? retint_user+0x2b/0x2b<br>
      [  485.475638]  [&lt;ffffffff81d30b54&gt;] ?
      rap_compat_sys_socketcall+0x14/0x40<br>
      [  485.475884]  [&lt;ffffffff81002391&gt;] ?
      do_fast_syscall_32+0xe1/0x2f0<br>
      [  485.476170]  [&lt;ffffffff82001f03&gt;] ?
      entry_SYSENTER_compat+0x93/0xa5<br>
      [  485.476414] Mem-Info:<br>
      [  485.476579] active_anon:79884 inactive_anon:103007
      isolated_anon:0<br>
                      active_<a class="moz-txt-link-freetext" href="file:54010">file:54010</a> inactive_<a class="moz-txt-link-freetext" href="file:219014">file:219014</a>
      isolated_<a class="moz-txt-link-freetext" href="file:0">file:0</a><br>
                      unevictable:1822 dirty:22 writeback:0 unstable:0<br>
                      slab_reclaimable:8637 slab_unreclaimable:25015<br>
                      mapped:16094 shmem:2271 pagetables:1481 bounce:0<br>
                      free:3459 free_pcp:180 free_cma:0<br>
      [  485.477691] Node 0 active_anon:320376kB inactive_anon:412028kB
      active_<a class="moz-txt-link-freetext" href="file:216040kB">file:216040kB</a> inactive_<a class="moz-txt-link-freetext" href="file:875844kB">file:875844kB</a> unevictable:7288kB
      isolated(anon):0kB isolated(file):0kB mapped:64376kB dirty:88kB
      writeback:0kB shmem:9084kB writeback_tmp:0kB unstable:0kB
      all_unreclaimable? no<br>
      [  485.478457] Node 0 DMA free:7896kB min:44kB low:56kB high:68kB
      active_anon:2324kB inactive_anon:0kB active_<a class="moz-txt-link-freetext" href="file:12kB">file:12kB</a>
      inactive_<a class="moz-txt-link-freetext" href="file:5228kB">file:5228kB</a> unevictable:0kB writepending:0kB
      present:15992kB managed:15892kB mlocked:0kB kernel_stack:0kB
      pagetables:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB<br>
      [  485.479233] lowmem_reserve[]: 0 1963 1963 1963<br>
      [  485.479483] Node 0 DMA32 free:5364kB min:5644kB low:7652kB
      high:9660kB active_anon:317672kB inactive_anon:412028kB
      active_<a class="moz-txt-link-freetext" href="file:216028kB">file:216028kB</a> inactive_<a class="moz-txt-link-freetext" href="file:871340kB">file:871340kB</a> unevictable:7288kB
      writepending:88kB present:2080624kB managed:2015900kB
      mlocked:7288kB kernel_stack:5584kB pagetables:5924kB bounce:0kB
      free_pcp:1052kB local_pcp:720kB free_cma:0kB<br>
      [  485.480425] lowmem_reserve[]: 0 0 0 0<br>
      [  485.480612] Node 0 DMA: 38*4kB (UMEH) 54*8kB (MEH) 51*16kB
      (UMEH) 35*32kB (UMEH) 16*64kB (MEH) 12*128kB (MH) 7*256kB (UMEH)
      0*512kB 1*1024kB (E) 0*2048kB 0*4096kB = 7896kB<br>
      [  485.481173] Node 0 DMA32: 12*4kB (MH) 16*8kB (H) 264*16kB (UH)
      7*32kB (H) 6*64kB (H) 1*128kB (H) 0*256kB 1*512kB (H) 0*1024kB
      0*2048kB 0*4096kB = 5648kB<br>
      [  485.481642] Node 0 hugepages_total=0 hugepages_free=0
      hugepages_surp=0 hugepages_size=1048576kB<br>
      [  485.481975] Node 0 hugepages_total=0 hugepages_free=0
      hugepages_surp=0 hugepages_size=2048kB<br>
      [  485.482309] 275972 total pagecache pages<br>
      [  485.482535] 0 pages in swap cache<br>
      [  485.482717] Swap cache stats: add 0, delete 0, find 0/0<br>
      [  485.482937] Free swap  = 1976316kB<br>
      [  485.483118] Total swap = 1976316kB<br>
      [  485.483300] 524154 pages RAM<br>
      [  485.483492] 0 pages HighMem/MovableOnly<br>
      [  485.483711] 16206 pages reserved<br>
      [  485.483889] 0 pages hwpoisoned<br>
      <br>
    </p>
    <p>Regards,<br>
    </p>
    <div class="moz-signature">-- <br>
      Georgi Nikolov<font color="#7B858F"><br>
      </font><br>
    </div>
    <div class="moz-cite-prefix">On 07/25/2018 10:42 PM, David Rientjes
      wrote:<br>
    </div>
    <blockquote type="cite"
cite="mid:alpine.DEB.2.21.1807251241380.201050@chino.kir.corp.google.com">
      <pre wrap="">On Wed, 25 Jul 2018, Georgi Nikolov wrote:

</pre>
      <blockquote type="cite">
        <pre wrap="">Hello,

I posted a kernel bug <a class="moz-txt-link-freetext" href="https://bugzilla.kernel.org/show_bug.cgi?id=200651">https://bugzilla.kernel.org/show_bug.cgi?id=200651</a> and
i hope this is the correct place to discuss this.

</pre>
      </blockquote>
      <pre wrap="">
Could you post the full allocation failure from the kernel log?  It's not 
possible to vmalloc any additional memory due to the memory pressure, so 
this is expected to fail but I'm curious as to the actual allocation that 
is triggering it.
</pre>
    </blockquote>
    <br>
  </body>
</html>

--------------366703332640353966D7DEBC--
