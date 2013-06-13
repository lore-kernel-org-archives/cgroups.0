From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 04/11] cgroup: use kzalloc() and list_del_init()
Date: Wed, 12 Jun 2013 19:41:15 -0700
Message-ID: <CAOS58YPv_uKeTqZSNF=sXTEnLn=LTbsdpBPM5K_ykXoVT-+CpA@mail.gmail.com>
References: <1371070996-20613-1-git-send-email-tj@kernel.org>
	<1371070996-20613-5-git-send-email-tj@kernel.org>
	<51B93038.9010202@huawei.com>
	<20130613023831.GB10979@localhost>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        bh=LadXFs1QzO/rbLZEn8Ew45jKW2r/8PZEsm7rf9pzkMQ=;
        b=JckRXRD3FJiezOBcTaq4LCGPuWEdrruPWXCZ9H6Jw+0GYLIxc+0w2mOWw2LJq9JUCo
         r90JMjgkni9qlI71td6dHUwewWZbN1Aq+dR3Cp5F3fTq1FZdlsDhqyOHguXh12iLEmGz
         NbopXJVWQ/FzbKpGF75yIrTdbYR+CMNy0fa46tCdWCy7BfpjPpHhcgZYn395LYLEWCbJ
         E+m3C8jE+8SD8pUlPXwwik+iRqbT0YwZcWtQM6KKRgsfctIdmvvmpVC+o/QMYeNCq+Xp
         e6LcLwqF/aIdp+tfHJMCWO+MuYoVEfT7oeftdQu3I9mrCu58Y4uARhQt70XVJZ9Q/iUx
         rV0A==
In-Reply-To: <20130613023831.GB10979@localhost>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Lameter <cl-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

Hello,

On Wed, Jun 12, 2013 at 7:38 PM, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> IMO, list_del() is preferred when the object shouldn't be reused (i.e.
> it gets taken off a list and then it's freed). list_del_init() could
> hide bugs.

Nah... use-after-frees are detected much more reliably by poisoning
anyway. Using list_del() instead of list_del_init() to hunt down
use-after-free isn't a good idea because you're likely to corrupt the
memory of unrelated area. I really don't see much point in using
list_del().

Thanks.

--
tejun
