From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup/cgroup.c: replace 'of->kn->priv' with of_cft()
Date: Wed, 25 Nov 2020 08:00:03 -0500
Message-ID: <X75VUww1HSDTIogr@mtj.duckdns.org>
References: <20201106144740.GA9692@rlk>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XuQ+2DG9U9Hwi9eXWeTXB4FOzgysYN6dM+DTmKoBeH0=;
        b=qJp6arWgErU52EuWjiDRXw9HeRKWRsWYxdYmBevAXA64CKkJl9n5dlPUWE3uZJB3wo
         ynVOismALsLZPJVeKGEurbPQo+/ayLYJJrrGV6L/kYu4XvOeT5NbhsEtXNRZNzTiesQ1
         sZ6630I0yDI2jQ155IzrsBYzFumlJ7syQ2lW1T6eFA8Dka6yYpbE8GkYjtGLFZhXIzNY
         C57JmhtsdTNy1m9xlZ+GvhS58tYPbPuzFWhluTeUgV93APIwUUblGwgocra7pJDvyis9
         HG0EEuO0edUIE2FTSbrwfUJDoBhvnEX8xCwXAwvZ+ZJ1kPKxCiA5EAghxX9CEc7gbqv+
         oEQQ==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20201106144740.GA9692@rlk>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hui Su <sh_def@163.com>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, Nov 06, 2020 at 10:47:40PM +0800, Hui Su wrote:
> we have supplied the inline function: of_cft() in cgroup.h.
> 
> So replace the direct use 'of->kn->priv' with inline func
> of_cft(), which is more readable.
> 
> Signed-off-by: Hui Su <sh_def@163.com>

Applied to cgroup/for-5.10-fixes.

Thanks.

-- 
tejun
