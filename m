From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 block/for-next] blk-iocost: fix divide-by-zero in
 transfer_surpluses()
Date: Fri, 11 Sep 2020 18:44:44 -0400
Message-ID: <20200911224444.GB865564@mtj.thefacebook.com>
References: <20200911170746.GG4295@mtj.thefacebook.com>
 <ff46ca79-433e-3279-a8eb-35156639be7b@kernel.dk>
 <20200911224049.GA865564@mtj.thefacebook.com>
 <59987f54-47fc-766f-0667-5a90daca0b1a@kernel.dk>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=u+WhBADY6qVJWkQ3xRM3bDy/SBlYQIzy5ZdNwaCGMPo=;
        b=Vd6T5UxRIdx5jTi/U0KU/8IsFPJn+d/lu1Rm2NRQqLFvakL1U7maewPdM/lewBZIBf
         3JlMLhMrGiLuqhfjC65xkDCyKXeVytlPJRK7J9HAiMm+TJRRlqOh/2R5NiUtCSLvaJT3
         OX9MD+J6eZXUr4IsDcH8JIThEv6bGpk9DePXSYqgZ0fFHA2XzxH5/EzeFwS12bSgIban
         T08PKKO3K2bSfLHbeNo9gH9hE41A48jpwozy4ttMKVyIvb+/HLVMTpx4JvRk9+nDgf9B
         24/5RuG4MXhn2RwEKraI50vOGj06UnXe33AFayZdWAj1277lIwCEUDN7UFQUtNdRLJDq
         7fww==
Content-Disposition: inline
In-Reply-To: <59987f54-47fc-766f-0667-5a90daca0b1a-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Sep 11, 2020 at 04:43:18PM -0600, Jens Axboe wrote:
> On 9/11/20 4:40 PM, Tejun Heo wrote:
> > Conceptually, root_iocg->hweight_donating must be less than WEIGHT_ONE but
> > all hweight calculations round up and thus it may end up >= WEIGHT_ONE
> > triggering divide-by-zero and other issues. Bound the value to avoid
> > surprises.
> > 
> > Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > Fixes: e08d02aa5fc9 ("blk-iocost: implement Andy's method for donation weight updates")
> > 
> > Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > ---
> > Jens, I was flipping between doing max_t(, 1) over the whole divider and
> > doing min_t(, WEIGHT_ONE - 1) for hweight_donating. I thought that I as
> > testing after the last change but it obviously wasn't and the previous patch
> > doesn't compile due to missing type argument. Can you please apply this
> > patch instead? I can send an incremental patch if that'd be better. My
> > apologies.
> 
> Sure, I replaced it. BTW, you had two signed-off-by's in there.

Yeah, sloppy all around. Sorry about that. Gotta slow down more when posting
oh-shit-I-fucked-up stuff.

Thanks.

-- 
tejun
