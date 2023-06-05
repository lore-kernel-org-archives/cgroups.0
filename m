From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -next] cgroup: Replace the css_set call with cgroup_get
Date: Mon, 5 Jun 2023 09:42:54 -1000
Message-ID: <ZH46vtiFKHu_f7gv@slm.duckdns.org>
References: <20230602074346.333276-1-cuigaosheng1@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685994177; x=1688586177;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1Q8kSKP9++RgTXV8bTvJUl35GTdFE0i1aFw7qo8YRcA=;
        b=st9XK94tNgN4BG9lXJHA34tKteBoTDSg3G12r3RGCadsgXM31vIpI+8D93lfZVOfEo
         zpcP3cw3krv/31bKyMPvY+CYuoz1XuIqjtvJIYNuzQWxdSld2iPSi896/mzbnoAjgZSu
         lXGzC+oMLNNihl3LP0sobt+LQIebd40GxamN7HpseTr5okTdA4gyOKTjhbexmdaVLd2x
         nQYnWnOjVQwjNrZ2f4w6n1YPwm2EmAagNkajnVHIrSYWHejRmzEkUDDkNz1PSUIzfcGh
         IhPtVlbr0rzBlrD6DOMd0gtDdZ69uJcd7nXuYtkgtRkbihgY9ueV+cj+FBNQjCaSJL00
         /vIg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230602074346.333276-1-cuigaosheng1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Gaosheng Cui <cuigaosheng1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Jun 02, 2023 at 03:43:46PM +0800, Gaosheng Cui wrote:
> We will release the refcnt of cgroup via cgroup_put, for example
> in the cgroup_lock_and_drain_offline function, so replace css_get
> with the cgroup_get function for better readability.
> 
> Signed-off-by: Gaosheng Cui <cuigaosheng1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-6.5.

Thanks.

-- 
tejun
