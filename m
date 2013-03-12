From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH -v2] device: separate all subsys mutexes (was: Re: [BUG]
 potential deadlock led by cpu_hotplug lock (memcg involved))
Date: Tue, 12 Mar 2013 11:47:18 -0700
Message-ID: <20130312184718.GA9749@kroah.com>
References: <513ECCFE.3070201@huawei.com>
 <20130312101555.GB30758@dhcp22.suse.cz>
 <20130312110750.GC30758@dhcp22.suse.cz>
 <20130312130504.GD30758@dhcp22.suse.cz>
 <20130312133446.GA3514@kroah.com>
 <20130312162119.GB5963@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=x-received:date:from:to:cc:subject:message-id:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        bh=4UwTV9PQZAEdhRPa9eFWxcL7iWrz4XyPEBLE2EXvZdk=;
        b=AtIp2FnnbtQJVm6bd8gxQll8qekrH9Hv3xkzngswJmqAmQZjWEpherxobIG0l9llbV
         0l1gYY3DaJFjl6xpiUjERVvXrlI7LtHz/aFYJIePWqa4iP00NISmMOQHRU4iqcSanalq
         ooswbxGOWBIWXsD8UEm1UGvk6iv6xK3r4wtYY=
Content-Disposition: inline
In-Reply-To: <20130312162119.GB5963-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>

On Tue, Mar 12, 2013 at 05:21:19PM +0100, Michal Hocko wrote:
> On Tue 12-03-13 06:34:46, Greg Kroah-Hartman wrote:
> > On Tue, Mar 12, 2013 at 02:05:04PM +0100, Michal Hocko wrote:
> > > The fix is quite simple. We can pull the key inside bus_type structure
> > > because they are defined per device so the pointer will be unique as
> > > well. bus_register doesn't need to be a macro anymore so change it
> > > to the inline. We could get rid of __bus_register as there is no other
> > > caller but maybe somebody will want to use a different key so keep it
> > > around for now.
> > 
> > Nice work, but just drop __bus_register(), no one should need to use a
> > new key for this type of thing, now that you have added a per-bus_type
> > variable.
> 
> OK v2 below. I have also ranamed __key to lock_key. Who is going to take
> the patch?

I will, thanks.

greg k-h
