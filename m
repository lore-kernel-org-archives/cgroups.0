From: Colin Walters <walters-gPq2gbYjIk8dnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC][PATCH 0/9] Make containers kernel objects
Date: Tue, 23 May 2017 10:54:52 -0400
Message-ID: <1495551292.2742620.985957224.3FCF254A@webmail.messagingengine.com>
References: <149547014649.10599.12025037906646164347.stgit@warthog.procyon.org.uk>
 <87lgpoww67.fsf@xmission.com> <1495491733.25946.3.camel@redhat.com>
 <874lwbraxh.fsf@xmission.com>
 <CAEiveUcbmm5m4=11ZppxAWppeoFWUBFpLC7dAZRuBCTFHR548g@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=x04t/f
        C4OvRVtz3F3kzRPdc/9jLYOF/dYfohcLgViDc=; b=JWBr89NIHiIXTUue1ai9qL
        T/t/3jci3TaigXWTfRAxsseCoOhG6+dd+ZX4w2Y0Fxp4OyfYmlHS/QVS7i9jOamS
        35bGLtID3wQuHWmhYcNWCdIhYDvJvUOvLyiHqCvxadJLJ2Cli2Teq3aVWsLLKiYR
        K9tF2fjvh2N2wRTLQTUhefxaW+YemoC4MtkCgyPD8AjsSDDFSnIPbFu13eoTsLiF
        +QhJal9hc/c6bXIRke5cig9Lcj3ZbLTS/nAxrud6EJiRMqeVx0ZEf9yYrMMi5ivH
        ESaBBT6lYPeXUJ96QKArGILBcCsuatvgyXSCJAoiBhD3U7VVkyMkXxcpMhrDkRzA
        ==
In-Reply-To: <CAEiveUcbmm5m4=11ZppxAWppeoFWUBFpLC7dAZRuBCTFHR548g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, trondmy-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org, Miklos Szeredi <mszeredi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, May 23, 2017, at 10:30 AM, Djalal Harouni wrote:
>
> Maybe it depends on the cases, a general approach can be too difficult
> to handle especially from the security point. Maybe it is better to
> identify what operations need what context, and a userspace
> service/proxy can act using kthreadd with the right context... at
> least the shift to this model has been done for years now in the
> mobile industry.

Why not drop the upcall model in favor of having userspace
monitor events via a (more efficient) protocol and react to them on its own?
It's just generally more flexible and avoids all of those issues like
replicating the seccomp configuration, etc.

Something like inotify/signalfd could be a precedent around having a read()/poll()able
fd.  /proc/keys-requests ?

Then if you create a new user namespace, and open /proc/keys-requests, the
kernel will always write to that instead of calling /sbin/request-key.
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
