From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH] Revert "mm: add nodes= arg to memory.reclaim"
Date: Tue, 3 Jan 2023 09:37:54 +0100
Message-ID: <Y7PpYsbv1xC6m/Hu@dhcp22.suse.cz>
References: <20221202223533.1785418-1-almasrymina@google.com>
 <Y5bsmpCyeryu3Zz1@dhcp22.suse.cz>
 <Y5xASNe1x8cusiTx@dhcp22.suse.cz>
 <20221216101820.3f4a370af2c93d3c2e78ed8a@linux-foundation.org>
 <Y52Scge3ynvn/mB4@dhcp22.suse.cz>
 <20221219144252.f3da256e75e176905346b4d1@linux-foundation.org>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1672735075; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=cxucqJyzfnCNVadtYHxDXtyUdE5BQ5o27Kjd3R83JAg=;
        b=pB+jvQ4LqFEtRQBnhrTspiYshQvgyQetx3pEFEuajdpgDTi17C9MFciV3ESup3uhcsSOzj
        /TQS3rxhGPtDbogm4hadF52JYRROPgu0QbRk5MeKfowBOv1rpXcYMrimuSK9YBgnfQRH5I
        3l4+qWHER2nf3zdpdyBBsQePl9eBXWA=
Content-Disposition: inline
In-Reply-To: <20221219144252.f3da256e75e176905346b4d1@linux-foundation.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mina Almasry <almasrymina@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <songmuchun@bytedance.com>, Huang Ying <ying.huang@intel.com>, Yang Shi <yang.shi@linux.alibaba.com>, Yosry Ahmed <yosryahmed@google.com>, weixugc@google.com, fvdl@google.com, bagasdotme@gmail.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

[Sorry I was offline]

On Mon 19-12-22 14:42:52, Andrew Morton wrote:
> On Sat, 17 Dec 2022 10:57:06 +0100 Michal Hocko <mhocko@suse.com> wrote:
> 
> > > I think it's a bit premature to revert at this stage.  Possibly we can
> > > get to the desired end state by modifying the existing code.  Possibly
> > > we can get to the desired end state by reverting this and by adding
> > > something new.
> > 
> > Sure if we can converge to a proper implementation during the rc phase
> > then it would be ok. I cannot speak for others but at least for me
> > upcoming 2 weeks would be mostly offline so I cannot really contribute
> > much. A revert would be much more easier from the coordination POV IMHO.
> > 
> > Also I do not think there is any strong reason to rush this in. I do not
> > really see any major problems to have this extension in 6.2
> 
> I'll queue the revert in mm-unstable with a plan to merge it upstream
> around the -rc5 timeframe if there hasn't been resolution.

Thanks! I do not really think we need to rush node based reclaim and
better have a reasonable and more futureproof interface.

> Please check Mina's issues with this revert's current changelog and
> perhaps send along a revised one.

Yes, I believe, I have addressed all the feedback but I am open to alter
the wording of course. The biggest concern by Mina IIRC was that the
nr_reclaimed reporting has been a pre-existing problem. And I agree with
that. The thing is that this doesn't matter without node specification
because the memory gets reclaimed even if the reported value is over
accounted. With nodemask specification the value becomes bogus if no
demotion nodes are specified because no memory gets reclaimed
potentially while the success is still reported. Mina has tried to
address that but I am not convinced the fix is actually future proof.

This really requires more discussion.

-- 
Michal Hocko
SUSE Labs
