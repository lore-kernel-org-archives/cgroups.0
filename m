From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2] kernfs: add kernfs_ops.free operation to free
 resources tied to the file
Date: Mon, 10 Jul 2023 10:38:46 -1000
Message-ID: <ZKxsVuDqdr6IJeyv@slm.duckdns.org>
References: <CAJuCfpF=DjwpWuhugJkVzet2diLkf8eagqxjR8iad39odKdeYQ@mail.gmail.com>
 <20230628-spotten-anzweifeln-e494d16de48a@brauner>
 <ZJx1nkqbQRVCaKgF@slm.duckdns.org>
 <CAJuCfpEFo6WowJ_4XPXH+=D4acFvFqEa4Fuc=+qF8=Jkhn=3pA@mail.gmail.com>
 <2023062845-stabilize-boogieman-1925@gregkh>
 <CAJuCfpFqYytC+5GY9X+jhxiRvhAyyNd27o0=Nbmt_Wc5LFL1Sw@mail.gmail.com>
 <ZJyZWtK4nihRkTME@slm.duckdns.org>
 <CAJuCfpFKjhmti8k6OHoDHAu6dPvqP0jn8FFdSDPqmRfH97bkiQ@mail.gmail.com>
 <CAJuCfpH3JcwADEYPBhzUcunj0dcgYNRo+0sODocdhbuXQsbsUQ@mail.gmail.com>
 <20230630-fegefeuer-urheber-0a25a219520d@brauner>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689021528; x=1691613528;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AANwmYnIjrNG1ny8ADZlcMF6VhBoiSpdnMPHT/u0j+U=;
        b=a9vlDHib/vMGEM7aj5ZziEIfVB9053U+yrZ7to7Yd8hR15TTgPRZXqM+aIlJDlWKPY
         CrJBsGBouks3CfFEd3QRv1Yh7dQm6xNAOqgHHU3VN9DNSaL1+tpwRU5rlXJO9ismFxe4
         Hq/4DleBOQdSXFD+XjWaDWY5xLt3mvgWf3U05EAxLNXXbn71AVZT33qR+hN/ZA7W5iti
         j2FlnXR+XTocZTLDWBsxKRyv8pcEf/x0EXhFXyFuz/MUiowyCCXOmCwW+UUzggU47gSN
         4bXR7XPV2Dca04qA0GJHy7NqllrEwRZPjVMgpFgoNDCPdqsRtEzr3a5JOoqHOKvIgcfJ
         pOfA==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230630-fegefeuer-urheber-0a25a219520d@brauner>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Suren Baghdasaryan <surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, lujialin4-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiggers-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, oleg-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vschneid-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org

Hello,

On Fri, Jun 30, 2023 at 10:21:17AM +0200, Christian Brauner wrote:
> What I'm mostly reacting to is that there's a kernfs_ops->release()
> method which mirrors f_op->release() but can be called when there are
> still users which is counterintuitive for release semantics. And that
> ultimately caused this UAF issue which was rather subtle given how long
> it took to track down the root cause.
> 
> A rmdir() isn't triggering a f_op->release() if there are still file
> references but it's apparently triggering a kernfs_ops->release(). It
> feels like this should at least be documented in struct kernfs_ops...

Oh yeah, better documentation would be great. The core part here is that
kernfs is the layer which is implementing the revoke-like semantics
specifically to allow kernfs users (the ones that implement kernfs_ops) can
synchronously abort their involvement at will. So, from those users' POV,
->release is being called when it should be. The problem here was that PSI
was mixing objects from two layers with different lifetime rules, which
obviously causes issues.

As Suren's new fix shows, the fix is just using the matching object whose
lifetime is governed by kernfs. While this shows up in a subtle way for
poll, for all other operations, this is almost completely transprent.

Thanks.

-- 
tejun
