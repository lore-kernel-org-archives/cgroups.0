From: ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org (Eric W. Biederman)
Subject: Re: [RFC][PATCH 0/9] Make containers kernel objects
Date: Tue, 23 May 2017 10:33:01 -0500
Message-ID: <87mva3k2qa.fsf@xmission.com>
References: <149547014649.10599.12025037906646164347.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <149547014649.10599.12025037906646164347.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
        (David Howells's message of "Mon, 22 May 2017 17:22:26 +0100")
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: trondmy-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org, mszeredi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> writes:

> Here are a set of patches to define a container object for the kernel and
> to provide some methods to create and manipulate them.

Just so this discussion has some clarity.

Nacked-by: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>

As a user visible entity I see nothing this container data structure
helps solve it only muddies the waters and makes things more brittle.

Embracing the complexity of namespaces head on tends to mean all of the
goofy scary semantic corner cases are visible from the first version of
the design, and so developers can't take short cuts that result in
buggy kernel code that persists for decades.  I am rather tired of
finding and fixing those.

Eric
