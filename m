From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 18/21] blkcg: move blkio_group_conf->weight to cfq
Date: Mon, 2 Apr 2012 15:28:33 -0700
Message-ID: <20120402222833.GB21017@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1332975091-10950-1-git-send-email-tj@kernel.org>
 <1332975091-10950-19-git-send-email-tj@kernel.org>
 <4F7A1C8B.3010402@tao.ma>
 <20120402214938.GA19634@dhcp-172-17-108-109.mtv.corp.google.com>
 <4F7A2217.2030201@tao.ma>
 <20120402221702.GA21017@dhcp-172-17-108-109.mtv.corp.google.com>
 <4F7A261A.9000200@tao.ma>
 <20120402222504.GA2672@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=UhhPBvdhR6IrSMy9V0xKrnWu521+UJF+ai9pmHSJyeY=;
        b=PzHarMyGbx+VGtZXpA07QFbekVvCl6V1iKkCT19KmtQpoNXVBDxvFd4IHKuz6542i0
         9mDMMYRVY0xOwYTcKPGQ42kO4R8tlkOTTK/9AnvheArwJ7/SHcjwrPI12cue99+97M3+
         V5ync48FiEvTkb1j5WuVWv3c72Mawxp/NApZ8303dvK0V/0XzNhXdvaY+unajzioecRb
         NDEagZhjckumnlLGpkq92bGJXYFR7o4lMOpqOVAXxZUekVQbVRk9M6Ap+nqhpmiHD2R1
         bM/Sm751UhVzRjwQu+tKmLa9deib2Zxql3OXjWgAstio3EMWgwlSR0e62epDwJvhAvpy
         Cjkw==
Content-Disposition: inline
In-Reply-To: <20120402222504.GA2672-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Tao Ma <tm-d1IQDZat3X0@public.gmane.org>, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

On Mon, Apr 02, 2012 at 06:25:04PM -0400, Vivek Goyal wrote:
> On Tue, Apr 03, 2012 at 06:20:10AM +0800, Tao Ma wrote:
> 
> [..]
> > > Yeah, just add config and stat files prefixed with the name of the new
> > > blkcg policy.
> > OK, I will add a new config file for it.
> 
> Only if CFQ could be modified to add one iops mode, flippable through a
> sysfs tunable, things will be much simpler. You will not have to add a
> new IO scheduler, no new configuration/stat files in blkcg (which is
> already crowded now).
> 
> I don't think anybody has shown the code that why CFQ can't be modified
> to support iops mode.

I haven't looked at the code so it's just an imporession but if we're
talking about completely different scheduling policy - cfq is about
slicing disk service time and IIUC the new thing being talked about is
using iops as scheduling unit probably for devices where seeking isn't
extremely expensive, and it might not make much sense to mix them
together.

Thanks.

-- 
tejun
