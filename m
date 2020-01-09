From: David Rientjes <rientjes@google.com>
Subject: Re: [Patch v2] mm: thp: grab the lock before manipulation defer
 list
Date: Thu, 9 Jan 2020 10:52:01 -0800 (PST)
Message-ID: <alpine.DEB.2.21.2001091051160.57374@chino.kir.corp.google.com>
References: <20200109143054.13203-1-richardw.yang@linux.intel.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=2BBH+3AnXzeFa/U3IS7qGFZcMtEqxZT7wCj3mRBcmeM=;
        b=eklIOp+zakQC1CE30sXqMuWzAwbyxZX8INDxq4BFkauoMMbdQ17lXR/YY65/cbXQ45
         WaN7oI/vJTlxvxToHdamg6mLQomJzQulnRCGUbZceY2CzjGzTD8sJeTKHRgIKWwwEevq
         rYiw6LQC0MJ7yxDH44OqGwqt74Nt03fWbVUE+CV+sFa+mMVT9MXWSPjDJB9QEKeWbMkS
         pu/xIlbtYzrdTy2A0YpgtvbfD6SPFwyDz7bhKJdo/Fqrxw9RrPP9Ya2Lv6KnwMa3B29w
         Q4qCIzysKksxVLY80Wshbr7UR+tk8nkzbwA6lSE1ht7jWyXNE8DH00YJQGQzk4S8T1hZ
         jd3A==
In-Reply-To: <20200109143054.13203-1-richardw.yang@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yang <richardw.yang@linux.intel.com>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kirill.shutemov@linux.intel.com, yang.shi@linux.alibaba.com, alexander.duyck@gmail.com

On Thu, 9 Jan 2020, Wei Yang wrote:

> As all the other places, we grab the lock before manipulate the defer list.
> Current implementation may face a race condition.
> 
> For example, the potential race would be:
> 
>     CPU1                      CPU2
>     mem_cgroup_move_account   split_huge_page_to_list
>       !list_empty
>                                 lock
>                                 !list_empty
>                                 list_del
>                                 unlock
>       lock
>       # !list_empty might not hold anymore
>       list_del_init
>       unlock
> 
> When this sequence happens, the list_del_init() in
> mem_cgroup_move_account() would crash if CONFIG_DEBUG_LIST since the
> page is already been removed by list_del in split_huge_page_to_list().
> 
> Fixes: 87eaceb3faa5 ("mm: thp: make deferred split shrinker memcg aware")
> 
> Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
> Acked-by: David Rientjes <rientjes@google.com>

Thanks Wei!

Andrew, I'd also suggest:

Cc: stable@vger.kernel.org # 5.4+
