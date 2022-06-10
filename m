From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH v5 02/11] mm: rename unlock_page_lruvec{_irq,
 _irqrestore} to lruvec_unlock{_irq, _irqrestore}
Date: Fri, 10 Jun 2022 16:08:17 -0700
Message-ID: <YqPO4YhRJq7gTsjV@carbon>
References: <20220530074919.46352-1-songmuchun@bytedance.com>
 <20220530074919.46352-3-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1654902503;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=i7qscO1Vtb3X66YSDizljaZgEO4PdhU7TjZ1ZnrPRUo=;
        b=ZtiKgrfdV4L1XyviDb233nRIQBlSe9wmuFm6YDm+4CalI0EPaZbRXv2lNJK3+HtxrWskCh
        YbefZi4UBEK0dEtaQ2fz8mermVf8mItetmiXscBb/PV/Q5UbH1NdG5UOTU1s0nHZ7yiSJM
        Q1KDlojAGVtO+bOpJoAR/0KBVopsi20=
Content-Disposition: inline
In-Reply-To: <20220530074919.46352-3-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, duanxiongchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

On Mon, May 30, 2022 at 03:49:10PM +0800, Muchun Song wrote:
> It is weird to use folio_lruvec_lock() variants and unlock_page_lruvec() variants
> together, e.g. locking folio and unlocking page.  So rename
> unlock_page_lruvec{_irq, _irqrestore} to lruvec_unlock{_irq, _irqrestore}.
> 
> Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Looks nice!

Acked-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
