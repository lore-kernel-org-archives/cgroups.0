From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: minor cleanup for cgroup_local_stat_show()
Date: Tue, 25 Jul 2023 11:53:08 -1000
Message-ID: <ZMBERCXR27X_gRAt@slm.duckdns.org>
References: <20230723031932.3152951-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690321990; x=1690926790;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0NAyxb3rFJ8DVsDZGRmjKUAotFVj47uT2nzJm7HWZdo=;
        b=BfCSapNPBI0ZoQl7ctCkDeeepZfQfgulGN6gyOx0/0sueOCMg+/WgJwjCPjwW3s7hW
         As1hkOmgewEGqke6eHhJvmEbq87INwhshGea5/sb/WfzBODNRJK7fhdlZToVMq+A1htr
         4ePA7C2h6x9qm2k/fMq/5VJCfu3cr8cuxm1LD0s75OxL9svbACeumsBL+xfUyqbGEgmK
         svKjR8R3RvK+0HnPwQ+l0b9+sPwzgfQsvvJU8Qg+LRE+n0KAup5JxRsWGQYsYoGkEvcI
         9eohhry1vatEoRG1AJ7Fhxb2wYQ3AVE+aSokm9icL/xt4EMOlpExIw/o9wRjVpi42jl9
         ptTw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230723031932.3152951-1-linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sun, Jul 23, 2023 at 11:19:32AM +0800, Miaohe Lin wrote:
> Make it under CONFIG_CGROUP_SCHED to rid of __maybe_unused annotation.
> Also put cgroup_tryget_css() inside CONFIG_CGROUP_SCHED as it's only
> called when CONFIG_CGROUP_SCHED. No functional change intended.
> 
> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Patch doesn't apply to cgroup/for-6.6. Can you please respin?

Thanks.

-- 
tejun
