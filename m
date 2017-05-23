From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC][PATCH 0/9] Make containers kernel objects
Date: Tue, 23 May 2017 11:31:31 -0400
Message-ID: <1495553491.2946.16.camel@redhat.com>
References: <149547014649.10599.12025037906646164347.stgit@warthog.procyon.org.uk>
         <87lgpoww67.fsf@xmission.com> <1495491733.25946.3.camel@redhat.com>
         <874lwbraxh.fsf@xmission.com>
         <CAEiveUcbmm5m4=11ZppxAWppeoFWUBFpLC7dAZRuBCTFHR548g@mail.gmail.com>
         <1495551292.2742620.985957224.3FCF254A@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1495551292.2742620.985957224.3FCF254A-2RFepEojUI2N1INw9kWLP6GC3tUn3ZHUQQ4Iyu8u01E@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Colin Walters <walters-gPq2gbYjIk8dnm+yROfE0A@public.gmane.org>, Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, trondmy-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org, Miklos Szeredi <mszeredi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, 2017-05-23 at 10:54 -0400, Colin Walters wrote:
> On Tue, May 23, 2017, at 10:30 AM, Djalal Harouni wrote:
> > 
> > Maybe it depends on the cases, a general approach can be too difficult
> > to handle especially from the security point. Maybe it is better to
> > identify what operations need what context, and a userspace
> > service/proxy can act using kthreadd with the right context... at
> > least the shift to this model has been done for years now in the
> > mobile industry.
> 
> Why not drop the upcall model in favor of having userspace
> monitor events via a (more efficient) protocol and react to them on its own?
> It's just generally more flexible and avoids all of those issues like
> replicating the seccomp configuration, etc.
> 
> Something like inotify/signalfd could be a precedent around having a read()/poll()able
> fd.  /proc/keys-requests ?
> 
> Then if you create a new user namespace, and open /proc/keys-requests, the
> kernel will always write to that instead of calling /sbin/request-key.

Case in point:

nfsdcltrack was originally nfsdcld, a long running daemon that used
rpc_pipefs to talk to the kernel. That meant that you had to make sure
it gets enabled by systemd (or sysvinit, etc). If it dies, then you also
want to ensure that it gets restarted lest the kernel server hang,
etc...

It was pretty universally hated, as it was just one more daemon that you
needed to run to work a proper nfs server. So, I was encouraged to
switch it to a call_usermodehelper upcall and since then it has just
worked, as long as the binary is installed.

It's quite easy to say:

"You're doing it wrong. You just need to run all of these services as
long-running daemons."

But, that ignores the fact that handling long-running daemons for
infrequently used upcalls is actually quite painful to manage in
practice.

-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
