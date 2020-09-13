From: Chris Down <chris@chrisdown.name>
Subject: Re: [PATCH v3] mm: memcontrol: Add the missing numa_stat interface
 for cgroup v2
Date: Sun, 13 Sep 2020 18:09:13 +0100
Message-ID: <20200913170913.GB2239582@chrisdown.name>
References: <20200913070010.44053-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=NHSyG/ZtG9S0n0YZM7cSzTFQ+FkKUxE2tX0ghcDmfZ0=;
        b=kXjiBqYL6OViT3ewAjh9aCHJsTXRTaC9OZ01erzxJzAY0iuwHOa6mBt/6RPf+22jJd
         g+UbRQyTmu2YclZLlFGpfI5q/gvpZ+Fu5Z73vb11F0o9mGNsGXQvXPXxKQod18U4WBU1
         HxqWnKX+7mSCl2lhKU7uexA73WmMS93491Q9o=
Content-Disposition: inline
In-Reply-To: <20200913070010.44053-1-songmuchun@bytedance.com>
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun@bytedance.com>
Cc: tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, corbet@lwn.net, mhocko@kernel.org, vdavydov.dev@gmail.com, akpm@linux-foundation.org, shakeelb@google.com, guro@fb.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel test robot <lkp@intel.com>

Muchun Song writes:
>In the cgroup v1, we have a numa_stat interface. This is useful for
>providing visibility into the numa locality information within an
>memcg since the pages are allowed to be allocated from any physical
>node. One of the use cases is evaluating application performance by
>combining this information with the application's CPU allocation.
>But the cgroup v2 does not. So this patch adds the missing information.
>
>Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>Suggested-by: Shakeel Butt <shakeelb@google.com>
>Reported-by: kernel test robot <lkp@intel.com>

This is a feature patch, why does this have LKP's Reported-by?
