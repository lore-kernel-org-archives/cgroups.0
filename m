From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] cgroup: avoid cpoied names in cgroup longer than max
Date: Tue, 12 Dec 2017 07:54:56 -0800
Message-ID: <20171212155456.GA3919388@devbig577.frc2.facebook.com>
References: <20171212014349.5036-1-mashimiao.fnst@cn.fujitsu.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XF+z74JaHmufzagJCcKxJmdkBaMDKLWZt89QnYX0dBg=;
        b=KecWkzQYkI91hNNMWD9qdircwy8CCXkiT6+j38sk+lbI8GxACvUqCP3eXb+r9Hmice
         RCXEnc5ps7VmGygXvZv9+/RQs3K2nvqmzovyoMntNyowoWIzvM0OYR72f4Rjd5InPd7S
         VJQS8Emrffgti+lQsXG2fQ4JPInnxf+/Fc99rGhJEd7A+9PAkBmQhbynFhGCoan/X6wg
         JU+zyMLBVJtEjHEeaxXoXigVkxBZoY76C4H1aGn8y6ZuLS9hWsnxlok5ffj4XZwQDWks
         jPFdYTh/m2swrN22aEdNQuZD1AJikr4ixmElahFyu/kTeZ9JuMGbYJttYerce0Pc1X3M
         3vrg==
Content-Disposition: inline
In-Reply-To: <20171212014349.5036-1-mashimiao.fnst@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Ma Shimiao <mashimiao.fnst@cn.fujitsu.com>
Cc: lizefan@huawei.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, Dec 12, 2017 at 09:43:49AM +0800, Ma Shimiao wrote:
> cgroup root name and file name have max length limit, we should
> avoid copying longer name than that to the name.
> 
> Signed-off-by: Ma Shimiao <mashimiao.fnst@cn.fujitsu.com>

Applied to cgroup/for-4.15-fixes.

Thanks.

-- 
tejun
