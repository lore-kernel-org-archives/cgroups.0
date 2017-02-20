From: kbuild test robot <lkp-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 01/19] kernel: convert sighand_struct.count from atomic_t
 to refcount_t
Date: Mon, 20 Feb 2017 20:30:14 +0800
Message-ID: <201702202032.y4RtL1WA%fengguang.wu@intel.com>
References: <1487585948-6401-2-git-send-email-elena.reshetova@intel.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="GvXjxJ+pjyke8COw"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1487585948-6401-2-git-send-email-elena.reshetova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
To: Elena Reshetova <elena.reshetova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: kbuild-all-JC7UmRfGjtg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-audit-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, acme-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, alexander.shishkin-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, paul-r2n+y4ga6xFZroRs9YW3xA@public.gmane.org, eparis-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, arnd-r2nGTMty4D4@public.gmane.org, luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Elena Reshetova <elena.reshetova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hans Liljestrand <ishkamiel-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, David Windsor <dwindsor-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Elena,

[auto build test WARNING on next-20170220]
[cannot apply to linus/master linux/master tip/perf/core v4.9-rc8 v4.9-rc7 v4.9-rc6]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Elena-Reshetova/kernel-convert-sighand_struct-count-from-atomic_t-to-refcount_t/20170220-183434
config: blackfin-TCM-BF537_defconfig (attached as .config)
compiler: bfin-uclinux-gcc (GCC) 6.2.0
reproduce:
        wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # save the attached .config to linux build tree
        make.cross ARCH=blackfin 

All warnings (new ones prefixed by >>):

   In file included from include/asm-generic/bug.h:4:0,
                    from arch/blackfin/include/asm/bug.h:71,
                    from include/linux/bug.h:4,
                    from include/linux/mmdebug.h:4,
                    from include/linux/mm.h:8,
                    from fs/proc/task_nommu.c:2:
   fs/proc/task_nommu.c: In function 'task_mem':
   include/asm-generic/atomic.h:177:37: error: 'refcount_t {aka struct refcount_struct}' has no member named 'counter'
    #define atomic_read(v) READ_ONCE((v)->counter)
                                        ^
   include/linux/compiler.h:316:17: note: in definition of macro '__READ_ONCE'
     union { typeof(x) __val; char __c[1]; } __u;   \
                    ^
   include/asm-generic/atomic.h:177:24: note: in expansion of macro 'READ_ONCE'
    #define atomic_read(v) READ_ONCE((v)->counter)
                           ^~~~~~~~~
>> fs/proc/task_nommu.c:64:26: note: in expansion of macro 'atomic_read'
     if (current->sighand && atomic_read(&current->sighand->count) > 1)
                             ^~~~~~~~~~~
   include/asm-generic/atomic.h:177:37: error: 'refcount_t {aka struct refcount_struct}' has no member named 'counter'
    #define atomic_read(v) READ_ONCE((v)->counter)
                                        ^
   include/linux/compiler.h:318:22: note: in definition of macro '__READ_ONCE'
      __read_once_size(&(x), __u.__c, sizeof(x));  \
                         ^
   include/asm-generic/atomic.h:177:24: note: in expansion of macro 'READ_ONCE'
    #define atomic_read(v) READ_ONCE((v)->counter)
                           ^~~~~~~~~
>> fs/proc/task_nommu.c:64:26: note: in expansion of macro 'atomic_read'
     if (current->sighand && atomic_read(&current->sighand->count) > 1)
                             ^~~~~~~~~~~
   include/asm-generic/atomic.h:177:37: error: 'refcount_t {aka struct refcount_struct}' has no member named 'counter'
    #define atomic_read(v) READ_ONCE((v)->counter)
                                        ^
   include/linux/compiler.h:318:42: note: in definition of macro '__READ_ONCE'
      __read_once_size(&(x), __u.__c, sizeof(x));  \
                                             ^
   include/asm-generic/atomic.h:177:24: note: in expansion of macro 'READ_ONCE'
    #define atomic_read(v) READ_ONCE((v)->counter)
                           ^~~~~~~~~
