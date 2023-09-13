From: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3] mm: memcg: add THP swap out info for anonymous reclaim
Date: Thu, 14 Sep 2023 04:16:50 +0800
Message-ID: <202309140314.DrcFvlZS-lkp@intel.com>
References: <20230913164938.16918-1-vernhao@tencent.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1694636232; x=1726172232;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=hDZx/NnQIDPBjtB/AhtOHhAokFh4nKpl+iCA4tYh6as=;
  b=Vx9G1oD/KFr7bbWnRo9cO2N4/5T9dSGpq/Puq7FvehsOeEmkSZgv9fQe
   1LNJDo7tzpXrJXwlMWOeMPz61T1xRtHyeqg8OPYOp7AJB8F2NSTOx8twZ
   ZcWpnmEHLM/QKXRWXJT0/tXB0H8KtR0H1bVOSrASaEoS5zNo7wcczmE27
   8adQRS78/sr64ZVx30zx+TM3i0W7/mUdEJljgn1x/qR7r2Qj1NZRSVVRX
   UEBUj18xOr94NyQAH+EBo11guHQnp1wj+d1F2xAiRExkeKAGECYeR+/Mo
   ncS5QoFYd+orD5Z8Xygp91gwmA/91ezGlj0Rv8PPzN2e+dj0N/1Pnmlz3
   w==;
Content-Disposition: inline
In-Reply-To: <20230913164938.16918-1-vernhao-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: llvm-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, oe-kbuild-all-cunTk1MwBs/YUNznpcFYbw@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, haoxing990-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Xin Hao <vernhao-1Nz4purKYjRBDgjK7y7TUQ@public.gmane.org>

Hi Vern,

kernel test robot noticed the following build errors:

[auto build test ERROR on akpm-mm/mm-everything]

