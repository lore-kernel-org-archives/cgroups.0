From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: minor cleanup for cgroup_extra_stat_show()
Date: Mon, 10 Jul 2023 10:23:54 -1000
Message-ID: <ZKxo2gzxmBMCKrE5@slm.duckdns.org>
References: <20230706094242.1707709-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689020636; x=1691612636;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9g3hnCKeeyeonNdi0zcIUQvwxiCz8ApNLGQhrycIqAg=;
        b=InVMQ/VHuNqtCpU4ma8Y21k3oB+fidG93tXHBhrC3ZOKYvY/UZG4FsP66pjY0mgpDJ
         3pv3u/0paL3IwW9nRC9ZrNoiMMuKN25Im4NcY3lF2dlzQp/b/DmcluJqVVszIH0AsKRC
         AtUnniXbcxTE5nJE3D6iTs/yjmGh3dcJ+n6U7bWrJikla5ZnWTEiNJS7mFcIoYiqJce2
         xgwrPsTcojI/lkJZ/N7crWEIaywUMgnpBk2+FlYr5pwtxxiYXRVrFCmbz3CCtQc29kuK
         U2B8zjrFqdM9TEIyFlPRnPLd1uxDwlPRZ1wOeOXzAPXK3qujLb2mGu+byssJ+BclvlX3
         x5jQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230706094242.1707709-1-linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Jul 06, 2023 at 05:42:42PM +0800, Miaohe Lin wrote:
> Make it under CONFIG_CGROUP_SCHED to rid of __maybe_unused annotation.
> And further fetch cgrp inside cgroup_extra_stat_show() directly to rid
> of __maybe_unused annotation of cgrp. No functional change intended.
> 
> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-6.6.

Thanks.

-- 
tejun
