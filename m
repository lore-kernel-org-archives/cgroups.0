From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 4/6] cgroups: forbid pre_destroy callback to fail
Date: Thu, 18 Oct 2012 15:41:48 -0700
Message-ID: <20121018224148.GR13370@google.com>
References: <1350480648-10905-1-git-send-email-mhocko@suse.cz>
 <1350480648-10905-5-git-send-email-mhocko@suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=D0oCIRKDf2hwW94fy+BaDQlE8fblehxGUVF65yflQzw=;
        b=rA1ln5NN+M6FOmdcj6btEW3jemNcm+Cu3TU0vINBzuTl8oqwkQkBdrNNgw6sL7zcIi
         lF39IrXhkhrvwG3dQKh7pUX21FDOLtlUDfCKMsrNFLa/+nc2uscvbLLDV2YtH9EFA43b
         7IqQVz1KYu0bC9XwQa0f7yThHmZyOf7aF/D/f9xN6HQHSUXkxOWHzL4auK8StmYRqN8s
         CSJWqdgmFi7NeO+281Tkoc3KBzTcy+6avjCu4Nd/kNjp0I9dN1ebDESwRkkuvxeu97xE
         DZ7ZHbdKPrV7c60326iPLTlmRYFrlN/5cjdoj9wG4lHgBStBz6K+iX44rFbSXFEy8KqE
         4MAA==
Content-Disposition: inline
In-Reply-To: <1350480648-10905-5-git-send-email-mhocko@suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>, Balbir Singh <bsingharora@gmail.com>

Hello, Michal.

On Wed, Oct 17, 2012 at 03:30:46PM +0200, Michal Hocko wrote:
> Now that mem_cgroup_pre_destroy callback doesn't fail finally we can
> safely move on and forbit all the callbacks to fail. The last missing
> piece is moving cgroup_call_pre_destroy after cgroup_clear_css_refs so
> that css_tryget fails so no new charges for the memcg can happen.
> The callbacks are also called from within cgroup_lock to guarantee that
> no new tasks show up. We could theoretically call them outside of the
> lock but then we have to move after CGRP_REMOVED flag is set.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>

So, the plan is to do something like the following once memcg is
ready.

  http://thread.gmane.org/gmane.linux.kernel.containers/22559/focus=75251

Note that the patch is broken in a couple places but it does show the
general direction.  I'd prefer if patch #3 simply makes pre_destroy()
return 0 and drop __DEPRECATED_clear_css_refs from mem_cgroup_subsys.
Then, I can pull the branch in and drop all the unnecessary cruft.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
