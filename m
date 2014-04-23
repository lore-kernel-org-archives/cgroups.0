From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] device_cgroup: rework device access check and exception checking
Date: Wed, 23 Apr 2014 10:33:41 -0400
Message-ID: <CAOS58YOuT1WhBwoh0A4OZOs-7dYZtCGRPw7OkJZkerbL5a8Gvg@mail.gmail.com>
References: <20140421161303.GG29214@redhat.com>
	<20140421223253.GB22730@htj.dyndns.org>
	<20140423143226.GK29214@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:date:message-id:subject
         :from:to:cc:content-type;
        bh=uyvmpQa8vxl+ZHuRg0TW76VEwO957VyGgMpmdnWxJbk=;
        b=z5sRsNhJpVnEKFHk7mbaW0sIsjbzagx0Q+/HrJyX6oz1DgoxLgrrtYby1+RUVQzZ7y
         aTdrlkvt94n/FSIkU7VPX7/eUKSgabDxdAaUiPIrCP1ngIGNRR87HQfH6bFR2A/ZkFAu
         O8wB62mq6VzvPhRp6/veEOxIQdha++HzSR/2ShkVY8a305LuUTSvPpY4aEdNbocIBupB
         VfFv/U6cHCyWs4AnHOdgjahMlWQTHBn3hKRAbSsXLGH2+0ttelDhwzm8xMXpj+Mx3Bl8
         jwuRmE8aS63RSrVOxLzpN41vRjGU8P0AtToo00tcLvGkAf3uW4VoD0dJhMpYxBuy1OJm
         MElg==
In-Reply-To: <20140423143226.GK29214-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Hello,

On Wed, Apr 23, 2014 at 10:32 AM, Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> A nit: Can you please prepare a separate patch to reformat the
>> function comments.  The usual style is single line at the top for the
>> function name and brief description.  The actual description should
>> come after the param list.
>
> Will submit with a v3, another bug found :\

Please make incremental patches against cgroup/for-3.15-fixes.

Thanks.

-- 
tejun
