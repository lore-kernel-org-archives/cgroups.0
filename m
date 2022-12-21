From: Daniel Vacek <neelx-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: no need to explicitly init a global static variable
Date: Wed, 21 Dec 2022 09:49:28 +0100
Message-ID: <CACjP9X90VT=sd_wT9MWg062qs=CRadsaj6V9gOMXSEJ7Up5Hzg@mail.gmail.com>
References: <20221220151415.856093-1-neelx@redhat.com> <9295b73a-5a3c-b1f6-d892-0da1d356ab9f@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1671612606;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4dBwPnF71tq2OBO2+/MVeKfW3ISUERpMcMh5zSeUYQo=;
        b=Dvwe/fgv3RdROeps1ZWhjDPLHSHBwevbfmt7eSB2Nzc53XzlRvHPQ7iyE4BLI/ntvzfkJG
        PmEmykTwOIWB2xPKOLcuuQO7ydgU3PENnNPS+tkaZNU9Qyy/dpADEx8VBFlj9AOwqnkZ/M
        tjTN2VjC35GFEkZMPiFFsn7vZ/cwS5A=
In-Reply-To: <9295b73a-5a3c-b1f6-d892-0da1d356ab9f-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Dec 20, 2022 at 5:59 PM Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>
> On 12/20/22 10:14, Daniel Vacek wrote:
> > cpuset_rwsem is a static variable. It's initialized at build time and so
> > there's no need for explicit runtime init leaking one percpu int.
>
> It will be clearer if you mention that DEFINE_STATIC_PERCPU_RWSEM() is
> used to set up cpuset_rwsem at build time. Other than that, the patch
> looks good to me.

That's true. I only figured later.
Whoever is going to apply it, feel free to amend the message if you like.

--nX

> Cheers,
> Longman
>

