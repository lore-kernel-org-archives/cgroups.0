From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH] cgroup: minor cleanup for cgroup_local_stat_show()
Date: Thu, 3 Aug 2023 10:27:58 -0400
Message-ID: <20230803142758.GC219857@cmpxchg.org>
References: <20230803113123.577023-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20221208.gappssmtp.com; s=20221208; t=1691072879; x=1691677679;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8CXtNf2juTpnNbc2iwpH+iIlLPgtlL44HuZlVb5tpAE=;
        b=we6Fk7q9zEhw+CJrONTMaJeY7V/kFX0HXrXBKxV2JUSNlNTJWCPnPehRlsHF+z0blk
         sCi0pOw0r/N0CWun/xl5QKYU5EqnUJgwj5FZ8JNAqoJy1DQT2hCMZCnpOuWyGc48sE3D
         sTyG5UxVGS4xRHYoxx1I/z/P48lOZIsUcjeK5qGjLLilXjY5rsapUi4EEYINt6r3pbBr
         gPVHJC6fpUvkYchQcfc6WKZCHsLYaReFuKXCga7sr7uJ92TuEhl1w+DkcZxa64DNoiBq
         hx0rO7pxXlDuzIVFdnJkvgOiXqqxD81njci1PpeY8re9g1MiTPuvkpD2EJIKFDJIHVOh
         ol4g==
Content-Disposition: inline
In-Reply-To: <20230803113123.577023-1-linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Thu, Aug 03, 2023 at 07:31:23PM +0800, Miaohe Lin wrote:
> Make it under CONFIG_CGROUP_SCHED to rid of __maybe_unused annotation.
> Also put cgroup_tryget_css() inside CONFIG_CGROUP_SCHED as it's only
> called when CONFIG_CGROUP_SCHED. No functional change intended.
> 
> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Acked-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>

> @@ -3686,8 +3686,9 @@ static int cpu_stat_show(struct seq_file *seq, void *v)
>  	return ret;
>  }
>  
> -static int __maybe_unused cgroup_local_stat_show(struct seq_file *seq,
> -						 struct cgroup *cgrp, int ssid)
> +#ifdef CONFIG_CGROUP_SCHED
> +static int cgroup_local_stat_show(struct seq_file *seq,
> +				  struct cgroup *cgrp, int ssid)

Andrew, this is based on "sched: add throttled time stat for throttled
children" in -next (coming in from -tip). Hence the routing through
you rather than the cgroup tree.
