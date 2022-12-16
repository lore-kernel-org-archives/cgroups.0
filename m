From: Bagas Sanjaya <bagasdotme@gmail.com>
Subject: Re: [PATCH] Revert "mm: add nodes= arg to memory.reclaim"
Date: Fri, 16 Dec 2022 19:28:13 +0700
Message-ID: <85f627d5-7572-1fc7-db1f-bc1337767a68@gmail.com>
References: <20221202223533.1785418-1-almasrymina@google.com>
 <Y5bsmpCyeryu3Zz1@dhcp22.suse.cz> <Y5xASNe1x8cusiTx@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XN2BUIyyxfcPTn0lH7csIpbvsG2W/DIuROkPMqaCcZA=;
        b=gTmjQHIthgTaarmTiJIFcOmKO18lOJx70K41j/h8aKXjh6KsuWGEkZFj33q3evneNQ
         Z2aOHDpL36LFgscqFBHNKzMVJ9mYIx0ZAod72hmvUaLZsAbM7hZrGu12f8gqDapCACMi
         41FVVH0qwRa4z0G6jmKXty6+LfGNMpKKDSTCYx8cJ/m33BMfthqrsxXH+AzoxBx8M9Yn
         C/3DIhGswmw+wRwrjR6uyzMYIeKhpQu3fKP+73cPXx9rO1TkIqOY+++ZfmE+EG9Mnlfb
         Id6KF6Rn3DAwHZhYd2fmrXGE5W6ntZV+znP4hk8sgPNWBl6FZtqOqmGU/m0AG/lTtkaW
         KYyA==
Content-Language: en-US
In-Reply-To: <Y5xASNe1x8cusiTx@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Hocko <mhocko@suse.com>, Mina Almasry <almasrymina@google.com>, Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <songmuchun@bytedance.com>, Huang Ying <ying.huang@intel.com>, Yang Shi <yang.shi@linux.alibaba.com>, Yosry Ahmed <yosryahmed@google.com>, weixugc@google.com, fvdl@google.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On 12/16/22 16:54, Michal Hocko wrote:
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> index c8ae7c897f14..74cec76be9f2 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -1245,13 +1245,17 @@ PAGE_SIZE multiple when read back.
>  	This is a simple interface to trigger memory reclaim in the
>  	target cgroup.
>  
> -	This file accepts a string which contains the number of bytes to
> -	reclaim.
> +	This file accepts a single key, the number of bytes to reclaim.
> +	No nested keys are currently supported.
>  
>  	Example::
>  
>  	  echo "1G" > memory.reclaim
>  
> +	The interface can be later extended with nested keys to
> +	configure the reclaim behavior. For example, specify the
> +	type of memory to reclaim from (anon, file, ..).
> +
>  	Please note that the kernel can over or under reclaim from
>  	the target cgroup. If less bytes are reclaimed than the
>  	specified amount, -EAGAIN is returned.
> @@ -1263,13 +1267,6 @@ PAGE_SIZE multiple when read back.
>  	This means that the networking layer will not adapt based on
>  	reclaim induced by memory.reclaim.
>  
> -	This file also allows the user to specify the nodes to reclaim from,
> -	via the 'nodes=' key, for example::
> -
> -	  echo "1G nodes=0,1" > memory.reclaim
> -
> -	The above instructs the kernel to reclaim memory from nodes 0,1.
> -
>    memory.peak
>  	A read-only single value file which exists on non-root
>  	cgroups.

Ah! I forgot to add my Reviewed-by: tag when the original patch was
submitted. However, I was Cc'ed the revert presumably due to Cc: tag in the
original.

In any case, for the documentation part:

Acked-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara

