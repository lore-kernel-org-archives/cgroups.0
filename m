From: Andrei Vagin <avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: kmemleaks reports a lot of cases around memcg_create_kmem_cache
Date: Thu, 29 Jun 2017 11:04:01 -0700
Message-ID: <CANaxB-x=xgLq116VReo4Og+jFsAB+ehx3xThnXoCx8pR3YXPSA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=OPKvwccvU3DQQn/0eSpwIDeb3P8dZia+GQHlt3slsM8=;
        b=HErjzm5LBvTEJo1FEezC59ippYFI1NEh8ql4pulUi8Pp0IysNxvJJVQP5arZz6doYo
         UagrWeMB+tu7QpmcSEcrB9mhcVHhMGDXvut1cdLDJQKS4/WysihdIs24qIHjvwUqRc1z
         t6/SsNfcc41qlbdx1WnRi/xWcLZM41/tyLR+8XNjUxuixAqwRnhdntwkB8KzLsBL6oMf
         Gng5i1x/MegJrAuonHiknSeY04o8fLC5q6mbAWLavpkI2pb3oCu2v+fgIhvPbMTBTDv1
         R7uYUF6nE5LdUWhLlhuz8a0LcPF8JLQOe91Lkqm5UPevLa3a74OQ68mI9MO6MzzrLuhF
         8fUw==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

Hello,

We run CRIU tests on the linus' tree and found that kmemleak reports
unreferenced objects which are allocated from memcg_create_kmem_cache:

unreferenced object 0xffff9f79442cd980 (size 112):
  comm "kworker/1:4", pid 15416, jiffies 4307432421 (age 28687.562s)
  hex dump (first 32 bytes):
    00 00 00 00 ad 4e ad de ff ff ff ff 00 00 00 00  .....N..........
    ff ff ff ff ff ff ff ff b8 39 1b 97 ff ff ff ff  .........9......
  backtrace:
    [<ffffffff9591d28a>] kmemleak_alloc+0x4a/0xa0
    [<ffffffff95276198>] kmem_cache_alloc_node+0x168/0x2a0
    [<ffffffff95279f28>] __kmem_cache_create+0x2b8/0x5c0
    [<ffffffff9522ff57>] create_cache+0xb7/0x1e0
    [<ffffffff952305f8>] memcg_create_kmem_cache+0x118/0x160
    [<ffffffff9528eaf0>] memcg_kmem_cache_create_func+0x20/0x110
    [<ffffffff950cd6c5>] process_one_work+0x205/0x5d0
    [<ffffffff950cdade>] worker_thread+0x4e/0x3a0
    [<ffffffff950d5169>] kthread+0x109/0x140
    [<ffffffff9592b8fa>] ret_from_fork+0x2a/0x40
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff9f798a79f540 (size 32):
  comm "kworker/1:4", pid 15416, jiffies 4307432429 (age 28687.554s)
  hex dump (first 32 bytes):
    6b 6d 61 6c 6c 6f 63 2d 31 36 28 31 35 39 39 3a  kmalloc-16(1599:
    6e 65 77 72 6f 6f 74 29 00 23 6b c0 ff ff ff ff  newroot).#k.....
  backtrace:
    [<ffffffff9591d28a>] kmemleak_alloc+0x4a/0xa0
    [<ffffffff9527a378>] __kmalloc_track_caller+0x148/0x2c0
    [<ffffffff95499466>] kvasprintf+0x66/0xd0
    [<ffffffff954995a9>] kasprintf+0x49/0x70
    [<ffffffff952305c6>] memcg_create_kmem_cache+0xe6/0x160
    [<ffffffff9528eaf0>] memcg_kmem_cache_create_func+0x20/0x110
    [<ffffffff950cd6c5>] process_one_work+0x205/0x5d0
    [<ffffffff950cdade>] worker_thread+0x4e/0x3a0
    [<ffffffff950d5169>] kthread+0x109/0x140
    [<ffffffff9592b8fa>] ret_from_fork+0x2a/0x40
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff9f79b6136840 (size 416):
  comm "kworker/1:4", pid 15416, jiffies 4307432429 (age 28687.573s)
  hex dump (first 32 bytes):
    40 fb 80 c2 3e 33 00 00 00 00 00 40 00 00 00 00  @...>3.....@....
    00 00 00 00 00 00 00 00 10 00 00 00 10 00 00 00  ................
  backtrace:
    [<ffffffff9591d28a>] kmemleak_alloc+0x4a/0xa0
    [<ffffffff95275bc8>] kmem_cache_alloc+0x128/0x280
    [<ffffffff9522fedb>] create_cache+0x3b/0x1e0
    [<ffffffff952305f8>] memcg_create_kmem_cache+0x118/0x160
    [<ffffffff9528eaf0>] memcg_kmem_cache_create_func+0x20/0x110
    [<ffffffff950cd6c5>] process_one_work+0x205/0x5d0
    [<ffffffff950cdade>] worker_thread+0x4e/0x3a0
    [<ffffffff950d5169>] kthread+0x109/0x140
    [<ffffffff9592b8fa>] ret_from_fork+0x2a/0x40
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff9f798cac8000 (size 1024):
  comm "kworker/1:4", pid 15416, jiffies 4307432429 (age 28687.573s)
  hex dump (first 32 bytes):
    10 00 00 00 70 09 00 00 20 09 00 00 00 09 00 00  ....p... .......
    80 02 00 00 b0 03 00 00 30 06 00 00 50 02 00 00  ........0...P...
  backtrace:
    [<ffffffff9591d28a>] kmemleak_alloc+0x4a/0xa0
    [<ffffffff952766b8>] __kmalloc+0x158/0x2c0
    [<ffffffff95230a5f>] cache_random_seq_create+0x6f/0x130
    [<ffffffff952714da>] init_cache_random_seq+0x3a/0x90
    [<ffffffff95279d70>] __kmem_cache_create+0x100/0x5c0
    [<ffffffff9522ff57>] create_cache+0xb7/0x1e0
    [<ffffffff952305f8>] memcg_create_kmem_cache+0x118/0x160
    [<ffffffff9528eaf0>] memcg_kmem_cache_create_func+0x20/0x110
    [<ffffffff950cd6c5>] process_one_work+0x205/0x5d0
    [<ffffffff950cdade>] worker_thread+0x4e/0x3a0
    [<ffffffff950d5169>] kthread+0x109/0x140
    [<ffffffff9592b8fa>] ret_from_fork+0x2a/0x40
    [<ffffffffffffffff>] 0xffffffffffffffff
unreferenced object 0xffff9f79442cd800 (size 112):

[root@zdtm linux]# git describe HEAD
v4.12-rc7-26-gb216759

[root@zdtm linux]# uname -a
Linux zdtm.openvz.org 4.12.0-rc7+ #9 SMP Thu Jun 29 08:28:18 CEST 2017
x86_64 x86_64 x86_64 GNU/Linux
