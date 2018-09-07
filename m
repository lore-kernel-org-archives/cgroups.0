From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 11/12] blkcg: change blkg reference counting to use
 percpu_ref
Date: Fri, 7 Sep 2018 10:59:12 -0700
Message-ID: <20180907175912.GD1100574@devbig004.ftw2.facebook.com>
References: <20180906211045.29055-1-dennisszhou@gmail.com>
 <20180906211045.29055-12-dennisszhou@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=kvOy7j6VyQo71prQRraDJula3JlRDxnFJbSd7s/3VsM=;
        b=ISVqSDxLzRU/Zu72YJywjEcV0C/qiz+Rz/ZlymoJ6RJ7xll1jGuYPTUUXf0x9fMZoP
         J9vhg+RKQtSOPAFtjFT8eOJEe3wKCwGUC6jVDKKg50t9r6ZEbcTClgALLhpvd51Ofm0S
         MoXzKjr+Em1z2ij+2EGC8WwWs+61nrsFRZ6zfG6J1MGtDcVrXtAUo4qC4KMfe8JCsxT4
         ZA1kZIAGl0md3BRLec7bvE43OJ6c381TPZTPy5/g7XPnQQXbBXxW/cUGRUEfyGDnyBZZ
         hAWAhuKtVFxE1Ea4xmLWF0y3xYrtBrCYW9Jgq8npv2WICwKYXqCKvmSPHDB9MmuNx039
         1Etw==
Content-Disposition: inline
In-Reply-To: <20180906211045.29055-12-dennisszhou@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dennis Zhou <dennisszhou@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>, Josef Bacik <josef@toxicpanda.com>, kernel-team@fb.com, linux-block@vger.kernel.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Sep 06, 2018 at 05:10:44PM -0400, Dennis Zhou wrote:
> From: "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>
> 
> Now that every bio is associated with a blkg, this puts the use of
> blkg_get, blkg_try_get, and blkg_put on the hot path. This switches over
> the refcnt in blkg to use percpu_ref.
> 
> Signed-off-by: Dennis Zhou <dennisszhou@gmail.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
