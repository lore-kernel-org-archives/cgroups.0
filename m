From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: remove unneeded return value of
 cgroup_rm_cftypes_locked()
Date: Tue, 11 Jul 2023 11:40:23 -1000
Message-ID: <ZK3MR5liSMSrlKVm@slm.duckdns.org>
References: <20230701073856.2095425-1-linmiaohe@huawei.com>
 <ZKxeke6SfBe37Jso@slm.duckdns.org>
 <27428e7d-e280-2f78-7856-056d4e174057@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689111625; x=1691703625;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bzWAKJljFotAV5RnvCyAUBH4oa3yNrE3i5b8cXS4wDs=;
        b=H01SSHIb1kS93H6HNYS/RLOyZc28d9HFwfIOpFx4oZPNYDhZvhiUTVu1TkqFq3e7Yy
         DcuRfyEW04VrLtmT/urRmUi6zZ00CHAOW2ABnQUc9rtno7jgsA1XeG366wfTuHiFm/kK
         gUMlKOcH2Pfgf/f2VvC2K97MrnNyyaJ2rWY9rBhQKn86qSW+UCWTn/rIMPuO+Mf7aqgV
         e5evxzYfzYBiAGDi77p53xjSWUcVXvE/wfo6LlsPIk8HBOT+S7jFgkINsbxjSq6hccQ5
         UhyInggwinXaLec/Q+VgspeCqGvvaV9uS+kZhwBMX2MQjHRYW20uZCqibWzIlde+Dy7e
         9Urw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <27428e7d-e280-2f78-7856-056d4e174057-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jul 11, 2023 at 11:00:58AM +0800, Miaohe Lin wrote:
> On 2023/7/11 3:40, Tejun Heo wrote:
> > On Sat, Jul 01, 2023 at 03:38:56PM +0800, Miaohe Lin wrote:
> >> The return value of cgroup_rm_cftypes_locked() is always 0. So remove
> >> it to simplify the code. No functional change intended.
> >>
> >> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> > 
> > Applied to cgroup/for-6.6. Please feel free to follow up with the comment
> > addition Michal suggested.
> 
> Should I send a v2 patch or a separate patch? Both is fine to me.

Please send a separate patch.

Thanks.

-- 
tejun
