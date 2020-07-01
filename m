From: Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/2] arm64: Allocate crashkernel always in ZONE_DMA
Date: Thu,  2 Jul 2020 03:44:20 +0530
Message-ID: <1593641660-13254-3-git-send-email-bhsharma@redhat.com>
References: <1593641660-13254-1-git-send-email-bhsharma@redhat.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1593641690;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:in-reply-to:in-reply-to:references:references;
        bh=xoqk9QTtScU+aPGKHoCc+VNYKEEQhDvkQeRwCbimQV8=;
        b=awDmTn3N5uvVaegRezZRYwFAXlwPYX/3uUq5fRPM4MIj4/v7eu6aAwPmy5dlQSMS68It55
        Yw+UbW47lKPp5Sp5SMN54vZysLxkUqvZdf0hawv05g3mVtQJCS4Za8x+Jt6MnII0KTVbLc
        rX61g5UWqJT17GjdWWFb8px8HWTUtK4=
In-Reply-To: <1593641660-13254-1-git-send-email-bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bhupesh.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org

commit bff3b04460a8 ("arm64: mm: reserve CMA and crashkernel in
ZONE_DMA32") allocates crashkernel for arm64 in the ZONE_DMA32.

However as reported by Prabhakar, this breaks kdump kernel booting in
ThunderX2 like arm64 systems. I have noticed this on another ampere
arm64 machine. The OOM log in the kdump kernel looks like this:

  [    0.240552] DMA: preallocated 128 KiB GFP_KERNEL pool for atomic allocations
  [    0.247713] swapper/0: page allocation failure: order:1, mode:0xcc1(GFP_KERNEL|GFP_DMA), nodemask=(null),cpuset=/,mems_allowed=0
  <..snip..>
  [    0.274706] Call trace:
  [    0.277170]  dump_backtrace+0x0/0x208
  [    0.280863]  show_stack+0x1c/0x28
  [    0.284207]  dump_stack+0xc4/0x10c
  [    0.287638]  warn_alloc+0x104/0x170
  [    0.291156]  __alloc_pages_slowpath.constprop.106+0xb08/0xb48
  [    0.296958]  __alloc_pages_nodemask+0x2ac/0x2f8
  [    0.301530]  alloc_page_interleave+0x20/0x90
  [    0.305839]  alloc_pages_current+0xdc/0xf8
  [    0.309972]  atomic_pool_expand+0x60/0x210
  [    0.314108]  __dma_atomic_pool_init+0x50/0xa4
  [    0.318504]  dma_atomic_pool_init+0xac/0x158
  [    0.322813]  do_one_initcall+0x50/0x218
  [    0.326684]  kernel_init_freeable+0x22c/0x2d0
  [    0.331083]  kernel_init+0x18/0x110
  [    0.334600]  ret_from_fork+0x10/0x18

This patch limits the crashkernel allocation to the first 1GB of
the RAM accessible (ZONE_DMA), as otherwise we might run into OOM
issues when crashkernel is executed, as it might have been originally
allocated from either a ZONE_DMA32 memory or mixture of memory chunks
belonging to both ZONE_DMA and ZONE_DMA32.

Fixes: bff3b04460a8 ("arm64: mm: reserve CMA and crashkernel in ZONE_DMA32")
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: James Morse <james.morse-5wv7dgnIgG8@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: Will Deacon <will-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Reported-by: Prabhakar Kushwaha <pkushwaha-eYqpPyKDWXRBDgjK7y7TUQ@public.gmane.org>
Signed-off-by: Bhupesh Sharma <bhsharma-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 arch/arm64/mm/init.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index 1e93cfc7c47a..02ae4d623802 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -91,8 +91,15 @@ static void __init reserve_crashkernel(void)
 	crash_size = PAGE_ALIGN(crash_size);
 
 	if (crash_base == 0) {
-		/* Current arm64 boot protocol requires 2MB alignment */
-		crash_base = memblock_find_in_range(0, arm64_dma32_phys_limit,
+		/* Current arm64 boot protocol requires 2MB alignment.
+		 * Also limit the crashkernel allocation to the first
+		 * 1GB of the RAM accessible (ZONE_DMA), as otherwise we
+		 * might run into OOM issues when crashkernel is executed,
+		 * as it might have been originally allocated from
+		 * either a ZONE_DMA32 memory or mixture of memory
+		 * chunks belonging to both ZONE_DMA and ZONE_DMA32.
+		 */
+		crash_base = memblock_find_in_range(0, arm64_dma_phys_limit,
 				crash_size, SZ_2M);
 		if (crash_base == 0) {
 			pr_warn("cannot allocate crashkernel (size:0x%llx)\n",
@@ -101,6 +108,11 @@ static void __init reserve_crashkernel(void)
 		}
 	} else {
 		/* User specifies base address explicitly. */
+		if (crash_base + crash_size > arm64_dma_phys_limit) {
+			pr_warn("cannot reserve crashkernel: region is allocatable only in ZONE_DMA range\n");
+			return;
+		}
+
 		if (!memblock_is_region_memory(crash_base, crash_size)) {
 			pr_warn("cannot reserve crashkernel: region is not memory\n");
 			return;
-- 
2.7.4

