From: Hui Su <sh_def@163.com>
Subject: Re: [PATCH] mm: fix some comments in page_alloc.c and mempolicy.c
Date: Thu, 8 Oct 2020 20:33:33 +0800
Message-ID: <20201008123333.GA7424@rlk>
References: <20200925160650.GA42847@rlk>
 <10c1b339-b352-7643-7adf-d82c941c7d2c@redhat.com>
 <11c9c699aaa873847b4d14dfa5e2435b94c08569.camel@perches.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Date:From:Subject:Message-ID:MIME-Version; bh=7snQg
        UUJSF5tKYLwhoTXmX+RnS13E0l5FHg91pRGEt8=; b=TBwxSNoIp21YXiaIJENv0
        MP5W7XPDKS3g7j6aUCxBY1VvRFNFo2nLYIeyER1o0tOtZWOgC2MNeVYZjMdU2xy0
        I6jCGPN9DpkmWlG0VmB9pBcz9nnbhMGZd1gYdCCqsJc/xWCClQxXr8XdmKluD5zr
        JsAcTktXCGtnTkD2ZLomW0=
Content-Disposition: inline
In-Reply-To: <11c9c699aaa873847b4d14dfa5e2435b94c08569.camel@perches.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Joe Perches <joe@perches.com>
Cc: akpm@linux-foundation.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On Thu, Oct 01, 2020 at 09:17:29AM -0700, Joe Perches wrote:
> On Thu, 2020-10-01 at 14:27 +0200, David Hildenbrand wrote:
> > On 25.09.20 18:06, Hui Su wrote:
> > > 1. the cpuset.c has been moved from kernel/cpuset.c to
> > > kernel/cgroup/cpuset.c long time ago, but the comment is stale,
> > > so we update it.
> []
> > > diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
> []
> > > @@ -1,5 +1,5 @@
> > >  /*
> > > - *  kernel/cpuset.c
> > > + *  kernel/cgroup/cpuset.c
> 
> It's probably better to remove this altogether instead.

Please ignore this change, thanks.

