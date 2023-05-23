From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH -next] cgroup: Remove out-of-date comment in
 cgroup_migrate()
Date: Tue, 23 May 2023 09:09:20 -1000
Message-ID: <ZG0PYH7a9Mw50bEl@slm.duckdns.org>
References: <20230523111456.146053-1-xiujianfeng@huaweicloud.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684868963; x=1687460963;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6z5OxRlNGFDksqOxV/WuukP5r2QPiQu+c1cFCQeYYDE=;
        b=Fjq2/r2eJg8sxpSURL2bskZvWvE/vaukNbU7Hr8dfPIbfks/WfaA/iyDBHVTG8qLJU
         JSB9bDnVnCl6OVMYqZUoI+EesTtZdzvDLno5/pKHSv4+GsSV1bcnjjfj7Ek3iCEzQGeD
         frvVPGI/tA0gYTokSJptMu17N3CwYUDVFjP4tIkW+2vZeXRxUbpm1G9O/qun6DmIua58
         Y2L0+Gn9PNMJaTqxqjoWTBqgutnxtV7+35UlkNhouHeG1VXbNcd23UnjO1m244dz3LO/
         AMXiW6ga2oIQmmzpTL3V8d749fuuxrZfi8lvkmeN8VHijWOZAnMsJGSESis1fSslZ2/J
         10lA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230523111456.146053-1-xiujianfeng-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Xiu Jianfeng <xiujianfeng-XF6JlduFytWkHkcT6e4Xnw@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, May 23, 2023 at 07:14:56PM +0800, Xiu Jianfeng wrote:
> From: Xiu Jianfeng <xiujianfeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> 
> Commit 674b745e22b3 ("cgroup: remove rcu_read_lock()/rcu_read_unlock()
> in critical section of spin_lock_irq()") has removed the rcu_read_lock,
> which makes the comment out-of-date, so remove it.
> 
> Signed-off-by: Xiu Jianfeng <xiujianfeng-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

So, that removed rcu_read_lock() because it's implied by the irq disable but
the comment content is still useful in describing what's preventing
use-after-free. Can you please update the comment accordingly instead?

Thanks.

-- 
tejun
