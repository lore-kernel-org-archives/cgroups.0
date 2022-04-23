From: Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v4 4/4] selftests: cgroup: add a selftest for memory.reclaim
Date: Sat, 23 Apr 2022 14:43:13 -0700
Message-ID: <CAJD7tkbhjJDNXcAmiAkGT8RCvBSz=SAfh7JR3AJysSz29hcEgw@mail.gmail.com>
References: <20220421234426.3494842-1-yosryahmed@google.com>
 <20220421234426.3494842-5-yosryahmed@google.com> <20220423142801.gnvd42cdcsz4hpon@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NjdKMlafojykRWM3mLmTI0beW/EaYpJclIaGul4FrUE=;
        b=DPReL9r/tgtBxHjkNlFUr3vLePZV3WBKBCdqSzMfebUFeNdYbJ/ENvRK/DMKBq2S8Q
         gLdxMYTD/r0rB1oM71uJkyNGfmhAkNRJP9KfLeZV3hYSi73cL81ApuqK0mqT6jU8IAYf
         0N56sADpN3Xkq48jtOg+tuJsm6VA3nAl921pZ+CQQfh6DaY3UIMoGmlqcaEkFaBuGsUF
         BmDd0YcJAuwAjyIfL3UniTtX7SPXUThVYlELl3Y5perm06zDnXZ+rV3AKMixc7Q8pZKz
         YvoRorV6wbnVw4L1iQwmzoC7meonzJsnBHwcBNixrZaEBPik4w4UydYvWeCWdLPI2kXz
         vTug==
In-Reply-To: <20220423142801.gnvd42cdcsz4hpon@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <roman.gushchin@linux.dev>, David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, Yu Zhao <yuzhao@google.com>, Dave Hansen <dave.hansen@linux.intel.com>, Wei Xu <weixugc@google.com>, Greg Thelen <gthelen@google.com>, Chen Wandun <chenwandun@huawei.com>, Vaibhav Jain <vaibhav@linux.ibm.com>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, Tim Chen <tim.c.chen@linux.intel.com>, Dan Schatzberg <schatzberg.dan@gmail.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kern>

On Sat, Apr 23, 2022 at 7:28 AM Shakeel Butt <shakeelb@google.com> wrote:
>
> On Thu, Apr 21, 2022 at 11:44:26PM +0000, Yosry Ahmed wrote:
> > Add a new test for memory.reclaim that verifies that the interface
> > correctly reclaims memory as intended, from both anon and file pages.
> >
> > Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
> > Acked-by: Roman Gushchin <roman.gushchin@linux.dev>
> > ---
> >  .../selftests/cgroup/test_memcontrol.c        | 86 +++++++++++++++++++
> >  1 file changed, 86 insertions(+)
> >
> > diff --git a/tools/testing/selftests/cgroup/test_memcontrol.c b/tools/testing/selftests/cgroup/test_memcontrol.c
> > index f2ffb3a30194..5f7c20de2426 100644
> > --- a/tools/testing/selftests/cgroup/test_memcontrol.c
> > +++ b/tools/testing/selftests/cgroup/test_memcontrol.c
> > @@ -760,6 +760,91 @@ static int test_memcg_max(const char *root)
> >       return ret;
> >  }
> >
> > +/*
> > + * This test checks that memory.reclaim reclaims the given
> > + * amount of memory (from both anon and file).
> > + */
> > +static int test_memcg_reclaim(const char *root)
> > +{
> > +     int ret = KSFT_FAIL, fd, retries;
> > +     char *memcg;
> > +     long current, to_reclaim;
> > +     char buf[64];
> > +
> > +     memcg = cg_name(root, "memcg_test");
> > +     if (!memcg)
> > +             goto cleanup;
> > +
> > +     if (cg_create(memcg))
> > +             goto cleanup;
> > +
> > +     current = cg_read_long(memcg, "memory.current");
> > +     if (current != 0)
> > +             goto cleanup;
> > +
> > +     cg_run_nowait(memcg, alloc_anon_noexit, (void *) MB(50));
>
> Don't you need is_swap_enabled() check before deciding to do the anon
> allocations?

Yes you are right. In the next version will check whether or not swap
is enabled and modify the test accordingly.

> > +     sleep(1);
> > +
> > +     fd = get_temp_fd();
> > +     if (fd < 0)
> > +             goto cleanup;
> > +
> > +     cg_run_nowait(memcg, alloc_pagecache_50M_noexit, (void *)(long)fd);
> > +     sleep(1);
>
> These sleep(1)s do not seem robust. Since kernel keeps the page cache
> around, you can convert anon to use tmpfs and use simple cg_run to
> trigger the allocations of anon (tmpfs) and file which will remain in
> memory even after return from cg_run.

Other tests in the file are also using sleep approach (see
test_memcg_min, although it retries for multiple times until
memory.current reaches an expected amount). In my experience it hasn't
been flaky running for multiple times on different machines, but I
agree it can be flaky (false negative).

I am not sure about the allocating file pages with cg_run, is it
guaranteed that the page cache will remain in memory until the test
ends? If it doesn't, it can also flake, but it would produce false
positives (the test could pass because the kernel drained page cache
for some other reason although the interface is not working
correctly).

In my personal opinion, false negative flakes are better than false
positives. At least currently the test explicitly and clearly fails if
the allocations are not successful. If we rely on the page cache
remaining until the test finishes then it could silently pass if the
interface is not working correctly.

There are a few ways we can go forward with this:
1) Keep everything as-is, but print a message if the test fails due to
memory.current not reaching 100MB to make it clear that it didn't fail
due to a problem with the interface.
2) Add a sleep/retry loop similar to test_memcg_min instead of sleeping once.
3) Send a signal from forked children when they are done with the
allocation, and wait to receive this signal in the test to make sure
the allocation is completed.

In my opinion we should do (1) (and maybe (2)) for now as (3) could be
an overkill if the test is normal passing. Maybe add a comment about
(3) being an option in the future if the test flakes. Let me know what
you think?
