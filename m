From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v6 0/5] memcg, cgroup: kill css id
Date: Mon, 23 Sep 2013 21:30:58 -0400
Message-ID: <20130924013058.GB3482@htj.dyndns.org>
References: <524001F8.6070205@huawei.com>
 <20130923130816.GH30946@htj.dyndns.org>
 <20130923131215.GI30946@htj.dyndns.org>
 <5240DD83.1070509@huawei.com>
 <20130923175247.ea5156de.akpm@linux-foundation.org>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=hXzfpEwClf8gLwUzQt3m16Lrb9NwjU9pifRxbbsYL1Q=;
        b=s/MFA8oX7dr1y+TAKKaMm2S8nadY/8on6Ct99+Bt0A5rVZUB4B0jnUac4kfkmmjwai
         IJNsOBWBO7jGBZFsKYddIqQ4Kb5mkvKKxxQMIIuoTKz4rGdTgOhNnGx+kBPsuuQhcoeS
         0h9AjsY7riC3eCThgHHO/STyy4Y8dTqSVmK4XuU49eMcMTxwyRsGZekMcCJFQea+b60O
         c6/ChjdhtMOus7YWgIto2MqC+JVFmCglzr6KHwUe8+wuCNhQIYP8/5EshffZTcMvv03M
         K99ggUy9schZoE9OD+41CRGQfgqUrmQ9UwXr7e2ZQkXJxAdzTpVX4LQawz5V98YEpfhC
         EPfA==
Content-Disposition: inline
In-Reply-To: <20130923175247.ea5156de.akpm@linux-foundation.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Li Zefan <lizefan@huawei.com>, Michal Hocko <mhocko@suse.cz>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>, LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>

Hello, Andrew.

On Mon, Sep 23, 2013 at 05:52:47PM -0700, Andrew Morton wrote:
> > I would love to see this patchset go through cgroup tree. The changes to
> > memcg is quite small,
> 
> It seems logical to put this in the cgroup tree as that's where most of
> the impact occurs.

Cool, applying the changes to cgroup/for-3.13.

> > and as -mm tree is based on -next it won't cause
> > future conflicts.
> 
> That's no longer the case - I'm staging -mm patches ahead of linux-next
> now.  Except in cases where that's impractical, such as the 3.12 memcg
> changes which were pretty heavily impacted by cgroups tree changes.

Please note that cgroup is likely to continue to go through a lot of
changes for the foreseeable future and memcg is likely to be affected
heavily.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
