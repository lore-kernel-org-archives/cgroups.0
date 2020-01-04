From: David Rientjes <rientjes@google.com>
Subject: Re: [RFC PATCH] mm: thp: grab the lock before manipulation defer
 list
Date: Fri, 3 Jan 2020 16:44:59 -0800 (PST)
Message-ID: <alpine.DEB.2.21.2001031642530.92066@chino.kir.corp.google.com>
References: <20200103143407.1089-1-richardw.yang@linux.intel.com> <alpine.DEB.2.21.2001031128200.160920@chino.kir.corp.google.com> <20200103233925.GA3678@richard>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=yueUb/2kKIa7znFfBTW3dbm2LtvKwc/fgWoUwv6QXa8=;
        b=mrSqENRxgPFzYjmvtbYUobSHdxD/gmPB8X3hNTXHwmWPCtHOKOY54ixHxasePPe/cc
         T2+yc3YpKwej9x8VwJ+mOO5DoH35aHhFDhbCdJalumQcWaes9OO05xzW5iKPb+y7FAAP
         XQ0MbV77UazX0jY9hxS8OVIFP5jFIxnhHHH5QhHoQeaXlRJ5pzKHmn2BpYoAZ5IyqodW
         F8RyV1oPchLvurdpYR3G65+tdA6DZwn7cgV36RQxVg9O+2+zR3ONkNuweFY8DUHfUMlz
         tVuCOWgc8341ZFLHp4DNobjomQY41eU/Xx0P5whxV7yedd8FP/vixBnLYFx8SFe+hXnL
         zjkA==
In-Reply-To: <20200103233925.GA3678@richard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yang <richardw.yang@linux.intel.com>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, kirill.shutemov@linux.intel.com, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, yang.shi@linux.alibaba.com

On Sat, 4 Jan 2020, Wei Yang wrote:

> On Fri, Jan 03, 2020 at 11:29:06AM -0800, David Rientjes wrote:
> >On Fri, 3 Jan 2020, Wei Yang wrote:
> >
> >> As all the other places, we grab the lock before manipulate the defer list.
> >> Current implementation may face a race condition.
> >> 
> >> Fixes: 87eaceb3faa5 ("mm: thp: make deferred split shrinker memcg aware")
> >> 
> >> Signed-off-by: Wei Yang <richardw.yang@linux.intel.com>
> >> 
> >> ---
> >> I notice the difference during code reading and just confused about the
> >> difference. No specific test is done since limited knowledge about cgroup.
> >> 
> >> Maybe I miss something important?
> >
> >The check for !list_empty(page_deferred_list(page)) must certainly be 
> >serialized with doing list_del_init(page_deferred_list(page)).
> >
> 
> Hi David
> 
> Would you mind giving more information? You mean list_empty and list_del_init
> is atomic?
> 

I mean your patch is obviously correct :)  It should likely also have a 
stable@vger.kernel.org # 5.4+

Acked-by: David Rientjes <rientjes@google.com>
