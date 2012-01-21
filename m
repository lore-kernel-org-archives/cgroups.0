From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 2/2] cgroup: add xattr support
Date: Fri, 20 Jan 2012 20:00:58 -0800 (PST)
Message-ID: <alpine.LSU.2.00.1201201951100.1448@eggly.anvils>
References: <4F13DA90.2000603@cn.fujitsu.com> <4F13DAA9.4070703@cn.fujitsu.com> <20120117175322.GC6762@google.com> <CAPXgP13fT3V4L0x6uj9ZdAOw25BgQtEpa8QzLB-_c_Yn+9kO2Q@mail.gmail.com> <20120118213638.GA21533@google.com> <20120119014727.GG29242@tango.0pointer.de>
 <20120119022005.GG21533@google.com> <20120119024021.GI21533@google.com> <20120121030204.GE2100@tango.0pointer.de>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        bh=ziuT1upzUxoSa/DDBBPTMHm+u+uzYU57OUUUEEkvbwM=;
        b=leDalNc/FdTQz3jGaXSBN0VpxkquOzRZfIP+JZxuMnxaI6i2+SIUwFfOKlr4SmVtID
         o+B+rTnMAAl0uYXIYwaMURNKG7wZNRxhmCDzsSVe8nu9VLFm37GNks8nZW9SCshz5ozp
         oddoNl50UPZRoiE92D3xqaBzb89MmYcsKgNBQ=
In-Reply-To: <20120121030204.GE2100-kS5D54t9nk0aINubkmmoJbNAH6kLmebB@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Lennart Poettering <mzxreary-uLTowLwuiw4b1SvskN2V4Q@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Sat, 21 Jan 2012, Lennart Poettering wrote:
> On Wed, 18.01.12 18:40, Tejun Heo (tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org) wrote:
> > On Wed, Jan 18, 2012 at 06:20:05PM -0800, Tejun Heo wrote:
> > 
> > Also note that tmpfs also implies size limit.  We definitely need some
> > form of control over the amount of memory xattr may consume.
> 
> Good point. But then again we don't even have anything resembling for
> tmpfs either, where it would be much more important... :-(

But although the tmpfs framework for xattrs is general, the validation
function only permits XATTR_SECURITY_PREFIX and XATTR_TRUSTED_PREFIX.

Yes, it would be very necessary to impose size limits if tmpfs went
beyond those to permit XATTR_USER_PREFIX - which the cgroupfs patch
under discussion does permit.

> 
> Given that cgroupfs is probably mostly read-only for normal users, the
> requirement for quotas on it is probably much less important than for tmpfs
> though.

Hugh
