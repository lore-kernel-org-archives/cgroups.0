From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] mm: vmscan: memcontrol: remove
 mem_cgroup_select_victim_node()
Date: Wed, 30 Oct 2019 14:06:58 -0400
Message-ID: <20191030180658.GA46103@cmpxchg.org>
References: <20191029234753.224143-1-shakeelb@google.com>
 <20191030174455.GA45135@cmpxchg.org>
 <20191030175302.GM31513@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=IAmQqO4bjeMP8pqof8/ZbpdZpz2QFcPnCQfgAz9Gnck=;
        b=mtx4zkyH5XIQgQbFqvvhGqBLpk59n9jvsGvwkO1VfmeSBi1fZTkm2jd/OJyjYb00UW
         s0eLLTypHsbreDef1db4Dqq/lLcoO7Y1Ijt4HNbZ+EeUGjZagKB9q7s2x6NaipcKhgx9
         4WhVOz5bRE5CSJI+LSDVZQr8gKMXGq4mhuGp3lThS3s7dZss+t7ixyPJXf19hzBOb0YI
         +ygYN0b1im2IVF2DbaB+QnHeBvBIZR00xvvEzU3MYvlmxAL9WkJsrGX3Cyc2l6CSlvE8
         qU59DasqpWmvC1rofTblT3lxM1r1aBj7PmMqmcv29+qRc0d/PeGv1uLHDUQB8T6MRMGg
         1M8g==
Content-Disposition: inline
In-Reply-To: <20191030175302.GM31513@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Shakeel Butt <shakeelb@google.com>, Greg Thelen <gthelen@google.com>, Roman Gushchin <guro@fb.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, syzbot+13f93c99c06988391efe@syzkaller.appspotmail.com

On Wed, Oct 30, 2019 at 06:53:02PM +0100, Michal Hocko wrote:
> On Wed 30-10-19 13:44:55, Johannes Weiner wrote:
> > Also, I think we should use sc.gfp_mask & ~__GFP_THISNODE, so that
> > allocations with a physical node preference still do node-agnostic
> > reclaim for the purpose of cgroup accounting.
> 
> Do not we exclude that by GFP_RECLAIM_MASK already?

My bad, you're right. Scratch that, then. Thanks.
