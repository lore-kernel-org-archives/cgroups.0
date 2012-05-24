From: Sasha Levin <levinsasha928-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup: make css->refcnt clearing on cgroup removal optional
Date: Thu, 24 May 2012 15:21:20 +0200
Message-ID: <CA+1xoqdbtkC5Ue3s1qZHHJBLcj9a=djFDGny6AJJSV-pdn7mcA@mail.gmail.com>
References: <20120330223423.GJ28934@google.com> <20120330223606.GK28934@google.com>
 <4F77B6BA.4070207@huawei.com> <20120401185430.GA9230@dhcp-172-17-108-109.mtv.corp.google.com>
 <CA+1xoqe5hMuxzCRhMy7J0XchDk2ZnuxOHJKikROk1-ReAzcT6g@mail.gmail.com>
 <20120518175548.GM19388@google.com> <CA+1xoqfr5aaGbxoX3YKrJHXTjU9fWSbX_xbuEOU=4K7kMay6XQ@mail.gmail.com>
 <20120523222242.GD3933@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        bh=OrKPIODVXNSaG9RHhq7FpqKCDHmgHcq64WJHLnsxKuw=;
        b=VW49T6R6dhR0LHgn0XmHK2UpjcXlYQZUG7MU6UyRjibXsinStCKcknqJDsq+G26DDe
         igdr06xU2rB1wUMjG9+lhgE5K2HEiUWjhZVHOMjPC3A0AEItEwb5nvja9toiV/K9Kmuo
         BgP5+RTZC/uMrC5FmkaRjB9O5QUpUzgnuAZe3lF8uVxjh2PXbv7Ao61AoiclRZ4BNQe5
         Do0A/U7z6OzQD3x6bUFoo6wuYULp0gWqcPNGIo/AfYiTIOGx+WRCNOlEknA4H+9uBh7W
         rU6ilJwsuy14bTARGdLftebCfiW4l7DXLVlyj/NucuKHj6HlbQSIlnoiU3Qrg+KwR1nk
         fXKA==
In-Reply-To: <20120523222242.GD3933-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>

On Thu, May 24, 2012 at 12:22 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello, Sasha.
>
> Does the following patch fix the problem you're seeing?
>
> Thanks.

Yup, that did the trick.

Thanks!
