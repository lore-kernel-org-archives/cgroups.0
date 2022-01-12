From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -next] cgroup: Fix cgroup_can_fork() and
 cgroup_post_fork() kernel-doc comment
Date: Wed, 12 Jan 2022 09:56:13 -1000
Message-ID: <Yd8yXXFIU102O/dy@slm.duckdns.org>
References: <20220108063812.50370-1-yang.lee@linux.alibaba.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dNkZ0++TsRPpQCPTOH0l2U03MNR7CYedQf/ILhGHDCQ=;
        b=FVHowSxzxH0lM5OYHTtnXmPdNNn6TwZTY9vMhwV3Kua4R5qH9ahghCKP7BgNpG7w93
         rInTEEox+Pdc4dBwQGdiXhYhIEZ0v6pTLbB4RUTpa8XAsxmzFxZ/yZj+CLIEibwO0QMr
         2alqRU8IwcePCT7PkUZXlrYLqAhIWA38/d9t/nQottPSJeyK9RWnFtx4SHVAr4y83d6Z
         ASGMC5Lca330QH44LwphBzPdIG13gOPVHf5k9fz+hl5kmRZdLBa3ZFmU+aqINGja6WkA
         auzGsDNGemwunjO2nW0VnddXmOXJoo/IsXbtnEISwViLWwN7svOrw8hwgNYTRCQuyaQ1
         Voig==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20220108063812.50370-1-yang.lee-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yang Li <yang.lee-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Abaci Robot <abaci-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>

On Sat, Jan 08, 2022 at 02:38:12PM +0800, Yang Li wrote:
> Add the description of @kargs in cgroup_can_fork() and
> cgroup_post_fork() kernel-doc comment to remove warnings found
> by running scripts/kernel-doc, which is caused by using 'make W=1'.
> 
> kernel/cgroup/cgroup.c:6235: warning: Function parameter or member
> 'kargs' not described in 'cgroup_can_fork'
> kernel/cgroup/cgroup.c:6296: warning: Function parameter or member
> 'kargs' not described in 'cgroup_post_fork'
> 
> Reported-by: Abaci Robot <abaci-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
> Signed-off-by: Yang Li <yang.lee-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>

Applied to cgroup/for-5.18.

Thanks.

-- 
tejun
