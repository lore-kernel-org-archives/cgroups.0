From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v2 02/06] kernel: cgroup: fix misuse of %x
Date: Mon, 6 May 2019 08:48:00 -0700
Message-ID: <20190506154800.GT374014@devbig004.ftw2.facebook.com>
References: <20190421114727.20325-1-huangfq.daxian@gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=LX6YFWpOFyks9hyOivtdYrKQenlUglNUVGne6XsM9M8=;
        b=CcTqdCliUeE1ZYvoBYOEJ0tHDuAM5vOzp2XWkvoudqqDauRGuQ+VCS/BmYqplP1ndW
         i1wkCyGAvyzC7WufXiQ4woED+t+TgUCIezlUm1qA1nJx/fdUuBMeJw+gGzdmvg73MT2a
         42Ff0r4lhGXsEdeBJ1OXv3WHSQ9cL1UfXyqmWFv+5RXoOBlB2OXbnQJLhd2aGnDE6nB4
         LmZDtsbylXhtLp3kxLQvYMlYpzScLiUNCMdfmffR67fy2Q88moE94mJ2f+JO7aRaIMA6
         ocjxZwY6kNGefZA7Q+qJfAqU5NKzBGsjnUOsC74SALI1+3jg8BAiDv6o2YrOegZFFAe9
         k6vA==
Content-Disposition: inline
In-Reply-To: <20190421114727.20325-1-huangfq.daxian@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Fuqian Huang <huangfq.daxian@gmail.com>
Cc: Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Sun, Apr 21, 2019 at 07:47:27PM +0800, Fuqian Huang wrote:
> Pointers should be printed with %p or %px rather than
> cast to unsigned long type and printed with %lx.
> Change %lx to %p to print the pointers.
> 
> Signed-off-by: Fuqian Huang <huangfq.daxian@gmail.com>

Applied to cgroup/for-5.2.

Thanks.

-- 
tejun
