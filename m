From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] cgroup: Avoid compiler warnings with no subsystems
Date: Fri, 27 Aug 2021 07:51:05 -1000
Message-ID: <YSkmCVwLvfusqtmA@slm.duckdns.org>
References: <20210827150424.2729274-1-keescook@chromium.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=c65PIoZtXrK5fG5yv9bS73WbrNpIpRgBV7KDj6Yda9o=;
        b=IdBLcrm3jZpcZrU/u1e8c49BCTkbf1fL9uye8pgEDvFivomEZ9CkjJScQHaslx8MRm
         Z6ks5DWfj9tf0yvzUXn43NlaS9EfJwcKUVcLkq4Fsg4leSe/mR+pAC7EsMr6gXo4QgGn
         4oWayV3tbdmwUCY5PZbZwTkREOjQIy+dZjVa4VbMu3KZf4tjv2j9UGMw1oWQB2aDAer9
         v1j/drh3EWQe92JJWBb2osEz1CcA6O/fPmWIJqrI7Rg26DcZ5kOdV8Y5P0KAmE47EJwe
         lQeUASFfUjFpg/jfmeKvlS81m/BhLeF/vUPhalCfuaspJz6FMd2QpFM22zcvLMeej0s/
         0ENg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20210827150424.2729274-1-keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-hardening-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Aug 27, 2021 at 08:04:24AM -0700, Kees Cook wrote:
> +	if (CGROUP_SUBSYS_COUNT > 0 && ss)

Can we encapsulate this in a macro so that it's clear (or at least
consolidated) why we need these without adding a comment in each spot?

Thanks.

-- 
tejun
