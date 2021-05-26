From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH-next] mm/memcontrol.c: Fix potential uninitialized
 variable warning
Date: Wed, 26 May 2021 13:43:21 -0700
Message-ID: <20210526134321.42bbd4a9dcbcf53e855c5b1b@linux-foundation.org>
References: <20210526193602.8742-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1622061802;
        bh=Wc0VpiNTofyWs1k/w7vX8Lh3TnH80xRCPirGtLFyVPI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RyuWUuz9Wqha7WDVAel0HwsYR+YjnUkiTHQ+CA3lL0pH90SXDsGQYssU3bqAAmuPf
         GC199lyAGoWTlfwC4P3vddNREIR+y8QrjvVuIjzWkrxwW7YbtgkT8bxAPjON4pwXWI
         TB1H3Y0KdYu/CHYNaF+lt3nafVuovwyPpQLIotV0=
In-Reply-To: <20210526193602.8742-1-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Waiman Long <longman@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, Muchun Song <songmuchun@bytedance.com>

On Wed, 26 May 2021 15:36:02 -0400 Waiman Long <longman@redhat.com> wrote:

> If the -Wno-maybe-uninitialized gcc option is not specified, compilation
> of memcontrol.c may generate the following warnings:
> 
> mm/memcontrol.c: In function ‘refill_obj_stock’:
> ./arch/x86/include/asm/irqflags.h:127:17: warning: ‘flags’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>   return !(flags & X86_EFLAGS_IF);
>           ~~~~~~~^~~~~~~~~~~~~~~~
> mm/memcontrol.c:3216:16: note: ‘flags’ was declared here
>   unsigned long flags;
>                 ^~~~~
> In file included from mm/memcontrol.c:29:
> mm/memcontrol.c: In function ‘uncharge_page’:
> ./include/linux/memcontrol.h:797:2: warning: ‘objcg’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>   percpu_ref_put(&objcg->refcnt);
>   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Fix that by properly initializing *pflags in get_obj_stock() and
> introducing a use_objcg bool variable in uncharge_page() to avoid
> potentially accessing the struct page data twice.
> 

Thanks.  I'll queue this as a fix against your "mm/memcg: optimize user
context object stock access".

