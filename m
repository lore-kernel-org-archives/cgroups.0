From: Greg KH <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCHSET cgroup/for-3.16] cgroup: implement cgroup.populated
Date: Fri, 25 Apr 2014 11:57:52 -0700
Message-ID: <20140425185752.GA10662@kroah.com>
References: <1397056052-2829-1-git-send-email-tj@kernel.org>
 <20140414213100.GA1863@htj.dyndns.org>
 <20140414222658.GA18152@kroah.com>
 <20140415161828.GA30990@htj.dyndns.org>
 <20140423151638.GG4781@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140423151638.GG4781-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, john-jueV0HHMeujJJrXXpGQQMAC/G2K4zDHf@public.gmane.org, rlove-L7G0xEPcOZbYtjvyW6yDsg@public.gmane.org, eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org, serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org, lennart-mdGvqq1h2p+GdvJs77BJ7Q@public.gmane.org, kay-tD+1rO4QERM@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org

On Wed, Apr 23, 2014 at 11:16:38AM -0400, Tejun Heo wrote:
> On Tue, Apr 15, 2014 at 12:18:28PM -0400, Tejun Heo wrote:
> > Hello, Greg.
> > 
> > On Mon, Apr 14, 2014 at 03:26:58PM -0700, Greg KH wrote:
> > > Do you want me to pull this branch into my tree for 3.16 now?  I have no
> > > objection to you taking it, if that's easier for you, which ever is fine
> > > for me.
> > 
> > I think the best way to proceed would be applying 1-2 to
> > driver-core-next and then base cgroup/for-3.16 on top of it, but I'd
> > like to get some feedback from inotify people before proceeding.
> 
> Greg, can you please apply the first two patches to driver-core-next
> (or a separate branch which is pulled into driver-core-next, either
> way works for me as long as the branch is stable)?  I'll pull in the
> branch and route the third patch through cgroup/for-3.16.

Now done.

greg k-h
