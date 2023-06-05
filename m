From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: remove unused macro for_each_e_css()
Date: Mon, 5 Jun 2023 09:20:57 -1000
Message-ID: <ZH41mW1D7TiY2Q0f@slm.duckdns.org>
References: <20230527093353.153078-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685992859; x=1688584859;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KkYFVdwirk/CiSbxka53j0MJonMcdF+VrPWbomHwsf0=;
        b=RK7/RNQleMDrPiCfrmVZurlIU9JePH+Mhf/Rzp7SPRwBezlKh1ohmTLzfjPTQq4/4o
         h0ON8jvMUvg8SuKqth9Cc252vwHoUyXbDZinaUcVIryadUsSDYcGDRpQk0AQbJU/4sMu
         npGFPEjVaxwqKeFRZC8iXEumGUjFftp+PJ3MVDUIGMWImM62/g4UZqWzsi74Eo5d54mr
         sC1wVHj4mn/8gk0dCuq6NEoW0YE3Of3cJ137rTian6GOfFoX53H76f7NfL+V6ZjnETC2
         /3ZzPHtEnUK3iux6R9YadkPTtuLijwWgBStBof+7ocGFf5Pwa2SEnyN6tA/immYIoHe+
         TVZA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230527093353.153078-1-linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, May 27, 2023 at 05:33:53PM +0800, Miaohe Lin wrote:
> for_each_e_css() is unused now. Remove it.
> 
> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-6.5.

Thanks.

-- 
tejun
