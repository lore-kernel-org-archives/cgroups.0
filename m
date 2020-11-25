From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] Docs/cgroup: update the cgroup-v1 docs
Date: Wed, 25 Nov 2020 07:58:28 -0500
Message-ID: <X75U9NjlD4RQq3z3@mtj.duckdns.org>
References: <20201102152116.GA186491@rlk>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jBninAlOvpYrGbFhaowzWy50Zpfu7elwWYRocqgCoUw=;
        b=RCltcKLUbOv0wiHSEWExJwFW+yO60P5UsIfxRcbymCTATMDcPJcEXr/KfMoSJPbDLz
         n7jLA1tZzTjoKOvnl8cl1kdXUSJH+fCvD/QMma/B76WYGPMw87AUriUpfyhNN2Bryl8L
         uDW7c+QxYiOV/CJLMr8rLlKxM4FcMxK2z6bBHlDRrjkCz05oUjMq9zh8SFRc1VkpeMyT
         xpw16qmlVImcO4t9m/lpP4RkAsNnCOT+sgTtxwHbOpzBgzroggmNI1t0yclCE3gUzNU6
         rxGXgn4Ruij2Ikjsizy16v/XpJb5wBXPLRMbUJ4UQSxJ1QwYinGYBrbkxGHXwiJEZlWu
         Flqg==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20201102152116.GA186491@rlk>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hui Su <sh_def@163.com>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, corbet@lwn.net, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Nov 02, 2020 at 11:21:16PM +0800, Hui Su wrote:
> Since 'commit 69d0206c793a ("cgroup: bring some sanity to
> naming around cg_cgroup_link")', 'cg_cgroup_link' has been
> changed to 'cgrp_cset_link'.
> so as its element 'cgrp_link_list' and 'cg_link_list'.
> 
> Since commit 47cfcd092245 ("cgroup: kill cgroup_[un]lock()"),
> cgroup_lock/cgroup_unlock have been killed.
> 
> So update the cgroup-v1 Docs.
> 
> Signed-off-by: Hui Su <sh_def@163.com>

Applied to cgroup/for-5.10-fixes.

Thanks.

-- 
tejun
