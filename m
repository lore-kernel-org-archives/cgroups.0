From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: Possible mem cgroup bug in kernels between 4.18.0 and 5.3-rc1.
Date: Thu, 1 Aug 2019 20:19:52 +0200
Message-ID: <20190801181952.GA8425@kroah.com>
References: <5659221C-3E9B-44AD-9BBF-F74DE09535CD@apple.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564683594;
        bh=q+8ENR75Wy6t1l+2MP7lncHhAHQqOj5Ajtb+pAArq+E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HlM3xjHDnfgu7lCpxFF7/2BzBSM1XM0GtsPJAEmUfWWJJ7gKt0QaaSWHN17Uuk/fq
         2dkuzuyXO0Bd8Twz7KMdE/VurZ/7pDM272K0QTEyne7qnWTy9o9IHGYocVBjUzOY0N
         tjYmdI27Vi8b9ktGRAtYe2yk+mMYtSxiVxZcKFaQ=
Content-Disposition: inline
In-Reply-To: <5659221C-3E9B-44AD-9BBF-F74DE09535CD@apple.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Masoud Sharbiani <msharbiani@apple.com>
Cc: mhocko@kernel.org, hannes@cmpxchg.org, vdavydov.dev@gmail.com, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Aug 01, 2019 at 11:04:14AM -0700, Masoud Sharbiani wrote:
> Hey folks,
> I’ve come across an issue that affects most of 4.19, 4.20 and 5.2 linux-stable kernels that has only been fixed in 5.3-rc1.
> It was introduced by
> 
> 29ef680 memcg, oom: move out_of_memory back to the charge path 
> 
> The gist of it is that if you have a memory control group for a process that repeatedly maps all of the pages of a file with  repeated calls to:
> 
>    mmap(NULL, pages * PAGE_SIZE, PROT_WRITE|PROT_READ, MAP_FILE|MAP_PRIVATE, fd, 0)
> 
> The memory cg eventually runs out of memory, as it should. However,
> prior to the 29ef680 commit, it would kill the running process with
> OOM; After that commit ( and until 5.3-rc1; Haven’t pinpointed the
> exact commit in between 5.2.0 and 5.3-rc1) the offending process goes
> into %100 CPU usage, and doesn’t die (prior behavior) or fail the mmap
> call (which is what happens if one runs the test program with a low
> ulimit -v value).
> 
> Any ideas on how to chase this down further?

Finding the exact patch that fixes this would be great, as then I can
add it to the 4.19 and 5.2 stable kernels (4.20 is long end-of-life, no
idea why you are messing with that one...)

thanks,

greg k-h
