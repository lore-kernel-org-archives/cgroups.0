From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: avoid unneeded cpuset_mutex re-lock
Date: Mon, 10 Jul 2023 10:26:36 -1000
Message-ID: <ZKxpfFeUVc3IKL74@slm.duckdns.org>
References: <20230704120352.1226787-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689020798; x=1691612798;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7xgjrQEr6levT2Vh4gm5c8CAJzd+VPW+vgoJrm3ih5I=;
        b=EsZBIRtDuJuW04K32p8u/Gh+PXrCbedviP0ImFheHGcG49q0PAmTdS14ZtPsv3tQPJ
         C2MOrVq12H6sUuqpRZVJ7+Bs31Dbfpff0lo5Ky2t08zmkpl4ff9SJCK5zyq1Z7o5AnS5
         2yBQk7FUrYUVrVRVMoGN2jrPiRpWjveMsSZPeQZPlkwXbmvTbl2Ja2/GTaYZ6+IDnFrb
         FdbtcgZFOPo2OcKcUcok4j4ERb43A7D+mdssF3rSgzA6JOYnZBbCo1AllZzg/nfG0UjT
         zbvbaw1mXEngcRIU4M2bK1clyOetrCBqjFhDmPNWzps/4bqGCwLXvJb7bJ5pRBVIr2lf
         L5qQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230704120352.1226787-1-linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jul 04, 2023 at 08:03:52PM +0800, Miaohe Lin wrote:
> cpuset_mutex unlock and lock pair is only needed when transferring tasks
> out of empty cpuset. Avoid unneeded cpuset_mutex re-lock when !is_empty
> to save cpu cycles.
> 
> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-6.6.

Thanks.

-- 
tejun
