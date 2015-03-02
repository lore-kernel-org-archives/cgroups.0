From: Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RFC 0/2] add nproc cgroup subsystem
Date: Tue, 3 Mar 2015 00:31:19 +1100
Message-ID: <CAOviyahKJthwLTND51HhaRNB_KJC60T7HFHjdqPZf3pQmAUAhw@mail.gmail.com>
References: <1424660891-12719-1-git-send-email-cyphar@cyphar.com>
	<20150227114940.GB3964@htj.duckdns.org>
	<54F09E62.8000007@gmail.com>
	<20150227170640.GK3964@htj.duckdns.org>
	<54F0BC51.4050506@gmail.com>
	<CAOviyajSOY6kTiwTA+APf9VGT=Ui=0QQH6KUqwaxHB3ahuJk2g@mail.gmail.com>
	<20150228115926.GA1005@htj.duckdns.org>
	<CAAAKZws45c3PhFQMGrm_K+OZV+KOyGV9sXTakHcTfNP1kHxzOQ@mail.gmail.com>
	<20150228164353.GR3964@htj.duckdns.org>
	<54F461F3.3030903@gmail.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54F461F3.3030903-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tim Hockin <thockin-Rl2oBbRerpQdnm+yROfE0A@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, richard-/L3Ra7n9ekc@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

> If 16-bit PID's aren't a concern anymore, then why do we still default to
> treating it like a 16-bit signed int (the default for
> /proc/sys/kernel/pid_max is 32768)?

I just want to emphasise that *even if* we changed to another default
limit, the mere existence of a system-wide pid_max makes PIDs a
resource.

--
Aleksa Sarai (cyphar)
www.cyphar.com
