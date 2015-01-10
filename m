From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCHSET RFC block/for-next] writeback: cgroup writeback support
Date: Sat, 10 Jan 2015 10:56:53 -0500
Message-ID: <20150110155653.GA25319@htj.dyndns.org>
References: <1420579582-8516-1-git-send-email-tj@kernel.org>
 <20150106214426.GA24106@htj.dyndns.org>
 <20150107234532.GD25000@dastard>
 <20150109212336.GB2785@htj.dyndns.org>
 <20150110003819.GP31508@dastard>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=oB6nQxGw9l6fTbylzY2fZz+wIgbw5E58LJUUdt+tfJA=;
        b=veVTBTxdW8Y3XcP/yQiqHplf03E3AQeh+nwMnpZ2TaBdGrayOyjGu9Ju6uzE3ar1zH
         Kj2CHTTV3P5wpdBogciZn7n7Mf2HvpRHm0m1rQBrlUUAzNv+s9zJ2tdF9/fI+amJZBAb
         sA02BWs/WPzmE7t2oxsRlq02iao8b4KUucOaHlaeLDmVgq8a1Z9Y9IPYSsEznerVB4ZH
         UTmnVLj1mvF2rVeno5H1H481H47xmXSBPLg6oc7+A6aNYd7Ly/Olc7jTgbcrtKprV5jy
         BoYqlsXZLdmHi70t5v5VuRsQDAZaLeUrJZ/eO+SELkWjbgaXI9AYkVBUbzHJ2WLOXEmv
         ikHQ==
Content-Disposition: inline
In-Reply-To: <20150110003819.GP31508@dastard>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Dave Chinner <david@fromorbit.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, jack@suse.cz, hch@infradead.org, hannes@cmpxchg.org, linux-fsdevel@vger.kernel.org, vgoyal@redhat.com, lizefan@huawei.com, cgroups@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.cz, clm@fb.com, fengguang.wu@intel.com

Hey,

On Sat, Jan 10, 2015 at 11:38:19AM +1100, Dave Chinner wrote:
> > What's implemented in this patchset is
> > propagation of memcg tags for pagecache pages.  If necessary, further
> > mechanisms can be added, but this should cover the basics.
> 
> Sure, but I'm just pointing out that if you dirty a million inodes
> in a memcg (e.g. chown -R), memcg-based writeback will not cause
> them to be written...

Sure, in such cases, they'd need further wiring up if to be solved
properly.  For some, we'd have to punt to the root cgroup and charge
it as general system cost but this is no different from other
controllers and at least some of such punting would be inherent in the
nature of the involved activities.

> > I measured avg sys+user time of 50 iterations of
> > 
> >   fs_mark -d /mnt/tmp/ -s 104857600 -n 32
> > 
> > on an ext2 on a ramdisk, which should put the hot path part - page
> > faulting and inode dirtying - under spotlight.  cgroup writeback
> > enabled but not used case consumes around 1% more cpu time - AVG 6.616
> > STDEV 0.050 w/o this patchset, AVG 6.682 STDEV 0.046 with.  This is an
> > extreme case and while it isn't free the overhead is fairly low.
> 
> What's the throughput for these numbers? CPU usage without any idea
> of the number of pages being scanned doesn't tell us a whole lot.

Ah, sorry about that.  Here's the output from one such fs_mark run.
Being run on a ramdisk, it's CPU bound (1.9Ghz Opteron).

$ fs_mark -d /mnt/tmp/ -s 104857600 -n 32 -v

[opt ~]# fs_mark -d /mnt/tmp/ -s 104857600 -n 32 -v

#  fs_mark  -d  /mnt/tmp/  -s  104857600  -n  32  -v
#       Version 3.3, 1 thread(s) starting at Sat Jan 10 10:46:13 2015
#       Sync method: INBAND FSYNC: fsync() per file in write loop.
#       Directories:  no subdirectories used
#       File names: 40 bytes long, (16 initial bytes of time stamp with 24 random bytes at end of name)
#       Files info: size 104857600 bytes, written with an IO size of 16384 bytes per write
#       App overhead is time in microseconds spent in the test not doing file writing related system calls.
#       All system call times are reported in microseconds.

FSUse%        Count         Size    Files/sec     App Overhead        CREAT (Min/Avg/Max)        WRITE (Min/Avg/Max)        FSYNC (Min/Avg/Max)         SYNC (Min/Avg/Max)        CLOSE (Min/Avg/Max)       UNLINK (Min/Avg/Max)
     5           32    104857600          4.6            23204       28       45       54       14       21      364    65986    73892   112279        0        0        0       12       12       13     2647     5777    23842

> I'd suggest that you should provide mechanisms at the block layer
> for accounting the pages in the bio to the memcg they belong to,
> not make a sweeping directive that filesystems can only write back
> pages from one memcg at a time.
> 
> If you account for pages to their memcg and decide on bio priority
> at bio_add_page() time you would avoid the inversion and cross-cg
> accounting problems.  If you do this, the filesystem doesn't need to
> care at all what memcg pages belong to; they just do optimal IO to
> clean sequential dirty pages and it is accounted and throttled
> appropriately by the lower layers.

That'd destroy the fundamental feedback mechanism propagating the
pressure from the blkcg split block device up through the writeback
eventually to the memcg.  This chain of backpressure is why this whole
scheme works.  When a blkcg on a device gets congested, its request
reserve becomes contended which in turn sets congestion state on the
channel and blocks further bio submissions till requests are complete.
This blocking of bio is the final and ultimate channel of the
backpressure propagation.  If you start mixing pages from different
cgroups in a single bio, the only options for handling it from the
lower layer is either splitting it into two separate requests and
finish the bio only on completion of both or choosing one victim
cgroup, essentially arbitrarily, both of which can lead to gross
priority inversion in many circumstances.

> > Maybe we can think of optimizations down the road but I'd strongly
> > prefer to stick to simple and clear divisions among cgroups.  Also, a
> > file highly interleaved by multiple cgroups isn't a particularly
> > likely use case.
> 
> That's true, and that's a further reason why I think we should not
> be caring about this case in the filesystem writeback code at all.

I'm afraid I'm not following this logic.  Why would we do something
which isn't straight forward and has a lot of corner cases for a
prospect for optimizing a fringe case?  The only thing filesystem
writeback logic has to do is skipping pages which belong to a
different cgroup, just like it'd skip a page which is already under
writeback.  There's nothing complicated about it.  Those pages simply
aren't the target of that writeback instance.

Thanks.

-- 
tejun

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
