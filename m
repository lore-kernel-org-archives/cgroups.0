From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH][next] cgroup: Avoid -Wstringop-overflow warnings
Date: Wed, 21 Jun 2023 10:42:20 -1000
Message-ID: <ZJNgrLEE7i9CfUnS@slm.duckdns.org>
References: <ZIpm3pcs3iCP9UaR@work>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687380143; x=1689972143;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=efNPwXii9p40aEa8rDVFFS1wZk6ktbvmOO6XguzWEk8=;
        b=DeEC7sohDKZ9WK1hcV069v/RrKf2OYtk4yfm9LUKkOHgANu2oXKTruOpn63bjz7Q00
         Rk3blTvq+RMsoJPzTG4zlVbWhm+8YOxVCuhSrA5Or82BE5oVnjnmd1xZdJVHsa7GA8t7
         /pS6bsBroCBBVQW6m1q7B0ex5DB/6rg18UhAXCRVI+4GCe31PJD8GGSK9Cx2MHbqZK6U
         H6OSOvUB1kH3m1iZc0be1q2EO4rxGDGGydfX/1u+KOx+C2GQe0QRA+uJzAo67smH96kJ
         ZZGZ/shnstWohFx9RAOhKZDAsZY7mQGJJxHOqbKb/qyz0l4Uk5rIfbRqhHO4Zl4dNeIg
         2+Wg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ZIpm3pcs3iCP9UaR@work>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: "Gustavo A. R. Silva" <gustavoars-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-hardening-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

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

Applied to cgroup/for-6.5.

Thanks.

-- 
tejun
