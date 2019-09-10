From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup: use kv(malloc|free) instead of
 pidlist_(allocate|free)
Date: Tue, 10 Sep 2019 09:46:49 -0700
Message-ID: <20190910164649.GU2263813@devbig004.ftw2.facebook.com>
References: <20190908144041.19667-1-insafonov@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=nGPjMw+0bTsKBBz+LmEuKCB2oVregNeJBfTo1Ogq1SQ=;
        b=FY0tyhssl1v85cCyEg/NN4HRY3hq/KixekXYiv8rvrGa4KLzdIXYwP88+KEqt0xLKP
         Lm3en+mF7zbP0lJwoeia/6SfM9NCrpaqdkvWSbdxYkg/b86FtG8DZ0/aFKRRlul5AgC3
         +tNTkDQWPK8jdHELiV3V521mz8taG6/Nh1vtKQMGwsv8zUaC392ADsHzRhgYPVSbNONE
         jxvAV6uvzks29ehtS4ROxp9pgEyRvO6RS6MhrltSuaS0Cs1RvhPpgKCALvCLNWKQFdGo
         1o3NR3mB5VE8GPy419vLO4w8tvWVSGITf0+OG95W6U077OyWW0JFcdEYPXYVWKu9GXhx
         /uwQ==
Content-Disposition: inline
In-Reply-To: <20190908144041.19667-1-insafonov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ivan Safonov <insafonov@gmail.com>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Sun, Sep 08, 2019 at 05:40:41PM +0300, Ivan Safonov wrote:
> Resolve TODO:
> > The following two functions "fix" the issue where there are more pids
> > than kmalloc will give memory for; in such cases, we use vmalloc/vfree.
> > TODO: replace with a kernel-wide solution to this problem
> 
> kv(malloc|free) is appropriate replacement for pidlist_(allocate|free).
> 
> Signed-off-by: Ivan Safonov <insafonov@gmail.com>

An equivalent patch is already queued.

https://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git/commit/?h=for-5.4&id=653a23ca7e1e1ae907654e91d028bc6dfc7fce0c

Thanks.

-- 
tejun
