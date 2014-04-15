From: Aristeu Rozanski <aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] device_cgroup: do not use rule acceptance function to
 validate access
Date: Tue, 15 Apr 2014 12:53:55 -0400
Message-ID: <20140415165355.GB29214@redhat.com>
References: <20140414144736.GS29214@redhat.com>
 <20140415155752.GC5184@sergelap>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20140415155752.GC5184@sergelap>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>

Hi Serge,

On Tue, Apr 15, 2014 at 10:57:52AM -0500, Serge Hallyn wrote:
> Quoting Aristeu Rozanski (aris-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org):
> > may_access() is currently used to validate both new exceptions from children
> > groups and to check if an access is allowed. This not only makes it hard to
> > understand and maintain, but it's also incorrect.
> 
> Heh, well one might argue that may_access() was more approriate at
> __devcgroup_check_permission(), should remain simpler, and parent_has_perm()
> should be the wrapper doing the extra bits.  That would be easier to
> read imo.
> 
> In what you have here, you end up duplicating the
> list_for_each_entry_rcu.  I think you should at least have a common
> fn for that.
> 
> I don't want to sound pedantic, but since the point of this patch is
> that simplicity/ease-of-reading would have prevented the bug ... :)

Yes, trying to get this right this time. The problem itself isn't
simple, comparing ranges when adding new rules on the child and the
possible difference between the meaning of the exception (is it to
disallow access in that range or to allow?) makes things complicated.

> I *think* it's ok, and I appreciate you finding and fixing the bug, but
> I don't think the result is as easy to read as it could be, so if you
> don't mind I'd like to wait for a new version to ack.  If you disagree
> with me, let me know and I'll re-read and (presumably) ack.

Yes, don't worry about it, I'm working on a v2 that will makes things
easier to read. If not, I'll keep working on it until it looks simple
enough.

-- 
Aristeu
