From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup/rstat: check updated_next only for root
Date: Thu, 6 Jan 2022 11:55:24 -1000
Message-ID: <YddlTA/+sBAHGGYo@slm.duckdns.org>
References: <20211225000932.7253-1-richard.weiyang@gmail.com>
 <20211225000932.7253-2-richard.weiyang@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=baLlX8J8fiaO85yjXAAqEuWMCG9f2mB0MZtSG6XCtsI=;
        b=cxw8HDbt/q+HOmPJeOndfMSKKs6qZF3mxJR8F51mdDj4j41LtWMxrhBRGgusQeuiA+
         8bQ4nmKVrXwHsfSeYSA7gN9CtfGmQOvXdkTzxErRCKb8KjLk9S6WiaLSx3PsKeDuhqla
         4No7o5oXOXihiQTjKOZ+jS0+OKu+JsAND8bD0TvKCnnorVyItdSSqwqGg+ZITAuzUsH4
         ZbNu5RlF8ZEfPjqYKHQp83YwcTH0jvtqz+5el0wNpk5mIQLwlUEmBPiCziNgE5PRcy/V
         D6ybDhDIir0dtCMSEoBH/Cp4tOee6377q65jjrojwDpO0p/h8aIosrbQPX7hiBe2+RqZ
         hb0w==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20211225000932.7253-2-richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Sat, Dec 25, 2021 at 12:09:32AM +0000, Wei Yang wrote:
> After commit dc26532aed0a ("cgroup: rstat: punt root-level optimization to
> individual controllers"), each rstat on updated_children list has its
> ->updated_next not NULL.
> 
> This means we can remove the check on ->updated_next, if we make sure
> the subtree from @root is on list, which could be done by checking
> updated_next for root.
> 
> Signed-off-by: Wei Yang <richard.weiyang-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Applied to cgroup/for-5.17 w/ coding style fixes.

Thanks.

-- 
tejun
