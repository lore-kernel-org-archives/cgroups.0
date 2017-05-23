From: Ian Kent <raven-PKsaG3nR2I+sTnJN9+BGXg@public.gmane.org>
Subject: Re: [RFC][PATCH 0/9] Make containers kernel objects
Date: Tue, 23 May 2017 18:09:53 +0800
Message-ID: <1495534193.2564.3.camel@themaw.net>
References: <149547014649.10599.12025037906646164347.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=cc
        :content-transfer-encoding:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-sender
        :x-me-sender:x-sasl-enc:x-sasl-enc; s=fm1; bh=onCnbn6DUZtHfa/mXi
        WmcxZLsW1iJrBYbKIuhvnpMx4=; b=mI27vTdBrIfdPpxQL4qheyqVidbTFhS4gR
        XNkpbUpHEf4oOCcwdN/ECAuJGoDdeUvat6PDbySk1oCYfpnOSqXgq+e5nPTwJWtQ
        cw6hMkv4O4T7C1j/RUmPGS82imjIIGCa89lAFfYVMfMigMZmoVZC6Ah69ZKG6Vjx
        G53LCIFRCjNAgl/SRLrHsVr6fFCEG1CwzA9dpXZyHjPCXmWdb4MTChw2OSF1WQGl
        9Unj/+ozFee+iRXYar3oLCKFlJvsLJrYmUeBReOUwPdsc0d+IDgN1/oD0YdUPWxl
        nsWUZNZLk14Ogubnylt3/Q3kexshpDFz9hxI0KTxq//CPQFdhl4Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-sender:x-me-sender:x-sasl-enc:x-sasl-enc; s=
        fm1; bh=onCnbn6DUZtHfa/mXiWmcxZLsW1iJrBYbKIuhvnpMx4=; b=QRFyMLcA
        OarAosR6cE1I5jkD3vBFkYxXO3z8e9gnG0byEf8TsJ4KUzOJqVgndh+RbJlMze1m
        oqXgz+ylDKG5Gne+VdgC/JEzYSkxtj5LVP/divSmDuoEU5HQnpayZLPcYIHl53F/
        tM6g+Nb6zN7yRmY1MAeVCdrDJSDukxUys/pqKv8rRaogngoSGcFtQ2Mya5IXNLY6
        +7e+FH5qSvn4YiIu2RpLiKukr+Ne/K3BM4qLkugiJe0BPyow/5WYPQWjyKqeJDIY
        r+U2X9jqeEhWqub7gm75/2F9BB0FZSd7aPjQ1FkruK6Uk9L7DhJsYopBrSyvtZyx
        DzCAfX2EPPCppA==
In-Reply-To: <149547014649.10599.12025037906646164347.stgit-S6HVgzuS8uM4Awkfq6JHfwNdhmdF6hFW@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="utf-8"
To: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, trondmy-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org
Cc: mszeredi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org

On Mon, 2017-05-22 at 17:22 +0100, David Howells wrote:
> Here are a set of patches to define a container object for the kernel and
> to provide some methods to create and manipulate them.
> 
> The reason I think this is necessary is that the kernel has no idea how to
> direct upcalls to what userspace considers to be a container - current
> Linux practice appears to make a "container" just an arbitrarily chosen
> junction of namespaces, control groups and files, which may be changed
> individually within the "container".
> 
> The kernel upcall mechanism then needs to decide which set of namespaces,
> etc., it must exec the appropriate upcall program.  Examples of this
> include:
> 
>  (1) The DNS resolver.  The DNS cache in the kernel should probably be
>      per-network namespace, but in userspace the program, its libraries and
>      its config data are associated with a mount tree and a user namespace
>      and it gets run in a particular pid namespace.
> 
>  (2) NFS ID mapper.  The NFS ID mapping cache should also probably be
>      per-network namespace.
> 
>  (3) nfsdcltrack.  A way for NFSD to access stable storage for tracking
>      of persistent state.  Again, network-namespace dependent, but also
>      perhaps mount-namespace dependent.
> 
>  (4) General request-key upcalls.  Not particularly namespace dependent,
>      apart from keyrings being somewhat governed by the user namespace and
>      the upcall being configured by the mount namespace.
> 
> These patches are built on top of the mount context patchset so that
> namespaces can be properly propagated over submounts/automounts.
> 
> These patches implement a container object that holds the following things:
> 
>  (1) Namespaces.
> 
>  (2) A root directory.
> 
>  (3) A set of processes, including a designated 'init' process.
> 
>  (4) The creator's credentials, including ownership.
> 
>  (5) A place to hang security for the container, allowing policies to be
>      set per-container.
> 
> I also want to add:
> 
>  (6) Control groups.
> 
>  (7) A per-container keyring that can be added to from outside of the
>      container, even once the container is live, for the provision of
>      filesystem authentication/encryption keys in advance of the container
>      being started.

It's hard to decide which of these has higher priority, I think both essential
to a container implementation.

Ian
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
