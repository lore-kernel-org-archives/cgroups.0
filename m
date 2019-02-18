From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] doc: cgroup: correct the wrong information about measure
 of memory pressure
Date: Mon, 18 Feb 2019 13:05:04 -0800
Message-ID: <20190218210504.GT50184@devbig004.ftw2.facebook.com>
References: <1550278564-81540-1-git-send-email-yang.shi@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9DzCR79XKeIjL7+2ReBiux03I1IsbcYYGjv2zjhhJ2U=;
        b=IvUXzBPQJEIyKxoXbz4dX0We4ImmqwmBbZb8b00WHoEnhmrQvX86N2WSx0rP1NzXFS
         uwDuVGKTJxW0Bg0RNeRMY2lqSxHlylMUB1QW2kusIPBR/1eSRw3pLDFw0DxTiX4xKIJH
         HI39c8dzh86yRNfROF1J4MTzi+z8cRaElf9D2wcp1bxf3Ak2psiTe3TVvbaMcSCeL0xz
         0v5+CKY58TFKGjYiJixaNyF/JCodpDsL5qER8CF0AdDGaUzq7o2WyEBYDVhxhqSvThX0
         wA2HOyR7hXaqWcIJ88Uhcpnx5RhK0K7pvEyKDaPBn85ZliSQTNNAHNknlI/GapPFjD4Q
         6KrA==
Content-Disposition: inline
In-Reply-To: <1550278564-81540-1-git-send-email-yang.shi@linux.alibaba.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yang Shi <yang.shi@linux.alibaba.com>
Cc: hannes@cmpxchg.org, corbet@lwn.net, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Sat, Feb 16, 2019 at 08:56:04AM +0800, Yang Shi wrote:
> Since PSI has implemented some kind of measure of memory pressure, the
> statement about lack of such measure is not true anymore.
> 
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Jonathan Corbet <corbet@lwn.net>
> Signed-off-by: Yang Shi <yang.shi@linux.alibaba.com>
> ---
>  Documentation/admin-guide/cgroup-v2.rst | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
> index 7bf3f12..9a92013 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -1310,8 +1310,7 @@ network to a file can use all available memory but can also operate as
>  performant with a small amount of memory.  A measure of memory
>  pressure - how much the workload is being impacted due to lack of
>  memory - is necessary to determine whether a workload needs more
> -memory; unfortunately, memory pressure monitoring mechanism isn't
> -implemented yet.
> +memory.

Maybe refer to PSI?

Thanks.

-- 
tejun
