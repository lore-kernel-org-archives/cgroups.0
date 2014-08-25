From: Dongsheng Yang <dongsheng081251-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V2] cgroup: Introduce cgroup_detach_task().
Date: Mon, 25 Aug 2014 23:00:00 +0800
Message-ID: <CA+qeAOpiW41i3dKyxYp_G9kB=Z9Kr7ZXeJOyq8QZP=qy6H6T3Q@mail.gmail.com>
References: <1408966330-2374-1-git-send-email-yangds.fnst@cn.fujitsu.com>
	<20140825141220.GA31066@mtj.dyndns.org>
	<CA+qeAOq7hYq-TJMh8jQpJy=nWwk2FsUMSS1Hd=-JkhLLXbweEQ@mail.gmail.com>
	<20140825144710.GA21688@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        bh=wTH0w9rFlxhdTA4s8Gu4C71tTAedyytxl7iMcUb9Skw=;
        b=w1Y8yVOIEW17S7c5iwi5i1XKtEnYKDq7ZElQKNcuE78sDDAvbEr3DJQba244dfVZ4o
         Wx+0FGPXRibeg0EoafSfl8kCz3d4YiGSgRj1TEL02ktDXr0nKMml+sJlQVd9bHxgp2tY
         vHWu+7r/G31SCvTVW4DR10XQGbjKUlCtjMVRCQPo+Pha1Tvvh8ZO8tgDYDzEYUY+XVOB
         FfG16JRJd2zuEk1BW6W0MCG/AR0q4aSxaRVBXN/gRTnUVQvn2aymrzEmBU1G/7oVJdFZ
         Ynb9Zvl+ik64ErJU59d0p9Ng6kngPxMk40Zby9eLt2NY3Qgdq4jJaJzySdW3DoxRsXvj
         3HLA==
In-Reply-To: <20140825144710.GA21688-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Dongsheng Yang <yangds.fnst-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Mon, Aug 25, 2014 at 10:47 PM, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> On Mon, Aug 25, 2014 at 10:46:03PM +0800, Dongsheng Yang wrote:
>> My point here is that attaching and detaching are a pair of operations.
>
> There is no detaching from a cgroup.  A task is always attached to a
> cgroup whether that's a root or non-root cgroup.

Okey, I should not think it as attaching and detaching. Just treat them as
a move between root and non-root cgroup.

It sounds reasonable to me now.

Thanx.
>
> Thanks.
>
> --
> tejun
