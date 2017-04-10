From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH]  Remove cpuset_update_active_cpus()'s parameter.
Date: Tue, 11 Apr 2017 08:58:29 +0900
Message-ID: <20170410235829.GB28603@wtj.duckdns.org>
References: <20170409013614.7138-1-rakib.mullick@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=sNB9vrfJFBTbyutNebWmrMV06nB5wcrdI7id8PjARXw=;
        b=Kbpvd6zZPN7iajzZ0yO3ea8XohVOl7TZ2Gl4sdyot+Lf2J9CbX6CT51O+MVPmkhQR4
         piuFlbOumuDI6taLcgP1bqpYj64A7IaTieiLGZHI5/921z0LfAZm5vIuRP4tEQCq5LfY
         8pSsJ+uXn9aYCy3s1xL7UoRITenDwZfYSaHXx9abJYvVyHQHAuKMyiGP0rVwY4SGfYC+
         IRlIkhG7OpYDmRU1Qqy0wqMGAmUcuVXKiVLxGBXCLspxVJDBzCmIQI2hb+Tb2jsZneI4
         OPrJkg9jyKrnTPHcy/fN0kS1X4TU8cpdNp5KYyJDMwYQa0bTYTbjZR2D2ewQJTXJhDLD
         4m6A==
Content-Disposition: inline
In-Reply-To: <20170409013614.7138-1-rakib.mullick-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Rakib Mullick <rakib.mullick-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

On Sun, Apr 09, 2017 at 07:36:14AM +0600, Rakib Mullick wrote:
> In cpuset_update_active_cpus(), cpu_online isn't used anymore. Remove
> it.
> 
> Signed-off-by: Rakib Mullick<rakib.mullick-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Applied to cgroup/for-4.12.

Thanks.

-- 
tejun
