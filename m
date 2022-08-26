From: Randy Dunlap <rdunlap@infradead.org>
Subject: Re: [PATCH linux-next] admin-guide: cgroup: fix a typo in description
Date: Thu, 25 Aug 2022 19:48:10 -0700
Message-ID: <795c6785-e13e-5322-15b3-60ee2ec24197@infradead.org>
References: <20220826020552.239407-1-lu.fengchang@zte.com.cn>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=KrBgq4HD/icun5bFiHHIUQ6IjONVJ/rxTezt7YCnkJE=; b=rGM/UuEBB9L8aI2AUVk+gK2KDP
        fKxnby64zNrqUPb9aKaMfaS7cuuLc+lcTb06Lp8ySc8Vk6/eQFezTahu31Rj544mnXY54mYmNceUr
        ToOTtf4bTziGm77ZUOaOtUzudaP/nprEk4/QNk6+TjGOBYkniPvBz4KV8My/62pnfwDkBJgq1Tm+R
        qOfblZEqiokIpz/hyr5GFpeffd8O7SlMmBm+VXU/i0+6YaJUtQpp81mLwVcrQahbTghA4hpsQZDOV
        lSLKH77yESrNAHC3i6ZOHGaBMgSn8cqhq4WczqKBqF8In3ZxMsV87K0kVmYT7dB1Agh1rwPzsHZSG
        GU6qIVyA==;
Content-Language: en-US
In-Reply-To: <20220826020552.239407-1-lu.fengchang@zte.com.cn>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: cgel.zte@gmail.com, tj@kernel.org
Cc: lizefan.x@bytedance.com, hannes@cmpxchg.org, corbet@lwn.net, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, lufengchang <lu.fengchang@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>

Hi,

On 8/25/22 19:05, cgel.zte@gmail.com wrote:
> From: lufengchang <lu.fengchang@zte.com.cn>
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: lufengchang <lu.fengchang@zte.com.cn>

Are you sure that it's a typo?

https://en.wikipedia.org/wiki/If_and_only_if

"iff" is commonly used (in math/technical literature)
to mean "if and only if".

> ---
>  Documentation/admin-guide/cgroup-v1/cgroups.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/admin-guide/cgroup-v1/cgroups.rst b/Documentation/admin-guide/cgroup-v1/cgroups.rst
> index b0688011ed06..fa747466e304 100644
> --- a/Documentation/admin-guide/cgroup-v1/cgroups.rst
> +++ b/Documentation/admin-guide/cgroup-v1/cgroups.rst
> @@ -573,7 +573,7 @@ cgroup_for_each_descendant_pre() for details.
>  ``void css_offline(struct cgroup *cgrp);``
>  (cgroup_mutex held by caller)
>  
> -This is the counterpart of css_online() and called iff css_online()
> +This is the counterpart of css_online() and called if css_online()
>  has succeeded on @cgrp. This signifies the beginning of the end of
>  @cgrp. @cgrp is being removed and the subsystem should start dropping
>  all references it's holding on @cgrp. When all references are dropped,

-- 
~Randy
