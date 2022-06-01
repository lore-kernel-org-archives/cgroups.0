From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup: Use separate work structs on css release path
Date: Wed, 1 Jun 2022 13:43:10 -1000
Message-ID: <Ypf5jpI7dSmpi4W0@slm.duckdns.org>
References: <20220525151517.8430-1-mkoutny@suse.com>
 <20220525151517.8430-3-mkoutny@suse.com>
 <20220525161455.GA16134@blackbody.suse.cz>
 <Yo7KfEOz92kS2z5Y@blackbook>
 <Yo/DtjEU/kYr190u@slm.duckdns.org>
 <0babd7df-bdef-9edc-3682-1144bc0c2d2b@linaro.org>
 <Ypf0VnKUMiuRgZqT@slm.duckdns.org>
 <1fb4d8d7-ccc0-b020-715e-38c2dfd94c23@linaro.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7PESzE8t9Lz5OlcxB//4LK+p9oMKSM6zcC2n6BmadAw=;
        b=jHJn4C6EiJHA/wfbqAQg3eI1uA1ryOPpUfynKm2uBWrty9D4XBUkhXQsUOCu8Ikhwu
         iVYsfkSi/+o3cLOVcI5ZyKmBF7MxnXoGXarYCVp0tjZJi+p1jPoO32tClD0Br+10qT/l
         MNzpDLGps7NWAom3zY3tMYa+qyWKS8pf0lMnNEwwTFZrO/rFkAxMbpaeTR7OmACjNSB1
         IFDWyE6bhFvYaHyil6X1QfkkFo4k5n87TeCTA2uIf/Noxk1bQtApnZbci3+E7v58fL0m
         8Yec0B87XoSKOGKUALuX/BcsiU/15e/J7BvPuB7UjnR0Xxvk2nsD1fomvrZh21l6114g
         Wy1Q==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1fb4d8d7-ccc0-b020-715e-38c2dfd94c23-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tadeusz Struk <tadeusz.struk-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Bui Quang Minh <minhquangbui99-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Wed, Jun 01, 2022 at 04:37:17PM -0700, Tadeusz Struk wrote:
> Yes, but as far as I can see the percpu_ref_kill_and_confirm(&css->refcnt, css_killed_ref_fn)
> doesn't change the value of the refcnt, it just causes the css_killed_ref_fn() to be called

Yeah, the base ref is special for percpu_ref.

> on it. Only css_get() & css_put() modify the refcnt value.
> And for the "free the thing" the css_killed_work_fn() does that.
> It calls offline_css(css) and css_put(css) for the whole css hierarchy.

Yeah, the freeing path depends on the css_put(css) invoking css_release()
which schedules the work item which actually frees. Am I misunderstanding
something here?

Thanks.

-- 
tejun
