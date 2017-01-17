From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 7/8] slab: remove synchronous synchronize_sched() from
 memcg cache deactivation path
Date: Tue, 17 Jan 2017 08:42:38 -0800
Message-ID: <20170117164238.GA28948@mtj.duckdns.org>
References: <20170114184834.8658-1-tj@kernel.org>
 <20170114184834.8658-8-tj@kernel.org>
 <20170117002611.GC25218@js1304-P5Q-DELUXE>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LVS1uY/z5pUBztmvAX7+elclTKr6fMtRu0FkE65HHiY=;
        b=vLvd7VJSku3L4aC1D0njCEfJrf/iBdhC6fW9kbOgcPvMhYw5e4RizAZT0wvJwoaMMj
         uQ4kEQUeu0Y5Q5HKf+nllhc7c9yA32Xl390sd8K2esLMAzYlSPV4KfZdQ7VJ84KdNAjC
         +n2UeUkHBl1Uzin17+R6djrNFYOWLVEHsF40VY6MlXBc/ovdc/AxJCg5FMOszJGuqemc
         TF62NChJMkSkwpAs68t/FkCONKoyK94QXyz+bkT7BzQme7gJ7yw0/+4iX7d97ZL46yKm
         4e12txecwersP4tk4r9rX8uX+P0weMnyeZLDil6E5vGg4GxswTNGFZqFfChWJtkSSmIz
         lcCg==
Content-Disposition: inline
In-Reply-To: <20170117002611.GC25218@js1304-P5Q-DELUXE>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: vdavydov.dev@gmail.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, akpm@linux-foundation.org, jsvana@fb.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, kernel-team@fb.com

On Tue, Jan 17, 2017 at 09:26:11AM +0900, Joonsoo Kim wrote:
> > +	INIT_WORK(&s->memcg_params.deact_work, kmemcg_deactivate_workfn);
> > +	schedule_work(&s->memcg_params.deact_work);
> > +}
> 
> Isn't it better to submit one work item for each memcg like as
> Vladimir did? Or, could you submit this work to the ordered workqueue?
> I'm not an expert about workqueue like as you, but, I think
> that there is a chance to create a lot of threads if there is
> the slab_mutex lock contention.

Yeah, good point.  I'll switch it to its own workqueue w/ concurrency
limited to one.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
