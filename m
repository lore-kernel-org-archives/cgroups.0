From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [External] Re: [RFC PATCH] blk-throtl: Introduce sync queue for
 write ios
Date: Thu, 15 Dec 2022 06:46:54 -1000
Message-ID: <Y5tPftzjXN6RcswM@slm.duckdns.org>
References: <20221206163826.10700-1-hanjinke.666@bytedance.com>
 <Y5et48VryiKgL/eD@slm.duckdns.org>
 <1e53592f-b1f1-df85-3edb-eba4c5a5f989@bytedance.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NtuasfiQwAVb7T7lHLup3YJ84O51YLi79K4mOD3jS5A=;
        b=hZ4Cot94gaF1e87/TucVOwB8o680736L461Il3xZ+KPnmu5CDTodnJjoxNhGI8jm/P
         ezzK6dmlX/iVzaI7KzXIoaOBAJ5qVX+ZsNI1FmMinXUp7f25Ja3zydw9ku6cOyd3u3+N
         j4nsXWLh/j2KY6m/XKiuAkRuwaLR7sGHukq0kX3UPrF00AMnQQTj5WRPw7fqziSIWjtD
         FS821KiSlWhilmJ2BKonUoauhCstgpIzJcskq9dEH0djxjxX7IwfuBbzIj/EFqkYwvRa
         9g5rakZUJwAy+N1If+4CzOizhNWKm/7dRP1W/6Cu7Zmriycj7YQjkSssTxulOU7U6ZrK
         HZGw==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1e53592f-b1f1-df85-3edb-eba4c5a5f989-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: hanjinke <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Cc: josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello,

On Wed, Dec 14, 2022 at 12:02:53PM +0800, hanjinke wrote:
> Should we keep the main category of io based READ and WRITE, and within READ
> / WRITE the subcategory were SYNC and ASYNC ? This may give less intrusion
> into existing frameworks.

Ah, you haven't posted yet. So, yeah, let's do this. The code was a bit odd
looking after adding the sync queue on the side. For reads, we can just
consider everything synchrnous (or maybe treat SYNC the same way, I don't
know whether reads actually use SYNC flags tho).

Thanks.

-- 
tejun
