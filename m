From: Colin Walters <walters-gPq2gbYjIk8dnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC][PATCH 0/9] Make containers kernel objects
Date: Tue, 23 May 2017 11:35:52 -0400
Message-ID: <1495553752.2751759.986007384.4E1A6A8B@webmail.messagingengine.com>
References: <149547014649.10599.12025037906646164347.stgit@warthog.procyon.org.uk>
 <87lgpoww67.fsf@xmission.com> <1495491733.25946.3.camel@redhat.com>
 <874lwbraxh.fsf@xmission.com>
 <CAEiveUcbmm5m4=11ZppxAWppeoFWUBFpLC7dAZRuBCTFHR548g@mail.gmail.com>
 <1495551292.2742620.985957224.3FCF254A@webmail.messagingengine.com>
 <1495553491.2946.16.camel@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=fDfc+Z
        9SO00r18dPOLucnwVsTKmLe1NOv37sX7aNTa4=; b=QhMJX4wUETudpNoQElFTLY
        mYlzt7ie0INs8VbZPrI9ah9QIVB4OOBxpXf6P9KOysNROo22jdbhfl1YBEk4ICZo
        +s+g1TLeC6SftL5cd70Hf/FcAUcUna6xWjILKlmtwWB4vSHwmKhvmUK7iIXVKElL
        ZNMeZMzWCCtq9ow7U7/M2xK/oqw8HhdnA9bXIFyrHrNmk9RmzBQdGPO9KOEPJMmG
        BfXSwGbcrxnTY0cmV4dXjpi+UyAifYZnP8kDm3jwlUhp9QzjEnWBNrCe/wE2rQct
        Szs0lFP7E0EEbNC7DZ99Ni8mS3XRXZhjSfwE7R6pLn/cnG2qT7t2l0KTBM6mr1Hg
        ==
In-Reply-To: <1495553491.2946.16.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Jeff Layton <jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Djalal Harouni <tixxdz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, trondmy-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org, Miklos Szeredi <mszeredi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "open list:CONTROL GROUP (CGROUP)" <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Tue, May 23, 2017, at 11:31 AM, Jeff Layton wrote:
> 
> nfsdcltrack was originally nfsdcld, a long running daemon that used
> rpc_pipefs to talk to the kernel. That meant that you had to make sure
> it gets enabled by systemd (or sysvinit, etc). If it dies, then you also
> want to ensure that it gets restarted lest the kernel server hang,
> etc...
> 
> It was pretty universally hated, as it was just one more daemon that you
> needed to run to work a proper nfs server. So, I was encouraged to
> switch it to a call_usermodehelper upcall and since then it has just
> worked, as long as the binary is installed.

Note that with the "read()/write() fd" model you don't need
a whole process just to do that...the functionality could be rolled into systemd
or equivalent easily enough.

> "You're doing it wrong. You just need to run all of these services as
> long-running daemons."

Also, I imagine we could figure out a clean model to do *activation*
from kernel -> userspace too.  systemd's socket activation model
where pid 1 activates units on demand is quite nice and obviates
the need to configure things on in advance.
