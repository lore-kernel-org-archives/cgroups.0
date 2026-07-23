Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15E81F3BA4
	for <cgroups@vger.kernel.org>; Thu, 23 Jul 2026 00:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784765978; cv=none; b=GLH6/bPTYpEVOzkuKbdvij1SgoeLcBqLQSbi8iwRyTVDhXfKVLGcLMDQQCXMEmIPvOh0q7K8+ElvEJAUoDYd1ueHuYi0s6aMLjTvc8PAWb6ip/8Nag/v5+UKilt+H5XtolFMx7aMqgN8OI51b+lf7jmeCMZm0Nl2K04pD4QPJUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784765978; c=relaxed/simple;
	bh=HMxxNFJ7/R13P7F3WD80iChOJgve/Ncy/ziKXcIGfV0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=CjxHKzXB15yfd5mjlwx48iEjsmtTp4Y9eSXmnlLfI57f+39tm7rJWTOYCsnSQb6Pi0Rz0dBCd4NR9Sm8/Uaku5v9WcGhrShAox7cyONY6oRGZ+w+FcHEnJuJhZf37cJQ8ixCnS3iueA+pFxlJcwyx48KYNLkLK357xR6UU0wfYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=XTFmqZOD; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="XTFmqZOD"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784765961;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=OLFnQzsIACb+c2PDBsFQsonnUveD7tbT8/TMCAkTouo=;
	b=XTFmqZODNpQdcNXG6C68aEfUOyYsaoZNxpiqt+mC3OSp1YNLhDOJk8PyN31GiUoi5Ehb/d
	U0G/RKHQAKfiUr/pVJTm4I/LxdGLuv8P2sbJaUEZHOBatNvDXQzZIBQqqDhcLoyoXHUvGA
	s+aaVaE7T5pyUfYwpw+SfbH5IL7d8UA=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Michal Hocko <mhocko@suse.com>,
	David Rientjes <rientjes@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Usama Arif <usama.arif@linux.dev>,
	Peter Zijlstra <peterz@infradead.org>,
	Darren Hart <dvhart@infradead.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	=?UTF-8?q?Andr=C3=A9=20Almeida?= <andrealmeid@igalia.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Rik van Riel <riel@surriel.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [RFC] Robust futex causing memcg OOM storm on exit
Date: Wed, 22 Jul 2026 17:19:07 -0700
Message-ID: <20260723001908.4046643-1-shakeel.butt@linux.dev>
Precedence: bulk
X-Mailing-List: cgroups@vger.kernel.org
List-Id: <cgroups.vger.kernel.org>
List-Subscribe: <mailto:cgroups+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:cgroups+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT

At Meta, we are seeing instances where an OOM killed job is stuck in the
exit path for several hours. In one particular case, the job was stuck
for more than 8 hours and I had to manually remove the memory.max limits
to allow the process to exit.

The job was a single process job and had ~55 GiB memory.max and zswap
enabled. It had almost 0 anon in memory and ~111 GiB in zswap compressed
to ~51 GiB zswap pool (i.e. almost all of memory.current was zswap).
Nothing was left on the LRUs to reclaim.

On further inspection, I observed ~20k threads of that process stuck
with the following stack:

[<0>] mem_cgroup_out_of_memory+0x4e/0xa0
[<0>] charge_memcg+0x8bf/0x990
[<0>] mem_cgroup_swapin_charge_folio+0x4e/0x80
[<0>] __read_swap_cache_async+0x10c/0x260
[<0>] swapin_readahead+0x116/0x3f0
[<0>] do_swap_page+0x13c/0x1ce0
[<0>] handle_mm_fault+0x61d/0x11f0
[<0>] do_user_addr_fault+0x3e7/0x6d0
[<0>] exc_page_fault+0x8f/0x110
[<0>] asm_exc_page_fault+0x22/0x30
[<0>] __get_user_8+0x14/0x20
[<0>] futex_cleanup+0x27/0x1c0
[<0>] futex_exit_release+0x47/0x60
[<0>] do_exit+0x107/0x940
[<0>] do_group_exit+0x81/0xa0
[<0>] get_signal+0x2b1/0x6e0
[<0>] arch_do_signal_or_restart+0x1a/0x1c0
[<0>] exit_to_user_mode_loop+0xa8/0x1c0
[<0>] do_syscall_64+0x152/0x250
[<0>] entry_SYSCALL_64_after_hwframe+0x4b/0x53

In addition the dmesg was filled with "Out of memory and no killable
processes..." messages.

I have no idea why oom reaper was not able to reap/unmap the process. My
guess is that since oom reaper tries to acquire mmap_lock in read mode
limited number of times and then gives up, there might a thread of that
process which had mmap_lock in write mode at that time.

My initial suspicion was the futex_cleanup and kernel page fault causing
infinite fault and charge retries but that was put to rest in previous
discussions happened on similar problem [1].

My current theory is that it is just a simple slow serialization behind
the oom_lock. Unlike page allocator, memcg charge code takes the
oom_lock without the "try". Though memcg oom code uses
mutex_lock_killable(),  note that in the call stack get_stack() consumes
SIGKILL (or sigdelset(SIGKILL)) before calling do_cgroup_exit(). So this
mutex_lock_killable() is just a mutex_lock() here. Therefore 10s of
thousands of threads are waiting on oom_lock and one by one they get
-EFAULT from get_user() in the futex cleanup code and bails out.

