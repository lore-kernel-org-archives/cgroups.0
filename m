From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v2] mm: Add configuration to control whether vmpressure
 notifier is enabled
Date: Mon, 30 Aug 2021 15:49:19 +0200
Message-ID: <YSzh31BasoxUQXAu@dhcp22.suse.cz>
References: <1629417219-74853-1-git-send-email-wang.yong12@zte.com.cn>
 <YR+Rc9HC6OqlEq4I@dhcp22.suse.cz>
 <CAOH5QeCfwF0hX3XpoThEtwnddtOFEU9Jtp0Hoj+Q37D4Q6HC0Q@mail.gmail.com>
 <YR/NRJEhPKRQ1r22@dhcp22.suse.cz>
 <CAOH5QeDUUqrMnuws6cnBDU_oub4cK6KsHeX39p7Eikr4Bcjcnw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1630331360; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cc2jyFkI4Y/eTP0fuxxH8ESHEZFe6V2z4lrRtmnXM6Q=;
        b=f9o3YxtNcrKp+PK+ZWm2qAcsw5SLHc0jhEZNVj2f5bET7VWTGz50zzq8TpyCC/RXE458Tf
        lSeFAgCdD9JtLnXb3jnosfjBDxBo6eXU50D46GUyB+DEzAz3eANVJR3QcOCnV1V7yPUKAJ
        xoHh8NZSrT3v+aSLPdXND61QpTGNN4g=
Content-Disposition: inline
In-Reply-To: <CAOH5QeDUUqrMnuws6cnBDU_oub4cK6KsHeX39p7Eikr4Bcjcnw@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: yong w <yongw.pur@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Andrew Morton <akpm@linux-foundation.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Shakeel Butt <shakeelb@google.com>, Roman Gushchin <guro@fb.com>, alexs@kernel.org, Wei Yang <richard.weiyang@gmail.com>, Hui Su <sh_def@163.com>, Stephen Rothwell <sfr@canb.auug.org.au>, wang.yong12@zte.com.cn, Cgroups <cgroups@vger.kernel.org>, linux-doc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, yang.yang29@zte.com.cn

On Sun 22-08-21 17:46:08, yong w wrote:
> > All those reasons should be a part of the changelog.
> >....
> > I am not sure these are sufficient justifications but that is something
> > to discuss. And hence it should be a part of the changelog.
> >
> OK, These reasons will be added to the patch notesin later versions.
> 
> > > 3. In the case where the user does not need vmpressure,  vmpressure
> > > calculation is additional overhead.
> >
> > You should quantify that and argue why that overhead cannot be further
> > reduced without config/boot time knobs.
> >
> The test results of the previously used PFT tool may not be obvious.
> Is there a better way to quantify it?

This is a question for you to answer I am afraid. You want to add a
configuration option and (as explained) that is not free of cost from
the maintenance POV. There must a very good reason to do that.

> > > In some special scenes with tight memory, vmpressure will be executed
> > > frequently.we use "likely" and "inline"
> > > to improve the performance of the kernel, why not reduce some
> > > unnecessary calculations?
> >
> > I am all for improving the code. Is it possible to do it by other means?
> > E.g. reduce a potential overhead when there no events registered?
> Yes, the method you mentioned may be feasible, but it does not conflict
> with this patch.

It is not in conflict but runtime overhead reduction without more burden
on the configurability is usually a preferred approach.
-- 
Michal Hocko
SUSE Labs
