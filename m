From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup: remove extra cgroup_migrate_finish() call
Date: Thu, 4 Apr 2019 13:41:06 -0700
Message-ID: <20190404204106.GC1975820@devbig004.ftw2.facebook.com>
References: <20190403230354.117915-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=YWVT86VODnemhQ8halJBxHEXUVOGSbGYGR97dsLgYLM=;
        b=CNxkjEf34OBeZL5d5pIjETWoXWcwekGu131qlrgHMN4kX3n0rJMk0BOAo84qWK2ApY
         3eeSqP/dPD8jk+Mn02zR/pNNhHFD+NF5DEnSRWVFH8UfeacLbkxEyGzkyXcPVv4pRrNv
         uCOjkbmuVXbBTTQLbc/bZS/69uiXq4wTwEML9ka/JlCEV6Pl06CwurEw6iu4Qg3aWU/e
         pHxjLW46mr01JR2nv8IOY0H2ZuFlhuP42umT3XCQsEMJRxyFRCfOYTHUQ9peYKNG66RG
         gF2k+6feJr18+76DcJsEd7XGOYw1WJG364YxMww1i6HmJfsOjrRHoTBW+Vz9z8PvEyCp
         0GFg==
Content-Disposition: inline
In-Reply-To: <20190403230354.117915-1-shakeelb@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, Apr 03, 2019 at 04:03:54PM -0700, Shakeel Butt wrote:
> The callers of cgroup_migrate_prepare_dst() correctly call
> cgroup_migrate_finish() for success and failure cases both. No need to
> call it in cgroup_migrate_prepare_dst() in failure case.
> 
> Signed-off-by: Shakeel Butt <shakeelb@google.com>

Applied to cgroup/for-5.2.

Thanks, Shakeel.

-- 
tejun
