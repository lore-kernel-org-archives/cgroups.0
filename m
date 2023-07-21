From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix obsolete comment above cgroup_create()
Date: Fri, 21 Jul 2023 09:55:14 -1000
Message-ID: <ZLrioiCmugdroXGJ@slm.duckdns.org>
References: <20230719090640.2568600-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689969316; x=1690574116;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ngS40wnJU6Nz9N58o+ae3RDY44wKRgOxGzApMOm7Pwo=;
        b=PqYaWRMTzF3Y28/FcPMachG4wI9LhwSaZoXAt9+dCQR7Eba996f6aZpcjo53JTvgSo
         sirafyLQw1T4DX2Nk5CzOyv0Zc0dxfg1NHI0blSN+8pydPzX54e3goFR3VkYC34KQasG
         lRVN2tZiUm1nEErmjkbZdtakLrmehiIQVaet4xSt0C7jB5/9z30Ab0A220xse6jKj0wF
         G7kVEMstTVdyRFAiWURMN2HV/0OmDxIbZ94gFR/BjgMI9yXjc4jJuXbp0w/KoYtcZbjn
         z16S3q86/Ka7KoCoIncxmSFH65UqpzO5YT9d1sf4pjaHgocJIr7UJbaJmx57jvcnYDdE
         p0nQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230719090640.2568600-1-linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Jul 19, 2023 at 05:06:40PM +0800, Miaohe Lin wrote:
> Since commit 743210386c03 ("cgroup: use cgrp->kn->id as the cgroup ID"),
> cgrp is associated with its kernfs_node. Update corresponding comment.
> 
> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-6.6.

Thanks.

-- 
tejun
