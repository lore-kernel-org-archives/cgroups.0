From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] MAINTAINERS: Update cgroup entry
Date: Thu, 31 Jan 2019 06:58:58 -0800
Message-ID: <20190131145858.GD50184@devbig004.ftw2.facebook.com>
References: <20190131142219.10175-1-andrea.parri@amarulasolutions.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=YisreuC3zrGql8vGIntXXcDgBVnywL4Va4Vu8WLo1iQ=;
        b=BnvTwXQl+sUA5bPGlHgb/uMP4W3E81CkUxMglbsvIAXefIlXexh7SNqgRgv1Mcrgb4
         LpusMYKTFLJQd9fNruMlTbE+Z/vWp00Mzs6c+rnZdaqFwZZOGdx0NWwy3ae9YKkzRZ36
         KaPqyUgzSfl1do7Zw8xldnsDaZ81VZpuHXuIx7hQZ40+HNoISRBVe9IdQmlk30sJoG6m
         zhbnPHDndqWtcBmdCXyLLyLINw504y7vZ5+MsXmcAnoS/MPwTTQZn0QCAsQEGZ01HO5T
         Y9Xh5M8u+TgEPti1zeNu0gbtoP5w4FMM+2OteO9OS6jJz/av8XbXR4xzgvXUdzza/Ad3
         c/BA==
Content-Disposition: inline
In-Reply-To: <20190131142219.10175-1-andrea.parri@amarulasolutions.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrea Parri <andrea.parri@amarulasolutions.com>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, Jan 31, 2019 at 03:22:19PM +0100, Andrea Parri wrote:
> Fix wildcard patterns and add cgroup-v2 documentation.
> 
> Signed-off-by: Andrea Parri <andrea.parri@amarulasolutions.com>

Applied to cgroup/for-5.0.

Thanks.

-- 
tejun
