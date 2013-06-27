From: Anatol Pomozov <anatol.pomozov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] cgroups: Do not show inactive devices in cgroups statistics
Date: Thu, 27 Jun 2013 09:39:12 -0700
Message-ID: <CAOMFOmVc5YerD56b_j9DMVYyyztN=54xZ9Xqq3gsB3pe27SXNw@mail.gmail.com>
References: <1372274770-30679-1-git-send-email-anatol.pomozov@gmail.com>
	<20130626204540.GA4536@htj.dyndns.org>
	<20130626210820.GA17564@redhat.com>
	<CAOS58YP_Umud2DTY+3tc4m02FywGNOEALSN1An4OLXczcmsQ4Q@mail.gmail.com>
	<CAOMFOmVqevNSKgWR5keT8u7vsCRpHhYROejM6OucyNeeA6j6zQ@mail.gmail.com>
	<20130627012304.GG4536@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=Y4sOKwoBxPIm3F5dBt1u2rkdIpn8j9pEh0zK7B1pD6c=;
        b=rWr9TtgLcHtgO6RiFCjKRcloajFdYZnMbpi4CLCGdl9pDfX6R8HI+PiPZjH+a9m4Ge
         V1tfYuMp8jcYjYufNXeTd8yN/vDH3LK+fCtotXDV2AiPTJ4PonNX3YMX8bvn1N39o6xu
         owG9rR5d1XcIpHH/vOeaNwIvUZmY/v8ptxoWEB22c9O5v/d852CXg+WCu81zcS0ZPp52
         6gn40qw4hSeYiKFyl4tpjJltMMhBU1EwdstAUNISoTXwqPGMdq8Fzq1eOuUntRoNk3G8
         XKubbdnwLNB3XZFSs8u0gTVhq20G8T9f6mldAii5hJenMypR9olOr9U5T9RyG+G0jelk
         HlSQ==
In-Reply-To: <20130627012304.GG4536-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>

Hi

On Wed, Jun 26, 2013 at 6:23 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> Hello,
>
> On Wed, Jun 26, 2013 at 05:37:38PM -0700, Anatol Pomozov wrote:
>> Bottom line: when we set weight for a device then it creates cfq_group
>> and initializes device stats with zero. Later that zero stat is shown
>> even if no activity happened on the device. Both CFQ and our custom IO
>> scheduler have this problem. And because we write set weight for all
>> devices in all cgroups we endup with a lot of zero useless stats.
>>
>> What is the right fix in this situation?
>
> Yeah, I think yours is fine.  You're just configuring each blkg during
> init.  Please just update the u64 case and repost.

Yep. But it looks like before 3.5 stats initialization was not tied to
device initialization.
