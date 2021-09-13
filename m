From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] docs/cgroup: remove some duplicate words
Date: Mon, 13 Sep 2021 07:56:48 -1000
Message-ID: <YT+Q4Gr7Ky1Tt9w8@slm.duckdns.org>
References: <1631509754-21485-1-git-send-email-brookxu.cn@gmail.com>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gSVJ2eIM6ASF+/M1pUdi7A7u/9wBqdKyPf+MuRt4P3o=;
        b=Q5ZThgVUFT2XJy9ZZ3JHUMd3INTVtkMLE2tXoNIME6xo30Bw5fDiF0A0WqMV2fdkZV
         BtZ7myHUs0imcosnzwMnUq/q2JJsNmF9burZEPbMTfpuPHjMkKRT7raxg56pxr+QuzDJ
         USkCq2o5S5nOGPi9GYHJBfHMi8uF2+J3rdZnTj/NocsKytqfpuldL87dU+fVK6k03sLF
         xYvhVXyZSA6fGGvfpydGgNsWRGAsakrFG1rhVIlKfXrmx8ejdb9Xq8LUDB6DMh9r9hSQ
         LHjD9wDUCrLi+U8jQR1RRVW4AYr12LLlcnuHkKNbaQg9DT2rLf5lCE90J5GlOFVmVsYv
         m+jw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <1631509754-21485-1-git-send-email-brookxu.cn@gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: brookxu <brookxu.cn@gmail.com>
Cc: lizefan.x@bytedance.com, hannes@cmpxchg.org, corbet@lwn.net, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org

On Mon, Sep 13, 2021 at 01:09:14PM +0800, brookxu wrote:
> From: Chunguang Xu <brookxu@tencent.com>
> 
> When I tried to add some new entries to cgroup-v2.rst, I found that
> the description of memory.events had some repetitive words, so I
> tried to delete them.
> 
> Signed-off-by: Chunguang Xu <brookxu@tencent.com>

Applied to cgroup/for-5.15-fixes.

Thanks.

-- 
tejun
