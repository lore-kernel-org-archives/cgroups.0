From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET v3] slab: make memcg slab destruction scalable
Date: Fri, 3 Feb 2017 12:43:46 -0500
Message-ID: <20170203174346.GA26336@mtj.duckdns.org>
References: <20170117235411.9408-1-tj@kernel.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=1RoWXxW8J8M4Z7kFtgSFYWyjV6i+xU0J0lMgwIMW+Is=;
        b=jf3E/Lp9FRL+fed/0CidzugLf7mVl/9GeAi8f4j0KF1EhsT6GV66j2YIT0WrAOoP/g
         Ps1kF86OJVSFD+SD/9tkmVlb/ubPvchSiTRAaIwlOjEJeDPVlC0yWWRu5JnlNgSECm2N
         3EEW6m3lHm6KNuhsazf/Xfd4YTkqWhGB/qFxLqtPXH+6PsnG0pKaLMWBNyStJFJWTeMR
         nG3MonGdJes3ev0ly569IiEHrWgvJ3eAVAlywgjE/lODJR4FF51Vic/NAxtR13zbqD2U
         kumH1DpjLaeJsfUtkgaohzbmwZq8XeUYt546UTaq7t65JMU5cApFfA/Z98UcqkMMFbEX
         X5+w==
Content-Disposition: inline
In-Reply-To: <20170117235411.9408-1-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: vdavydov.dev@gmail.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, iamjoonsoo.kim@lge.com, akpm@linux-foundation.org
Cc: jsvana@fb.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, kernel-team@fb.com

Hello,

On Tue, Jan 17, 2017 at 03:54:01PM -0800, Tejun Heo wrote:
> Changes from [V2] to V3.
> 
> * 0002-slub-separate-out-sysfs_slab_release-from-sysfs_slab.patch
>   separated out from
>   0002-slab-remove-synchronous-rcu_barrier-call-in-memcg-ca.patch.
> 
> * 0002-slab-remove-synchronous-rcu_barrier-call-in-memcg-ca.patch
>   replaced with
>   0003-slab-remove-synchronous-rcu_barrier-call-in-memcg-ca.patch.
>   It now keeps rcu_barrier() in the kmem_cache destruction path.
> 
> * 0010-slab-memcg-wq.patch added to limit concurrency on destruction
>   work items.

Are there more concerns on this patchset?  If not, Andrew, can you
please route these patches?  On certain setups, this can cause serious
performance and scalability issues.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
