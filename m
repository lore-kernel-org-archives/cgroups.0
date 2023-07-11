From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: put cgroup_tryget_css() inside
 CONFIG_CGROUP_SCHED
Date: Tue, 11 Jul 2023 11:46:28 -1000
Message-ID: <ZK3NtKHk_w7XoAVZ@slm.duckdns.org>
References: <20230711023820.3854596-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689111990; x=1691703990;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kyzlh81U6Ju2jWhDiLjgeqy7+sksvV31PzhzVl8MBhQ=;
        b=aPy0SNz9dz6HANDuditq55E3EjWQCri+A9re2o5i05xDNLrJFWA3izghbC7A0uVoJX
         QXALQHOutvp97mrZej0leDFB9kp4fGa85LoQzCdj+tc3cLv8A4jq4qxl8mtrGA4KRm1I
         kZPJXtt6NQJLOZ+QnPOuM4vJLWnGnmOMb6SyFhJ+htPUt3j7eGUQAiCWFv/6KBkW3zqJ
         TSuapNB3+JMMaZ32q/jC9za6PUB4IoZEonxcNSv0qFTuFGXVfGDQGXDQjK/lapCVElIf
         NZN2Y0E5H6oI5UHwpiITD7sDl1DcXH9Ei8bQ2+2j3rs5OlXpTtdihDw6hMW1tCJ0l0KT
         00rQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230711023820.3854596-1-linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jul 11, 2023 at 10:38:20AM +0800, Miaohe Lin wrote:
> Put cgroup_tryget_css() inside CONFIG_CGROUP_SCHED to fix the warning
> of 'cgroup_tryget_css' defined but not used [-Wunused-function] when
> CONFIG_CGROUP_SCHED is disabled.
> 
> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-6.6.

Thanks.

-- 
tejun
