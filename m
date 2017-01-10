From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [cgroup:for-next 16/18] kernel/cgroup/rdma.c:526:4: warning:
 'value' may be used uninitialized in this function
Date: Tue, 10 Jan 2017 11:37:22 -0600
Message-ID: <CAG53R5Wj3nJAEOX00jk0mYD5COdsFkPc_awf+bGxYH7JTrL5BQ@mail.gmail.com>
References: <201701110136.ojmLaqcf%fengguang.wu@intel.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=o6ngeafLyKZsIM0Cb/mT5eZHPkCi3E2IQBIAdAwNIyk=;
        b=vYWC1oSJI4MC5pDKv83EbqnXCJc3kc1vcG/i+TmA1kOYfGRdrYMv5Euf5McnUDXaS3
         33H+zZCOg0Yu/o0yUtrphTdLYRHIEKF7/3kUH/hKSNd2VghSgvQR6fLGzkMqplFgtHgW
         KBN5fBkfG9awmaSwYazbxHq7cDSqrUyxDclmwbNCtAmNG8pBlYvwetSlCdABv9mfGXnE
         KNJnvT6JC1rNyNZWee4/CvjyWdeh3j4fISD3TA8d6o/sQZ4GrRAlo2GwOCiD6jVxYSYo
         CYzXzNhjCicLQt9Sg8B5CQmWbK/HN+3d6ekYryJ35uHbPEr946Q4IP8dItUv9Mrj3Na3
         kbWg==
In-Reply-To: <201701110136.ojmLaqcf%fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: kbuild-all-JC7UmRfGjtg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

I reviewed the code. value initializing to zero is required. Sending
the incremental patch.

Parav

On Tue, Jan 10, 2017 at 11:20 AM, kbuild test robot
<fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-next
> head:   9c1e67f941019907034d7e5584c891603cce2d8e
> commit: 39d3e7584a686541a3295ff1624d341e669e1afc [16/18] rdmacg: Added rdma cgroup controller
> config: ia64-allmodconfig (attached as .config)
> compiler: ia64-linux-gcc (GCC) 6.2.0
> reproduce:
>         wget https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git/plain/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         git checkout 39d3e7584a686541a3295ff1624d341e669e1afc
>         # save the attached .config to linux build tree
>         make.cross ARCH=ia64
>
> Note: it may well be a FALSE warning. FWIW you are at least aware of it now.
> http://gcc.gnu.org/wiki/Better_Uninitialized_Warnings
>
> All warnings (new ones prefixed by >>):
>
>    kernel/cgroup/rdma.c: In function 'rdmacg_resource_read':
>>> kernel/cgroup/rdma.c:526:4: warning: 'value' may be used uninitialized in this function [-Wmaybe-uninitialized]
>        seq_printf(sf, "%d", value);
>        ^~~~~~~~~~~~~~~~~~~~~~~~~~~
>    kernel/cgroup/rdma.c:506:6: note: 'value' was declared here
>      u32 value;
>          ^~~~~
>
> vim +/value +526 kernel/cgroup/rdma.c
>
>    510          for (i = 0; i < RDMACG_RESOURCE_MAX; i++) {
>    511                  seq_puts(sf, rdmacg_resource_names[i]);
>    512                  seq_putc(sf, '=');
>    513                  if (sf_type == RDMACG_RESOURCE_TYPE_MAX) {
>    514                          if (rpool)
>    515                                  value = rpool->resources[i].max;
>    516                          else
>    517                                  value = S32_MAX;
>    518                  } else {
>    519                          if (rpool)
>    520                                  value = rpool->resources[i].usage;
>    521                  }
>    522
>    523                  if (value == S32_MAX)
>    524                          seq_puts(sf, RDMACG_MAX_STR);
>    525                  else
>  > 526                          seq_printf(sf, "%d", value);
>    527                  seq_putc(sf, ' ');
>    528          }
>    529  }
>    530
>    531  static int rdmacg_resource_read(struct seq_file *sf, void *v)
>    532  {
>    533          struct rdmacg_device *device;
>    534          struct rdmacg_resource_pool *rpool;
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
