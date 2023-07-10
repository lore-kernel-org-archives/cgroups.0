From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix obsolete comment above for_each_css()
Date: Mon, 10 Jul 2023 10:47:52 -1000
Message-ID: <ZKxueJGs6ZSgOWWV@slm.duckdns.org>
References: <20230627114059.1310936-1-linmiaohe@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689022074; x=1691614074;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vYfYEgruayK9dexrYha0GdoxGIRikS6sxUciqhG4Qug=;
        b=fyOST0vDrhBJq00W+LmsNke8ozMtF0Se8rBJWw4JfK0vMMI7TNm7wYtbHLx+Kg6npg
         /LZewepSK2hN9JNyTN3Z5s/afuJZIt6EQ9W8rMr0pFJ2X5hZHnCpV6v5o2RrOI6aQ/++
         ju4v9VPbHVmRvYeFYbg+OPt4k19azTSyN2Bv8+jdjN8cv9FY8eeLUmcZuFoMEL4/goXj
         rbst0fqlGHUtPIJ6MGFhJc2QtCWC3tzVSO5dk6IYVG1y3C1xg+0fwwxv42+LUMScv7XN
         2Rz9RDWAYiXWsV0eeqQkmzi19vHUGaZC4Uz6iyxx5+g3t1faCh2WHe3Rsh19aPRhRyBM
         3cLA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230627114059.1310936-1-linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Jun 27, 2023 at 07:40:59PM +0800, Miaohe Lin wrote:
> cgroup_tree_mutex is removed since commit 8353da1f91f1 ("cgroup: remove
> cgroup_tree_mutex"), update corresponding comment.
> 
> Signed-off-by: Miaohe Lin <linmiaohe-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Applied to cgroup/for-6.6.

Thanks.

-- 
tejun
