From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cpuset: convert 'allowed' in __cpuset_node_allowed() to
 be boolean
Date: Fri, 7 Jan 2022 12:06:13 -1000
Message-ID: <Ydi5VRmOm5e2Malb@slm.duckdns.org>
References: <20211219024154.28853-1-zhengqi.arch@bytedance.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tn3eWO9zz8sRJIypwap85PQFXjv9Ix4xcI+tN55JBrE=;
        b=PFm4tFrOfDjDZHQWcN2Kxn/K0Sg2LubhX99OruFwoZADzE1tw8uJXWa2gym+YCUkZq
         upwonpi3EVVTBNDD/of8XpfOHtku8uYEEsSg0Bw0B/oXUfnFoLHmv5thWYo1nZq6/4Xj
         chKi+Hz3cCiZeRfB0t9D6xB/2qkPyIdOmOboXQA+/sfYfthM08j2zussz5D/vVc/45+R
         vJ13VoBaYIjf8XgQM9zTbGp4Gic1dM5nxI1nhTcG8qdorrlp8CO5he1PtX5Gs/a4ofGJ
         Fu6H8vjM9VDT6KAvrNiWfk2+Lwm0P0JyF/C0CSldXnt3Qv5hAdw34WLuvjmm4qdtV/I5
         DhlQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20211219024154.28853-1-zhengqi.arch@bytedance.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: lizefan.x@bytedance.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Sun, Dec 19, 2021 at 10:41:54AM +0800, Qi Zheng wrote:
> Convert 'allowed' in __cpuset_node_allowed() to be boolean since the
> return types of node_isset() and __cpuset_node_allowed() are both
> boolean.
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>

Applied to cgroup/for-5.17.

Thanks.

-- 
tejun
