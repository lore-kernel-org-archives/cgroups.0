From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix obsolete function name in
 cgroup_destroy_locked()
Date: Thu, 3 Aug 2023 10:10:53 -0400
Message-ID: <20230803141053.GB219857@cmpxchg.org>
References: <20230803115702.741128-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20221208.gappssmtp.com; s=20221208; t=1691071854; x=1691676654;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YK1kR5msnkStlX/fQur0EoisiWFGZLTUdGslkPaUGUk=;
        b=UFOM7zDVQVcS3LfF/4QazEBXoUPkF5omxMvrFErHuGjaX/itDvATmOxiOE101O+XMw
         gy8iScRh4vaPBjWLFKcTsyeaw5iLs4Wu6simJm1pMbYQMfGTfZz8rmpbjV3TXtOVh60T
         YtAfMqN1tYQyoFfKOcgZ2HDeANRxU8tctaXUHZYCq+W3Kagr5a07jSL42pUev4wm3b0h
         FfWGxKAR53Xvdc/JXLg891qsRI1LjYV81hCLfsAYeVeiOKkE/Wv51Rup2osuUe27Emhy
         Q2bOYlT5SDplenN//8wyLqeEdGGC4NH8nFk9PaAG3zOL163k7T/MRD7QRT66ot4e2Eu5
         qTpg==
Content-Disposition: inline
In-Reply-To: <20230803115702.741128-1-linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Aug 03, 2023 at 07:57:02PM +0800, Miaohe Lin wrote:
> Since commit e76ecaeef65c ("cgroup: use cgroup_kn_lock_live() in other
> cgroup kernfs methods"), cgroup_kn_lock_live() is used in cgroup kernfs
> methods. Update corresponding comment.
> 
> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
