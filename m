From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup: check cgroup liveliness before unbreaking
 kernfs protection
Date: Tue, 2 Sep 2014 11:51:19 -0400
Message-ID: <20140902155119.GB17424@htj.dyndns.org>
References: <5405A27A.3090605@huawei.com>
 <5405A2B2.4010406@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=wcruqjLMIhT9bQkE1JRDkd2FTd7pF7a45hg+VxbVHG8=;
        b=w3Ypxmm7tvhgnGpPa2Tr6Qvj50av44+JyvsEeg1dyRzUxAfswNTWohIgQpMcr2j2gP
         Ttg1qDtDlkN+Q79ULq3MKtJs+PvpJtr/rhHjSgtjJRMBi45XSUDWD0nMLsJ3FLnKlhx1
         41lF+4gyhSw15tacro6y3K6g9xyugCLdhE9XYuuOioaz7ze1jndO6av/7zXvThCXn4Bb
         R6fzXzDie8SJvRrgyt1j57hyaglSe75SuCqJTq51NpKItFOC91V2nMmisVwTxznPvvSa
         hIm9wyiK0SkJdKgjWxcl5tD1fa+JrWS+v4vRb9X53bxg1kszMmyB6oMvj7KWiSI4/J+W
         4qNA==
Content-Disposition: inline
In-Reply-To: <5405A2B2.4010406-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster-Mmb7MZpHnFY@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Sep 02, 2014 at 06:57:54PM +0800, Li Zefan wrote:
> diff --git a/kernel/cgroup.c b/kernel/cgroup.c
> index e03fc62..c8d07e5 100644
> --- a/kernel/cgroup.c
> +++ b/kernel/cgroup.c
> @@ -1025,6 +1025,11 @@ static umode_t cgroup_file_mode(const struct cftype *cft)
>  	return mode;
>  }
>  
> +static bool cgroup_tryget(struct cgroup *cgrp)
> +{
> +	return css_tryget(&cgrp->self);
> +}

Can you please move this right below cgroup_get() definition?

Thanks.

-- 
tejun
