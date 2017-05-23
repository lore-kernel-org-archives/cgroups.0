From: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [RFC][PATCH 0/9] Make containers kernel objects
Date: Tue, 23 May 2017 10:27:24 -0400
Message-ID: <1495549644.2946.14.camel@redhat.com>
References: <149547014649.10599.12025037906646164347.stgit@warthog.procyon.org.uk>
         <87lgpoww67.fsf@xmission.com> <1495491733.25946.3.camel@redhat.com>
         <874lwbraxh.fsf@xmission.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <874lwbraxh.fsf-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, trondmy-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org, mszeredi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

On Tue, 2017-05-23 at 07:54 -0500, Eric W. Biederman wrote:
> Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:
> 
> > On Mon, 2017-05-22 at 14:04 -0500, Eric W. Biederman wrote:
> > > David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:
> > > 
> > > > Here are a set of patches to define a container object for the kernel and
> > > > to provide some methods to create and manipulate them.
> > > > 
> > > > The reason I think this is necessary is that the kernel has no idea how to
> > > > direct upcalls to what userspace considers to be a container - current
> > > > Linux practice appears to make a "container" just an arbitrarily chosen
> > > > junction of namespaces, control groups and files, which may be changed
> > > > individually within the "container".
> > > > 
> > > 
> > > I think this might possibly be a useful abstraction for solving the
> > > keyring upcalls if it was something created implicitly.
> > > 
> > > fork_into_container for use by keyring upcalls is currently a security
> > > vulnerability as it allows escaping all of a containers cgroups.  But
> > > you have that on your list of things to fix.  However you don't have
> > > seccomp and a few other things.
> > > 
> > > Before we had kthreadd in the kernel upcalls always had issues because
> > > the code to reset all of the userspace bits and make the forked
> > > task suitable for running upcalls was always missing some detail.  It is
> > > a very bug-prone kind of idiom that you are talking about.  It is doubly
> > > bug-prone because the wrongness is visible to userspace and as such
> > > might get become a frozen KABI guarantee.
> > > 
> > > Let me suggest a concrete alternative:
> > > 
> > > - At the time of mount observer the mounters user namespace.
> > > - Find the mounters pid namespace.
> > > - If the mounters pid namespace is owned by the mounters user namespace
> > >   walk up the pid namespace tree to the first pid namespace owned by
> > >   that user namespace.
> > > - If the mounters pid namespace is not owned by the mounters user
> > >   namespace fail the mount it is going to need to make upcalls as
> > >   will not be possible.
> > > - Hold a reference to the pid namespace that was found.
> > > 
> > > Then when an upcall needs to be made fork a child of the init process
> > > of the specified pid namespace.  Or fail if the init process of the
> > > pid namespace has died.
> > > 
> > > That should always work and it does not require keeping expensive state
> > > where we did not have it previously.  Further because the semantics are
> > > fork a child of a particular pid namespace's init as features get added
> > > to the kernel this code remains well defined.
> > > 
> > > For ordinary request-key upcalls we should be able to use the same rules
> > > and just not save/restore things in the kernel.
> > > 
> > 
> > OK, that does seem like a reasonable idea. Note that it's not just
> > request-key upcalls here that we're interested in, but anything that
> > we'd typically spawn from kthreadd otherwise.
> 
> General user mode helper *Nod*.
> 
> > That said, I worry a little about this. If the init process does a setns
> > at the wrong time, suddenly you're doing the upcall in different
> > namespaces than you intended.
> > 
> > Might it be better to use the init process of the container as the
> > template like you suggest, but snapshot its "context" at a particular
> > point in time instead?
> > 
> > knfsd could do this when it's started, for instance...
> 
> The danger of a snapshot it time is something important (like cgroup
> membership) might change.
> 

This is also a problem with relying on the userland program to do a
setns() and whatnot to set itself up for running in the container. If
something is added that it doesn't know about you'll just end up
inheriting whatever kthreadd had. If we don't get that right, we can end
up giving userland a security hole.

> It might be necessary to have this be an opt-in.   Perhaps even to the
> point of starting a dedicated kthreadd.
> 

I think we could live with that in knfsd-land. We could spawn a kthreadd
thread whenever a new nfsd_net is created. Then we'd just need something
like call_usermodehelper that puts the task create request on the right
kthreadd list. Running one more thread in your containerized NFS server
shouldn't be too onerous, I wouldn't think.

Once we start getting into uses with keyrings and the like though, I'm
not sure how workable that would be.

> Right now I think we need to figure out what it will take to solve this
> in the kernel because I strongly suspect that solving this in userspace
> is a cop out and we really aren't providing enough information to
> userspace to run the helper in the proper context.    And I strongly
> suspect that providing enough information from the kernel will be
> roughly equivalent to solving this in the kernel.
> 
> The only big issue I have had with the suggestion of a dedicated thread
> in the past is the overhead something like that will breing with it.
> 

Yes, I don't see how you can do these sorts of upcalls properly without
either more help from the kernel, or without providing the kernel with
enough info to do it properly.

I don't quite get the arguments that have been made about loss of
flexibility either. The basic idea here is to communicate to the kernel
how a container is structured so that it can spawn processes inside of
it as necessary.
-- 
Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
