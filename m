From: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [RFD] cgroup: about multiple hierarchies
Date: Fri, 02 Mar 2012 12:24:51 +0100
Message-ID: <1330687491.11248.223.camel@twins>
References: <20120221211938.GE12236@google.com>
	  <20120222163858.GB4128@redhat.com> <20120222165714.GC4128@redhat.com>
	  <1329990094.24994.64.camel@twins> <1330006399.11248.20.camel@twins>
	  <4F4FAF89.3090706@redhat.com> <1330633603.7414.49.camel@marge.simpson.net>
	 <4F50ABF2.5070809@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7BIT
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F50ABF2.5070809-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Michal Schmidt <mschmidt-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Mike Galbraith <efault-Mmb7MZpHnFY@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizf-BthXqXjhjHXQFUHtdCDX3A@public.gmane.org>, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, Lennart Poettering <lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org>, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

On Fri, 2012-03-02 at 12:16 +0100, Michal Schmidt wrote:
> On 03/01/2012 09:26 PM, Mike Galbraith wrote:
> > Q: you say systemd requires CONFIG_CGROUPS=y.  Why is that?  It's taking
> > over sysvinits job afaiui, what does that have to do with cgroups?
> 
> It does more than sysvinit. It does more than fork off services and then 
> forget about them. It keeps track of them all the time.
> It notices when all processes of a service have exited.
> It can kill all processes descended from a service.
> It can always tell what service a given process belongs to.

And I don't give a crap about any of that.. sysvinit was sufficient. 