url:    https://github.com/intel-lab-lkp/linux/commits/Vern-Hao/mm-memcg-add-THP-swap-out-info-for-anonymous-reclaim/20230914-005121
base:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-everything
patch link:    https://lore.kernel.org/r/20230913164938.16918-1-vernhao%40tencent.com
patch subject: [PATCH v3] mm: memcg: add THP swap out info for anonymous reclaim
config: um-allnoconfig (https://download.01.org/0day-ci/archive/20230914/202309140314.DrcFvlZS-lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/config)
compiler: clang version 17.0.0 (https://github.com/llvm/llvm-project.git 4a5ac14ee968ff0ad5d2cc1ffa0299048db4c88a)
reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20230914/202309140314.DrcFvlZS-lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/reproduce)

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
| Closes: https://lore.kernel.org/oe-kbuild-all/202309140314.DrcFvlZS-lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/

All errors (new ones prefixed by >>):

   In file included from mm/page_io.c:15:
   In file included from include/linux/kernel_stat.h:9:
   In file included from include/linux/interrupt.h:11:
   In file included from include/linux/hardirq.h:11:
   In file included from arch/um/include/asm/hardirq.h:5:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:13:
   In file included from arch/um/include/asm/io.h:24:
   include/asm-generic/io.h:547:31: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     547 |         val = __raw_readb(PCI_IOBASE + addr);
         |                           ~~~~~~~~~~ ^
   include/asm-generic/io.h:560:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     560 |         val = __le16_to_cpu((__le16 __force)__raw_readw(PCI_IOBASE + addr));
         |                                                         ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/little_endian.h:37:51: note: expanded from macro '__le16_to_cpu'
      37 | #define __le16_to_cpu(x) ((__force __u16)(__le16)(x))
         |                                                   ^
   In file included from mm/page_io.c:15:
   In file included from include/linux/kernel_stat.h:9:
   In file included from include/linux/interrupt.h:11:
   In file included from include/linux/hardirq.h:11:
   In file included from arch/um/include/asm/hardirq.h:5:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:13:
   In file included from arch/um/include/asm/io.h:24:
   include/asm-generic/io.h:573:61: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     573 |         val = __le32_to_cpu((__le32 __force)__raw_readl(PCI_IOBASE + addr));
         |                                                         ~~~~~~~~~~ ^
   include/uapi/linux/byteorder/little_endian.h:35:51: note: expanded from macro '__le32_to_cpu'
      35 | #define __le32_to_cpu(x) ((__force __u32)(__le32)(x))
         |                                                   ^
   In file included from mm/page_io.c:15:
   In file included from include/linux/kernel_stat.h:9:
   In file included from include/linux/interrupt.h:11:
   In file included from include/linux/hardirq.h:11:
   In file included from arch/um/include/asm/hardirq.h:5:
   In file included from include/asm-generic/hardirq.h:17:
   In file included from include/linux/irq.h:20:
   In file included from include/linux/io.h:13:
   In file included from arch/um/include/asm/io.h:24:
   include/asm-generic/io.h:584:33: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     584 |         __raw_writeb(value, PCI_IOBASE + addr);
         |                             ~~~~~~~~~~ ^
   include/asm-generic/io.h:594:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     594 |         __raw_writew((u16 __force)cpu_to_le16(value), PCI_IOBASE + addr);
         |                                                       ~~~~~~~~~~ ^
   include/asm-generic/io.h:604:59: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     604 |         __raw_writel((u32 __force)cpu_to_le32(value), PCI_IOBASE + addr);
         |                                                       ~~~~~~~~~~ ^
   include/asm-generic/io.h:692:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     692 |         readsb(PCI_IOBASE + addr, buffer, count);
         |                ~~~~~~~~~~ ^
   include/asm-generic/io.h:700:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     700 |         readsw(PCI_IOBASE + addr, buffer, count);
         |                ~~~~~~~~~~ ^
   include/asm-generic/io.h:708:20: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     708 |         readsl(PCI_IOBASE + addr, buffer, count);
         |                ~~~~~~~~~~ ^
   include/asm-generic/io.h:717:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     717 |         writesb(PCI_IOBASE + addr, buffer, count);
         |                 ~~~~~~~~~~ ^
   include/asm-generic/io.h:726:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     726 |         writesw(PCI_IOBASE + addr, buffer, count);
         |                 ~~~~~~~~~~ ^
   include/asm-generic/io.h:735:21: warning: performing pointer arithmetic on a null pointer has undefined behavior [-Wnull-pointer-arithmetic]
     735 |         writesl(PCI_IOBASE + addr, buffer, count);
         |                 ~~~~~~~~~~ ^
>> mm/page_io.c:298:45: error: use of undeclared identifier 'p'
     298 |         count_swpout_vm_event(page_folio(sio->bvec[p].bv_page));
         |                                                    ^
   12 warnings and 1 error generated.


vim +/p +298 mm/page_io.c

   290	
   291	static void swap_writepage_fs(struct page *page, struct writeback_control *wbc)
   292	{
   293		struct swap_iocb *sio = NULL;
   294		struct swap_info_struct *sis = page_swap_info(page);
   295		struct file *swap_file = sis->swap_file;
   296		loff_t pos = page_file_offset(page);
   297	
 > 298		count_swpout_vm_event(page_folio(sio->bvec[p].bv_page));
   299		set_page_writeback(page);
   300		unlock_page(page);
   301		if (wbc->swap_plug)
   302			sio = *wbc->swap_plug;
   303		if (sio) {
   304			if (sio->iocb.ki_filp != swap_file ||
   305			    sio->iocb.ki_pos + sio->len != pos) {
   306				swap_write_unplug(sio);
   307				sio = NULL;
   308			}
   309		}
   310		if (!sio) {
   311			sio = mempool_alloc(sio_pool, GFP_NOIO);
   312			init_sync_kiocb(&sio->iocb, swap_file);
   313			sio->iocb.ki_complete = sio_write_complete;
   314			sio->iocb.ki_pos = pos;
   315			sio->pages = 0;
   316			sio->len = 0;
   317		}
   318		bvec_set_page(&sio->bvec[sio->pages], page, thp_size(page), 0);
   319		sio->len += thp_size(page);
   320		sio->pages += 1;
   321		if (sio->pages == ARRAY_SIZE(sio->bvec) || !wbc->swap_plug) {
   322			swap_write_unplug(sio);
   323			sio = NULL;
   324		}
   325		if (wbc->swap_plug)
   326			*wbc->swap_plug = sio;
   327	}
   328	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki
