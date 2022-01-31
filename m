From: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Subject: Re: LTP test suite triggers LOCKDEP_CIRCULAR on linux-next
Date: Mon, 31 Jan 2022 09:01:54 -0800
Message-ID: <YfgWAuzAo2WDyPH+@carbon.dhcp.thefacebook.com>
References: <87mtjzslv7.fsf@oc8242746057.ibm.com>
 <YeI78TMjU12qRmQ8@carbon.dhcp.thefacebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=facebook; bh=dqWZiyrAtQfsRnyQvy9/KIobXqyxeLef1Rz2DWYEAk8=;
 b=m7TUlZSornpCB7rOJ8dVCugFgJSFwmefM8zlDqUS3m65nGxni8Ye7JjztubSQVmg+nYt
 HStFi3hOiVYVhI5cUJGV0VRIJ0SQoGkVLatSVS9Mv13NpruLgxshFLb/YxOmB2KsDddb
 JFnhUcEKc24DqnPAaXXo68ccRnvXI2PVbdo= 
Content-Disposition: inline
In-Reply-To: <YeI78TMjU12qRmQ8-cx5fftMpWqeCjSd+JxjunQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Alexander Egorenkov <egorenar-tEXmvtCZX7AybS5Ee8rs3A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Fri, Jan 14, 2022 at 07:13:53PM -0800, Roman Gushchin wrote:
> On Thu, Jan 13, 2022 at 04:20:44PM +0100, Alexander Egorenkov wrote:
> 
> Hi Alexander!
> 
> Can you, please, check if the following patch is fixing the problem for you?
> 
> Thanks a lot in advance!

Friendly ping.

Thanks!
