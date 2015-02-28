From: Tim Hockin <thockin-Rl2oBbRerpQdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC 0/2] add nproc cgroup subsystem
Date: Sat, 28 Feb 2015 14:26:58 -0800
Message-ID: <CAAAKZwv=idxvrffHx2QyW=PGH4k42ckq-VLJGQrXkeQ6NmByRQ@mail.gmail.com>
References: <1424660891-12719-1-git-send-email-cyphar@cyphar.com>
 <20150227114940.GB3964@htj.duckdns.org> <54F09E62.8000007@gmail.com>
 <20150227170640.GK3964@htj.duckdns.org> <CAAAKZwtDS+MNd3wTheGUrNVbP7qLX_u3vo+YDOAbsU-Rq=Ot2w@mail.gmail.com>
 <20150227174503.GM3964@htj.duckdns.org> <CAAAKZwvuR2X7EEZz+UWRCGYajaJQ+VzXYfDEq6EQnssv9+6FJQ@mail.gmail.com>
 <20150227214904.GQ3964@htj.duckdns.org> <CAAAKZwsCc8BtFx58KMFpRTohU81oCBeGVOPGMJrjJt9q5upKfQ@mail.gmail.com>
 <20150228165706.GS3964@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:from:date:message-id
         :subject:to:cc:content-type;
        bh=A2TX1VpsM5i1ZVkY9rkk3/wk3G3Vq/O1WWlq4CGA4Ls=;
        b=NFQFPoTJjBVmVgSi64iR6TdFTV5WpN75oBw0nVVfy+Tk9yZ/t4/kbhmV3m6sY0lquy
         7gSR9lE9FWui8P5Asts6onBBdJZcX7CzckHzgySNY7cuzmAAF5Vug7GzEE4yTvxWCCau
         EPANlMHHOtkmLAZP6mD1veosJ5N8/t3ncTj0o14yvvgvJvXt/dqkIxsDY0Gi4kElV95U
         Bpo7OwdNt/UdG8BzSCcn55PyT8VQuhFi9Aaeg69l518ARaATj7c6lPHraNEQ5y/PVh9P
         Zar56070oRPke2qKzRA4GOBSgKL01Ogt1WuC/LXCl1keLIrUyqUvRHfTV/66N/PF03Rq
         S0TQ==
In-Reply-To: <20150228165706.GS3964-piEFEHQLUPpN0TnZuCh8vA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Austin S Hemmelgarn <ahferroin7-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Aleksa Sarai <cyphar-gVpy/LI/lHzQT0dZR+AlfA@public.gmane.org>, richard <richard-/L3Ra7n9ekc@public.gmane.org>, mingo <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

On Sat, Feb 28, 2015 at 8:57 AM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
> On Sat, Feb 28, 2015 at 08:48:12AM -0800, Tim Hockin wrote:
> > I am sorry that real-user problems are not perceived as substantial.  This
> > was/is a real issue for us.  Being in limbo for years on end might not be a
> > technical point, but I do think it matters, and that was my point.
>
> It's a problem which is localized to you and caused by the specific
> problems of your setup.  This isn't a wide-spread problem at all and
> the world doesn't revolve around you.  If your setup is so messed up
> as to require sticking to 16bit pids, handle that locally.  If
> something at larger scale eases that handling, you get lucky.  If not,
> it's *your* predicament to deal with.  The rest of the world doesn't
> exist to wipe your ass.

Wow, so much anger.  I'm not even sure how to respond, so I'll just
say this and sign off.  All I want is a better, friendlier, more
useful system overall.  We clearly have different ways of looking at
the problem.

No antagonism intended

Tim
