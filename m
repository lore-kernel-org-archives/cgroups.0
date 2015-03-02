From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] cgroup: call cgroup_subsys->bind on cgroup subsys
 initialization
Date: Mon, 2 Mar 2015 12:12:57 -0500
Message-ID: <20150302171257.GL17694@htj.duckdns.org>
References: <131af5f5ee0eec55d0f94a785db4be04baf01f51.1424356325.git.vdavydov@parallels.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=8HdT6bYHDLQoFZSuClvKJzU4e1xM8tvbLdwsg6uRmj8=;
        b=LO6IlSYocoxhJnp8CWOBliiEqsKlOFLduMYcjIvQiTDO8Ao2x/t42lnLOmrcA5zUM/
         NPmotpnzyR3sQ1m6fqWhHuyy+/br4jN4mpCMGR839W/FufGAIvGqb+xwmkPDRlq49xEV
         tsqbW1iWBAfjK99DItg9mwA4LeKZJYdlRAzTx6hz0Qi+VCEhmVLX+mKnbntNTZNXleGp
         O3djyQ2tVvGzIIqIq4f8Zbuuc4mxhrWyu9Lk9AjW8aPrhvd1VbMKCxl5YgiYvFJHD8aJ
         F2kcXbgyk2GxTdb/eHlnawHYgXeOdt/I6CMpu7W/h6Vek3dlTn0YQPpvbhWKqG6xQRWJ
         navA==
Content-Disposition: inline
In-Reply-To: <131af5f5ee0eec55d0f94a785db4be04baf01f51.1424356325.git.vdavydov@parallels.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Feb 19, 2015 at 05:34:46PM +0300, Vladimir Davydov wrote:
> Currently, we call cgroup_subsys->bind only on unmount, remount, and
> when creating a new root on mount. Since the default hierarchy root is
> created in cgroup_init, we will not call cgroup_subsys->bind if the
> default hierarchy is freshly mounted. As a result, some controllers will
> behave incorrectly (most notably, the "memory" controller will not
> enable hierarchy support). Fix this by calling cgroup_subsys->bind right
> after initializing a cgroup subsystem.
> 
> Signed-off-by: Vladimir Davydov <vdavydov@parallels.com>

Applied to cgroup/for-4.0-fixes.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
