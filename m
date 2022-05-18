From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH -next] cgroup: Make cgroup_debug static
Date: Wed, 18 May 2022 07:03:16 -1000
Message-ID: <YoUm1C9ozORHfFk1@slm.duckdns.org>
References: <20220517112523.243386-1-xiujianfeng@huawei.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PZ3XZrh23YKpTQBXyyyesP7NAmJ1EfYKnoyuawcBqe0=;
        b=KmBqcA1c47T3IqI7qZnw1e+G/2uUP/yPiBVthOYegGBYFrAV2UMc5bEMEgTV6HgsWp
         t8IkHzeKyzZPhYfaWgyvHcdIJQVOAXJLzN0+itYeOk9GovPH+YSIUgZEDWZAou4QOkzk
         YDJPG7mP7PXJtPo3gRnGq38utyS6abWidyBu7oi+CHp72goeRhVSqbkmhk4fVaRM1trU
         3A6G6h3ZNAvNBedbycotR2kbrX1yI8Tw482ONL+6eQ2Ks8SOJ9KJHljlVNpoq8pIqPBm
         U0NydR6B5CUyEWH2xtrHCC4N8SP7xcoXylwoXoqjkFx1QO1b4+cWX+w34V9fTyTD360m
         lovw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <20220517112523.243386-1-xiujianfeng@huawei.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xiu Jianfeng <xiujianfeng@huawei.com>
Cc: lizefan.x@bytedance.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, May 17, 2022 at 07:25:23PM +0800, Xiu Jianfeng wrote:
> Make cgroup_debug static since it's only used in cgroup.c
> 
> Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>

Applied to cgroup/for-5.19.

Thanks.

-- 
tejun
