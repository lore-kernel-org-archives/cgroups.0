From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 01/19] kernel: convert sighand_struct.count from atomic_t
 to refcount_t
Date: Mon, 20 Feb 2017 20:42:45 +0800
Message-ID: <201702202048.0D1beSTu%fengguang.wu@intel.com>
References: <1487585948-6401-2-git-send-email-elena.reshetova@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="x+6KMIRAuhnl3hBn"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1487585948-6401-2-git-send-email-elena.reshetova@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
To: Elena Reshetova <elena.reshetova@intel.com>
Cc: kbuild-all@01.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-audit@redhat.com, linux-fsdevel@vger.kernel.org, peterz@infradead.org, gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk, tj@kernel.org, mingo@redhat.com, hannes@cmpxchg.org, lizefan@huawei.com, acme@kernel.org, alexander.shishkin@linux.intel.com, paul@paul-moore.com, eparis@redhat.com, akpm@linux-foundation.org, arnd@arndb.de, luto@kernel.org, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, Kees Cook <keescook@chromium.org>, David Windsor <dwindsor@gmail.com>


--x+6KMIRAuhnl3hBn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Elena,

[auto build test ERROR on next-20170220]
[cannot apply to linus/master linux/master tip/perf/core v4.9-rc8 v4.9-rc7 v4.9-rc6]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Elena-Reshetova/kernel-convert-sighand_struct-count-from-atomic_t-to-refcount_t/20170220-183434
config: blackfin-BF561-EZKIT-SMP_defconfig (attached as .config)
compiler: bfin-uclinux-gcc (GCC) 6.2.0
reproduce:
        wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        make.cross ARCH=blackfin 

All errors (new ones prefixed by >>):

   In file included from include/linux/atomic.h:4:0,
                    from arch/blackfin/include/asm/spinlock.h:14,
                    from include/linux/spinlock.h:87,
                    from include/linux/mmzone.h:7,
                    from include/linux/gfp.h:5,
                    from include/linux/mm.h:9,
                    from fs/proc/task_nommu.c:2:
   fs/proc/task_nommu.c: In function 'task_mem':
>> arch/blackfin/include/asm/atomic.h:27:53: error: 'refcount_t {aka struct refcount_struct}' has no member named 'counter'
    #define atomic_read(v) __raw_uncached_fetch_asm(&(v)->counter)
                                                        ^
   fs/proc/task_nommu.c:64:26: note: in expansion of macro 'atomic_read'
     if (current->sighand && atomic_read(&current->sighand->count) > 1)
                             ^~~~~~~~~~~

vim +27 arch/blackfin/include/asm/atomic.h

d835b6c4 arch/blackfin/include/asm/atomic.h Peter Zijlstra 2015-04-23  21  
d835b6c4 arch/blackfin/include/asm/atomic.h Peter Zijlstra 2015-04-23  22  asmlinkage int __raw_atomic_and_asm(volatile int *ptr, int value);
d835b6c4 arch/blackfin/include/asm/atomic.h Peter Zijlstra 2015-04-23  23  asmlinkage int __raw_atomic_or_asm(volatile int *ptr, int value);
6b3087c6 arch/blackfin/include/asm/atomic.h Graf Yang      2009-01-07  24  asmlinkage int __raw_atomic_xor_asm(volatile int *ptr, int value);
6b3087c6 arch/blackfin/include/asm/atomic.h Graf Yang      2009-01-07  25  asmlinkage int __raw_atomic_test_asm(const volatile int *ptr, int value);
6b3087c6 arch/blackfin/include/asm/atomic.h Graf Yang      2009-01-07  26  
ae41f32e arch/blackfin/include/asm/atomic.h Mike Frysinger 2011-06-17 @27  #define atomic_read(v) __raw_uncached_fetch_asm(&(v)->counter)
1394f032 include/asm-blackfin/atomic.h      Bryan Wu       2007-05-06  28  
d835b6c4 arch/blackfin/include/asm/atomic.h Peter Zijlstra 2015-04-23  29  #define atomic_add_return(i, v) __raw_atomic_add_asm(&(v)->counter, i)
d835b6c4 arch/blackfin/include/asm/atomic.h Peter Zijlstra 2015-04-23  30  #define atomic_sub_return(i, v) __raw_atomic_add_asm(&(v)->counter, -(i))

:::::: The code at line 27 was first introduced by commit
:::::: ae41f32e16d8e87c84cb910a6a6aefb50318894d Blackfin: SMP: convert to common asm-generic/atomic.h

:::::: TO: Mike Frysinger <vapier@gentoo.org>
:::::: CC: Mike Frysinger <vapier@gentoo.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--x+6KMIRAuhnl3hBn
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--x+6KMIRAuhnl3hBn--
