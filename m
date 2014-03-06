From: Tejun Heo <tj@kernel.org>
Subject: Re: [patch 09/11] mm, page_alloc: allow system oom handlers to use
 memory reserves
Date: Thu, 6 Mar 2014 16:13:37 -0500
Message-ID: <20140306211337.GC17902@htj.dyndns.org>
References: <alpine.DEB.2.02.1403041952170.8067@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1403041956510.8067@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=qxKHP7vdJmpOyCfhdGE1qAzlNblc/2GIldACVAUyJEw=;
        b=qiPvCOE+RVGSZreZt2H2teSeMvcc47ZbG2jqefpBdwH3R2iuOtbBqD7TWTgGwQ1bN2
         B878fSxRRTSTVGpavlfqmoubXnI1bq5/FOMn1pTpm2LkdrOLOvDPDM0+QpUYZzpPe9iH
         baGAmcnKsDEc1kk4/lhOdh5RVpLyE8NLYiQCm8G//aU2NPhPI0UN7e5H5kjvGBnP5wRl
         3Xw/nEkevcNxkrNq7yF5vaqh2nTKKO6//kmt3uzpu9qox9kv3AYrBDM25goUQPALrVPm
         +WCdFVhu2SNmNuICfj2XSADYq+vtfM2xMexz90M5LyXqFSDs/qe+R32OuTDGUCT9ZG2L
         4D2A==
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1403041956510.8067@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Christoph Lameter <cl@linux-foundation.org>, Pekka Enberg <penberg@kernel.org>, Mel Gorman <mgorman@suse.de>, Oleg Nesterov <oleg@redhat.com>, Rik van Riel <riel@redhat.com>, Jianguo Wu <wujianguo@huawei.com>, Tim Hockin <thockin@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org

On Tue, Mar 04, 2014 at 07:59:35PM -0800, David Rientjes wrote:
> The root memcg allows unlimited memory charging, so no memory may be
> reserved for userspace oom handlers that are responsible for dealing
> with system oom conditions.
> 
> Instead, this memory must come from per-zone memory reserves.  This
> allows the memory allocation to succeed, and the memcg charge will
> naturally succeed afterwards.
> 
> This patch introduces per-zone oom watermarks that aren't really
> watermarks in the traditional sense.  The oom watermark is the root
> memcg's oom reserve proportional to the size of the zone.  When a page
> allocation is done, the effective watermark is
> 
> 	[min/low/high watermark] - [oom watermark]
> 
> For the [min watermark] case, this is effectively the oom reserve.
> However, it also adjusts the low and high watermark accordingly so
> memory is actually only allocated from min reserves when appropriate.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>

Until consensus on the whole approach can be reached,

 Nacked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
