From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup: Use separate work structs on css release path
Date: Wed, 1 Jun 2022 14:07:14 -1000
Message-ID: <Ypf/MpwzByOrSp6A@slm.duckdns.org>
References: <20220525151517.8430-1-mkoutny@suse.com>
 <20220525151517.8430-3-mkoutny@suse.com>
 <20220525161455.GA16134@blackbody.suse.cz>
 <Yo7KfEOz92kS2z5Y@blackbook>
 <Yo/DtjEU/kYr190u@slm.duckdns.org>
 <0babd7df-bdef-9edc-3682-1144bc0c2d2b@linaro.org>
 <Ypf0VnKUMiuRgZqT@slm.duckdns.org>
 <1fb4d8d7-ccc0-b020-715e-38c2dfd94c23@linaro.org>
 <Ypf5jpI7dSmpi4W0@slm.duckdns.org>
 <c3bd8e63-7204-f86d-8efa-254db71185fc@linaro.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ae4Em02O4DoW8HqZVWLGSrl5wgz4cCAQSui5vC+qx38=;
        b=SWcH+oItm/XxdIwRq5d7dWi4k8EsrLve4tmhF9StwgkVAeB/ST+4WCb9E2NxUXGT7g
         q8GzCidpe0aYC1tY7l8ZUuV3j01269AWUz6gdiLCMvRT1p3tEmlx+qW0snAnBV5OPGvM
         DXLvnYtjOFtN4WUjBBpXkIykso8QRjUpr72FdUS3296sgzRusW3cir5K4s1OLzUYhfRF
         Pou3Y74c4/+dj9zMDvz0Zgiu/uUCvVLNWgOZqow7iX/ggarDUwyyXCSl/j1RSV5uOUC2
         +1gBSrqQvr/7wPpt4i7OoAuLFKu0wYhBLeQV3POlB/VGAWkw5GU4UB8qeT7IAzJsl6Dq
         tB4Q==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <c3bd8e63-7204-f86d-8efa-254db71185fc-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tadeusz Struk <tadeusz.struk-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Bui Quang Minh <minhquangbui99-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hello,

On Wed, Jun 01, 2022 at 05:00:44PM -0700, Tadeusz Struk wrote:
> What I'm trying to say is that it's not really a ref imbalance problem.
> I think once the kill_css() has been called on a css, and it is enqueued to be
> killed, we shouldn't call css_put(css) on it anymore outside of the "killed call
> flow path". It will all be handled by the css_killed_ref_fn() function.
> 
> The fact the css_release() is called (via cgroup_kn_unlock()) just after
> kill_css() causes the css->destroy_work to be enqueued twice on the same WQ
> (cgroup_destroy_wq), just with different function. This results in the
> BUG: corrupted list in insert_work issue.

I have a hard time following here. The kill / release paths relationship
isn't that complicated. The kill path is invoked when the percpu_ref's base
ref is killed and holds an extra ref so that it's guaranteed that release
can't happen before the kill path is done with the css. When the final put
happens - whether that's from the kill path or someone else, which often is
the case - the release path triggers. If we have release getting scheduled
while the kill path isn't finished, it is a reference counting problem,
right?

Can you elaborate the exact scenario that you think is happening? Please
feel free to omit the function calls and all that. Just lay out who's doing
what.

Thanks.

-- 
tejun
