From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup/misc: Fix an overflow
Date: Mon, 17 Jul 2023 10:37:08 -1000
Message-ID: <ZLWmdBfcuPUBtk1K@slm.duckdns.org>
References: <20230717184719.85523-1-haitao.huang@linux.intel.com>
 <CU4OCLEHU1S5.359W394902648@seitikki>
 <ZLWPN_xyGFrqqJkV@slm.duckdns.org>
 <op.178pr1qewjvjmi@hhuan26-mobl.amr.corp.intel.com>
 <op.178te0tbwjvjmi@hhuan26-mobl.amr.corp.intel.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689626230; x=1692218230;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2kAwJHiR+H4GDqr7e6nXyr8bmo5EmU5aiLGkOZNmvaM=;
        b=kmeBqa5MdbvFwdthLNdn6x5K0aMOzpJkcGZV6u06eY00afZa0fY9RvCh6intNP8pXp
         ova0U7D4MjTIHFXVKb77udj94AQogskNUHixxA7OnLXGJPqGQg6Ye8E8Nr80P7xmVjtH
         AT+CNgtY69k3C9UANOeU+fLg0WgCyuVlNL42ktb03Tr4Ttm67yY0eM3nIU9UTMc/OHvx
         59KCftrig2iDJHxr3GXZJA7GmYbli/hP5Gfi8PyDKfKvTV/Uc6F+p1auVV2NYVy0z5kj
         3RopdAE1ZYsq0E5J5tInZWS6tPHLNKqw1jaKxPBBsjVes2aS1YV/KBTdgWJzhzxViEOO
         segw==
Sender: Tejun Heo <htejun@gmail.com>
Content-Disposition: inline
In-Reply-To: <op.178te0tbwjvjmi@hhuan26-mobl.amr.corp.intel.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Haitao Huang <haitao.huang@linux.intel.com>
Cc: Jarkko Sakkinen <jarkko@kernel.org>, dave.hansen@linux.intel.com, linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org, cgroups@vger.kernel.org, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, vipinsh@google.com, kai.huang@intel.com, reinette.chatre@intel.com, zhiquan1.li@intel.com, kristen@linux.intel.com

Hello,

On Mon, Jul 17, 2023 at 03:19:38PM -0500, Haitao Huang wrote:
> Actually, we are using atomic_long_t for 'current' which is the same width
> as long defined by arch/compiler. So new_usage should be long to be
> consistent?

We can use atomic64_t, right? It's slower on 32bit machines but I think it'd
be better to guarantee resource counter range than micro-optimizing charge
operations. None of the current users are hot enough for this to matter and
if somebody becomes that hot, the difference between atomic_t and atomic64_t
isn't gonna matter that much. We'd need to batch allocations per-cpu and so
on.

> ditto for event counter. Only max is plain unsigned long but I think it is
> also OK as it only compared with 'current' without any arithmetic ops
> involved.
> Did I miss something here?

I'm saying that it'd be better to make everything explicitly 64bit.

Thanks.

-- 
tejun
