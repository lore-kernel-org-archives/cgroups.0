From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 2/2] memcg: punt high overage reclaim to
 return-to-userland path
Date: Tue, 15 Sep 2015 11:53:55 -0400
Message-ID: <20150915155355.GH2905@mtj.duckdns.org>
References: <20150913185940.GA25369@htj.duckdns.org>
 <20150913190008.GB25369@htj.duckdns.org>
 <20150915074724.GE2858@cmpxchg.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=y37CgHArKodrvk3Z22W1kZzbdexrn/DnPfPA1c5n4TU=;
        b=D6QGzis3IYwL/AR0dSBxTCV1z9jH7IXAAnxtjZihkIIX0jvmieLW0oXtMN+xCeke5z
         Ev/oDpLes2NaXCMUUsXc+F2v6bILLQkHMmAHL/VZQsH91D++AwQeraKgaDi+S4zoZBPq
         l0N/5S1vH93l1q4x+yXClDUVCUcPST6mWnA4E4jLv+yBOEWyhMRbXS1so7u41pXHLr9O
         FnuywPMtHLoJqs9pVAZCXgO4u5+S0mzoWD5Oo9RXUL73XbZlHekmmKKve2XJopmNIMlN
         2VIDwqfwtUZWJkl4uEn7sgM/s5tbHpZB4ZycaJm9xtCarRyDK1F1VRuIgoD5P9VBAnnf
         3RsA==
Content-Disposition: inline
In-Reply-To: <20150915074724.GE2858@cmpxchg.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: akpm@linux-foundation.org, mhocko@kernel.org, cgroups@vger.kernel.org, linux-mm@kvack.org, vdavydov@parallels.com, kernel-team@fb.com

Hello, Johannes.

On Tue, Sep 15, 2015 at 09:47:24AM +0200, Johannes Weiner wrote:
> Why can't we simply fail NOWAIT allocations when the high limit is
> breached? We do the same for the max limit.

Because that can lead to continued systematic failures of NOWAIT
allocations.  For that to work, we'll have to add async reclaimaing.

> As I see it, NOWAIT allocations are speculative attempts on available
> memory. We should be able to just fail them and have somebody that is
> allowed to reclaim try again, just like with the max limit.

Yes, but the assumption is that even back-to-back NOWAIT allocations
won't continue to fail indefinitely.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
