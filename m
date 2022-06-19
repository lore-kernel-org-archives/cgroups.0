From: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
Subject: Re: [PATCH v5 10/11] mm: lru: add VM_BUG_ON_FOLIO to lru maintenance
 function
Date: Sun, 19 Jun 2022 12:49:21 -0700
Message-ID: <Yq99wcC8wJ/2swzw@castle>
References: <20220530074919.46352-1-songmuchun@bytedance.com>
 <20220530074919.46352-11-songmuchun@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1655668170;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XTYDF9D1xRBqvEkIY/ONzMnvR1i6T1Y9BCxsJP7NEik=;
        b=iL6YfmMAG2p0X/5gbwURAp46tCZ3JVCg5XQj8j0kJcfdzd8GpZcwIqK+rrSh2+DfTLgrS/
        fHu0/cvEEvB2i/JDQmg9tGfO7fv+/SvuWHRs+6CJwMgnFSjnJifTMszZdW4NvhhpIw0Y0p
        AqIgK1bpEvvdpQX1YXV1oWGvXxQUtqw=
Content-Disposition: inline
In-Reply-To: <20220530074919.46352-11-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, duanxiongchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org

On Mon, May 30, 2022 at 03:49:18PM +0800, Muchun Song wrote:
> We need to make sure that the page is deleted from or added to the
> correct lruvec list. So add a VM_WARN_ON_ONCE_FOLIO() to catch
> invalid users.  Then the VM_BUG_ON_PAGE() in move_pages_to_lru()
> could be removed since add_page_to_lru_list() will check that.
> 
> Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Acked-by: Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>
