From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCHv7 1/3] rdmacg: Added rdma cgroup controller
Date: Tue, 1 Mar 2016 10:26:53 +0200
Message-ID: <56D5524D.1060905@mellanox.com>
References: <1456668821-25799-1-git-send-email-pandit.parav@gmail.com>
 <1456668821-25799-2-git-send-email-pandit.parav@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1; h=From:To:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=UPC9Ie1odvQ2D1KGVDU8fYFHT9iOyzu3c5qabRujm1w=;
 b=BO6+ppzLmTX7iSUV3/ltqu71hXughaRkVGjlwcL5Xm8q3Yj9/RRvBeX7UTI/8Ufitwee2fcAFyTbBXLaQ9wT57wG/2eFgZp73tacIU6q5AgyuQ8fj4upVa/P2yWgnaW2mJM7Flcaj8+sEZU/g8VDD80OtHeYy9fydRyKpje73Vo=
In-Reply-To: <1456668821-25799-2-git-send-email-pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org
Cc: corbet-T1hC0tSOHrs@public.gmane.org, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On 28/02/2016 16:13, Parav Pandit wrote:
> Added rdma cgroup controller that does accounting, limit enforcement
> on rdma/IB verbs and hw resources.
> 
> Added rdma cgroup header file which defines its APIs to perform
> charing/uncharing functionality and device registration which will
> participate in controller functions of accounting and limit
> enforcements. It also define rdmacg_device structure to bind IB stack
> and RDMA cgroup controller.
> 
> RDMA resources are tracked using resource pool. Resource pool is per
> device, per cgroup entity which allows setting up accounting limits
> on per device basis.
> 
> Resources are not defined by the RDMA cgroup, instead they are defined
> by the external module IB stack. This allows extending IB stack
> without changing kernel, as IB stack is going through changes
> and enhancements.
> 
> Resource pool is created/destroyed dynamically whenever
> charging/uncharging occurs respectively and whenever user
> configuration is done. Its a tradeoff of memory vs little more code
> space that creates resource pool whenever necessary,
> instead of creating them during cgroup creation and device registration
> time.
> 
> Signed-off-by: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Reviewed-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
