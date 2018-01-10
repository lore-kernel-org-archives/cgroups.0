From: Roman Gushchin <guro@fb.com>
Subject: Re: cgroups(7): documenting /sys/kernel/cgroup files
Date: Wed, 10 Jan 2018 06:32:21 -0800
Message-ID: <20180110143202.GA12804@castle.DHCP.thefacebook.com>
References: <ff431fd8-f1c1-ed8d-2d69-64ea83a8a505@gmail.com>
 <CAKgNAkhk-527Rh6tGYJO-U3UXgwBC1+t5nB+5JEq62nTO2p15A@mail.gmail.com>
 <20180110124407.GA26913@castle.DHCP.thefacebook.com>
 <20180110140239.GX3668920@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=G0Ty09/JzR0QWidkF2yt5ti+npTROzkr9voPguSA7b0=;
 b=Ss3b7qiT+Fybad6IHQ47VkxNND3BF++W57/AX9yh06eZKuCA/RhrXmQ9OumEnbSXjTbr
 KzGmtLEIK/DeuSeI9C6AA7DCLpOTZnI9MhLhQ99iobFCSEx6fhiC89DjGrZztrlDJZuL
 IsgYKijzkB6cSVwBFkXXzE03B5c9gc6OJP8= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=G0Ty09/JzR0QWidkF2yt5ti+npTROzkr9voPguSA7b0=;
 b=VXm6YbTRujodX/P2GrMeNmVHISLY2CYUliDZtP76UGmOK1WHw55zMQtgp5OHlWgXANc02IZJ4Ku5x+BdMvUwVsIJpUoa84KbK2U1cl1WnkZ/aejbwOgZzQ03fuKqW/UY9J5/9U8qSqfPKu+D0H8nPLkDtIv/Sp4nEBAkEPEYiBo=
Content-Disposition: inline
In-Reply-To: <20180110140239.GX3668920@devbig577.frc2.facebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>
Cc: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, linux-man <linux-man@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups@vger.kernel.org>

On Wed, Jan 10, 2018 at 06:02:39AM -0800, Tejun Heo wrote:
> Hello,
> 
> On Wed, Jan 10, 2018 at 04:44:14AM -0800, Roman Gushchin wrote:
> > cgroup.threads is not listed because it's not delegatable (doesn't have
> > CFTYPE_NS_DELEGATABLE flag set). I don't know if it was intended or just
> > an accident (I believe the latter).
> 
> So, thread mode isn't delegatble.  Marking a cgroup as threaded turns
> that subtree threaded and join the parent's domain, so we can't allow
> delegation roots to be turned threaded - just like we can't mark the
> root cgroup threaded, and I'm not really not sure what it means to
> delegate a portion of threaded subtree.

Thank you for the clarification!

Roman
