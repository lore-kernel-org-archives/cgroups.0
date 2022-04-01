From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH resend] memcg: introduce per-memcg reclaim interface
Date: Fri, 1 Apr 2022 17:51:41 -0400
Message-ID: <Ykdz7fiMFZeFltYy@cmpxchg.org>
References: <YkdrEG5FlL7Gq2Vi@cmpxchg.org>
 <243A0156-D26A-47C9-982A-C8B0CDD69DA2@linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=M11X+y56T/1F4fHNq5auQu00TlcNFHXDYbY/RsKteOE=;
        b=c99U3qkEZHhIEc7ajhsZpxJqU4l3cAi/NL5cixEEbUy7C6XoKYSnxPRQBhDUZTmgW3
         CdaWd0g1Bby07fp/jIyG1J3+95Fzgp/LQjARdfXbFBUkPZqyz7od9HefPpO8KeihaS2q
         AlvwqXjClIn82Ow/qtMIqMEuy5CmEAoKGT4g+DwYdedW4fXEssdeJNdj65X6UuIG3Gye
         uo1vCgIZbKpkm4ga/owAOGsj/OUuejccn7DdhxMou/c44twsSE4v7r5tzRnQ3jKJpheT
         vGlmiuBEeWfJ6E0nzDdCP0Neo+0FVxArhDDUs374m/wmtChQS97scg1pGgtlfoHSbhwi
         XX8Q==
Content-Disposition: inline
In-Reply-To: <243A0156-D26A-47C9-982A-C8B0CDD69DA2@linux.dev>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Yosry Ahmed <yosryahmed@google.com>, Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeelb@google.com>, Andrew Morton <akpm@linux-foundation.org>, David Rientjes <rientjes@google.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Linux-MM <linux-mm@kvack.org>, Jonathan Corbet <corbet@lwn.net>, Yu Zhao <yuzhao@google.com>, Dave Hansen <dave.hansen@linux.intel.com>, Wei Xu <weixugc@google.com>, Greg Thelen <gthelen@google.com>

On Fri, Apr 01, 2022 at 02:21:52PM -0700, Roman Gushchin wrote:
> > On Apr 1, 2022, at 2:13 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> > 
> > ﻿On Fri, Apr 01, 2022 at 11:39:30AM -0700, Roman Gushchin wrote:
> >> The interface you're proposing is not really extensible, so we'll likely need to
> >> introduce a new interface like memory.reclaim_ext very soon. Why not create
> >> an extensible API from scratch?
> >> 
> >> I'm looking at cgroup v2 documentation which describes various interface files
> >> formats and it seems like given the number of potential optional arguments
> >> the best option is nested keyed (please, refer to the Interface Files section).
> >> 
> >> E.g. the format can be:
> >> echo "1G type=file nodemask=1-2 timeout=30s" > memory.reclaim
> > 
> > Yeah, that syntax looks perfect.
> > 
> > But why do you think it's not extensible from the current patch? We
> > can add those arguments one by one as we agree on them, and return
> > -EINVAL if somebody passes an unknown parameter.
> > 
> > It seems to me the current proposal is forward-compatible that way
> > (with the current set of keyword pararms being the empty set :-))
> 
> It wasn’t obvious to me. We spoke about positional arguments and then it wasn’t clear how to add them in a backward-compatible way. The last thing we want is a bunch of memory.reclaim* interfaces :)
> 
> So yeah, let’s just describe it properly in the documentation, no code changes are needed.

Sounds good to me!
