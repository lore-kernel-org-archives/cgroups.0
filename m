From: Tejun Heo <tj@kernel.org>
Subject: Re: [patch 07/11] mm, memcg: allow processes handling oom
 notifications to access reserves
Date: Thu, 6 Mar 2014 16:12:46 -0500
Message-ID: <20140306211246.GB17902@htj.dyndns.org>
References: <alpine.DEB.2.02.1403041952170.8067@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1403041956040.8067@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=fpuG5UBCioevyVi4YTA8oAo3Ij6Z9CAs6/ndDRV1HiA=;
        b=LoVzKcsCd9ZqjHzBMbwQJLdetzIaqaGr4MtIy/sOL9+W+h4aLs4mH/TUHBeGg2K0PT
         MyKnG7GonOo+uamxVBZCZy/humTZ2oVDNBga2rvg6bpbxrEkroGfkOuZ3FrFOko2kATL
         +pkxn9aFcvW7Ou11HEwUwCLLLFckZfvwbIQ12VwgUX4vxmsk6kEf97jv0VIE4SWqs25P
         A92a/e6rDrU7lhDjWwbVneyF7v+aHoBncUNa/CcnrROqXqtIoK+jEsUWG6w6PLWvAt77
         RGTKfDdJUVZ6F1o0/e29x6K1sHzvyllhHLP79QaLASNdBpREb/QSr4azxgmcHn7CH2b2
         bkdA==
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1403041956040.8067@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Christoph Lameter <cl@linux-foundation.org>, Pekka Enberg <penberg@kernel.org>, Mel Gorman <mgorman@suse.de>, Oleg Nesterov <oleg@redhat.com>, Rik van Riel <riel@redhat.com>, Jianguo Wu <wujianguo@huawei.com>, Tim Hockin <thockin@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org

On Tue, Mar 04, 2014 at 07:59:29PM -0800, David Rientjes wrote:
> Now that a per-process flag is available, define it for processes that
> handle userspace oom notifications.  This is an optimization to avoid
> mantaining a list of such processes attached to a memcg at any given time
> and iterating it at charge time.
> 
> This flag gets set whenever a process has registered for an oom
> notification and is cleared whenever it unregisters.
> 
> When memcg reclaim has failed to free any memory, it is necessary for
> userspace oom handlers to be able to dip into reserves to pagefault text,
> allocate kernel memory to read the "tasks" file, allocate heap, etc.
> 
> System oom conditions are not addressed at this time, but the same per-
> process flag can be used in the page allocator to determine if access
> should be given to userspace oom handlers to per-zone memory reserves at
> a later time once there is consensus.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>

ntil consensus on the whole approach can be reached,

 Nacked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
