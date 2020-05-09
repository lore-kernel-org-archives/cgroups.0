From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2] netprio_cgroup: Fix unlimited memory leak of v2
 cgroups
Date: Sat, 9 May 2020 18:57:36 -0400
Message-ID: <20200509225736.GA16815@mtj.duckdns.org>
References: <939566f5-abe3-3526-d4ff-ec6bf8e8c138@huawei.com>
 <2fcd921d-8f42-9d33-951c-899d0bbdd92d@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=rNy4JOtG+nCRfsj1WL1vWdLxzYPRX62nRZqLhv1rCGQ=;
        b=ZBrXz5ssxM8itMJvIuhpryRMrVoN3j3run4YUAz9kEkOoLcLITpSlYjkDQ7w9RSvP1
         HojOEGvaQDlHZxwbT5lZPfEogQgu8nZ9xiQG2LBJjr6pQw6jEdLZYdyThxAK7iKXAKQd
         h/ZPs7oYkGx6MLK5yVck7arft1mrtTZBmumNr8P/oEV1EECn43KBNnYn9M0Js1dGFp4/
         XCMz5qTkq1i2i4WFKcSfdsO9C55aV/5BpbJMQyj6IU0Bc0RLAujCsLkqDy6X9S3W2oQb
         AQ2oKK+CDVfbfZdfdssvS6OZ+Pbo0E5iwtFQcPKP978sryTITGs/XquTmjhclfNGtfNe
         WE+w==
Content-Disposition: inline
In-Reply-To: <2fcd921d-8f42-9d33-951c-899d0bbdd92d@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zefan Li <lizefan@huawei.com>
Cc: David Miller <davem@davemloft.net>, yangyingliang <yangyingliang@huawei.com>, Kefeng Wang <wangkefeng.wang@huawei.com>, huawei.libin@huawei.com, guofan5@huawei.com, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, Linux Kernel Network Developers <netdev@vger.kernel.org>

On Sat, May 09, 2020 at 11:32:10AM +0800, Zefan Li wrote:
> If systemd is configured to use hybrid mode which enables the use of
> both cgroup v1 and v2, systemd will create new cgroup on both the default
> root (v2) and netprio_cgroup hierarchy (v1) for a new session and attach
> task to the two cgroups. If the task does some network thing then the v2
> cgroup can never be freed after the session exited.
> 
> One of our machines ran into OOM due to this memory leak.
> 
> In the scenario described above when sk_alloc() is called cgroup_sk_alloc()
> thought it's in v2 mode, so it stores the cgroup pointer in sk->sk_cgrp_data
> and increments the cgroup refcnt, but then sock_update_netprioidx() thought
> it's in v1 mode, so it stores netprioidx value in sk->sk_cgrp_data, so the
> cgroup refcnt will never be freed.
> 
> Currently we do the mode switch when someone writes to the ifpriomap cgroup
> control file. The easiest fix is to also do the switch when a task is attached
> to a new cgroup.
> 
> Fixes: bd1060a1d671("sock, cgroup: add sock->sk_cgroup")
> Reported-by: Yang Yingliang <yangyingliang@huawei.com>
> Tested-by: Yang Yingliang <yangyingliang@huawei.com>
> Signed-off-by: Zefan Li <lizefan@huawei.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
