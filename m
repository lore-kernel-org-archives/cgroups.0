From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC PATCH 0/2] support cgroup pool in v1
Date: Wed, 8 Sep 2021 06:35:11 -1000
Message-ID: <YTjmP0EGEWGYhroM@slm.duckdns.org>
References: <cover.1631102579.git.escape@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OcymaPtn2yQq8RdWF6BFH20bMyFtxjOxZMFIB1OMhb4=;
        b=cEO/E0Ry4JDv4NAoZWlVwP4k205lyAd9w0Jc/1E0rCsSXw3qxpjooAnEo5b0LiZ/xh
         1cmfhhXIkymzyYy74CxqfFRkcGkxEeqgtwbcmUmMOkNEgfNyZNECXRyYhdC3TWU3C1wr
         RYo72dsDHQjeUlpJ7ZxqIgnRC0i4WwnJja8UvQ7EAgxQKkXrN4eymCpiHcJPG6g0QGA8
         1fdL5abIwfzLj6FxUwYFP5fiwW7rZUSkCJFGZOaOTXRaWkmRkbrJ+7uEWs7JEQ0dy4ji
         /jGHumraXj/+ujT5+g4BougNm+Fbf7wvpHnEOR+SoWoel7IC/QoSVu1xTlgMd7VHAL2l
         7/XA==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <cover.1631102579.git.escape@linux.alibaba.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yi Tao <escape@linux.alibaba.com>
Cc: gregkh@linuxfoundation.org, lizefan.x@bytedance.com, hannes@cmpxchg.org, mcgrof@kernel.org, keescook@chromium.org, yzaikin@google.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-fsdevel@vger.kernel.org, shanpeic@linux.alibaba.com

Hello,

On Wed, Sep 08, 2021 at 08:15:11PM +0800, Yi Tao wrote:
> In order to solve this long-tail delay problem, we designed a cgroup
> pool. The cgroup pool will create a certain number of cgroups in advance.
> When a user creates a cgroup through the mkdir system call, a clean cgroup
> can be quickly obtained from the pool. Cgroup pool draws on the idea of
> cgroup rename. By creating pool and rename in advance, it reduces the
> critical area of cgroup creation, and uses a spinlock different from
> cgroup_mutex, which reduces scheduling overhead on the one hand, and eases
> competition with attaching processes on the other hand.

I'm not sure this is the right way to go about it. There are more
conventional ways to improve scalability - making locking more granular and
hunting down specific operations which take long time. I don't think cgroup
management operations need the level of scalability which requires front
caching.

Thanks.

-- 
tejun
