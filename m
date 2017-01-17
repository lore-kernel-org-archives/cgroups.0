From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/9] slab: remove synchronous rcu_barrier() call in memcg
 cache release path
Date: Tue, 17 Jan 2017 09:02:15 -0800
Message-ID: <20170117170215.GC28948@mtj.duckdns.org>
References: <20170114055449.11044-1-tj@kernel.org>
 <20170114055449.11044-3-tj@kernel.org>
 <20170114131939.GA2668@esperanza>
 <20170114151921.GA32693@mtj.duckdns.org>
 <20170117000754.GA25218@js1304-P5Q-DELUXE>
 <20170117163745.GA8352@mtj.duckdns.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=umpJxPbaKFmDbgYwz8dxcfODFAIHWxsf6/CbAzTPzgI=;
        b=f//wKVjRfuprw7sLNcmAQoDfIBGTV2QKMyo0uhasUXc47aNeNAR0uXDW2Nsok0S3MP
         0WDwFLj1lbcgz/7P6s4qzITclAAbOJgdYBM1IukMzp2siwOCewrxoplKuJVhBSUME+hI
         fGkMfi818dZ+znMN7vdhW5A/qDwhvPX1NTuDrV/lIpMYrtYk5eXTicVbJhKOETxA+bMR
         stZe9nolgDtgx806cbOBeY+SuURJABJX1Qf2gU8pnxB3wiE6y+7eieVRUAwQPIJ5sHIe
         79hnA7e7nKB8pieToqKTHvd/6ZcTSZbzz90QUb7u0FrnDmjl8WsDTdK/QHvQG/5fXdrm
         gTtg==
Content-Disposition: inline
In-Reply-To: <20170117163745.GA8352@mtj.duckdns.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Vladimir Davydov <vdavydov@tarantool.org>, cl@linux.com, penberg@kernel.org, rientjes@google.com, akpm@linux-foundation.org, jsvana@fb.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, kernel-team@fb.com

On Tue, Jan 17, 2017 at 08:37:45AM -0800, Tejun Heo wrote:
> The call sequence doesn't matter.  Whether you're using call_rcu() or
> rcu_barrier(), you're just waiting for a grace period to pass before
> continuing.  It doens't give any other ordering guarantees, so the new
> code should be equivalent to the old one except for being asynchronous.

Oh I was confusing synchronize_rcu() with rcu_barrier(), so you're
right, kmem_cache struct needs to stay around for the slab pages to be
freed after RCU grace period.  Will revise the patch accordingly,
thanks.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
