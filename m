From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] cgroups: Do not show inactive devices in cgroups statistics
Date: Wed, 26 Jun 2013 14:11:12 -0700
Message-ID: <CAOS58YP_Umud2DTY+3tc4m02FywGNOEALSN1An4OLXczcmsQ4Q@mail.gmail.com>
References: <1372274770-30679-1-git-send-email-anatol.pomozov@gmail.com>
	<20130626204540.GA4536@htj.dyndns.org>
	<20130626210820.GA17564@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        bh=ywRF8tl74+jzIrk9UOUC1GZ4pEHrATFAf907DEQ6+eo=;
        b=BrQPe0lFLCHPDBl9V8cYYFryQqVd7tD8DOPF/Q0jK7od9YmhRyn0CX1Ejmia17Xrzi
         ozhKOKPq8LBKW7GBR6iYniyh4EHZm6a51fCMp0l/I7iOrQKzyfLUDOW/zWQh2oCive52
         aYWt0BBzBp5qifw5u6aFmHfhSYkZ4+ihZVniLZs4ZKu+1HH+eX4it0N5bKvd6n5IugU+
         DcmEdrjxkyhUgKcG8RmB6PoykadTV8X96hKz12ueaKYFgL7k6HOopJr40cFzsSD9uPia
         3FKvBmg11LBkE9qXjKR2PuBl1m4ZFkfivODAkIlZra/wYlF55XirU/ijObTA1maJCaBo
         lP1Q==
In-Reply-To: <20130626210820.GA17564-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Anatol Pomozov <anatol.pomozov-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>

On Wed, Jun 26, 2013 at 2:08 PM, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> I don't have an objection to not listing stats of devices which are
> zero, but wondering why all the devices of system are showing in
> cgroup stat.
>
> Don't we add a blkg to a blkcg only if that cgroup did some IO to
> that particular device. If yes, then only those devices should
> show to which cgroup did some IO and that should be non-zero.
>
> Is it because of hierarchical support where if a child does IO
> to device, we will add an blkg instance to parent's cgroup? In
> that case hierarchical stats will still be non-zero but group
> local stat can be zero.

I wondered that too.  Maybe they're configuring all combinations?  Anatol?

Thanks.

--
tejun
