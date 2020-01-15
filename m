From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup: fix function name in comment
Date: Wed, 15 Jan 2020 07:59:12 -0800
Message-ID: <20200115155912.GE2677547@devbig004.ftw2.facebook.com>
References: <20200110072320.85605-1-chenzhou10@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=BHlo4uJGdkpMotzf6l1LEH0nK2SaURIBMqF7pq0+cPE=;
        b=LwRP9gLUlXJubGXbdTk+FhYOQlXwRmMsHlEe55cVAnjtJ90OQMIoErVrPpruu18dlX
         gk9SxqoS+xp621iP9KezoinvlIWqxdUruCqdIjGT0wMVd8oFC9Hg0l/mGm/aa6G5lQnS
         myUuH1Il7L7qvg1vzJD0Vh6JhzHuENKoLY8+i/CJDR+TmGEE48+64nxI9QGLCtwwK9vi
         7Tj+N4LP7dU3wf5k7tQAeD5e2WyyViFDeBQwyWar+u9GbQ43KtAhQveaJbuzQ9yweZvN
         izYsaa3bnk/z3Y6bjHTITWkMD1RyD3Vg5f9jUU4DXO63KMPxIx07fcmj0nmVRg/5LRSS
         y6Qw==
Content-Disposition: inline
In-Reply-To: <20200110072320.85605-1-chenzhou10@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Chen Zhou <chenzhou10@huawei.com>
Cc: lizefan@huawei.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Jan 10, 2020 at 03:23:20PM +0800, Chen Zhou wrote:
> Function name cgroup_rstat_cpu_pop_upated() in comment should be
> cgroup_rstat_cpu_pop_updated().
> 
> Signed-off-by: Chen Zhou <chenzhou10@huawei.com>

Applied to cgroup/for-5.6.

Thanks.

-- 
tejun
