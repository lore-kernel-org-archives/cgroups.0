From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cpuset: Fix kernel-doc
Date: Tue, 22 Feb 2022 09:50:33 -1000
Message-ID: <YhU+iQ8GdN9JKjgs@slm.duckdns.org>
References: <20220216031753.8298-1-jiapeng.chong@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UXjqKNRIgAxMkX6Cqpc/qXekDEWeVq9e93BE44DZgy8=;
        b=bzNy2OQYqoF9fgSgZMFDD5DbAtgYNYLa2UZkmn8QOEBGt9Ddtu+Xm0gVwHi5NeBRLw
         Xanu1t2DcPXG0uuFeBVnkrZ5Xux/TYpApMgXLVHeNHAHNL//JZEQdgImpgwjuRR0U6pV
         9soDMPSrXsY1fjBNig2HWKxELREeNFI1I0Mj/hsX2erYiDcGUnLHDwJz3WXlGJQ1zUrd
         IwfAFtDasYah/dnF5DrT+KqRe9JPoX+z9vYIz6mvfVY88As2x80YUcXiD6OpuLEp38uX
         5UH+96wV1uLjy3PBjdqhvFOQsHaCBKqKihcj9VZWXAFEnNgsNY43d/+N8Y+vaG+dYOam
         Z8Zw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220216031753.8298-1-jiapeng.chong-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jiapeng Chong <jiapeng.chong-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Abaci Robot <abaci-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>

On Wed, Feb 16, 2022 at 11:17:53AM +0800, Jiapeng Chong wrote:
> Fix the following W=1 kernel warnings:
> 
> kernel/cgroup/cpuset.c:3718: warning: expecting prototype for
> cpuset_memory_pressure_bump(). Prototype was for
> __cpuset_memory_pressure_bump() instead.
> 
> kernel/cgroup/cpuset.c:3568: warning: expecting prototype for
> cpuset_node_allowed(). Prototype was for __cpuset_node_allowed()
> instead.
> 
> Reported-by: Abaci Robot <abaci-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> Signed-off-by: Jiapeng Chong <jiapeng.chong-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>

Applied to cgroup/for-5.17-fixes.

Thanks.

-- 
tejun
