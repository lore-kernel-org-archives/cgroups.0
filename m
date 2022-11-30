From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2 10/10] blk-throttle: avoid dead code in
 throtl_hierarchy_can_upgrade
Date: Wed, 30 Nov 2022 11:36:08 -1000
Message-ID: <Y4fMyEo0dxPl/Kt1@slm.duckdns.org>
References: <20221129030147.27400-1-shikemeng@huawei.com>
 <20221129030147.27400-11-shikemeng@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eK6V1Iwqa8K2Cx4KZBhR6JdQyqcABL42POC5cN5uPd8=;
        b=hLqeV7uirai+WjRpqhtSE0U3RAdVMqJVdFGUPQL0QBlYwqYbxRVGxmZuLy4C7svch8
         rUpcA46/fiSWdxgqy/Xneo1ADSX2ac2tEJeZZv4LpRUMaMogrJd3f1X5vG6IwZxXt9yb
         YGXC2tNer8sHejbOuUg9T8QFikzVXopGQN+qJwUTzjAppe0y+G6q0gimx/QyauhPxDc1
         KdrkkzgxP9uONjaH60oXkm/233B2SwcsWyhp5F1EFa6pfhKGfH6t1S2WVbqb1OSR6rDZ
         062xhcp8WkK7/ILwpuL+1V6j2ae+6uV9zjJiYTbM1j5dg+I+iy2y6HK18XlTiDcg8KPo
         GKGQ==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20221129030147.27400-11-shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kemeng Shi <shikemeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Nov 29, 2022 at 11:01:47AM +0800, Kemeng Shi wrote:
> Function throtl_hierarchy_can_upgrade will always return from while loop,
> so the return outside while loop is never reached. Break the loop when
> we traverse to root as throtl_hierarchy_can_downgrade do to avoid dead
> code.

I don't know why this is an improvement.

-- 
tejun
