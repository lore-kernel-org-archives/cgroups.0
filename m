From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 2/8] cgroup: implement cgroup_from_id()
Date: Mon, 8 Apr 2013 08:48:47 -0700
Message-ID: <20130408154847.GE3021@htj.dyndns.org>
References: <51627DA9.7020507@huawei.com>
 <51627DEB.4090104@huawei.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=VBKEeFFuNLwpWAxTOA6LvT3J+BXfc/opvbU3psnWDAU=;
        b=zhWPieTKRw7WZ2BPvMtE/bZQUP/eJJwggrYgkLiqgwXyAJRjjIsXGj8j1PFMz7ZTDi
         QvVRmd4aN/enmf74GHA3hAFOuRECT6+6P1YE568UTEER7NEDr3TDbBklxOuMgg1Jsjtz
         RQ//SWYN+FcDSASUMx1HPFhRqF9s1koDHM/ERQQJ8GIwxkTt/uXH9nUiHK3t0W+N7pUX
         +qQEe6ZcwB6gfxj/vBBCMHqLv7xYx3DhB2MbfM/8FOTp4XmW/2qOrY/AB106L7AkcBNQ
         BdA09RYg0loKcsckK2bq9eHgMZW4M1vViJO6GT8ygAqjYwXD3di1h87C4KIuyXdNnpbv
         xkYg==
Content-Disposition: inline
In-Reply-To: <51627DEB.4090104@huawei.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Glauber Costa <glommer@parallels.com>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>, LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>, linux-mm@kvack.org

Oops, one more thing.

On Mon, Apr 08, 2013 at 04:20:59PM +0800, Li Zefan wrote:
> -	cgrp->id = ida_simple_get(&root->cgroup_ida, 1, 0, GFP_KERNEL);
> +	cgrp->id = idr_alloc(&root->cgroup_idr, cgrp, 1, 0, GFP_KERNEL);

This will allow lookups to return half-initialized cgroup, which
shouldn't happen.  Either idr_alloc() should be moved to after
initialization of other fields are finished, or it should be called
with NULL @ptr with idr_replace() added at the end to install @cgrp.

Similarly, the removal path should guarantee that the object is
removed from idr *before* its grace period starts.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
