From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH -mm v2 3/7] cgroup: release css->id after css_free
Date: Mon, 19 Jan 2015 09:30:01 -0500
Message-ID: <20150119143001.GH8140@htj.dyndns.org>
References: <cover.1421664712.git.vdavydov@parallels.com>
 <4d7447a920522c1085ff96c08b2be71e0eb5d896.1421664712.git.vdavydov@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=+2/0rewU/2edRsINQ3YIGgZfKuiYvV8Hu7JXeUotLYs=;
        b=1HAEbl/3MS1cgCpZkEQxUC3hKY4apBSs0z5Eyp5K11gLun5lCZMU17+RsIOISPrV31
         X6itE2XSMFB7t61l0SWyIVru0Di47KkIFFqfuvG95GIL5KQEfg3BMvQ3JeELc3+S3Iam
         XCDTIUORmiP6JkSSqPCvp/lb/buFplOcwWEAnJPcSLfwn2EDCTAFajInvqznWLJy1c81
         1W5Ib9TqNVpn3MRZoIguRGl3xb2StgyfF+MlCrIr2hdTBO10fShXZbOzjKaF1w0VeLlI
         +D6oV2el6d5Phomdwy6PR95+XkVLHII54OSUO/MKlJTSH414i1DqCoU5soooZTE8Te1X
         4UCw==
Content-Disposition: inline
In-Reply-To: <4d7447a920522c1085ff96c08b2be71e0eb5d896.1421664712.git.vdavydov@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Dave Chinner <david@fromorbit.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 02:23:21PM +0300, Vladimir Davydov wrote:
> Currently, we release css->id in css_release_work_fn, right before
> calling css_free callback, so that when css_free is called, the id may
> have already been reused for a new cgroup.
> 
> I am going to use css->id to create unique names for per memcg kmem
> caches. Since kmem caches are destroyed only on css_free, I need css->id
> to be freed after css_free was called to avoid name clashes. This patch
> therefore moves css->id removal to css_free_work_fn. To prevent
> css_from_id from returning a pointer to a stale css, it makes
> css_release_work_fn replace the css ptr at css_idr:css->id with NULL.

I think it'd be better if you create a separate id for this purpose.
The requirement is pretty unusual and likely contradictory with other
usages.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
