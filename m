From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [Phishing Risk] Re: [Phishing Risk] [External] Re: [PATCH]
 cgroup/cpuset: Add a new isolated mems.policy type.
Date: Wed, 7 Sep 2022 05:26:09 -1000
Message-ID: <Yxi4EYxMaPNkL+of@slm.duckdns.org>
References: <20220902063303.1057-1-hezhongkun.hzk@bytedance.com>
 <YxT/liaotbiOod51@slm.duckdns.org>
 <c05bdeac-b354-0ac7-3233-27f8e5cbb38a@bytedance.com>
 <YxeBGeOaQxvlPLzo@slm.duckdns.org>
 <d323bd95-476b-0901-855e-14c8796d1b23@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date;
        bh=T6N91VXL3P8JDR20lw0om2klLL1DyAPfzo9iAd40Kjg=;
        b=K8P5YEaVd5+q3A8nyGjz9haRwLkLdQ+3gkZT7IJhCoE9Z+aDbjvnVaJy3IpbnK+4Id
         Tpxl2i7/GxiWvlli2vFfE7Ztdv8G5GRIbcWSFH25XSFKKNEWuyJ6AQ5DguaKT7l/2mSI
         ZDskeA/7IG6yx76IgwlZRdc3SsNYF2GeoboK3BZxyQ0ZhEqj6tjBzrraJI8rORFGu3Ou
         8wOLposlrWgOCaQjVL71crILG+qiz94TwejqdrmGgiZ3Aa4YF6/rlCdLnOr50W0B2NWZ
         fLofVTge7UqV6obw9NLTxpzwdxdrWtMUGXkXGaV7x019QsbiXbGAhPsME/qXNJHoOHbA
         +/Bw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <d323bd95-476b-0901-855e-14c8796d1b23-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Zhongkun He <hezhongkun.hzk-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Wed, Sep 07, 2022 at 08:06:30PM +0800, Zhongkun He wrote:
> It would be better if one process had a way to dynamically modify the
> mempolicy of another process. But unfortunately there is no interface or
> system call to do that in userspace.

If you need to change the properties dynamically, I suggest adding this as a
dynamic per-process interface first. That's more generic and useful for more
cases.

Thanks.

-- 
tejun
