From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 0/5] memcg/kmem: switch to white list policy
Date: Mon, 9 Nov 2015 13:54:01 -0500
Message-ID: <20151109185401.GB28507@mtj.duckdns.org>
References: <cover.1446924358.git.vdavydov@virtuozzo.com>
 <20151109140832.GE8916@dhcp22.suse.cz>
 <20151109182840.GJ31308@esperanza>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=QcEgon/LlvclhSdSsYo90FZs2Be/2wUSpfO45nFQyXc=;
        b=Hdxgup4/WXyh8weJiHkbItUEUkfJ91h4kJL5P/+guamtz1VBufY54DzQ25+pp9cEHS
         Y9g9diif0rVW2Mt2F2ujZFx52wkrWR1wd2fqDS2k2dD0HpoVexuOjl3rEx45m6/QNYGA
         k+y6LTKH1OprlSFQObGX8mdTz3CtETi4Iucf2Ske25Lmalhc35AqgzjeQRlM20wJPHS3
         D6reAzUGU6ZplW+0R0pO+tr9moAWXVwGaL68n/cYpndr/VlONYWkCIpcJNASRC7fNqZG
         QbfqDZziXCZ+unlRSxLUXvYPqeIm7SvihM9NMGAjSqx7frcunKKAn2IfpaXXWovEbWg2
         S0YQ==
Content-Disposition: inline
In-Reply-To: <20151109182840.GJ31308@esperanza>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Michal Hocko <mhocko@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Greg Thelen <gthelen@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

Hello, Vladmir.

On Mon, Nov 09, 2015 at 09:28:40PM +0300, Vladimir Davydov wrote:
> > I am _all_ for this semantic I am just not sure what to do with the
> > legacy kmem controller. Can we change its semantic? If we cannot do that
> 
> I think we can. If somebody reports a "bug" caused by this change, i.e.
> basically notices that something that used to be accounted is not any
> longer, it will be trivial to fix by adding __GFP_ACCOUNT where
> appropriate. If it is not, e.g. if accounting of objects of a particular
> type leads to intense false-sharing, we would end up disabling
> accounting for it anyway.

I agree too, if anything is meaningfully broken by the flip, it just
indicates that the whitelist needs to be expanded; however, I wonder
whether this would be done better at slab level rather than per
allocation site.

A class of objects which can consume noticeable amount of memory which
can be attributed to userland is likely to be on its own slab already
or separating it out to its own slab is likely to be a good idea.
Marking those slabs as kmemcg accounted seems better suited to the
semantics - it's always about classes of objects - and less
error-prone than marking individual allocation sites.

This also reduces the number of slabs to worry about and more
importantly makes it clear which slabs need to be replicated for
kmemcg accounting from the beginning and the slab part of
implementation can be far simpler / more static.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
