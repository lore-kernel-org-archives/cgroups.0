From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH block/for-4.5-fixes] writeback: keep superblock pinned
 during cgroup writeback association switches
Date: Thu, 18 Feb 2016 08:00:33 -0500
Message-ID: <20160218130033.GE6479@mtj.duckdns.org>
References: <CAAeU0aNCq7LGODvVGRU-oU_o-6enii5ey0p1c26D1ZzYwkDc5A@mail.gmail.com>
 <20160215210047.GN3965@htj.duckdns.org>
 <CAAeU0aNAd1Ra6LXmWwq8row4MD_BpVHiSXOwHx07m86UWREvHw@mail.gmail.com>
 <20160216182457.GO3741@mtj.duckdns.org>
 <20160217205721.GE14140@quack.suse.cz>
 <20160217210744.GA6479@mtj.duckdns.org>
 <20160217223009.GN14140@quack.suse.cz>
 <CAAeU0aOvSwPbLPU0=20D1RExNj8VsbB38hUnyso2L8xNSQC0XA@mail.gmail.com>
 <20160217230231.GC6479@mtj.duckdns.org>
 <20160218095538.GA4338@quack.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=wW7VanKqUZ2QvN5J2xhbu0Caeqih5cjqvGw/5PVheqA=;
        b=Avv4T59/KIR7H/yyVgq13hMlCJI0B0x0uUe2gMFI4o/Z8byNETRkUo6dGKtK8aFKS4
         lJcFt0YO8nLPIr40SKPYOrSpqNO0500l1bCYR4sGLx7oRF8nrhDO1bsAwGp+wr5Tlu6a
         MzZ5euZLxFiDQuzYOAgUXl1jNZz3k8jAu7rdjskE5OQ9A2aUD7U+BwwjIbGF0+jd1Zz6
         Kq8f4ZmiOA+5Gjf5g7/Ek3g8nxvPhQum6VvqgP3Ll5AO3OqtMccAmh5Z/wOmfIQPwCyW
         XpiDS4lJbgDPuu5PqPYOWbAvuED6M9LYth/DCPZJ7Xj7hnSc9O+nZ7lXL2BaKInrRGin
         0V9w==
Content-Disposition: inline
In-Reply-To: <20160218095538.GA4338-+0h/O2h83AeN3ZZ/Hiejyg@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Cc: Tahsin Erdogan <tahsin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Nauman Rafique <nauman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Kara <jack-IBi9RG/b67k@public.gmane.org>

Hello, Jan.

On Thu, Feb 18, 2016 at 10:55:38AM +0100, Jan Kara wrote:
> I'm not sure I understand the question. Do you mean why both s_active and
> s_umount rwsem exist? s_active is a reference count keeping superblock

Yes.

> alive - e.g. if the filesystem is mounted in more places, we need a
> reference for each mountpoint. s_umount is used when we want to block any

I could be mistaken but I *think* we used to reject umounts based on
s_active and s_umount is the mechanism to delay umounts rather than
failing them and probably with bind mounts the behavior changed.

> umount operation until we are done. For example sync(2) is using it to make
> sure superblock doesn't disappear and so that we don't keep superblock
> alive after admin called umount(2).

So, the question is why aren't we just using s_active and draining it
on umount of the last mountpoint.  Because, right now, the behavior is
weird in that we allow umounts to proceed but then let the superblock
hang onto the block device till s_active is drained.  This really
should be synchronous.

Thanks.

-- 
tejun
