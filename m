From: Chris Down <chris@chrisdown.name>
Subject: Re: [PATCH v3 0/4] Support user xattrs in cgroupfs
Date: Fri, 13 Mar 2020 01:00:57 +0000
Message-ID: <20200313010057.GB24320@chrisdown.name>
References: <20200312200317.31736-1-dxu@dxuuu.xyz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2U6tAzdLF1x4vnU8NvQtzG93LtZx8bGoRnFmPfqzr44=;
        b=fbJPeQvIkVYKb9c1z7XgxRxx4/zfKwEcy6ajBhwUYxVUorFsSnvoInvgs6/KSmWLvz
         LdXzEIc4+V3XoENOHwR/e8OLYs4uvwpyncqQCDonDb+Oeak8teYTgUW57sGK8xMgpEBK
         P5bPncy48nsYk/HrlB2rCtcGyUogOalJxiMwQ=
Content-Disposition: inline
In-Reply-To: <20200312200317.31736-1-dxu@dxuuu.xyz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Daniel Xu <dxu@dxuuu.xyz>
Cc: cgroups@vger.kernel.org, tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, viro@zeniv.linux.org.uk, shakeelb@google.com, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, kernel-team@fb.com

Daniel Xu writes:
>User extended attributes are useful as metadata storage for kernfs
>consumers like cgroups. Especially in the case of cgroups, it is useful
>to have a central metadata store that multiple processes/services can
>use to coordinate actions.
>
>A concrete example is for userspace out of memory killers. We want to
>let delegated cgroup subtree owners (running as non-root) to be able to
>say "please avoid killing this cgroup". This is especially important for
>desktop linux as delegated subtrees owners are less likely to run as
>root.
>
>The first two commits set up some stuff for the third commit which
>intro introduce a new flag, KERNFS_ROOT_SUPPORT_USER_XATTR,
>that lets kernfs consumers enable user xattr support. The final commit
>turns on user xattr support for cgroupfs.

The whole series looks good to me, thanks.

For the whole series:

Acked-by: Chris Down <chris@chrisdown.name>
