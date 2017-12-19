From: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH v2] writeback: synchronize sync(2) against cgroup
 writeback membership switches
Date: Tue, 19 Dec 2017 14:04:54 +0100
Message-ID: <20171219130454.GJ2277@quack2.suse.cz>
References: <dc694ae2-f07f-61e1-7097-7c8411cee12d@gmail.com>
 <20171205182007.GV2421075@devbig577.frc2.facebook.com>
 <8844b550-d91c-38d5-997a-a899d1e4aa42@gmail.com>
 <20171211195052.GN2421075@devbig577.frc2.facebook.com>
 <20171212163830.GC3919388@devbig577.frc2.facebook.com>
 <20171213110004.GB23068@quack2.suse.cz>
 <20171213153930.GO3919388@devbig577.frc2.facebook.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171213153930.GO3919388-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, xuejiufei <xuejiufei-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, kernel-team-b10kYP2dOMg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Wed 13-12-17 07:39:30, Tejun Heo wrote:
> Hello,
> 
> On Wed, Dec 13, 2017 at 12:00:04PM +0100, Jan Kara wrote:
> > OK, but this effectively prevents writeback from sync_inodes_sb() to ever
> > make inode switch wbs. Cannot that be abused in some way like making sure
> > writeback of our memcg is "invisible" by forcing it out using sync(2)? It
> > just looks a bit dangerous to me...
> 
> That's true.  There are a couple mitigating factors tho.
> 
> * While it can delay switching during sync(2), it'll all still be
>   recorded and the switch will happen soon if needed.
> 
> * sync(2) is hugely disruptive with or without this and can easily be
>   used to DOS the whole system.  People are working on restricting the
>   blast radius of sync(2) to mitigate this problem, which most likely
>   make this a non-problem too.
> 
> If you can think of a better solution, I'm all ears.

After some thinking about this I don't have a better solution. So you can
add:

Acked-by: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>

								Honza
-- 
Jan Kara <jack-IBi9RG/b67k@public.gmane.org>
SUSE Labs, CR
