From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup: Use separate work structs on css release path
Date: Fri, 27 May 2022 18:54:29 +0200
Message-ID: <20220527165429.GJ11007@blackbody.suse.cz>
References: <20220525151517.8430-1-mkoutny@suse.com>
 <20220525151517.8430-3-mkoutny@suse.com>
 <20220525161455.GA16134@blackbody.suse.cz>
 <Yo7KfEOz92kS2z5Y@blackbook>
 <Yo/DtjEU/kYr190u@slm.duckdns.org>
 <904ef8af-13a5-e566-b760-74519f70fa62@linaro.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1653670470; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+u8JHoqLLvsvRVRBUuvCk5vOU0EPwCFY9Y54KiKuKVk=;
        b=hsMieLInNRiAFgba/ZyPJYd4fTnZWpaKHkD81x/3sHXl8J57s/mbfM10cJZ/tgrYCx4GU3
        E4pweojjXyzWX8ILfLZZqX2DYyZNLolbQgy+7oLilvuFWqBXX/VnIgybG3/7ew2v/tY2c2
        LC18jfjBjXvsIReeB0Qutu1x07qBcYw=
Content-Disposition: inline
In-Reply-To: <904ef8af-13a5-e566-b760-74519f70fa62-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tadeusz Struk <tadeusz.struk-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Bui Quang Minh <minhquangbui99-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hello Tadeusz.

On Fri, May 27, 2022 at 09:39:20AM -0700, Tadeusz Struk <tadeusz.struk-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> As far as I can see we are trying to test the same thing suggested by Tejun.
> I just sent a test request to try this:
> https://github.com/tstruk/linux/commit/master

Yup, I've added few more prints to get more fine-grained resolution.
Also, I decided to use ftrace printk not to interfere with timing too
much (due to the original race hypothesis).

> Let me know if you have any more tests to run and I will hold off until
> you are done.

My latest attempt is [1] (tip 5500e05d82fd5b5db2203eedb3f786857d3ccbea).

So far, I'm not convinced, I extract the complete ftrace buffer from the
syzbot runs, so I'm not drawing any conclusions from the traces I've
got. I'm not going to continue today. You may have more luck with your
plain printk (if it's just imbalance and it avoids printk locking
sensitive paths).

HTH,
Michal

[1] https://github.com/Werkov/linux/tree/cgroup-ml/css-lifecycle-b2
