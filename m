From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup: Use separate work structs on css release path
Date: Wed, 1 Jun 2022 14:29:23 -1000
Message-ID: <YpgEY/lJbLidLOhc@slm.duckdns.org>
References: <20220525161455.GA16134@blackbody.suse.cz>
 <Yo7KfEOz92kS2z5Y@blackbook>
 <Yo/DtjEU/kYr190u@slm.duckdns.org>
 <0babd7df-bdef-9edc-3682-1144bc0c2d2b@linaro.org>
 <Ypf0VnKUMiuRgZqT@slm.duckdns.org>
 <1fb4d8d7-ccc0-b020-715e-38c2dfd94c23@linaro.org>
 <Ypf5jpI7dSmpi4W0@slm.duckdns.org>
 <c3bd8e63-7204-f86d-8efa-254db71185fc@linaro.org>
 <Ypf/MpwzByOrSp6A@slm.duckdns.org>
 <416dc60a-f0e5-7d05-1613-3cd0ca415768@linaro.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=cd8OZfkfOfbdrVH9nYcg5+3JeiqoxxNBfwL2one6FPI=;
        b=jnHM3OC9fRgEf/1zuyaXHSXBeile/rBcpDVd8BJSs0VVnbhYPwNj+cWPNmgQAmvHeW
         4iGEMcxNC+qiLljZ8z8i9CJvG5r8NHZhqNXaUcIrZ84DpP51x+Ahhebso1nAqKjD/OTn
         b3uitEK1RVAtJ8oXA9Mjm5zS61EZ7uHPRLfDDeqOHSPjRwvoj63mJd51XZRJLAvEmGp3
         QSj1724wDBVcxczmWh5BVAFAZcgYw0QupcnmzOa25Oyrii6AtIl4Dq+nhwGTL0fpfSrs
         xtjKtGmnYxhc18OuN0W283tCI7OwaZS3UwG99PfIVIXxD7PzY/+AGupJgN9a9Ho1ypod
         yPNg==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <416dc60a-f0e5-7d05-1613-3cd0ca415768-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tadeusz Struk <tadeusz.struk-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Bui Quang Minh <minhquangbui99-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Wed, Jun 01, 2022 at 05:26:34PM -0700, Tadeusz Struk wrote:
> Ok the problem is that
> 
> 1. kill_css() triggers css_killed_ref_fn(), which enqueues &css->destroy_work on cgroup_destroy_wq
> 2. Last put_css() calls css_release(), which enqueues &css->destroy_work on cgroup_destroy_wq
> 
> We have two instances of the same work struct enqueued on the same WQ (cgroup_destroy_wq),
> which causes "BUG: corrupted list in insert_work"

#2 shouldn't be happening before kill_ref_fn() is done with the css. If what
you're saying is happening, what's broken is the fact that the refcnt is
reaching 0 prematurely.

> So I think the easiest way to solve this would be to have two separate work_structs,
> one for the killed_ref path and css_release path as in:

If you do that, you'd just be racing the free path against the kill path and
the css might get freed while the kill path is still accessing it.

Thanks.

-- 
tejun
