From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -next] cgroup: Make cgroup_debug static
Date: Tue, 17 May 2022 07:06:45 -1000
Message-ID: <YoPWJZ+RJmlvBLwV@slm.duckdns.org>
References: <20220517112523.243386-1-xiujianfeng@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jf4s8QIDSrOKg81HbuSA52ij+q0WBYhYTRAF+5w+aLk=;
        b=VtoWTUwBib/p6g9+5Y6v7nCk/SG4snA+neR+JdtetOycCsBah4LsINBvKMmAVfJtbR
         VbiMQdF3H+44sT0KlE99hveW4lREXTpNV7FbX1ZjPTQGDakMHFYGIGYAvVsk/RNBOdIA
         lNJuw4/hWrPpWYmDGJjQUeJTXttNjagmUPdfKaYkFjSw42oqlfPmIaUhR6b1uOyHihot
         O4q3FiZOfGQwlrJ0v52lIES4ktkkdYtvY6bW7STRDlnYNlND0CIUTNX7pqtuAf9Vchv5
         pzqkTDAN+l+uYcWxT1e+knThpmgWlXfPDZiwbUF996JX6DRDdSh2ttcOQqpwo6eUTUEa
         68gw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220517112523.243386-1-xiujianfeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xiu Jianfeng <xiujianfeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, May 17, 2022 at 07:25:23PM +0800, Xiu Jianfeng wrote:
> Make cgroup_debug static since it's only used in cgroup.c
> 
> Signed-off-by: Xiu Jianfeng <xiujianfeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

The only thing it does is gating CFTYPE_DEBUG which isn't used anymore.
Can you remove both CFTYPE_DEBUG and cgroup_debug() instead?

Thanks.

-- 
tejun
