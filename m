From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3] blk-throtl: Introduce sync and async queues for
 blk-throtl
Date: Thu, 5 Jan 2023 07:35:59 -1000
Message-ID: <Y7cKf7IH+FJ/6IyV@slm.duckdns.org>
References: <20221226130505.7186-1-hanjinke.666@bytedance.com>
 <20230105161854.GA1259@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gkjsNq+41nhz5t6YNHufJptj0TXGHPydjE1ADy7+6FM=;
        b=F7AETA8YmQngoALJiwWtbL0ff8RtVbY4EEr53C6FVlL+DjvgCS7aideTdCWmxjFESd
         SeiRq631vXOAX++cF5PyZgvg1K66m5yYZ1/kNZWXsC6IwAeKeSZd5dJI25JEOakb5hTn
         koOxsxdTnhPtdbZa50u70QRWGBbgPhkudNr+UVeZO49V+rJahQKqkZ1pZR+sqjplBze3
         q35Wqugk6MwBc7S+ubvDZFqhYjXGVsB/XPQOU15imjrES3mE+4jS6D5EO6hub0FHZxAT
         +zCaPPlxhFluLFItLj3F5QdevNoFUcoaXuo+CM0bND1qvelEblmhqLuD8fraDS1YHsIn
         MT+g==
Sender: Tejun Heo <htejun-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20230105161854.GA1259-9OudH3eul5jcvrawFnH+a6VXKuFTiq87@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Jinke Han <hanjinke.666-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yinxin.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, jack-AlSwsSmVLrQ@public.gmane.org

Hello,

On Thu, Jan 05, 2023 at 05:18:54PM +0100, Michal Koutn=FD wrote:
> I guess similar problem would arise for devices that are "naturally"
> slow.
> Then:
> a) it must have been solved elsewhere in the block layer (but it's
>    broken),
> b) it should be solved generically in the block layer (thus this is only
>    a partial solution).

Hard limits tend to make this sort of problems a lot more pronounced because
the existing mechanisms tend to break down for the users which are severely
throttled down even while the device as a whole is fairly idle. cpu.max
often triggers severe priority inversions too, so it isn't too surprising
that people hit severe priority inversion issues w/ io.max.

Another problem with blk-throttle is that it doesn't prioritize shared IOs
identified by bio_issue_as_root_blkg() like iolatency and iocost do, so
there can be very severe priority inversions when e.g. journal commit gets
trapped in a low priority cgroup further exacerbating issues like this.

Thanks.

--=20
tejun
