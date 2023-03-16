From: Josh Don <joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] cgroup: fix display of forceidle time at root
Date: Thu, 16 Mar 2023 11:52:58 -0700
Message-ID: <CABk29NuKPJAVFCJ=i2Qh4=UqPoj5aia01-mCiF3p8vebV3uPWg@mail.gmail.com>
References: <20230315214029.899573-1-joshdon@google.com> <bfbdef64-1b8c-4168-2576-f6d4a112686b@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1678992790;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h1W/YlEcuttY3U+vH0Zvi8N5CN0MRI21GzH8QWAyVcI=;
        b=Lat+lKQfUS8qaHdbgQZoN+LZJ35jZBofHf93jeA469v8V8xyILhxZ+ts9CUZjkmXG4
         BbOsppMk1ngvHvYqHcCR8mIv1Ai6oqZ0J82FEJaLC7Jw5+YnuB86WMQq76w5MdLh/hsV
         xnUwyu2dXI2LCGJXqS424ufkp3xGGJAbtKYKOQmSQhDwW1JAqJt3Rpg+EzFHFkPZXFdH
         cqVf30QcR/9JUr0XM1+OT4Z0QBBo7OV8m+HCyQGbdr/t+5TGOKhEooqc26/y6FP1R0pw
         k7g9H+qG/GeBUhVNf9fAqrS8yCyfH/ZH7aVRbTPn2QIPARVF3t6WP7325CEJl5rRB9Ek
         nGUA==
In-Reply-To: <bfbdef64-1b8c-4168-2576-f6d4a112686b-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed, Mar 15, 2023 at 7:19=E2=80=AFPM Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wr=
ote:
>
> How about adding the following fixes tag?
>
> Fixes: 1fcf54deb767 ("sched/core: add forced idle accounting for cgroups"=
)

SGTM, thanks Waiman!
