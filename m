From: Tejun Heo <tj@kernel.org>
Subject: Re: [GIT PULL] cgroup changes for v4.18-rc1
Date: Wed, 6 Jun 2018 08:22:26 -0700
Message-ID: <20180606152226.GN1351649@devbig577.frc2.facebook.com>
References: <20180605192157.GG1351649@devbig577.frc2.facebook.com>
 <CA+55aFzWdPavAPC--MY15RgwvU1QYgF+Uy7rMJmx2Dr3ddJdsQ@mail.gmail.com>
 <20180606150438.GM1351649@devbig577.frc2.facebook.com>
 <CA+55aFy=a3nm+r7462mLq4D6eDxDsPXUO3_tviT=DqJPsohx5A@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=W6NfEyUMlE8xfAKjoOYdJR4Hx0Vf0U3wNLFbegs/5rM=;
        b=mL94jdDG6ADqyM8o3T/Dp9+dtDjFat2aSdHShgCE4W5iI0sIrgkS7p8YUImWy1a4Kk
         yWuF9PLKP6yH2LjFzym8fcUk/Lw/ekkQAnktOC9nzaKgBR9ZzLEdzzvVKmtUMfH/m8eb
         BC9ob7J5oKKFwdNZ9BvvDnKj3uig/Gigbo3+rfGnfIDVDxv008Y2Hi6/uQVDuR7T6woI
         4gqRUS/PonEXtggQVC1WDUGvm9VKBC1mt+x50fhz1myzg5xLNydhlobA7w0D/H3Syzp0
         a9DgP750JjKe6QdfBJOoTPs8thv2SHFt6+uKxByaDn1MqAg/oy53aJjTf54z0P48xEnL
         PJsA==
Content-Disposition: inline
In-Reply-To: <CA+55aFy=a3nm+r7462mLq4D6eDxDsPXUO3_tviT=DqJPsohx5A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups <cgroups@vger.kernel.org>

On Wed, Jun 06, 2018 at 08:14:27AM -0700, Linus Torvalds wrote:
> On Wed, Jun 6, 2018 at 8:04 AM Tejun Heo <tj@kernel.org> wrote:
> >
> > The notification implementation isn't super light weight, so the patch
> > ratelimits the notifications by capping minimum notification interval
> > interval to 10ms.
> 
> Yeah, I looked at the patch (and the code) to make sense of the explanation.
> 
> My reaction to that was that it might be a better idea to simply not
> notify if a notification was already pending, rather than have the
> timeout. Or perhaps in addition to. The path _to_ the fsnotify code
> looked quite messy, though.

Yeah, getting to the inode is currently quite involved.  Some of the
complications come from the fact that a kernfs node can be associated
with multiple inodes for sysfs namespace support.

The right thing to do could be linking the inodes to the kernfs node
and protect it with a spinlock so that we don't have to punt and walk
them directly from notification path.

For now, I think the 10ms thing is an acceptable workaround but this
likely needs more work in the future.

Thanks.

-- 
tejun
