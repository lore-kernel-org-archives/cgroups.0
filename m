From: Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH 13/15] blkcg: change blkg reference counting to use
 percpu_ref
Date: Fri, 31 Aug 2018 11:49:41 -0400
Message-ID: <20180831154939.sb24oz7ekxcwkkfd@destiny>
References: <20180831015356.69796-1-dennisszhou@gmail.com>
 <20180831015356.69796-14-dennisszhou@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=sC8N1acRi2T0wcB2hYaIbejNJ4iMdgdw+m2NKObxBm0=;
        b=hmVVNNHXcUy+YLY9OhZzCIWW2RBnPcBYnVfh7t9lwJxo+qJTxhzzHiCaq8vucWlFMj
         eYDo9R8u03JOZzxZ/kn3K3iNvUzShDcY2rjNyuYDPRai58GJGFCVPkQgZO9Y39iklpR7
         N/RyVM/CoTMEJNbg7Vv7FzvJwismPWcOstByUEvGX5xSsh9bR+BT8Agvyrw/7kQ8gqw6
         gNG/9PTQPRw7LMpm4zb5rhkzURuJY9NjNRPRyH5QpwAdUKIHcMsOnZYt4qt3iJhnpKlX
         aoZp4j0xUqo7wpst3j89S8D7PCAXmHD2GUF+Hx/puogsSJwBMTZAl1vDsmVp9ijC3JCX
         R0eQ==
Content-Disposition: inline
In-Reply-To: <20180831015356.69796-14-dennisszhou@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dennis Zhou <dennisszhou@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Aug 30, 2018 at 09:53:54PM -0400, Dennis Zhou wrote:
> From: "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>
> 
> Now that every bio is associated with a blkg, this puts the use of
> blkg_get, blkg_try_get, and blkg_put on the hot path. This switches over
> the refcnt in blkg to use percpu_ref.
> 
> Signed-off-by: Dennis Zhou <dennisszhou@gmail.com>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
