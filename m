From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC 0/2] add nproc cgroup subsystem
Date: Mon, 2 Mar 2015 08:54:21 -0500
Message-ID: <20150302135421.GB17694@htj.duckdns.org>
References: <20150227114940.GB3964@htj.duckdns.org>
 <54F09E62.8000007@gmail.com>
 <20150227170640.GK3964@htj.duckdns.org>
 <54F0BC51.4050506@gmail.com>
 <CAOviyajSOY6kTiwTA+APf9VGT=Ui=0QQH6KUqwaxHB3ahuJk2g@mail.gmail.com>
 <20150228115926.GA1005@htj.duckdns.org>
 <CAAAKZws45c3PhFQMGrm_K+OZV+KOyGV9sXTakHcTfNP1kHxzOQ@mail.gmail.com>
 <20150228164353.GR3964@htj.duckdns.org>
 <54F461F3.3030903@gmail.com>
 <CAOviyahKJthwLTND51HhaRNB_KJC60T7HFHjdqPZf3pQmAUAhw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=BrfLQjU5OnNYfSF6A9ySQG7M24WWYmLtFjqzRQJjbVM=;
        b=WFMJo0zxWE6u1I/09u99sAEN+PMadwyKu+dg1ZcVIEdnd3hzGhPbexr9YOZA8y7lzV
         8WHEzA0PEVcuUNrJBNO0JKrkJSLAfXoQ09BNWsgBavw7dt9nbzcHXSz/BrhTB+7HSgkv
         CKFmdoQy7V2nwJX5PSihz808FHlqirs6SSz9Xo9eTWWix7Ex+sN+y3XxLR4JMWP5rQEF
         TDbpN7WwwBlLyvlWt36sdL70d+aPkqtWT8DTNEligVrgMENR3gP72NRQ2/gJD5kX0mI6
         Cz4hnxprYIt+MC7o1UGuK+B09bL5L1tz+Jo16j1LgMWziy8qTl4Ro+48ymlGB78r+G5O
         tpBw==
Content-Disposition: inline
In-Reply-To: <CAOviyahKJthwLTND51HhaRNB_KJC60T7HFHjdqPZf3pQmAUAhw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Cc: Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tim Hockin <thockin-Rl2oBbRerpQdnm+yROfE0A@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, Mar 03, 2015 at 12:31:19AM +1100, Aleksa Sarai wrote:
> > If 16-bit PID's aren't a concern anymore, then why do we still default to
> > treating it like a 16-bit signed int (the default for
> > /proc/sys/kernel/pid_max is 32768)?
> 
> I just want to emphasise that *even if* we changed to another default
> limit, the mere existence of a system-wide pid_max makes PIDs a
> resource.

We seem to fail to communicate.  The primary reason why pid promotes
itself to a global resource status is because it's globally capped way
below its backing resource's (kernel memory) limit and it is very
difficult to make it not so due to direct userland dependencies on it.

Thanks.

-- 
tejun
