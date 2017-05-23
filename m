From: Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC][PATCH 0/9] Make containers kernel objects
Date: Tue, 23 May 2017 16:23:55 +0200
Message-ID: <CAEiveUchdQVvFCVxSVcvpxnT0gj=sidfsJfW5mOOWKL6LWddYQ@mail.gmail.com>
References: <149547014649.10599.12025037906646164347.stgit@warthog.procyon.org.uk>
 <87lgpoww67.fsf@xmission.com> <1495491733.25946.3.camel@redhat.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=Q0AoP/PkJ+iu06hwzT1Vxe2+uhBabqo/7W7+tM2spTs=;
        b=hXMfHYuaMm/9a5096klUmcy1Fo5IDf9gz5BDP8BRldZo3v2mApE1ON/IgMUMjzCywE
         Lg/KY0hW6mVVtQKbCcxo2Ji/CbqtOkTrugVTITIrT4pCJtCUaeUvZc96UJn/nXdADyxc
         cUjFNUjbiCWTPwEqQqgvF0L+45luh6JF0IvQU4ilwzf5+hpiGpSpQFKXINyl/6i80gWy
         KDzjx2Mb3dDyuc7sxmhiYo2R1VFbf5j3nfiPGLIM90q2tLRmSHaJljviyWyroEeVWHKl
         juh8G5j6/ogYLPtQxCozMAUQ447N60mNSwtdEPCXwKjGQuxK/XX6De0jHhEPhxrrWLCX
         EToA==
In-Reply-To: <1495491733.25946.3.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, trondmy-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org, Miklos Szeredi <mszeredi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>

On Tue, May 23, 2017 at 12:22 AM, Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> On Mon, 2017-05-22 at 14:04 -0500, Eric W. Biederman wrote:
>> David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:
>>
>> > Here are a set of patches to define a container object for the kernel and
>> > to provide some methods to create and manipulate them.
>> >
>> > The reason I think this is necessary is that the kernel has no idea how to
>> > direct upcalls to what userspace considers to be a container - current
>> > Linux practice appears to make a "container" just an arbitrarily chosen
>> > junction of namespaces, control groups and files, which may be changed
>> > individually within the "container".
>> >
>>
>> I think this might possibly be a useful abstraction for solving the
>> keyring upcalls if it was something created implicitly.
>>
>> fork_into_container for use by keyring upcalls is currently a security
>> vulnerability as it allows escaping all of a containers cgroups.  But
>> you have that on your list of things to fix.  However you don't have
>> seccomp and a few other things.
>>
>> Before we had kthreadd in the kernel upcalls always had issues because
>> the code to reset all of the userspace bits and make the forked
>> task suitable for running upcalls was always missing some detail.  It is
>> a very bug-prone kind of idiom that you are talking about.  It is doubly
>> bug-prone because the wrongness is visible to userspace and as such
>> might get become a frozen KABI guarantee.
>>
>> Let me suggest a concrete alternative:
>>
>> - At the time of mount observer the mounters user namespace.
>> - Find the mounters pid namespace.
>> - If the mounters pid namespace is owned by the mounters user namespace
>>   walk up the pid namespace tree to the first pid namespace owned by
>>   that user namespace.
>> - If the mounters pid namespace is not owned by the mounters user
>>   namespace fail the mount it is going to need to make upcalls as
>>   will not be possible.
>> - Hold a reference to the pid namespace that was found.
>>
>> Then when an upcall needs to be made fork a child of the init process
>> of the specified pid namespace.  Or fail if the init process of the
>> pid namespace has died.
>>
>> That should always work and it does not require keeping expensive state
>> where we did not have it previously.  Further because the semantics are
>> fork a child of a particular pid namespace's init as features get added
>> to the kernel this code remains well defined.
>>
>> For ordinary request-key upcalls we should be able to use the same rules
>> and just not save/restore things in the kernel.
>>
>
> OK, that does seem like a reasonable idea. Note that it's not just
> request-key upcalls here that we're interested in, but anything that
> we'd typically spawn from kthreadd otherwise.

Generalizing it will expose the kernel to exploits, today containers
setup the mount namespace for images from the net, outdated
filesystems, and users just do it,  it is easy. Having kthread running
inside such contexts is not a good idea. That's today usecases.


> That said, I worry a little about this. If the init process does a setns
> at the wrong time, suddenly you're doing the upcall in different
> namespaces than you intended.

That init process or whatever process inside owns that context and files.

Maybe for some cases it is better to use userspace that you can talk
to through a standard kernel bus endpoint and request a resource as it
is done within modern apps. The application at the other end acts
using kthread helpers in the appropriate context.


-- 
tixxdz
