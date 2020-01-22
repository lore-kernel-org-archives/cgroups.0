From: David Rientjes <rientjes@google.com>
Subject: Re: [Patch v4] mm: thp: remove the defer list related code since
 this will not happen
Date: Wed, 22 Jan 2020 15:39:16 -0800 (PST)
Message-ID: <alpine.DEB.2.21.2001221534510.159514@chino.kir.corp.google.com>
References: <20200117233836.3434-1-richardw.yang@linux.intel.com> <20200118145421.0ab96d5d9bea21a3339d52fe@linux-foundation.org> <alpine.DEB.2.21.2001181525250.27051@chino.kir.corp.google.com> <20200120072237.GA18451@dhcp22.suse.cz>
 <alpine.DEB.2.21.2001201307520.259466@chino.kir.corp.google.com> <20200120212726.GB29276@dhcp22.suse.cz> <alpine.DEB.2.21.2001211500250.157547@chino.kir.corp.google.com> <20200122081406.GO29276@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=YNvajkPj2BUn62eVSIlq+7puNDrKQpZK5MXXRGczBsE=;
        b=WZJFiO4NDHzrXRTXfEk15plzqfBCf/XF0WnvEGStfqkfZ8Fj/EQr8PPvQ1mLAYqSCP
         v+tE914RPXI/94X6Y2Ek89gj39gHYxA1NTi3sKa6IgtxsqR7fEYjau6jIW00dazgJtqm
         NZx1MnFTfqkmUSUZZeskkvhavOEJCNt5fV+mYrZt5vPpBAD/vBNFA/RgfJYLX8D9PJaA
         G3KnjIHOycLCS+ldcv/ah1Uk5FmX3GkTjliBdERDyczvEhEsSyWkRdr9Dv0Y86tQcqZ1
         /LhnvAT2PoZqjNrkdXKx4QNEIv+ukhBvwK0989ik3JobGkgCQ3qE+FM9Wjg3YeOp+dJQ
         Gk/Q==
In-Reply-To: <20200122081406.GO29276@dhcp22.suse.cz>
Sender: stable-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Wei Yang <richardw.yang@linux.intel.com>, hannes@cmpxchg.org, vdavydov.dev@gmail.com, ktkhai@virtuozzo.com, kirill.shutemov@linux.intel.com, yang.shi@linux.alibaba.com, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, alexander.duyck@gmail.com, stable@vger.kernel.org

On Wed, 22 Jan 2020, Michal Hocko wrote:

> > The current code in 5.4 from commit 87eaceb3faa59 places any migrated 
> > compound page onto the deferred split queue of the destination memcg 
> > regardless of whether it has a mapping pmd 
> > (list_empty(page_deferred_list()) was already false) or it does not have a 
> > mapping pmd (but is now on the wrong queue).  For the latter, 
> > can_split_huge_page() can help for the actual split but not for the 
> > removal of the page that is now erroneously on the queue.
> 
> Does that mean that those fully mapped THPs are not going to be split?
> 

It believe it should but deferred_split_scan() also won't take it off the 
wrong split queue so it will remain there and any other checks for 
page_deferred_list(page) will succeed.

> > For the former, 
> > memcg reclaim would not see the pages that it should split under memcg 
> > pressure so we'll see the same memcg oom conditions we saw before the 
> > deferred split shrinker became SHRINKER_MEMCG_AWARE: unnecessary ooms.
> 
> OK, this is yet another user visibile effect and it would be better to
> mention it explicitly in the changelog. 
> 

Ok, feel free to add to the last paragraph:

Memcg reclaim would not see the compound pages that it should split under 
memcg pressure so we'll otherwise see the same memcg oom conditions we saw 
before the deferred split shrinker became SHRINKER_MEMCG_AWARE: 
unnecessary ooms.
