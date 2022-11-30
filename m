From: Bagas Sanjaya <bagasdotme@gmail.com>
Subject: Re: [RFC PATCH v2] mm: Add nodes= arg to memory.reclaim
Date: Wed, 30 Nov 2022 15:44:11 +0700
Message-ID: <7c5e0ca5-0ad1-452d-60b9-50dbb63d2dee@gmail.com>
References: <20221130020328.1009347-1-almasrymina@google.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nX9u5Fipz7QbP1G6lS7SK8y5UdXxGb4XBtSgvsH1ex8=;
        b=HGg1XUBOCu82ZW+TXKFrDzMOhzT3qhH5/0+upzC/MFORU/djS9EShs8RWQGhA54loM
         +k6NJCRNXDJNxM6sbRBwiIBo/OcIM0fhyianG1qSBJ5Wmx9QHrGTh/KbDnS09g3nvbmJ
         NIG9Wvn+WzT/MVyJpUH04RIow7GXkhx9+9THVjE7EmjkRTjfj4u5BeRoil9YD6Y73UzQ
         Egf8NgiZqcJh1NuoRJc0KeI1QHGOtEM9BO/x9WU+eKo1jVIZEfrKLgh68gIcU2WSTHEv
         p6AhzxuMSRWx4Jq0+gGOvstl9MGxxHf483dY52Nn2Lyndh6M1j7/s5mIL65cOYy3UIGy
         gwdQ==
Content-Language: en-US
In-Reply-To: <20221130020328.1009347-1-almasrymina@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Mina Almasry <almasrymina@google.com>, Huang Ying <ying.huang@intel.com>, Yang Shi <yang.shi@linux.alibaba.com>, Yosry Ahmed <yosryahmed@google.com>, Tim Chen <tim.c.chen@linux.intel.com>, weixugc@google.com, shakeelb@google.com, gthelen@google.com, fvdl@google.com, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <songmuchun@bytedance.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On 11/30/22 09:03, Mina Almasry wrote:
> -	This file accepts a single key, the number of bytes to reclaim.
> -	No nested keys are currently supported.
> +	This file accepts a string which contains the number of bytes to
> +	reclaim.
> 
Amount of memory to reclaim?

> +	This file also allows the user to specify the nodes to reclaim from,
> +	via the 'nodes=' key, example::
> +

"..., for example"

> +	  echo "1G nodes=0,1" > memory.reclaim
> +
> +	The above instructs the kernel to reclaim memory from nodes 0,1.
> +

Thanks.

-- 
An old man doll... just what I always wanted! - Clara

