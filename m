From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] mm: Charge current memcg when no mm is set
Date: Wed, 12 Feb 2020 18:06:39 -0500
Message-ID: <20200212230639.GC88887@mtj.thefacebook.com>
References: <20200205223348.880610-1-dschatzberg@fb.com>
 <20200205223348.880610-2-dschatzberg@fb.com>
Mime-Version: 1.0
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jrnsMbO/zuCHlgaM/a/FjOvE1m1S8Xf2JYCWP8EYCzM=;
        b=j25pRrxQLvVZl/hEdj5hXOzR1QKKISX1INcpFeUQwW54ZkvXglE2Q8is0HTnPgMVhY
         +rrllujU687I53A7vCShJl/TveRHUdGZ7FLptbaNixQzozpWPI0q2u00LR0jlKDRjkuP
         d0JFMpSmy6fiaW+th1QywF2c8Kw4Qq1NGxrlOZvw6+qow4skZ3y1Ywg9vLEP/OLLL+uH
         tvDX3ICWcLknKYTPQoH6mOUomjQnTai2SXty1W3W1b0zZ35Oqj3GFmY81AZurUAiiUWR
         5zka7dCR9XMARQQxkUKkhslnuVIlmbsMgSRGtPvWpe/4ckBcScSgES52ks4wZSQK18sd
         MsTQ==
Content-Disposition: inline
In-Reply-To: <20200205223348.880610-2-dschatzberg@fb.com>
Sender: linux-block-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dan Schatzberg <dschatzberg@fb.com>
Cc: Jens Axboe <axboe@kernel.dk>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, "open list:BLOCK LAYER" <linux-block@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>, "open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <linux-mm@kvack.org>

On Wed, Feb 05, 2020 at 02:33:47PM -0800, Dan Schatzberg wrote:
> This modifies the shmem and mm charge logic so that now if there is no
> mm set (as in the case of tmpfs backed loop device), we charge the
> current memcg, if set.
> 
> Signed-off-by: Dan Schatzberg <dschatzberg@fb.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
