From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 1/2] mm: Charge current memcg when no mm is set
Date: Thu, 6 Feb 2020 10:27:04 -0500
Message-ID: <20200206152704.GA24735@cmpxchg.org>
References: <20200205223348.880610-1-dschatzberg@fb.com>
 <20200205223348.880610-2-dschatzberg@fb.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XZOggLanx1OakxhbvmLypkwLB6o7BwYbW0LP99Ryt1o=;
        b=yqZ/FZfL7rzCP/2Jqs5bBr0b3LqQr+WLoYGIPyBGKw6323lJiZKUFKys6E+VHeTJf2
         Q6Piw50B5YbifhP9CblDm+U1GrvZEKZfGAIM/WgHxJp8L+nPX03q6D8VELhZ9R6NOLtJ
         0N0BATZjWI1IczjjfHIveuTCnUgMe+YptD0IpellozuQtXZMs1KXJDOQoRD808ussEVS
         Oeq1YPf/gA/4zQLcWiJBTPhyXQkV4fdKw2VzJoUCEkl+iDXax7CtlZ/cnhsc9SesEK6s
         rSpSpV2Ot3fvi+Ga5GgVIr1vsjh5V4Ifnz9qtatPI8rzuX97IK5IffeOowrdFDe+hNk2
         Ak9A==
Content-Disposition: inline
In-Reply-To: <20200205223348.880610-2-dschatzberg@fb.com>
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Schatzberg <dschatzberg@fb.com>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Li Zefan <lizefan@huawei.com>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, "open list:BLOCK LAYER" <linux-block@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <linux-mm@kvack.org>

On Wed, Feb 05, 2020 at 02:33:47PM -0800, Dan Schatzberg wrote:
> This modifies the shmem and mm charge logic so that now if there is no
> mm set (as in the case of tmpfs backed loop device), we charge the
> current memcg, if set.
> 
> Signed-off-by: Dan Schatzberg <dschatzberg@fb.com>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

It's a dependency for 2/2, but it's also an overdue cleanup IMO: it's
always been a bit weird that memalloc_use_memcg() worked for kernel
allocations but was silently ignored for user pages.

This patch establishes a precedence order for who gets charged:

1. If there is a memcg associated with the page already, that memcg is
   charged. This happens during swapin.

2. If an explicit mm is passed, mm->memcg is charged. This happens
   during page faults, which can be triggered in remote VMs (eg gup).

3. Otherwise consult the current process context. If it has configured
   a current->active_memcg, use that. Otherwise, current->mm->memcg.

Thanks Dan