Discussion from [1] lead to the commit a75ffa26122b ("memcg, oom: do not
bypass oom killer for dying tasks") which routes dying tasks into the OOM
path precisely so the oom_reaper can reap their mm and free the memory
asynchronously. But the reaper is best-effort and one-shot: if it cannot
take mmap_lock for read (e.g. a sibling thread holds it for write) it
sets MMF_OOM_SKIP and never retries, leaving only the glacial
oom_lock-serialized synchronous drain.

Let's short-circuit that path: once reclaim has failed, if current is
dying, force the charge instead of invoking the OOM killer for it. A
dying task frees its memory as soon as it finishes exiting, so running
the (necessarily no-victim) OOM killer for it is pointless - and doing so
for 10s of thousands of exiting threads is exactly what serializes them
behind oom_lock. The dying task instead faults its page in, completes
exit and releases its memory, including the zswap pool, so the memcg
recovers on its own without the oom_lock serialization and dump_header
storm.

Unlike the unconditional bypass that commit a4ebf1b6ca1e ("memcg:
prohibit unconditional exceeding the limit of dying tasks") removed -
which force-charged every dying task before even attempting reclaim - the
force charge here happens only after reclaim has failed, and only for a
dying task, whose excess is bounded and transient: it is exiting and
frees its memory immediately after. A non-dying task still goes to the
OOM killer and can still get -ENOMEM.

I tried to reproduce this scenario using AI and I was able to trigger
the futex cleanup trigerring memcg oom but I couldn't emulate the
slowness we saw in the production environement. I am attaching the repro
for others to see and provide feedback.

Mainly I am looking for discussion on how to effectively resolve this
issue and if force charing the only path. However I don't see how this
same situation can not happen for the global reclaim, so maybe we should
aim for a general solution.

Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Link: https://lore.kernel.org/7a4e5591f45df455e6a485fc5400989569d3d22d.camel@surriel.com/ [1]
---
 memcg-oom-repro/Makefile          |  14 ++++
 memcg-oom-repro/README.md         | 107 +++++++++++++++++++++++
 memcg-oom-repro/repro_futex_oom   | Bin 0 -> 17840 bytes
 memcg-oom-repro/repro_futex_oom.c | 135 ++++++++++++++++++++++++++++++
 memcg-oom-repro/run.sh            |  97 +++++++++++++++++++++
 memcg-oom-repro/trace.sh          |  69 +++++++++++++++
 mm/memcontrol.c                   |  19 +++--
 7 files changed, 434 insertions(+), 7 deletions(-)
 create mode 100644 memcg-oom-repro/Makefile
 create mode 100644 memcg-oom-repro/README.md
 create mode 100755 memcg-oom-repro/repro_futex_oom
 create mode 100644 memcg-oom-repro/repro_futex_oom.c
 create mode 100755 memcg-oom-repro/run.sh
 create mode 100755 memcg-oom-repro/trace.sh

diff --git a/memcg-oom-repro/Makefile b/memcg-oom-repro/Makefile
new file mode 100644
index 000000000000..07b9b3abf914
--- /dev/null
+++ b/memcg-oom-repro/Makefile
@@ -0,0 +1,14 @@
+# Reproducer for the memcg exit-path OOM-lock serialization.
+CC      ?= cc
+CFLAGS  ?= -O2 -Wall -Wextra
+LDFLAGS ?= -pthread
+
+all: repro_futex_oom
+
+repro_futex_oom: repro_futex_oom.c
+	$(CC) $(CFLAGS) -o $@ $< $(LDFLAGS)
+
+clean:
+	rm -f repro_futex_oom
+
+.PHONY: all clean
diff --git a/memcg-oom-repro/README.md b/memcg-oom-repro/README.md
new file mode 100644
index 000000000000..b9be2a6a0002
--- /dev/null
+++ b/memcg-oom-repro/README.md
@@ -0,0 +1,107 @@
+# memcg exit-path OOM-lock serialization reproducer
+
+Reproduces a production failure where an OOM-killed, multi-threaded job got
+stuck in the exit path for hours, with dmesg flooded by
+`Out of memory and no killable processes...`.
+
+## The bug
+
+A cgroup's memory is dominated by its own **zswap pool** (compressed anon that
+is charged back to `memory.max`, with no writeback), so nothing is reclaimable
+and the memcg is pinned at its limit. When the job is OOM-group-killed, every
+one of its (10s of) thousands of threads takes an exit-time page fault while
+walking its **robust-futex list** in `futex_cleanup()`, on a page that lives in
+the zswap pool:
+
+```
+out_of_memory
+mem_cgroup_out_of_memory
+try_charge_memcg / charge_memcg
+mem_cgroup_swapin_charge_folio
+__swap_cache_alloc / swapin
+do_swap_page
+handle_mm_fault
+do_user_addr_fault
+exc_page_fault
+__get_user_8            <- robust-futex list walk (exit_robust_list, inlined)
+futex_cleanup
+futex_exit_release
+do_exit
+do_group_exit
+get_signal              <- the thread is dying (SIGKILL already dequeued here)
+...
+entry_SYSCALL_64_after_hwframe
+```
+
+Each swap-in charge invokes the memcg OOM killer, which finds no victim (all
+tasks are dying). `mem_cgroup_out_of_memory()` takes `oom_lock` *without* a
+trylock, so thousands of exiting threads serialize behind it one at a time —
+turning a should-be-instant process exit into a multi-hour stall.
+
+## The fix under test
+
+`memcg: force charge dying tasks instead of invoking the OOM killer` — in
+`try_charge_memcg()`, once reclaim has failed, a dying task force-charges
+instead of entering the (no-victim) OOM path, so it never contends on
+`oom_lock` and exits promptly.
+
+## Requirements
+
+- cgroup v2, `CONFIG_ZSWAP`, a swap device (`run.sh` uses zram, needs
+  `CONFIG_ZRAM`), `CONFIG_FUTEX`.
+- Run as **root**, in a **throwaway VM** — this deliberately drives a cgroup
+  into a sustained OOM. `trace.sh` additionally needs `CONFIG_KPROBE_EVENTS`
+  and `CONFIG_STACKTRACE`.
+
+## Build & run
+
+```sh
+make
+sudo ./run.sh 10000 512 2G 64M     # nthreads filler_mb max_hi max_lo
+```
+
+`run.sh` creates a cgroup, spawns `nthreads` threads each with a robust-futex
+head on its own page, pushes the process's anon (a `filler_mb` region plus the
+robust pages) into the zswap pool, then drops `memory.max` from `max_hi` to
+`max_lo` (below the pool) to trigger the OOM-group-kill, and reports:
+
+- `memcg_oom_invocations` — `memory.events:oom`, the degree of the
+  oom_lock-serialized storm (the key metric).
+- `exit_time_seconds` — wall-clock for the whole process to leave the cgroup.
+
+### Example (10k threads, in a VM)
+
+| kernel | memcg_oom_invocations | exit_time |
+|--------|-----------------------|-----------|
+| baseline            | ~14000 | ~4 s |
+| with the fix        | ~20    | ~2 s |
+
+The 600x drop in OOM invocations is the signal. (Wall-clock is far smaller in a
+VM than on the real host: production's per-OOM cost was `dump_header` output
+over **netconsole** under `oom_lock`, which a local VM's ring buffer doesn't
+incur. The invocation count is the faithful, reproducible measure.)
+
+## Confirm the exact path (optional)
+
+```sh
+sudo ./trace.sh 300 512 64M
+```
+
+kprobes `mem_cgroup_swapin_charge_folio` and `out_of_memory` and prints a full
+stack for each, showing they originate from `get_signal -> ... ->
+futex_cleanup -> __get_user_8 -> swap-in -> charge -> out_of_memory`, and that
+`memory.current` stays pinned throughout.
+
+## Notes / tuning
+
+- The filler is filled ~2x-compressible on purpose. A trivially compressible
+  filler shrinks the zswap pool to near nothing, the memcg is no longer pinned,
+  and the storm does not reproduce.
+- `max_lo` must be below the resulting zswap pool size (check
+  `memory.stat:zswap` printed by `run.sh`) so the memcg stays over the limit for
+  the whole exit.
+- Running under virtme-ng (vng), from a kernel tree built with the options
+  above:
+  ```sh
+  vng --cpu 16 -m 8G -- bash -c "cd $PWD && make && ./run.sh 10000 512 2G 64M"
+  ```
diff --git a/memcg-oom-repro/repro_futex_oom b/memcg-oom-repro/repro_futex_oom
new file mode 100755
index 0000000000000000000000000000000000000000..edb7143497744d127694307efab2d52d8b95a95c
GIT binary patch
literal 17840
zcmeHPeQX@Zb$@phrL!X+DO*w~%ZV-yl}L8D<cSnR(WS-X=h8TRRH9@j{#Y;XmgLpP
zyUXsLOR9pZn3ACj#ab!yVFX3N21RNVC}22gAuE7HO0GVd0A-w_RUJ4I)H=G8<A|;t
zMNTA6@pj)kE;qMskOJ*Lw}SZg{pP(lGjC>RXJ+T!pLR!k{5~J><%dTBxrUYP7G(bg
zc(sis0NSAi?tyj)!8%w9080Qd`)a2<rWgG-&NM)B6{J^#HvmvmVOwDO0Ld}s5+cR?
z7OsVy5u3fsPGJhwHjjFhcuPD~lOEBml?cF;<%;=*Y&#GlJ)*~`U`(BQ=$m|<t(R}J
z^_c!O`30!{tcNh_-6FkPq{noY@?*;WM4#aQ7P8ku{$yG#K2^i5_XO!ZL3&KPNS-PC
ze)l_O{P)RkC+Qub0v#bgGHs&#m~wu9_>LJzzx=KjH}fva&#N73s2!M+d!as=7-(*)
zPsZz#iBxv9ZnUMjuDMAv($XfY2v{!61G`P{_C4S~2-AphbK?C<;xYZg+pl$ReDrwd
z)$Dg(ICbg5j@@rvxr=RJo+yJC>T}mX9`9EJSkI(Ye-!pr`w{y%0Brok(FeBt*91Q%
zmJR2hPXfTbPJr%z2>{$DoXKdjl>9$?;9(E^Z#?h@5By~he1)%cIa@sBPkZ3Q9yq$Q
zRDF9r@U#cM)dN58frmWm^}2^V_O(*wJm7(=0I&kqz*M_E?(p+IMfkJ}hm1L_YieAH
zYo;0-hOCj)v<wVsW+o8_MM)+GVv1p^x~Yt)i4+WG^hC-W1jE$LbP`6?`11)vD_T)a
zQ&$Yl9LlPC+(_)xz%b+KtO<jI$*eJ4l#A(_YW}vGVXCp`Y_%~XrY4i9uIYMF&$6FL
zB}^=Urt4`PGHMnJU^62lY6h^(_{26tZ?vzYQ`sbKk~SCb8=FAs>))otHC-D@7^bH8
zZ|h8^Q(C_|kkmj?hDOpUs<L8>mK4Ni)CU!gf6Vy-|6z)a*!T9+<^w<ci{o{ay+3gm
zKK(x>?0aAR#!|F=jULYPTkUqlF@VP?OqzAz&T-?S1E*J_W$Cg5clIalCpezr*uoe0
z6U1?BC|=ZmmN~{eOba-09N+k=cHs1?wUTNaxO03DIdIH_uMG~I`!uFCIPkk!7~h8u
z{9_Kh-GMK6;Iae1$ARy3;6VregafZ~;Lkd6eivc#umfM=kk2^q`yBYF1IPCXUk4rd
zDhA86?18ce${r|tpzML)(E~TCKKW~T{O19AqVhsLfP8q`^ov<}{EfgF%YxYaPxSy|
z{SWH_s@AoGSdTo;rlD|I2qD&=Mjodmg;|R~fjmw{3ey(<8uGZTDZFa&e~Ua$4GL2h
z|83-PN>Dgv@!vuorvin87XRnS;}oEfvG}hbkFWm1vljmX@;JpQ?6mlO$m0~C&~EWM
z^7!g6G+6u}A&;;8LdfC=kjGbjq1xiVh&;aH3t;iPkjGbhVQwDl`xx^0N-tcV7b5a_
zWN&0oq<_zDdHm<Y<HA?<(ocN=^0~?b^#IkM1^7Px>C0W}4qu2IM~h+6H*<CQ>kk6J
z3G_=eH=qCec_HLnWe+yN_$^U&=udnA;pxapoDRz8x@rSB>&tc3E<rQn=Y^#n&E2#t
zghk$*7ososkG67$A3&ab6#@WZas2hM&;MoLWV8(i2c@cYhpc8D<eS`Sd3?q<bLF1!
zZ0_{TwH4vhx!IY^mEqYV5g~7RKYL03@;O}S%3nT<B)a8S`gi5YWNk>!UC*zZ7vdz&
zN0GT=F({h5p3h=^4*%r)nArg>IvKC6d3P=LA9-SbZH+vB#+UCvku9HiQUW;8Dd+zE
zL}*nz$hlucb64{{^Fkb+Hs8#h%Rh%=6KyLcH2l`d4Ivbo2~X!=yCcNAcb}SF29V!t
z2~~<Z0C~&B{nsY?YnL2;v+D3|+=1!4BSdtft2PkLeJJPN%AGy66OGIiR)(kZ(L0v;
zuh#+Or|t-mpFp!8o~jPDL;eybj=wQ{9J}|EPe-1LJRNx^qMXUyktYrW`f?wfz<w6K
zneRctT;)rcf9}lq9e>rKyRktg_SaUk%!8IpS8ZVYPDRzBuK@ri*Kl&h9U-uN`*N3}
z6J~9I+8Mh_*lum^EPXRSTbVy}+sbhj<~Tm>t2*?U5TZN$-nPRxs}4OmFGS(TcFk^l
z4&VgN5V4!h-xgxq;rFTzU7Z(#(3{cR_53@xg($o^FGTo4E?T>!@VpS>)C1^)pJ2+b
z=7kunTGs`D<3;$rzTA(Vk#kq%@&BCL+20+W4quSZooipw4q}z@Fu(^39S!BrEU?Gq
z$+k70!`@kWFOn^{%vJJ4WzWO*&~ul#T(#~XcA7Ip<;k`JCQfd?f@I^ooSTzpez8@a
zxm6+i&dNWUH&@CNm8-}=KwP%V$@-Z8!M3*_27v5+d*s|Z`F%o&vz0%17{K@RnPX=h
z4+Zv5lz;at3k9~u#+j?jPt;&bPs<aVzl~Y>=1<|ygq&-Z&-GaA5cyn>HP6pK^cx}O
z<nhWcVGhUgkNgJvlV#VkRUBEZ=dk>z?18ce${r|tpzMLN2g)8Od!X!r|5Fd(cL?W&
zA5KDgdLV0<VBHTUl1Xjh!;AgFCN!ufl3F~ZnxXZ{cx!0A!F%qzx+7g*2xSuSw)OFl
z{YlAaTc3=RO=V=DZT-G%$hJxx>iX7JJc8eRaU<a6>q3kI!0|aDz6SuW+z?_X09?Ew
zL>$vU5CXqr;l+F6zJ0sEH(KpmyL?#yzs2KR96yTgydlJAP_S!RHDdVvF?mA>{svKt
zNqGL?x)AtH4uaJ^!J5aaKK93fgRu4fM;>ad#f7?MF9`s1H-x}%gU}VMjsgHKR&HMx
z;u^ZKBUt^Czav=lXB8d6(BzVi;D)1>kzm7%OC!OS@nv1XDPP6E`R)$3^aL9s!3`b3
zP)D$)BUs%L3`CsYCeVEODtn;pfwBk69w>XD?18ce${r|tpzMLN2Yz1<RIjqnk6os7
z-F$`&&!FK|JOf4Nq5167FzKx!IX=I<mUupcbwBZQbY7Vcq;mQ%=LH^}gef{-%<Hef
z(uH$vn0}tpc|F-m1?BY-eulxzeddYJ-R9|h8?S0#CVgHf@>w!I%hnRG^Jn~(Wj4>{
zK1TWR89L5?UfA^+C3!(S`*n`^4oW98|8IoPkGl)dOzqu6bT83CqR$h3k?1#weuwBk
z5IsxuUy1&V=uM(aSJ-}CP4qKFn~7q%dOJH?LmPUx@7Wj%ho#L@LugaOrly9^hqr__
z?9$>PSv4u4F5I+nk$97|NeZL*=7w;%!69xX)P);2LS%1iQzqOPZh~EVTlH)zl}HVR
zhGH>yUeK|(RZXSR1Bq10<le_y8%7)Bn;JGZt076MH^z*(mNDu_Tbk?Dfka&@ZE8{s
zcJFL$gx#I3Vd(5>ZTSeno@i@b_#@JLBduZB*@xD;TN@y;yR`upl>v{zN-;Ydy0>i-
zvq;!5RWlK*)3sze#!4>CR(65-JXqg1eE_|YT3@3YF2;!Lr7@+Hj7DipOUZC7#%k&-
zrDS*<%FuXJN+v^jt^Np^AxdLf$_}S7EhWQcUHcJb=CWofPxrIu<Z;|s0`ChahWD7a
z50=1w8W;J@KAznzC6D`Aeh2~{rohYEs{#PYva<#*(z#Kzi&rb*vo5@c@XIcIhey6&
zq<pyz$UHnn_!PAb<M=Yba`O9#@xzqwdCHf^)2~|iO5pbk%O58@{C;En4NLw$;P(~d
zUgiG}Oa5Ls`YGFQERVF5pWnCSSAlz6{k5gI0yv(9?cC$TcKkT-`-$;S`%0hdZ}*4~
zc*<A$T>rEsUjs+TZ)`v9VgChdkF*Aky5w^x@2>)W-q_Ad9(I1{flqnhCn;ZdIe*|G
zf5`*C;o%>@zqCJB`2kk=t0BPgTU4<J5yz2@a6Yph_OR3Gf$#OeGamTY{WzYkfxOHA
z-$HqR5T2#yh383cSbhi=$6RYq8vtG-JMMNoY2_OPJd}f%wLgvLYCOvGwg>*c2fm~N
z{aFLYT;;E>C>^i!P(|r>*^0P-Iq*Ax`&+k%JjSVETnon~@HqCIhdjh|Gc2V+QPhEi
zVyZ)+YZ*PQ3}#JjR7s~tq!>`-%U}xZ4<CxEYbszg%$O2OXHzDm=t~A#GtBJZpcI3J
zxDmx1QDPW5Vt}H=)5=gXJ)kC)xS7@sMa_;vEIpD*YNi&K8cItjgNal^QFUD%Q?!(+
zkHMg>j%Z3eJ2El`isIlDe5)@KRg|7xk!{^d_x3JD0j28;+aufhIzdr-x9?H9WlEL1
zc7f6x-O&+=Dm!|5c6awH{gIAnxANP;J?$JW^FM^h*daYdX$-Eh<AoMMiWXN*6|5>+
zpOhA*a@bKZpl4C4qM)uFgu@|6iv$ciJZKT-irldylw1;VBdrXpsW=Au^zBd#GoDB(
zSwoB4VML3h?U1EK5SQ8xmMSJSHZ2ZNat1&-g%m9n2PK|VtZA5PYFI-v5mPb=3_Kbz
z463pfYQ>q^pWd8yDC(*RVGGy+P>Uc%>EG7L-2+3OO2#p9Ak|`3>}?bbwkW}l$65q&
zIXU*L7{pbSYHR|KjIj|@9RLa2#iGM}mq?kKo&m|4K@X*}Qbtc_G~FC?Km*xCGG3R6
z6BOy_tHXy{Lh)hM7zQammNLdhY-;Lu%JZ6TB+{uxjG}|2Ye^Lq=q{5qL9%KrncAoc
z5<Zq7>1nG6OWH6!h{JImikz)sKasWu-^a&N>PR96(oov8{zz5^wy^=j04bIp8PQTE
zNVMRvs&3fDv}!7$GZO<@Q!{vE{NGVrx8t0O*T)=h&2iYgZs%Nh{>A*K0RY#^tk3bq
z9Cys~Q<mrPnfYdyKF1kz{4vg7ofp548S8WD^SpRJZ2-9Qck4e605^q5bNP8cVv6)P
zP(~b!<}N?RRpMR*>+^oadD3sE1oRR5j`expAmNJf<^7KUWyt#-Twk~UzXX8C(u?Ki
z{e=$Nz`*a@cyal;oJ=uZ6!$Ke=lzROm%h9FWELi^`S3#hdB5Zp(&zmW&fi`CZ<2lo
z8RY$!782zB8q~)<8n^ymkzd(<ao%7pP62pdip%S6|G#kQhiLs4B7N%&04wvF*FiC^
z8QX;O=lNAT1@nE@m7#kz@pmqLo@Wo!h8FL;aS>eR;Jc*H?Z@+04(5K56^XL{7{(L%
zSbo;$bqdGhbKE`4yYs)`(x0Yz^E5qpv#jWm|BvyAg(GH^*Jm7`?=CO%OfLZd24nDk
zAFl`J==Ty>j*G!O(|4)uSfAH#{Cf-hy9(5ui~Wzf2Yf*FXMK*#JzsC<=pKJKU#1_r
z^m#p)Cw)HG;#GdXwT@h<Kd+;X(1Y)8FZcKn@Y&B4m!IQ)kCML3854Ea$6m+U=V+Xw
ztpAJ?q`D%+<ycMS=W&X~uMzMl3sM5JOxOGD_YdpkpS7Q`4ffA6Ko<*=Kq-H4-)9?0
zGmSQvp#>NIZUV+ZbGz~Qjr+jtJE#6-{6PW$IOa-p6$fybaEVxYnLn`gA8{$TSom*w
CDtJKv

literal 0
HcmV?d00001

diff --git a/memcg-oom-repro/repro_futex_oom.c b/memcg-oom-repro/repro_futex_oom.c
new file mode 100644
index 000000000000..1491103720da
--- /dev/null
+++ b/memcg-oom-repro/repro_futex_oom.c
@@ -0,0 +1,135 @@
+// Reproducer for the memcg exit-path swap-in OOM storm.
+//
+// Spawns N threads, each of which registers a robust-futex list whose head
+// lives on its own page in a large anonymous region. That region is then
+// pushed out to (z)swap. When the process is OOM-group-killed, every thread
+// runs futex_cleanup()->exit_robust_list() on the way out, which does a
+// get_user() on its (swapped-out) head page -> do_swap_page() -> swap-in
+// charge against the (now over-limit) memcg -> memcg OOM killer. With no
+// eligible victim the charge serializes thousands of threads on oom_lock.
+//
+// Build: gcc -O2 -o repro_futex_oom repro_futex_oom.c -pthread
+// Run:   repro_futex_oom <nthreads> <filler_mb> <pageout 0|1>
+
+#define _GNU_SOURCE
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <unistd.h>
+#include <errno.h>
+#include <pthread.h>
+#include <sys/syscall.h>
+#include <sys/mman.h>
+
+#ifndef MADV_PAGEOUT
+#define MADV_PAGEOUT 21
+#endif
+
+#define PAGE_SIZE 4096UL
+
+/* Must match the kernel ABI (uapi/linux/futex.h). */
+struct rl { struct rl *next; };
+struct rl_head {
+	struct rl list;
+	long futex_offset;
+	struct rl *list_op_pending;
+};
+
+static long nthreads;
+static char *robust_area;
+static volatile long ready_count;
+
+static void *thread_fn(void *arg)
+{
+	long i = (long)arg;
+	struct rl_head *head =
+		(struct rl_head *)(robust_area + (size_t)i * PAGE_SIZE);
+
+	/* Build an (empty) robust list head on our own page. */
+	head->list.next = &head->list;
+	head->futex_offset = 0;
+	head->list_op_pending = NULL;
+
+	/* Override glibc's per-thread head (which points at resident TLS)
+	 * with our head, which is about to be swapped out. */
+	syscall(SYS_set_robust_list, head, sizeof(*head));
+
+	__atomic_add_fetch(&ready_count, 1, __ATOMIC_SEQ_CST);
+
+	/* Park until SIGKILL. pause() never touches robust_area. */
+	for (;;)
+		pause();
+	return NULL;
+}
+
+int main(int argc, char **argv)
+{
+	nthreads    = (argc > 1) ? atol(argv[1]) : 10000;
+	size_t fmb  = (argc > 2) ? (size_t)atol(argv[2]) : 256;
+	int pageout = (argc > 3) ? atoi(argv[3]) : 0;
+	size_t rsize = (size_t)nthreads * PAGE_SIZE;
+	size_t fsize = fmb * 1024UL * 1024UL;
+
+	robust_area = mmap(NULL, rsize, PROT_READ | PROT_WRITE,
+			   MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+	if (robust_area == MAP_FAILED) { perror("mmap robust"); return 1; }
+
+	char *filler = NULL;
+	if (fsize) {
+		filler = mmap(NULL, fsize, PROT_READ | PROT_WRITE,
+			      MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
+		if (filler == MAP_FAILED) { perror("mmap filler"); return 1; }
+		/*
+		 * ~2x compressible so zswap keeps a large in-cgroup pool that
+		 * pins the memcg above the limit for the whole exit storm
+		 * (like the incident's ~51 GiB pool).  First half of each page
+		 * is xorshift pseudo-random (incompressible), second half is
+		 * left zero.  A constant-byte fill would compress ~64x and the
+		 * pool would be too small to pin the cgroup.
+		 */
+		unsigned int rng = 0x9e3779b9;
+		for (size_t o = 0; o < fsize; o += PAGE_SIZE) {
+			for (size_t i = 0; i < PAGE_SIZE / 2; i++) {
+				rng ^= rng << 13;
+				rng ^= rng >> 17;
+				rng ^= rng << 5;
+				filler[o + i] = (char)rng;
+			}
+		}
+	}
+
+	pthread_attr_t attr;
+	pthread_attr_init(&attr);
+	pthread_attr_setstacksize(&attr, 64 * 1024);
+	pthread_attr_setguardsize(&attr, PAGE_SIZE);
+
+	long created = 0;
+	for (long i = 0; i < nthreads; i++) {
+		pthread_t t;
+		int rc = pthread_create(&t, &attr, thread_fn, (void *)i);
+		if (rc) {
+			fprintf(stderr, "pthread_create failed at %ld: %s\n",
+				i, strerror(rc));
+			break;
+		}
+		pthread_detach(t);
+		created++;
+	}
+
+	while (__atomic_load_n(&ready_count, __ATOMIC_SEQ_CST) < created)
+		usleep(2000);
+
+	if (pageout) {
+		madvise(robust_area, rsize, MADV_PAGEOUT);
+		if (filler)
+			madvise(filler, fsize, MADV_PAGEOUT);
+	}
+
+	printf("READY pid=%d threads=%ld robust_mb=%zu filler_mb=%zu\n",
+	       getpid(), created, rsize / 1024 / 1024, fmb);
+	fflush(stdout);
+
+	for (;;)
+		pause();
+	return 0;
+}
diff --git a/memcg-oom-repro/run.sh b/memcg-oom-repro/run.sh
new file mode 100755
index 000000000000..15961696c038
--- /dev/null
+++ b/memcg-oom-repro/run.sh
@@ -0,0 +1,97 @@
+#!/bin/bash
+# Reproduce the memcg exit-path OOM-lock serialization.
+#
+# Run as root, inside a throwaway VM (it drives the whole cgroup into OOM).
+# Requires: cgroup2, zswap, a swap device (this script sets up zram),
+# CONFIG_FUTEX (robust futex).
+#
+# Usage: ./run.sh [nthreads] [filler_mb] [max_hi] [max_lo] [pageout] [timeout_s] [oom_dump_tasks]
+# Example: ./run.sh 10000 512 2G 64M
+#
+# Metric: "memcg_oom_invocations" (memory.events:oom) is the degree of the
+# oom_lock-serialized storm, and "exit_time_seconds" is the wall-clock for the
+# whole process to leave the cgroup. A baseline kernel shows a large OOM count;
+# a fixed kernel (force-charge dying tasks) shows a handful.
+set -u
+
+NTHREADS=${1:-10000}
+FILLER_MB=${2:-512}
+MAX_HI=${3:-2G}
+MAX_LO=${4:-64M}
+PAGEOUT=${5:-1}
+TIMEOUT=${6:-300}
+DUMP=${7:-0}
+
+HERE="$(cd "$(dirname "$0")" && pwd)"
+REPRO="$HERE/repro_futex_oom"
+CG=/sys/fs/cgroup/repro
+RDY=/tmp/repro.out
+
+[ -x "$REPRO" ] || { echo "FATAL: build first ('make'); missing $REPRO"; exit 1; }
+[ "$(id -u)" = 0 ] || { echo "FATAL: run as root"; exit 1; }
+
+echo "===== kernel: $(uname -r) ====="
+
+ulimit -u 4000000 2>/dev/null || ulimit -u unlimited 2>/dev/null || true
+sysctl -q -w kernel.threads-max=4000000 kernel.pid_max=4000000 \
+	vm.max_map_count=2000000 vm.oom_dump_tasks="$DUMP" 2>/dev/null || true
+echo 1 4 1 7 > /proc/sys/kernel/printk 2>/dev/null || true	# keep OOM spam off the console
+
+# cgroup v2
+grep -q 'cgroup2 /sys/fs/cgroup ' /proc/mounts || \
+	mount -t cgroup2 none /sys/fs/cgroup || { echo "FATAL: cgroup2 mount"; exit 1; }
+echo "+memory" > /sys/fs/cgroup/cgroup.subtree_control 2>/dev/null || true
+mkdir -p "$CG"
+
+# backing swap via zram (zswap sits in front of it)
+[ -e /dev/zram0 ] || cat /sys/class/zram-control/hot_add >/dev/null 2>&1 || true
+echo 6G > /sys/block/zram0/disksize 2>/dev/null || echo "WARN: zram disksize"
+mkswap /dev/zram0 >/dev/null 2>&1
+swapon /dev/zram0 2>/dev/null || echo "WARN: swapon zram0 (need CONFIG_ZRAM)"
+echo "zswap enabled=$(cat /sys/module/zswap/parameters/enabled 2>/dev/null) comp=$(cat /sys/module/zswap/parameters/compressor 2>/dev/null)"
+
+echo "$MAX_HI" > "$CG/memory.max"
+echo 1 > "$CG/memory.oom.group"
+echo 0 > "$CG/memory.zswap.writeback" 2>/dev/null || echo "WARN: no memory.zswap.writeback"
+
+# launch the reproducer inside the cgroup
+rm -f "$RDY"
+( echo $BASHPID > "$CG/cgroup.procs"; exec "$REPRO" "$NTHREADS" "$FILLER_MB" "$PAGEOUT" ) >"$RDY" 2>&1 &
+for i in $(seq 1 180); do grep -q READY "$RDY" 2>/dev/null && break; sleep 1; done
+grep -q READY "$RDY" 2>/dev/null || { echo "FATAL: repro not READY"; cat "$RDY"; exit 1; }
+echo "repro: $(cat "$RDY")"
+
+# push the process's anon into the zswap pool
+echo 8G > "$CG/memory.reclaim" 2>/dev/null || true
+sleep 1
+echo "memory.stat: $(grep -E '^(anon|zswap|zswapped) ' "$CG/memory.stat" | tr '\n' ' ')"
+echo "memory.current pre-trigger: $(cat "$CG/memory.current")"
+
+oom0=$(awk '/^oom /{print $2}' "$CG/memory.events")
+
+# trigger: shrink memory.max below the (pinned) zswap pool -> OOM-group-kill
+echo "===== drop memory.max -> $MAX_LO ====="
+T0=$(date +%s.%N)
+echo "$MAX_LO" > "$CG/memory.max"
+done=0
+for i in $(seq 1 $((TIMEOUT * 2))); do
+	[ -n "$(cat "$CG/cgroup.procs" 2>/dev/null)" ] || { done=1; break; }
+	sleep 0.5
+done
+T1=$(date +%s.%N)
+oom1=$(awk '/^oom /{print $2}' "$CG/memory.events")
+
+echo "===== RESULT ====="
+if [ "$done" = 1 ]; then
+	echo "process_exited=yes exit_time_seconds=$(awk "BEGIN{printf \"%.2f\", $T1-$T0}")"
+else
+	echo "process_exited=NO(timeout=${TIMEOUT}s) still=$(wc -l < "$CG/cgroup.procs")"
+fi
+echo "memcg_oom_invocations=$((oom1 - oom0))"
+
+# cleanup
+echo "$MAX_HI" > "$CG/memory.max" 2>/dev/null || true
+[ -n "$(cat "$CG/cgroup.procs" 2>/dev/null)" ] && kill -9 $(cat "$CG/cgroup.procs") 2>/dev/null
+sleep 1; rmdir "$CG" 2>/dev/null || true
+swapoff /dev/zram0 2>/dev/null || true
+echo "===== DONE ====="
diff --git a/memcg-oom-repro/trace.sh b/memcg-oom-repro/trace.sh
new file mode 100755
index 000000000000..c8f0af1b2804
--- /dev/null
+++ b/memcg-oom-repro/trace.sh
@@ -0,0 +1,69 @@
+#!/bin/bash
+# Confirm the OOM path with kprobes (needs CONFIG_KPROBE_EVENTS + CONFIG_STACKTRACE).
+# Shows that the swap-in charge and out_of_memory come from the dying threads'
+# get_signal -> futex_cleanup (robust-futex) exit path, and that memory.current
+# stays pinned. Run as root inside a VM.  Usage: ./trace.sh [nthreads] [filler_mb] [max_lo]
+set -u
+NTHREADS=${1:-300}
+FILLER_MB=${2:-512}
+MAX_LO=${3:-64M}
+HERE="$(cd "$(dirname "$0")" && pwd)"
+REPRO="$HERE/repro_futex_oom"
+CG=/sys/fs/cgroup/repro
+RDY=/tmp/repro.out
+T=/sys/kernel/tracing
+
+[ -x "$REPRO" ] || { echo "build first (make)"; exit 1; }
+echo "kernel: $(uname -r)"
+ulimit -u 4000000 2>/dev/null || true
+sysctl -q -w kernel.threads-max=4000000 kernel.pid_max=4000000 \
+	vm.max_map_count=2000000 vm.oom_dump_tasks=0 2>/dev/null || true
+echo 1 4 1 7 > /proc/sys/kernel/printk 2>/dev/null || true
+
+grep -q 'cgroup2 /sys/fs/cgroup ' /proc/mounts || mount -t cgroup2 none /sys/fs/cgroup
+echo "+memory" > /sys/fs/cgroup/cgroup.subtree_control 2>/dev/null || true
+mkdir -p "$CG"
+[ -e /dev/zram0 ] || cat /sys/class/zram-control/hot_add >/dev/null 2>&1 || true
+echo 6G > /sys/block/zram0/disksize 2>/dev/null || true
+mkswap /dev/zram0 >/dev/null 2>&1; swapon /dev/zram0 2>/dev/null || true
+echo 2G > "$CG/memory.max"; echo 1 > "$CG/memory.oom.group"
+echo 0 > "$CG/memory.zswap.writeback" 2>/dev/null || true
+
+# kprobes (exit_robust_list is usually inlined into futex_cleanup, so that probe
+# may fail; the swap-in/OOM stacks still show the full path).
+[ -d "$T" ] || mount -t tracefs none /sys/kernel/tracing 2>/dev/null
+[ -d "$T" ] || T=/sys/kernel/debug/tracing
+echo 0 > "$T/tracing_on"; : > "$T/trace"; : > "$T/kprobe_events" 2>/dev/null || true
+echo 'p:kp_swpin mem_cgroup_swapin_charge_folio' >> "$T/kprobe_events" 2>/dev/null || true
+echo 'p:kp_oom out_of_memory' >> "$T/kprobe_events" 2>/dev/null || true
+
+rm -f "$RDY"
+( echo $BASHPID > "$CG/cgroup.procs"; exec "$REPRO" "$NTHREADS" "$FILLER_MB" 1 ) >"$RDY" 2>&1 &
+for i in $(seq 1 120); do grep -q READY "$RDY" 2>/dev/null && break; sleep 1; done
+echo "repro: $(cat "$RDY")"
+echo 8G > "$CG/memory.reclaim" 2>/dev/null || true; sleep 1
+echo "zswapped=$(awk '/^zswapped /{print $2}' "$CG/memory.stat") current=$(cat "$CG/memory.current")"
+
+echo 1 > "$T/events/kprobes/kp_swpin/enable" 2>/dev/null
+echo 1 > "$T/events/kprobes/kp_oom/enable" 2>/dev/null
+echo stacktrace > "$T/events/kprobes/kp_swpin/trigger" 2>/dev/null || true
+echo stacktrace > "$T/events/kprobes/kp_oom/trigger" 2>/dev/null || true
+echo 1 > "$T/tracing_on"
+
+echo "===== drop memory.max -> $MAX_LO ====="
+echo "$MAX_LO" > "$CG/memory.max"
+for i in $(seq 1 240); do [ -n "$(cat "$CG/cgroup.procs" 2>/dev/null)" ] || break; sleep 0.5; done
+echo 0 > "$T/tracing_on"
+
+echo "===== TRACE RESULTS ====="
+echo "swapin_charge calls   : $(grep -c 'kp_swpin:' "$T/trace")"
+echo "out_of_memory calls   : $(grep -c 'kp_oom:' "$T/trace")"
+echo "memcg oom events      : $(awk '/^oom /{print $2}' "$CG/memory.events")"
+echo "----- one swap-in charge stack (exit path) -----"
+awk '/<stack trace>/{b=1;s="";next} b&&/=>/{s=s $0 "\n";next}
+     b{b=0; if(s ~ /mem_cgroup_swapin_charge_folio/ && s ~ /futex_cleanup/){printf "%s",s; exit}}' "$T/trace"
+echo "----- one out_of_memory stack (exit path) -----"
+awk '/<stack trace>/{b=1;s="";next} b&&/=>/{s=s $0 "\n";next}
+     b{b=0; if(s ~ /out_of_memory/ && s ~ /futex_cleanup/){printf "%s",s; exit}}' "$T/trace"
+echo "===== DONE ====="
+[ -n "$(cat "$CG/cgroup.procs" 2>/dev/null)" ] && kill -9 $(cat "$CG/cgroup.procs") 2>/dev/null
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8319ad8c5c23..5ffe612e0c08 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2605,7 +2605,6 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	struct mem_cgroup *mem_over_limit;
 	struct page_counter *counter;
 	unsigned long nr_reclaimed;
-	bool passed_oom = false;
 	unsigned int reclaim_options;
 	bool drained = false;
 	bool raised_max_event = false;
@@ -2690,18 +2689,24 @@ static int try_charge_memcg(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	if (gfp_mask & __GFP_RETRY_MAYFAIL)
 		goto nomem;
 
-	/* Avoid endless loop for tasks bypassed by the oom killer */
-	if (passed_oom && task_is_dying())
-		goto nomem;
+	/*
+	 * A dying task frees its memory as soon as it exits, so invoking
+	 * the OOM killer for it is pointless - it finds no victim but
+	 * itself.  Worse, when 10s of thousands of threads take exit-time
+	 * faults at once (e.g. robust futex cleanup on swapped-out memory)
+	 * they all serialize behind oom_lock in a fruitless no-victim OOM
+	 * storm.  Force the charge instead so the task can make progress
+	 * and exit without contending on oom_lock.
+	 */
+	if (task_is_dying())
+		goto force;
 
 	/*
 	 * keep retrying as long as the memcg oom killer is able to make
-	 * a forward progress or bypass the charge if the oom killer
-	 * couldn't make any progress.
+	 * a forward progress.
 	 */
 	if (mem_cgroup_oom(mem_over_limit, gfp_mask,
 			   get_order(nr_pages * PAGE_SIZE))) {
-		passed_oom = true;
 		nr_retries = MAX_RECLAIM_RETRIES;
 		goto retry;
 	}
-- 
2.53.0-Meta

