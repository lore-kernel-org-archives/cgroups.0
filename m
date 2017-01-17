From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/9] slab: remove synchronous rcu_barrier() call in memcg
 cache release path
Date: Tue, 17 Jan 2017 08:37:45 -0800
Message-ID: <20170117163745.GA8352@mtj.duckdns.org>
References: <20170114055449.11044-1-tj@kernel.org>
 <20170114055449.11044-3-tj@kernel.org>
 <20170114131939.GA2668@esperanza>
 <20170114151921.GA32693@mtj.duckdns.org>
 <20170117000754.GA25218@js1304-P5Q-DELUXE>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=8vN+u0rmH/QzU96RDWVhLEObOOnKn0Z4xdmhR4HmmhY=;
        b=gcPgXocYFNCWK+F12bVgT42pGXB7rM0XTx+ZzWsJ6nIjMwV2DVfUu2YtAzbdkxB7J1
         bAm73QpknaHPvmuttIvLACAV+LigVauJ+QWGcBmIeRwwgkH7w6H3K9RNOOOX5RfIC5/o
         3vyUiiuV/qeA5QDrJC5UyrxE+MUhROxCa9hFYERYupy6PrTPMYKaK6YW3QIph+gXhOgh
         +9BGtm13FlWLVWC+iqgEiqTEzcC3hgcUeQBvHsQDZA9T3n6AoYo/91/+wBfoqoj42RsL
         ziBb2o7HcOpaBxl00dLUCa/SmcpHJtL9He3fAyP3bUxy8zRoNU5+LGQNY2J2bAQoUtYV
         Vcgg==
Content-Disposition: inline
In-Reply-To: <20170117000754.GA25218@js1304-P5Q-DELUXE>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vladimir Davydov <vdavydov@tarantool.org>, cl@linux.com, penberg@kernel.org, rientjes@google.com, akpm@linux-foundation.org, jsvana@fb.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, kernel-team@fb.com

Hello, Joonsoo.

On Tue, Jan 17, 2017 at 09:07:54AM +0900, Joonsoo Kim wrote:
> Long time no see! :)

Yeah, happy new year!

> IIUC, rcu_barrier() here prevents to destruct the kmem_cache until all
> slab pages in it are freed. These slab pages are freed through call_rcu().

Hmm... why do we need that tho?  SLAB_DESTROY_BY_RCU only needs to
protect the slab pages, not kmem cache struct.  I thought that this
was because kmem cache destruction is allowed to release pages w/o RCU
delaying it.

> Your patch changes it to another call_rcu() and, I think, if sequence of
> executing rcu callbacks is the same with sequence of adding rcu
> callbacks, it would work. However, I'm not sure that it is
> guaranteed by RCU API. Am I missing something?

The call sequence doesn't matter.  Whether you're using call_rcu() or
rcu_barrier(), you're just waiting for a grace period to pass before
continuing.  It doens't give any other ordering guarantees, so the new
code should be equivalent to the old one except for being asynchronous.

Thanks.

-- 
tejun
