From: "Paul E. McKenney" <paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH] cgroup/cpuset: fix circular locking dependency
Date: Wed, 10 Jan 2018 14:10:40 -0800
Message-ID: <20180110221040.GO9671@linux.vnet.ibm.com>
References: <20180108225238.GN9671@linux.vnet.ibm.com>
 <20180109003127.GA30224@linux.vnet.ibm.com>
 <20180109034211.GC3668920@devbig577.frc2.facebook.com>
 <20180109042016.GR9671@linux.vnet.ibm.com>
 <20180109134448.GE3668920@devbig577.frc2.facebook.com>
 <20180109152112.GT9671@linux.vnet.ibm.com>
 <20180109153752.GI3668920@devbig577.frc2.facebook.com>
 <20180109160022.GW9671@linux.vnet.ibm.com>
 <20180110200821.GA22541@linux.vnet.ibm.com>
 <20180110214101.GE3460072@devbig577.frc2.facebook.com>
Reply-To: paulmck-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180110214101.GE3460072-4dN5La/x3IkLX0oZNxdnEQ2O0Ztt9esIQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, avagin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sramana-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org

On Wed, Jan 10, 2018 at 01:41:01PM -0800, Tejun Heo wrote:
> Hello, Paul.
> 
> On Wed, Jan 10, 2018 at 12:08:21PM -0800, Paul E. McKenney wrote:
> > And one additional question...  How are we pushing this upstream?  By
> > default, I would push things starting this late into the merge window
> > following the next one (v4.17), but would be more than willing to make
> > an exception given that this fixes a valid real-world complaint.
> 
> I put the workqueue part in the fixes branch.  If there's gonna be
> another rc, I'm gonna push it to Linus.  If not, I'll push when the
> next window opens.  I think either way should be fine.
> 
> > For that matter, if you would rather push my commit along with your pair
> > of commits, that works for me!  Either way, please just let me know.
> 
> Oh, let's push these through their respective trees.  Please take the
> RCU one through the usual RCU tree.

Works for me!

> Thank you very much.

And to you!

							Thanx, Paul
