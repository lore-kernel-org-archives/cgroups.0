From: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH] blk-cgroup: fix missing pd_online_fn() while
 activating policy
Date: Mon, 16 Jan 2023 19:04:13 -0700
Message-ID: <167392105396.441215.10700011927533380031.b4-ty@kernel.dk>
References: <20230103112833.2013432-1-yukuai1@huaweicloud.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SExj9sPYRI5nvri+f4hPOSN0wQyEHXBODvypNoBRz/E=;
        b=Gh1phClZGkEjfMyk7PFqNeMBC2BIMQscw5aErf3bX7JD7N4WENyYXGTvElDfKcp44g
         gR6v9FsUAlk3gLf+hll8ixHOu2Go53fjYr7VQw4w95GZqyidqq1U5/9JWWE6a9ksmjBx
         R7FDsKTErGWvXlNdJ1lh9Op1clvxpjFkY4/nJRgPJNEG2X6u0GbCcPWm3bnobYNDO1t1
         6SrPvB96sAFFi3J2LM9YgqfSuf39ca1gBny1IMzDsrP+RNhFbdFHORnBShPzbFGHE3A/
         SpzuwiNuEAVIP7kvNXqWXUUX9bIMkwC3jehvlsSwzEM/T6QBR2UBYgEkN7KNwXoa5LKq
         mUcA==
In-Reply-To: <20230103112833.2013432-1-yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, Yu Kuai <yukuai1-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yukuai3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yi.zhang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, yangerkun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org


On Tue, 03 Jan 2023 19:28:33 +0800, Yu Kuai wrote:
> If the policy defines pd_online_fn(), it should be called after
> pd_init_fn(), like blkg_create().
> 
> 

Applied, thanks!

[1/1] blk-cgroup: fix missing pd_online_fn() while activating policy
      commit: e3ff8887e7db757360f97634e0d6f4b8e27a8c46

Best regards,
-- 
Jens Axboe



