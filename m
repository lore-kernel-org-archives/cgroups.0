From: Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [PATCH 2/4] selftests: memcg: Expect no low events in
 unprotected sibling
Date: Fri, 13 May 2022 11:54:16 -0700
Message-ID: <Yn6pWPodGPlz+D8G@carbon>
References: <20220512174452.tr34tuh4k5jm6qjs@dev0025.ash9.facebook.com>
 <20220513171811.730-1-mkoutny@suse.com>
 <20220513171811.730-3-mkoutny@suse.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1652468073;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WunYiDoozFlJnA00AKYmdrxduHSk2KR4s1IxWu01ZWc=;
        b=AkUGvY90Jenytj6a63yYuxluujbvSqSww8LlEQcAyTtBtRbjxIIxf66PW9Ho/kLc5jtzJt
        drtj2VBNrmFmOyBVoOFl14yrxxxMFOjvCF+s0/THk6f1LHXt5FgsMgN79qfdYRcsU380PR
        kUR0n2FgMwIWI+167bKGI6XfkBdyL0I=
Content-Disposition: inline
In-Reply-To: <20220513171811.730-3-mkoutny@suse.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: void@manifault.com, akpm@linux-foundation.org, cgroups@vger.kernel.org, hannes@cmpxchg.org, kernel-team@fb.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@kernel.org, shakeelb@google.com, tj@kernel.org, Richard Palethorpe <rpalethorpe@suse.de>

On Fri, May 13, 2022 at 07:18:09PM +0200, Michal Koutny wrote:
> This is effectively a revert of commit cdc69458a5f3 ("cgroup: account
> for memory_recursiveprot in test_memcg_low()"). The case test_memcg_low
> will fail with memory_recursiveprot until resolved in reclaim
> code.

Hm, what are our plans here? Are we going to fix it soon-ish, or there
is still no agreement on how to proceed?
