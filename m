From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET v2] slab: make memcg slab destruction scalable
Date: Tue, 17 Jan 2017 08:49:13 -0800
Message-ID: <20170117164913.GB28948@mtj.duckdns.org>
References: <20170114184834.8658-1-tj@kernel.org>
 <20170117001256.GB25218@js1304-P5Q-DELUXE>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LG8q35hNba/fAgGPAOyr/mdUPEuYcpIqo930ozPglZo=;
        b=W6LzR9rP3m1+Qqtk4iJblrVOXvk69+YMuqIfWQGSkVa/HA2pu7tBGAtTjTANlqrACb
         bDuCv67hifnd3nx8SePmPZu1uVFoqQrlNTnJ0f+B11uGUGXWGKjBmFwwFpe7EwK84zeF
         i9hwMCSTkRxQiTr0AHP7rbUzvM6oPNtOs6c6PiXXXkCeJ9etWNm3jv83T0E3cnkWOklB
         j84TU3kmoiRXC4YCfnfryTki/SvOKPR6blr4+av/clm8m//p3e2eipDAO0vdQ/gT8Iot
         4U400n97yl6LlN/zOFQlHH/zauaJsKU3jnWP1ZAw2ckI073dURkoAnYmsjnZaxAv4/ur
         SfLw==
Content-Disposition: inline
In-Reply-To: <20170117001256.GB25218@js1304-P5Q-DELUXE>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: vdavydov.dev@gmail.com, cl@linux.com, penberg@kernel.org, rientjes@google.com, akpm@linux-foundation.org, jsvana@fb.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, kernel-team@fb.com

Hello,

On Tue, Jan 17, 2017 at 09:12:57AM +0900, Joonsoo Kim wrote:
> Could you confirm that your series solves the problem that is reported
> by Doug? It would be great if the result is mentioned to the patch
> description.
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=172991

So, that's an issue in the creation path which is already resolved by
switching to an ordered workqueue (it'd probably be better to use
per-cpu wq w/ @max_active == 1 tho).  This patchset is about relesae
path.  slab_mutex contention would definitely go down with this but
I don't think there's more connection to it than that.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
