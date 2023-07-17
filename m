From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: use cached local variable parent in for loop
Date: Mon, 17 Jul 2023 08:34:58 -1000
Message-ID: <ZLWJ0jYbNxK0q1Hw@slm.duckdns.org>
References: <20230715030829.2343109-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689618901; x=1692210901;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=goViAJVjt+VltPBDimAYth5M8v49WVfPG0UW7xjQVYs=;
        b=m6IuYLbfIdqHXBTmqDzWjN/BPrMu8eNhSlUTEXVXkTUr+Dt9u06nULrTWUdTy4FxKj
         XEQVoB1xkBIHKzTbsQsvnbskF1lGL3UWOP6eh+bCAiUKIzIngnWRhU12tW/TOdchEBXr
         kFwG1BBw94pFYxDLc25C9y+UaWEr5+w+B8gbY+t5mBqNE78wysiR9LXxYQNETRrXwb45
         WNCTq58auz6vSzBSP6eB9QX1DV4GnRq7rNNzBK7psbLgioU1fFqGP2ATSB1U78dyumYz
         UjJn3KjnqVk/WoatKkTiL9sesGS9NB88H/xe1QP8shzUVEFDohglpnWsTLWGqE8aagZm
         Kt5g==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230715030829.2343109-1-linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Jul 15, 2023 at 11:08:29AM +0800, Miaohe Lin wrote:
> Use local variable parent to initialize iter tcgrp in for loop so the size
> of cgroup.o can be reduced by 64 bytes. No functional change intended.
> 
> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-6.6.

Thanks.

-- 
tejun
