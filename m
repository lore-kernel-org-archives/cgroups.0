From: Tejun Heo <tj@kernel.org>
Subject: Re: [patch 00/11] userspace out of memory handling
Date: Thu, 6 Mar 2014 16:33:24 -0500
Message-ID: <20140306213324.GG17902@htj.dyndns.org>
References: <alpine.DEB.2.02.1403041952170.8067@chino.kir.corp.google.com>
 <20140306204923.GF14033@htj.dyndns.org>
 <alpine.DEB.2.02.1403061254240.25499@chino.kir.corp.google.com>
 <20140306205911.GG14033@htj.dyndns.org>
 <alpine.DEB.2.02.1403061301020.25499@chino.kir.corp.google.com>
 <20140306211136.GA17902@htj.dyndns.org>
 <alpine.DEB.2.02.1403061312020.25499@chino.kir.corp.google.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=V8DkRyp/1RjrO68iqOvtl/kSU+5GbU1Id0gBVym5PGk=;
        b=x/jZlaZPFK/9Zb/5I3CGR1gGFcjhUlkPmEDiWBlfKIhqDfpbHhf3u1m01rgKR3agPu
         6aBDub7jjHDhj5IQxoK3wF8KUXIq3qF/kL7D3pLQwAsE9g09rUnGZO0l7bal7jYxzSHy
         wbgTnduYmzXSJrYnQ/b0qtxR02/zomEnrEkUgDNBSSrCXO+svf+ZyCExWxnxxcWDMtQ9
         /mbx+EVzZKff+ruVdkauYlay7L3B7RKrUPLQF6/K2eYe7nueqadSrCmNASUZpwfpojAo
         XfJy6tajg4+QovceFKy5B2YmVeQ+Z6Ms9bg1gnR8WsKxiOxNNgWnH5+PkaelEAzHKHfG
         4y1A==
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1403061312020.25499@chino.kir.corp.google.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Christoph Lameter <cl@linux-foundation.org>, Pekka Enberg <penberg@kernel.org>, Mel Gorman <mgorman@suse.de>, Oleg Nesterov <oleg@redhat.com>, Rik van Riel <riel@redhat.com>, Jianguo Wu <wujianguo@huawei.com>, Tim Hockin <thockin@google.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org

A bit of addition.

On Thu, Mar 06, 2014 at 01:23:57PM -0800, David Rientjes wrote:
> This patchset provides a solution to a real-world problem that is not 
> solved with any other patchset.  I expect it to be reviewed as any other 
> patchset, it's not an "RFC" from my perspective: it's a proposal for 
> inclusion.  Don't worry, Andrew is not going to apply anything 
> accidentally.

I can't force it down your throat but I feel somewhat uneasy about how
this was posted without any reference to the previous discussion as if
this were just now being proposed especially as the said discussion
wasn't particularly favorable to this approach.  Prefixing RFC or at
least pointing back to the original discussion seems like the
courteous thing to do.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
