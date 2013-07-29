From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 2/8] cgroup: document how cgroup IDs are assigned
Date: Mon, 29 Jul 2013 14:26:32 -0400
Message-ID: <20130729182632.GC26076@mtj.dyndns.org>
References: <51F614B2.6010503@huawei.com>
 <51F614D4.6000703@huawei.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=xBEonJoJAN+6nrVXMV1rh59gkGp1Hb43VVMkg6Sv1q4=;
        b=zgqFh0HXcqyeM2vpbGhDK3z/iIEB8+GRgVq7QGtGZNfOzCg2zB+4jGODMz1w+QAJOm
         BSfPjz3KTjAMY9xU0E42BvoxBcoApLefIXqgIC0iczxiSLlxRngRxdK3N1mZXe/584KH
         Wuxk75OgRdM3XG0/Kpz2vHd6VzMXo15+uzeWHbIslUplxbpSMM6L/Fs/S7VRJtRDXGdh
         eKAJAgR2qUE0IXqzvCBbsm09Z6/F3pvDGJXMdZOwnt5qO0LsyzeeacMCKOKWUK0/rNEC
         AlD0OewonjZpMM5BVOVtdLYZRexDB8EzYdmqfDVpDHk00LMnGaLavAJldLGUdgf8bw66
         mtJA==
Content-Disposition: inline
In-Reply-To: <51F614D4.6000703@huawei.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Glauber Costa <glommer@parallels.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, linux-mm@kvack.org

On Mon, Jul 29, 2013 at 03:08:04PM +0800, Li Zefan wrote:
> As cgroup id has been used in netprio cgroup and will be used in memcg,
> it's important to make it clear how a cgroup id is allocated.
> 
> For example, in netprio cgroup, the id is used as index of anarray.
> 
> Signed-off-by: Li Zefan <lizefan@huwei.com>
> Reviewed-by: Michal Hocko <mhocko@suse.cz>

We can merge this into the first patch?

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
