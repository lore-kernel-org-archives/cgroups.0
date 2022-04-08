From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix attach task fail when subtree_control
 configured
Date: Fri, 8 Apr 2022 07:54:26 -1000
Message-ID: <YlB20sw1e998Dant@slm.duckdns.org>
References: <1649413394-17501-1-git-send-email-zhaoyang.huang@unisoc.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4Ro5wZmz5/qjQoMRhhyRUYMmqQbliREDVqsZ81z5Kko=;
        b=XtxAWitQSB4YBg/9d5jI5GEOZ55aoUF9Ezg/KdD/yMNC9r0yJU7zSrbgzPwx18YsZx
         O7EST5Hup1HYNHyOuU4Gn9xc8kgTc50AWCNDyWpH96BU/O0M7IZLyXntwdM83AvkGJx0
         9PBjLSKeeTk3O17dhV6Cbu6xFO80FcqAIZl0Bxf4Gb+VmR1lg8G6R2ByX7tqfRsZwi2X
         cz34XrBlVXwdt9kcfWX9nfoM9MHeJNJ2omo4yRRqk1a4fZVRvx+lsDRFjzMYYuIxYhB3
         vEP/YhRJE9996VGhwLWbVyM+6pqzFpowHBWHijc3tlSK37o4UU2aJAnzuMENi0Bp3wyd
         WH8A==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1649413394-17501-1-git-send-email-zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "zhaoyang.huang" <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Zhaoyang Huang <huangzhaoyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ke.wang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org

On Fri, Apr 08, 2022 at 06:23:14PM +0800, zhaoyang.huang wrote:
> From: Zhaoyang Huang <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>
> 
> It is found that task attach to a vacant cgroup will fail when its
> subtree_control has been configured. Fix it by judging if there is no chrildren
> existed.
> 
> Signed-off-by: Zhaoyang Huang <zhaoyang.huang-1tVvrHeaX6nQT0dZR+AlfA@public.gmane.org>

If I'm not misunderstanding, that's the intended behavior. Can you please
take a look at Documentation/admin-guide/cgroup-v2.rst and confirm what
you're trying to do?

Thanks.

-- 
tejun
