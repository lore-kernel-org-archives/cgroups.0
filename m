From: Tejun Heo <tj@kernel.org>
Subject: Re: [Lsf] [RFC] writeback and cgroup
Date: Wed, 4 Apr 2012 11:56:05 -0700
Message-ID: <20120404185605.GC29686@dhcp-172-17-108-109.mtv.corp.google.com>
References: <20120403183655.GA23106@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120404145134.GC12676@redhat.com>
 <CAH2r5mtwQa0Uu=_Yd2JywVJXA=OMGV43X_OUfziC-yeVy9BGtQ@mail.gmail.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=zZDDJEccnFyBIO3LZ80JJ5knbhdzX4lYA5pVPImQzpo=;
        b=z1e0McnkMfSa+6DC2eehWrsKnlOiXxkfglVrMHz0hXLscKmDvtVKl8g7iBiqkk69Vi
         lwAEk+YzifM+BmTvPm0EoX0SAOaxRbR/88hsV7jSzpr7pSEmUBxp6vgAAExnpwL6/JPe
         tUcGbY0uz6Rwe4nlwSvn4yQhwrcPFz+JLt7uSCNOGY9MrUqLGh0z9ZatHLUDSfhPgCdc
         qOfUCyQ0uThYWI4dH+LNDZGZ+uIdmlxE0xUNBddrphsbM//Z7cmxl4Hw7SXzdisLQVh4
         ArKbsnHyhFwDi7KOziwcZxB4xVoHWUwTaUc9o5lD40tVNUyvN7pmC8TH4g5fPreUN1xr
         KLqg==
Content-Disposition: inline
In-Reply-To: <CAH2r5mtwQa0Uu=_Yd2JywVJXA=OMGV43X_OUfziC-yeVy9BGtQ@mail.gmail.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Steve French <smfrench@gmail.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, ctalbott@google.com, rni@google.com, andrea@betterlinux.com, containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org, lsf@lists.linux-foundation.org, linux-mm@kvack.org, jmoyer@redhat.com, lizefan@huawei.com, linux-fsdevel@vger.kernel.org, cgroups@vger.kernel.org

On Wed, Apr 04, 2012 at 10:36:04AM -0500, Steve French wrote:
> > How do you take care of thorottling IO to NFS case in this model? Current
> > throttling logic is tied to block device and in case of NFS, there is no
> > block device.
> 
> Similarly smb2 gets congestion info (number of "credits") returned from
> the server on every response - but not sure why congestion
> control is tied to the block device when this would create
> problems for network file systems

I hope the previous replies answered this.  It's about writeback
getting pressure from bdi and isn't restricted to block devices.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Fight unfair telecom internet charges in Canada: sign http://stopthemeter.ca/
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
