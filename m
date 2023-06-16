From: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 1/2] mm/memcontrol: do not tweak node in mem_cgroup_init()
Date: Fri, 16 Jun 2023 10:42:46 +0200
Message-ID: <ZIwghl18d45vPNpd@dhcp22.suse.cz>
References: <20230615073226.1343-1-haifeng.xu@shopee.com>
 <ZIrIb7pgRXln27nv@dhcp22.suse.cz>
 <47119364-30ac-cb57-7fd8-d9aa4b230478@shopee.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1686904967; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ftqQxEyXprQeOR6akOe/4MsCo2o6FrnRrf5983ERKLo=;
        b=VV5M0MksasB5tNcC7sIZMcywp0knL6LvM7lfzJlFDnZU6EFlbhIDIm7qy01BIoB6wCYhIa
        NW6l1Mzasvo1uZCPKRuk0B92JuRHDzM+nfGMIaWUv0Q/mqQEn9AY6eUCvq+Ifxg6MLhWcK
        PBLS3Gm/QYO29GuX2iDK4z13XDDG5f4=
Content-Disposition: inline
In-Reply-To: <47119364-30ac-cb57-7fd8-d9aa4b230478-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Haifeng Xu <haifeng.xu-LL2PKPoSiP3QT0dZR+AlfA@public.gmane.org>
Cc: roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri 16-06-23 16:28:38, Haifeng Xu wrote:
> 
> 
> On 2023/6/15 16:14, Michal Hocko wrote:
> > On Thu 15-06-23 07:32:25, Haifeng Xu wrote:
> >> mem_cgroup_init() request for allocations from each possible node, and
> >> it's used to be a problem because NODE_DATA is not allocated for offline
> >> node. Things have already changed since commit 09f49dca570a9 ("mm: handle
> >> uninitialized numa nodes gracefully"), so it's unnecessary to check for
> >> !node_online nodes here.
> > 
> > How have you tested this patch?
> 
> Start with one empty node:
> 
> qemu-system-x86_64 \
>   -kernel vmlinux \
>   -initrd full.rootfs.cpio.gz \
>   -append "console=ttyS0,115200 root=/dev/ram0 nokaslr earlyprintk=serial oops=panic panic_on_warn" \
>   -drive format=qcow2,file=vm_disk.qcow2,media=disk,if=ide \
>   -enable-kvm \
>   -cpu host \
>   -m 8G,slots=2,maxmem=16G \
>   -smp cores=4,threads=1,sockets=2  \
>   -object memory-backend-ram,id=mem0,size=4G \
>   -object memory-backend-ram,id=mem1,size=4G \
>   -numa node,memdev=mem0,cpus=0-3,nodeid=0 \
>   -numa node,memdev=mem1,cpus=4-7,nodeid=1 \
>   -numa node,nodeid=2 \
>   -net nic,model=virtio,macaddr=52:54:00:12:34:58 \
>   -net user \
>   -nographic \
>   -rtc base=localtime \
>   -gdb tcp::6000
> 
> Guest state when booting:
> [    0.048881] NUMA: Node 0 [mem 0x00000000-0x0009ffff] + [mem 0x00100000-0xbfffffff] -> [mem 0x00000000-0xbfffffff]
> [    0.050489] NUMA: Node 0 [mem 0x00000000-0xbfffffff] + [mem 0x100000000-0x13fffffff] -> [mem 0x00000000-0x13fffffff]
> [    0.052173] NODE_DATA(0) allocated [mem 0x13fffc000-0x13fffffff]
> [    0.053164] NODE_DATA(1) allocated [mem 0x23fffa000-0x23fffdfff]
> [    0.054187] Zone ranges:
> [    0.054587]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
> [    0.055551]   DMA32    [mem 0x0000000001000000-0x00000000ffffffff]
> [    0.056515]   Normal   [mem 0x0000000100000000-0x000000023fffffff]
> [    0.057484] Movable zone start for each node
> [    0.058149] Early memory node ranges
> [    0.058705]   node   0: [mem 0x0000000000001000-0x000000000009efff]
> [    0.059679]   node   0: [mem 0x0000000000100000-0x00000000bffdffff]
> [    0.060659]   node   0: [mem 0x0000000100000000-0x000000013fffffff]
> [    0.061649]   node   1: [mem 0x0000000140000000-0x000000023fffffff]
> [    0.062638] Initmem setup node 0 [mem 0x0000000000001000-0x000000013fffffff]
> [    0.063745] Initmem setup node 1 [mem 0x0000000140000000-0x000000023fffffff]
> [    0.064855]   DMA zone: 158 reserved pages exceeds freesize 0
> [    0.065746] Initializing node 2 as memoryless
> [    0.066437] Initmem setup node 2 as memoryless
> [    0.067132]   DMA zone: 158 reserved pages exceeds freesize 0
> [    0.068037] On node 0, zone DMA: 1 pages in unavailable ranges
> [    0.068265] On node 0, zone DMA: 97 pages in unavailable ranges
> [    0.124755] On node 0, zone Normal: 32 pages in unavailable ranges
> 
> 
> cat /sys/devices/system/node/online
> 0-1
> cat /sys/devices/system/node/possible
> 0-2

Excellent! Please extend the changelog by this information. Feel free to
add
Acked-by: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>

Thanks!
-- 
Michal Hocko
SUSE Labs
