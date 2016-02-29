From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH block/for-linus] writeback: flush inode cgroup wb
 switches instead of pinning super_block
Date: Mon, 29 Feb 2016 16:08:00 -0500
Message-ID: <20160229210800.GY3965@htj.duckdns.org>
References: <20160216182457.GO3741@mtj.duckdns.org>
 <20160217205721.GE14140@quack.suse.cz>
 <20160217210744.GA6479@mtj.duckdns.org>
 <20160217223009.GN14140@quack.suse.cz>
 <CAAeU0aOvSwPbLPU0=20D1RExNj8VsbB38hUnyso2L8xNSQC0XA@mail.gmail.com>
 <20160217230231.GC6479@mtj.duckdns.org>
 <20160229204724.GV3965@htj.duckdns.org>
 <20160229205428.GB17997@ZenIV.linux.org.uk>
 <20160229205837.GX3965@htj.duckdns.org>
 <20160229210614.GC17997@ZenIV.linux.org.uk>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=iZ6+RipYLKM7n3331u1kxs8XQZ11O3bfZ+dV9kyMFDo=;
        b=wNWOnotfLBsxeoJqkws1NoKoeMLarsewOeZuefGeCmG1AxJ1EG+QAwTbWO50U4QaHa
         MfsXypZsPTWN+fM+l7OBL/RZJytRO1e+JfY8AuYr7/gqm4KznFgPHzs+iHh61oIe3T0c
         C4zVsmaP1KvO5nmC5bdLPS/8JHW0yYPNvCef/a9NgWED3B6IO1W9q9T7YDq70Akt3Iwb
         w7nQzTZaMWu6rAOZChLM4f6PxZej7O8RvRuhyPHPZRU9gEfx6cINdVaAiqp7lSSI4PIS
         ojYJq7Ofs1ISaZNHLJrJMdfrN7r/Tw6lxx1affaWGvoQLt3eBiSb+cuujPJRkoAEV8Ag
         by+w==
Content-Disposition: inline
In-Reply-To: <20160229210614.GC17997-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Tahsin Erdogan <tahsin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Theodore Ts'o <tytso-3s7WtUTddSA@public.gmane.org>, Nauman Rafique <nauman-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Kara <jack-IBi9RG/b67k@public.gmane.org>

On Mon, Feb 29, 2016 at 09:06:15PM +0000, Al Viro wrote:
> > Hmmm?  The flushing is done after shrink_dcache_for_umount() and
> > sync_filesystems().  Aren't inodes supposed to stay clean after that?
> 
> s/shrink_dcache_for_umount/fsnotify_unmount_inodes/ - sorry.

Is that allowed to dirty indoes and initiate writebacks again, after
sync_filesystems() is done?  That sounds weird but it's trivial to
move cgroup_writeback_umount() below that if so.

Thanks.

-- 
tejun
