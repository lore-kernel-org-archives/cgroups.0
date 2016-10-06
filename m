From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCHv12 1/3] rdmacg: Added rdma cgroup controller
Date: Thu, 6 Oct 2016 18:25:11 +0530
Message-ID: <CAG53R5WdFE-Ck7iQrsqrVEAPn0OoL5DM4RNwa3Ayc+W0jggUEw@mail.gmail.com>
References: <20160911171409.GA13442@obsidianresearch.com> <20160911172445.GA25953@lst.de>
 <20160911175235.GB13442@obsidianresearch.com> <20160912050717.GE8812@leon.nu>
 <CAG53R5X4stfy5+Jmg+XReUJqt56Z-zABK+UEswHW1dXhH-9cNw@mail.gmail.com>
 <20160915185629.GF26069@leon.nu> <CAG53R5XBS0B5XaTzjKC3-zgoB2-fz2ctbk_E2YG76zBgzOfG-A@mail.gmail.com>
 <20160921142645.GB10734@htj.duckdns.org> <CAG53R5WMuojhzFGmqk6nHfypd9Hq4dGsWRKjtUyMZ=RezU-LhQ@mail.gmail.com>
 <CAG53R5VqQ6UzsuzcovsD+ufv3HaEQEbUpaf3kDo4zLOrAf__8A@mail.gmail.com> <20161005063735.GC3086@lst.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=ZcVLgQjwc+umJ7q4OTP5f6y7HwkkPqFUOY7ja1naT/w=;
        b=OB2aIO9AEzQq8yy7vLs2zQTb5fH9liSA3KcEUYYGvbRIXMMp56PLlccNOq7AdMKVTW
         g7dNAcfR9uDRHayEF1o9jybOX+TGkJ2/wn2Cpfv+U94pH8WvpDwQVd7v4yW7se3lWOvD
         2ZOLMvLo6/cqHrmLf7YcEBqS+0Jkr+LGYGm7wptIKtvjR/ykcGXz/k8QOpF4f9IEtOce
         x6v56/ZtxYFhjOmDQKs7Sl3oJmxLTEXDdPGVGmz5cwbF0Xz4MzBl5c2vImgb0955xGtb
         +WtXktDHYP7DewsDjBvvzbczoWIcGjFE26UXFzx6bubnwVScUPYLq4iV0sNIJvIuLEla
         Ul7Q==
In-Reply-To: <20161005063735.GC3086-jcswGhMUV9g@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi Christoph,

On Wed, Oct 5, 2016 at 12:07 PM, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org> wrote:
> FYI, the patches look fine to me:
>
> Acked-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
>
Thanks a lot for review.

Parav
