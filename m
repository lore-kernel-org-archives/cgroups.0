From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH v4 4/4] selftests: cgroup: add a selftest for memory.reclaim
Date: Mon, 25 Apr 2022 15:16:12 +0000
Message-ID: <20220425151612.izmxhkgugq6isyz3@google.com>
References: <20220421234426.3494842-1-yosryahmed@google.com>
 <20220421234426.3494842-5-yosryahmed@google.com> <20220423142801.gnvd42cdcsz4hpon@google.com>
 <CAJD7tkbhjJDNXcAmiAkGT8RCvBSz=SAfh7JR3AJysSz29hcEgw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=VgCwJNrSWLamwr26sf8FxhD/HG4cXOd5kOE1NHtb3Lc=;
        b=n+3K4I/06qyEIawpbSiGFoxmIG2WckzHJniuNA3IrWYHIDmrQJPps1fZCv8oZNwSmM
         djRwqb8qKIJdhL5flEOwoWrVf3bgw6r6rtBL6CiLjfJjgVeHt9rbRyZvi2iSQtcSgL0m
         65ns45Ge3Iq2HNetZYhGnHOJBhbwo86ueRNoo7CPPkWaqJ5XyjXrA6fYqELFFEZSjet5
         0OWyA1mggzBwOWq2YcP+eq1e9fceZkTFP0kFcxB7g7bqxE3NHOKo/3QkDrmhQK19CILR
         xTvPRmKD1wfvVAMuwJG6R7P9g1gkSn/gsfhl21Nj9xXHYQ1wxqgQ0MMJhY0uXSFekZE/
         Z5QQ==
In-Reply-To: <CAJD7tkbhjJDNXcAmiAkGT8RCvBSz=SAfh7JR3AJysSz29hcEgw@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Yosry Ahmed <yosryahmed@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Roman Gushchin <roman.gushchin@linux.dev>, David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>, Yu Zhao <yuzhao@google.com>, Dave Hansen <dave.hansen@linux.intel.com>, Wei Xu <weixugc@google.com>, Greg Thelen <gthelen@google.com>, Chen Wandun <chenwandun@huawei.com>, Vaibhav Jain <vaibhav@linux.ibm.com>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Tim Chen <tim.c.chen@linux.intel.com>, Dan Schatzberg <schatzberg.dan@gmail.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.ke>

On Sat, Apr 23, 2022 at 02:43:13PM -0700, Yosry Ahmed wrote:
[...]
> > > +     cg_run_nowait(memcg, alloc_pagecache_50M_noexit, (void *)(long)fd);
> > > +     sleep(1);
> >
> > These sleep(1)s do not seem robust. Since kernel keeps the page cache
> > around, you can convert anon to use tmpfs and use simple cg_run to
> > trigger the allocations of anon (tmpfs) and file which will remain in
> > memory even after return from cg_run.
> 
> Other tests in the file are also using sleep approach (see
> test_memcg_min, although it retries for multiple times until
> memory.current reaches an expected amount). In my experience it hasn't
> been flaky running for multiple times on different machines, but I
> agree it can be flaky (false negative).
> 

If other tests are doing the same then ignore this comment for now.
There should be a separate effort to move towards more deterministic
approach for the tests instead of sleep().

> I am not sure about the allocating file pages with cg_run, is it
> guaranteed that the page cache will remain in memory until the test
> ends? If it doesn't, it can also flake, but it would produce false
> positives (the test could pass because the kernel drained page cache
> for some other reason although the interface is not working
> correctly).
> 
> In my personal opinion, false negative flakes are better than false
> positives. At least currently the test explicitly and clearly fails if
> the allocations are not successful. If we rely on the page cache
> remaining until the test finishes then it could silently pass if the
> interface is not working correctly.
> 
> There are a few ways we can go forward with this:
> 1) Keep everything as-is, but print a message if the test fails due to
> memory.current not reaching 100MB to make it clear that it didn't fail
> due to a problem with the interface.
> 2) Add a sleep/retry loop similar to test_memcg_min instead of sleeping once.
> 3) Send a signal from forked children when they are done with the
> allocation, and wait to receive this signal in the test to make sure
> the allocation is completed.
> 
> In my opinion we should do (1) (and maybe (2)) for now as (3) could be
> an overkill if the test is normal passing. Maybe add a comment about
> (3) being an option in the future if the test flakes. Let me know what
> you think?

I am ok with (1).
