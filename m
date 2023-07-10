From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: remove unneeded return value of
 cgroup_rm_cftypes_locked()
Date: Mon, 10 Jul 2023 09:40:01 -1000
Message-ID: <ZKxeke6SfBe37Jso@slm.duckdns.org>
References: <20230701073856.2095425-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689018003; x=1691610003;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ivhLVKhACKnZhgX7GHkfgbJfc6Z11Wv6X0HCdw2KFv4=;
        b=ig89NSSNCjVNIUtp+LTVjG7HGB9E2wmkZykr4cZYhYKHnJFmCdAGyPdHPq24XHeZ5t
         hnJlw4JRuHka8VDdhWnaF6l4pvXy5vYPzk1YOJk0BMhyTBtJl/WAso1qUD9w8T5i4sfD
         sP+V8Z0/l0dO+K6u8JrMmWsvjD3pq2ldsDSfS21zyooQOmjDkGzgZgoFFKiAVTodTlLf
         HRa0L0HYZNmrg8tPBz/z9BB5+lD7zUb1TCDiTowsYQreCy4xRFPUtFrQGDjHM8UiLiFf
         hK+bIaVW6ZCjCO7gDPGpGf0WMVGRe9PcCiGNrl7BvNDMKJNF3PA7fflK5i2ggufGx7if
         /4pg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230701073856.2095425-1-linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Jul 01, 2023 at 03:38:56PM +0800, Miaohe Lin wrote:
> The return value of cgroup_rm_cftypes_locked() is always 0. So remove
> it to simplify the code. No functional change intended.
> 
> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-6.6. Please feel free to follow up with the comment
addition Michal suggested.

Thanks.

-- 
tejun
