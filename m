From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH rdma-next] IB/core: Simplify rdma cgroup registration
Date: Fri, 18 Jan 2019 08:16:06 -0800
Message-ID: <20190118161606.GD50184@devbig004.ftw2.facebook.com>
References: <20190117181415.28566-1-leon@kernel.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rsOU4IZ09Qp6Nmi/lJ+hFBR4kFX8sxK+HJmA6AHo+Ns=;
        b=Iuso1rGlXoQmbfJ0AgUzCBwQan1kkY55FpIK9KhQkHxm0VBw9UuO1YzJ6/kwqi6vrF
         dsCdMI6DOOhiqcuAJAcbxysEF0B3eiCCk4qyqEY6sXYoFJwi+hh5gEUJ8fTvB/ecV4Df
         tvMV64XxQZPWxf60iVvuIF06t/uH9KrhHbannuyvsSIS19kv/iHa1S3598f9PAkUbaCh
         kAGU6VPAdZXioKuk4ZKuRB1RhS+NqT5kxMkl0kV5DGdmbH6fhFC14oI6MgoId34F1FpI
         /7QVvZOLl64qP6DjCM1PJRfRI/BKH84Jr+hK1Ogc72CBRqZmELSPJGhVADAi+5Kwdwks
         1fKw==
Content-Disposition: inline
In-Reply-To: <20190117181415.28566-1-leon@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Leon Romanovsky <leon@kernel.org>
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, Parav Pandit <parav@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>, Leon Romanovsky <leonro@mellanox.com>

On Thu, Jan 17, 2019 at 08:14:15PM +0200, Leon Romanovsky wrote:
> From: Parav Pandit <parav@mellanox.com>
> 
> RDMA cgroup registration routine always returns success,
> so simplify function to be void and run clang formatter
> over whole CONFIG_CGROUP_RDMA art of core_priv.h.
> 
> This reduces unwinding error path for regular registration and
> future net namespace change functionality for rdma device.
> 
> Signed-off-by: Parav Pandit <parav@mellanox.com>
> Signed-off-by: Leon Romanovsky <leonro@mellanox.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
