From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH][next] cgroup: Avoid -Wstringop-overflow warnings
Date: Tue, 20 Jun 2023 12:51:04 -0700
Message-ID: <202306201250.6FA10ADF4@keescook>
References: <ZIpm3pcs3iCP9UaR@work>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1687290665; x=1689882665;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fEQfxADvgSzjQCfBomhgDaEgGtqyU75um/V6Dxu05cc=;
        b=bYg+oupnLPHq6deMXlRsxgjqDTrfbi7ADGIUtbQfBQXgJObZaO/KjayEbPgKT45RRz
         icYzOrlCbPuoaZu8Xl+6oXqqOBi/yyNQJ8SwgCBgJUredayRBaNxkcYKZygJDu16iCwy
         OMnbMkyBU6X4YOPCSK3RdowMxqqtNjyQ0QM8Y=
Content-Disposition: inline
In-Reply-To: <ZIpm3pcs3iCP9UaR@work>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Gustavo A. R. Silva" <gustavoars-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-hardening-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Jun 14, 2023 at 07:18:22PM -0600, Gustavo A. R. Silva wrote:
> Address the following -Wstringop-overflow warnings seen when
> built with ARM architecture and aspeed_g4_defconfig configuration
> (notice that under this configuration CGROUP_SUBSYS_COUNT == 0):
> kernel/cgroup/cgroup.c:1208:16: warning: 'find_existing_css_set' accessing 4 bytes in a region of size 0 [-Wstringop-overflow=]
> kernel/cgroup/cgroup.c:1258:15: warning: 'css_set_hash' accessing 4 bytes in a region of size 0 [-Wstringop-overflow=]
> kernel/cgroup/cgroup.c:6089:18: warning: 'css_set_hash' accessing 4 bytes in a region of size 0 [-Wstringop-overflow=]
> kernel/cgroup/cgroup.c:6153:18: warning: 'css_set_hash' accessing 4 bytes in a region of size 0 [-Wstringop-overflow=]
> 
> These changes are based on commit d20d30ebb199 ("cgroup: Avoid compiler
> warnings with no subsystems").
> 
> Signed-off-by: Gustavo A. R. Silva <gustavoars-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Ah nice, this should reduce code size for the "0" case too.

Reviewed-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

-- 
Kees Cook
