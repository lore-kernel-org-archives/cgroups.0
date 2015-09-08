From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix seq_show_option merge with legacy_name
Date: Tue, 8 Sep 2015 14:33:57 -0400
Message-ID: <CAOS58YPMWNCwuAwFtgyQuBwuEkkGsKiqbXLE-jkVtgtGv3phZA@mail.gmail.com>
References: <20150908183043.GA23974@www.outflux.net>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date:message-id:subject
         :from:to:cc:content-type;
        bh=UYeDA2n8cY7vFgyDP1Y+DQxhGQFf1vh4K0E2l3XyFwM=;
        b=jWawE9v8IiVbKo5zo3gMPJhu3us2Pl1JbYp+qIjX6quGDTuzPOktpuO84vdkGVdIvi
         xFM9vRZFFGfC2y6zSFaz+tYir/myuGyuGUevFAa/g4XjZkE2pK/BtNtjjvB+KPkfPSkp
         5HftRsiXC8xsNHOwTrKeFz2Imvf5TN109Vzy05GUHisCGhaVo6+VlQdogUtnRO+exLnW
         xwD9idVsB/zOG2WaAdCix/wDfrDKdd7+UDYokwkaQohgw9wd3d1BQ2EvKSoceSrKt/LI
         MbMXh+oybGqgbrfelKbHv1/bSOFirvHP4ttM8rFWyCCREkNBZsjfnuxt0k59rvi5ryyN
         0efQ==
In-Reply-To: <20150908183043.GA23974-0X9Bc/hWBUTk6RaD4rd5nQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, Sep 8, 2015 at 2:30 PM, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org> wrote:
> When seq_show_option (068acf2ee776) was merged, it did not correctly
> collide with cgroup's addition of legacy_name (3e1d2eed39d8) changes. This
> fixes the reported name.
>
> Signed-off-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

Acked-by: Tejun Heo <tj-sDbnwqqx25gdnm+yROfE0A@public.gmane.org>

Thanks.

--
tejun