>> fs/proc/task_nommu.c:64:26: note: in expansion of macro 'atomic_read'
     if (current->sighand && atomic_read(&current->sighand->count) > 1)
                             ^~~~~~~~~~~
   include/asm-generic/atomic.h:177:37: error: 'refcount_t {aka struct refcount_struct}' has no member named 'counter'
    #define atomic_read(v) READ_ONCE((v)->counter)
                                        ^
   include/linux/compiler.h:320:30: note: in definition of macro '__READ_ONCE'
      __read_once_size_nocheck(&(x), __u.__c, sizeof(x)); \
                                 ^
   include/asm-generic/atomic.h:177:24: note: in expansion of macro 'READ_ONCE'
    #define atomic_read(v) READ_ONCE((v)->counter)
                           ^~~~~~~~~
>> fs/proc/task_nommu.c:64:26: note: in expansion of macro 'atomic_read'
     if (current->sighand && atomic_read(&current->sighand->count) > 1)
                             ^~~~~~~~~~~
   include/asm-generic/atomic.h:177:37: error: 'refcount_t {aka struct refcount_struct}' has no member named 'counter'
    #define atomic_read(v) READ_ONCE((v)->counter)
                                        ^
   include/linux/compiler.h:320:50: note: in definition of macro '__READ_ONCE'
      __read_once_size_nocheck(&(x), __u.__c, sizeof(x)); \
                                                     ^
   include/asm-generic/atomic.h:177:24: note: in expansion of macro 'READ_ONCE'
    #define atomic_read(v) READ_ONCE((v)->counter)
                           ^~~~~~~~~
>> fs/proc/task_nommu.c:64:26: note: in expansion of macro 'atomic_read'
     if (current->sighand && atomic_read(&current->sighand->count) > 1)
                             ^~~~~~~~~~~

vim +/atomic_read +64 fs/proc/task_nommu.c

^1da177e Linus Torvalds    2005-04-16  48  
^1da177e Linus Torvalds    2005-04-16  49  	if (atomic_read(&mm->mm_count) > 1)
^1da177e Linus Torvalds    2005-04-16  50  		sbytes += kobjsize(mm);
^1da177e Linus Torvalds    2005-04-16  51  	else
^1da177e Linus Torvalds    2005-04-16  52  		bytes += kobjsize(mm);
^1da177e Linus Torvalds    2005-04-16  53  	
498052bb Al Viro           2009-03-30  54  	if (current->fs && current->fs->users > 1)
^1da177e Linus Torvalds    2005-04-16  55  		sbytes += kobjsize(current->fs);
^1da177e Linus Torvalds    2005-04-16  56  	else
^1da177e Linus Torvalds    2005-04-16  57  		bytes += kobjsize(current->fs);
^1da177e Linus Torvalds    2005-04-16  58  
^1da177e Linus Torvalds    2005-04-16  59  	if (current->files && atomic_read(&current->files->count) > 1)
^1da177e Linus Torvalds    2005-04-16  60  		sbytes += kobjsize(current->files);
^1da177e Linus Torvalds    2005-04-16  61  	else
^1da177e Linus Torvalds    2005-04-16  62  		bytes += kobjsize(current->files);
^1da177e Linus Torvalds    2005-04-16  63  
^1da177e Linus Torvalds    2005-04-16 @64  	if (current->sighand && atomic_read(&current->sighand->count) > 1)
^1da177e Linus Torvalds    2005-04-16  65  		sbytes += kobjsize(current->sighand);
^1da177e Linus Torvalds    2005-04-16  66  	else
^1da177e Linus Torvalds    2005-04-16  67  		bytes += kobjsize(current->sighand);
^1da177e Linus Torvalds    2005-04-16  68  
^1da177e Linus Torvalds    2005-04-16  69  	bytes += kobjsize(current); /* includes kernel stack */
^1da177e Linus Torvalds    2005-04-16  70  
df5f8314 Eric W. Biederman 2008-02-08  71  	seq_printf(m,
^1da177e Linus Torvalds    2005-04-16  72  		"Mem:\t%8lu bytes\n"

:::::: The code at line 64 was first introduced by commit
:::::: 1da177e4c3f41524e886b7f1b8a0c1fc7321cac2 Linux-2.6.12-rc2

:::::: TO: Linus Torvalds <torvalds-gWtpgVMusWVb5UGfqNBoRg@public.gmane.org>
:::::: CC: Linus Torvalds <torvalds-gWtpgVMusWVb5UGfqNBoRg@public.gmane.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--GvXjxJ+pjyke8COw
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--GvXjxJ+pjyke8COw--
