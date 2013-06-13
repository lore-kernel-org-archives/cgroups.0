From: Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 04/11] cgroup: use kzalloc() and list_del_init()
Date: Wed, 12 Jun 2013 19:43:10 -0700
Message-ID: <20130613024310.GC10979@localhost>
References: <1371070996-20613-1-git-send-email-tj@kernel.org>
 <1371070996-20613-5-git-send-email-tj@kernel.org>
 <51B93038.9010202@huawei.com>
 <20130613023831.GB10979@localhost>
 <CAOS58YPv_uKeTqZSNF=sXTEnLn=LTbsdpBPM5K_ykXoVT-+CpA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=zXkyJugx8yzkkjQcaXts1gfYVKokut0W8heItRdREBU=;
        b=c3pJwmh5k1KQRaeJTcI7pHAb5iaJ0Q+SKac/rQqttISPY28P0WxIrfXoLNyLgSerVn
         IszhFtJDZ9L0VnJn9sqIBsrFsSb8uWL5EllaisTNmvbh8Nhze/zwd916eeQ2dB2jebli
         SDfmkfxPWVTAiKTPTZ/nwuO7pcu5deHyTuVNcQB1e5AznwikcWnpgfFJMzLaofelRwOr
         HzWvEX9fWKJoCt3kTvC0f/oAODyBk+swhWSpQxG6x4oP8DP/xYPZdK3JleudC98Gsp9O
         woZZUJbg9DYgclsVjCgJ1matWyJs3bvNxNp7S5VggdK4G4kaamI9u0rlU3LOQvKzoRFR
         vHFA==
Content-Disposition: inline
In-Reply-To: <CAOS58YPv_uKeTqZSNF=sXTEnLn=LTbsdpBPM5K_ykXoVT-+CpA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Lameter <cl-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>

On Wed, Jun 12, 2013 at 07:41:15PM -0700, Tejun Heo wrote:
> Hello,
> 
> On Wed, Jun 12, 2013 at 7:38 PM, Kent Overstreet <koverstreet-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org> wrote:
> > IMO, list_del() is preferred when the object shouldn't be reused (i.e.
> > it gets taken off a list and then it's freed). list_del_init() could
> > hide bugs.
> 
> Nah... use-after-frees are detected much more reliably by poisoning
> anyway. Using list_del() instead of list_del_init() to hunt down
> use-after-free isn't a good idea because you're likely to corrupt the
> memory of unrelated area. I really don't see much point in using
> list_del().

list_del() does do poisoning - and list debugging is cheaper to enable
than full slab debugging.
