From: Tejun Heo <tj@kernel.org>
Subject: Re: [patch 11/11] mm, memcg: allow system oom killer to be disabled
Date: Thu, 6 Mar 2014 16:15:29 -0500
Message-ID: <20140306211529.GE17902@htj.dyndns.org>
References: <alpine.DEB.2.02.1403041952170.8067@chino.kir.corp.google.com>
 <alpine.DEB.2.02.1403041957340.8067@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=LsXpm+lbdO9MFSdlCWqKuGhiTn6Q8gWfjOO5Dw56s8k=;
        b=ZMbd2fA/QUni1QhxHPZtKLfCDIEeoN144/a0W9vvWI+M7aY+KAtINBgsy1ekHUERBK
         i8Zn/FPnsTnGCI7UToaWsjvATpoWutCg10jDP3c8MoLH+37FLkhO8NZcXWpPok05TjNv
         gzjND3woD/l4GY+qSNtYDVHzbG2z6+0ZDnASZxzOcjMIsYcE+1bqPQuK1SjEVFJI7gxs
         6d/oERPWksTL1VTRsDZrmFXepS1aGL/WdKCucGevdULMtUphhTiL9uWRyGR/I/jtB0+e
         lRwFW+mtkQxMQH+FgQG8jFVB/fpwY+Pa8tNPB1HR+yhkNthGLkeq5jtbuKmqkNNEEGjV
         G0jQ==
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1403041957340.8067@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Christoph Lameter <cl@linux-foundation.org>, Pekka Enberg <penberg@kernel.org>, Mel Gorman <mgorman@suse.de>, Oleg Nesterov <oleg@redhat.com>, Rik van Riel <riel@redhat.com>, Jianguo Wu <wujianguo@huawei.com>, Tim Hockin <thockin@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org

On Tue, Mar 04, 2014 at 07:59:46PM -0800, David Rientjes wrote:
> Now that system oom conditions can properly be handled from userspace,
> allow the oom killer to be disabled.  Otherwise, the kernel will
> immediately kill a process and memory will be freed.  The userspace oom
> handler may have a different policy.
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
