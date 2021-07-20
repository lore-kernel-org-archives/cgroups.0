From: Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] memcg: charge io_uring related objects
Date: Tue, 20 Jul 2021 12:39:31 -0700
Message-ID: <CALvZod5RGZwta+Dpeak9McQd=n_QShzooALCsYrMLbz3ihSiBQ@mail.gmail.com>
References: <1626675625-9883-1-git-send-email-nglaive@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=L+MjaH1R1E0F0RWN0i5cSWeDaZRVcDk5Z+roBLBaQww=;
        b=SZzRTqY+pX1aPq5w/WdqDiLB176GplKJ66paQIBWPcVU2KYjcig77AvWa8ubb9Jt8p
         7x/G+AWlv+nLASckmvWWav9PPCbmOqfdl1tOlLC6Q6igjzYwMhYYbsKhVCtbneYxGIVK
         HNrMuYnL6TNDY6EkyhfX17PrbaPZpVYf/YkF93m66+0SJgEZJx5GrPBuJN6CsVV0Q0oL
         pYGUZ181yxFFld48EYPQi+Yx4ypEMf3hgUjhjd9AnIKI6jylx0pjPBVpDES/dXF9JxAR
         OR/SwlcnoT/YOiRLp/zEcZ8gzMy+FBSnB9YbHgJ0g2Ol/G7V4z/QVJngwpcq1lI4tqlO
         oaGA==
In-Reply-To: <1626675625-9883-1-git-send-email-nglaive-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Yutian Yang <nglaive-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, shenwenbo-Y5EWUtBUdg4nDS1+zs4M5A@public.gmane.org

On Sun, Jul 18, 2021 at 11:20 PM Yutian Yang <nglaive-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
> This patch is a more complete version than the previous one, adding
> accounting flags to nearly all syscall-triggerable kernel object
> allocations. The patch does not account for temporary objects, i.e.,
> objects that are freed soon after allocation, to avoid meaningless
> performance penalty.
>
> Thanks!
>
> Yutian Yang,
> Zhejiang University
>
>
> Signed-off-by: Yutian Yang <nglaive-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Can you please bring back the commit message of the previous version
(which has the program to trigger the unaccounted allocations) and can
add the details on this one to that?
