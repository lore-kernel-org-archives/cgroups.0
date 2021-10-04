From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/1] cgroup-v1: Grant CAP_SYS_NICE holders permission to
 move tasks between cgroups
Date: Mon, 4 Oct 2021 06:41:39 -1000
Message-ID: <YVsuw+UBZDY6Rkzd@slm.duckdns.org>
References: <20210617090941.340135-1-lee.jones@linaro.org>
 <YMs08Ij8PZ/gemLL@slm.duckdns.org>
 <YMs5ssb50B208Aad@dell>
 <CAJuCfpHvRuapSMa2KMdF4_-8fKdqtx_gYVKyw5dYT6XjfRrDfg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DaLvQvhsWsf+s4lKV5/UMhvRlT3UszqwQeMdAkp1K3Y=;
        b=quXUJID1FdabBGz7mwElEsxPvEcN27h5uU84QFos6CG76Q06RyCwmCRrgwdJ/NtBSe
         eI4YUiwaxF8nBTgUyf0Eapc+zxNNJHBe1gG+O0Kr+uf1lk4zedFsGmcJp8foUlAnk9qF
         ZaKp6+1M+vsx1Vykw52NXb3FwgFrlIfaERdI+0fCUn2Dt8HTz0rp1OxrcLDBbCTkQtcH
         Zw/QwqmiIcpMerEn2QnER5fJkHTlgAQeBEHR3rzdbS8TMMmMzP13C33iHchRML/2fJPj
         d7qvROcOuYc8A14dJR3AIYR7r5o3jQRTeRo9bsfCA0gmgpIZPs22J6pCCFqhdJgpDbp/
         q9Zw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJuCfpHvRuapSMa2KMdF4_-8fKdqtx_gYVKyw5dYT6XjfRrDfg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Lee Jones <lee.jones-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups mailinglist <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Sep 30, 2021 at 02:20:53PM -0700, Suren Baghdasaryan wrote:
> Some of the controllers are moving to cgroup v2 but not all of them
> are there yet. For example, there are still some issues with moving
> the cpu controller to v2 which I believe were discussed during Android
> Microconference at LPC 2021.

Care to provide a summary?

Thanks.

-- 
tejun
