From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH]cgroup: __cpuset_node_allowed return bool
Date: Mon, 26 Mar 2018 07:25:27 -0700
Message-ID: <20180326142527.GJ2149215@devbig577.frc2.facebook.com>
References: <d2f9fe6096235032f445ab88e562560f@codeaurora.org>
 <0fee75e4a1b12f5fca30e04306a95788@codeaurora.org>
 <20180326141212.GI2149215@devbig577.frc2.facebook.com>
 <3540bc7869927f54c409b697c743938a@codeaurora.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LknNw6f+nIhcSR+heKRMCBNMuE4YhrnzXyqO0hsX2xw=;
        b=TgstmNvjO+bs38OCAkWAP+jPElZmI+KnwhFiU2kjtf4vp2boAkcWOz4n1M2wjSvLde
         uP8SIVNuRti5+vMOiNgQxqgmXXfQcFfphntavLohkU3nTYvKRC+0ixLx1F18cNZusRcX
         AFkU6Q0gse40a2ol/uqm0YDrLdzPUOgqFRAiBGuV8vCrZVjUrs64Ac/V7wUflDKcxuBv
         jatg2jrOZQCUSJa+4n0zgwXuvkBww7sgmBCoM4bk1NlkbAkz9LFVy33R43HBeil5bSDR
         C5Nsur6n1jR3gdzOdRqaSmbM8Ru/nsoRY4vEQcHE8E7sQujS+zLiSrHovsjMsQxGA6x1
         Z82A==
Content-Disposition: inline
In-Reply-To: <3540bc7869927f54c409b697c743938a@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: yuankuiz@codeaurora.org
Cc: cgroups@vger.kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, linux-kernel@vger.kernel.org, pkondeti@codeaurora.org, cgroups-owner@vger.kernel.org

On Mon, Mar 26, 2018 at 10:20:43PM +0800, yuankuiz@codeaurora.org wrote:
>  1) return int type variable in bool function:
>  bool enabled()
>  {
>  	int ret = 1;
>  	return ret;
>  }
...
>  2)
>  bool enabled()
>  {
>  	bool ret = 1;
>  	return ret;
>  }
...
>  so the #1) style function can generate significant instructions
> than the #2).

That is a problem for the compiler, not the code.

>  While, this is happened only when "-On" is not used with *-gcc
> together. Though, it is oftern there, it is best to provide this
> with decoupling of which option is used for optimization.

We don't want to dictate minute coding styles to avoid things which
are trivially optimized by compilers.

Thanks.

-- 
tejun
