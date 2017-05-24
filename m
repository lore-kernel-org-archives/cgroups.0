From: Ian Kent <raven-PKsaG3nR2I+sTnJN9+BGXg@public.gmane.org>
Subject: Re: [RFC][PATCH 0/9] Make containers kernel objects
Date: Wed, 24 May 2017 17:16:49 +0800
Message-ID: <1495617409.2538.1.camel@themaw.net>
References: <1495554267.27369.9.camel@HansenPartnership.com>
         <87zie3mxkc.fsf@xmission.com>
         <f167feeb-e653-12e3-eec8-24162f7f7c07@suse.de>
         <149547014649.10599.12025037906646164347.stgit@warthog.procyon.org.uk>
         <1495472039.2757.19.camel@HansenPartnership.com>
         <2446.1495551216@warthog.procyon.org.uk>
         <2961.1495552481@warthog.procyon.org.uk> <87bmqjmwl5.fsf@xmission.com>
         <3860.1495557363@warthog.procyon.org.uk> <87k256ek3e.fsf@xmission.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=themaw.net; h=cc
        :content-transfer-encoding:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-sender
        :x-me-sender:x-sasl-enc:x-sasl-enc; s=fm1; bh=zenQ4qOz/ivJ9x3YQB
        xOlw8Ri878a5kVaZteCBeR348=; b=icDkK1XzOZb9M2QqDeLwbKIU8IhS+glFmy
        0Nr+L/uikDN/X+Ogd+4TCILyvwjR4125+tOmfVCNyu5UMuy3rheyXjSnfbM6IR1T
        qJtpTDdRE+5FLoPWgPNzaq5o9JM2Tezp7llZTkXMcCJG9yOk/u86X2RBPCoVtb+N
        1QNK5EubKZGPLuoPM+/v17Zg4Heo3Ce2QgIOB/GV496B8N/4ykqxNKF8YIKYHjNk
        y8k0EeMIDLMDmCaCnUv2OYCm5CZPhudBb5vLf4gv8COp63tp/EOHAZQp5ZbSYrho
        GKDdbQIovLZQCf9tG/H1dgH5mdW1r4wMGwJAQHXEPYDZ1cte/1RQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-sender:x-me-sender:x-sasl-enc:x-sasl-enc; s=
        fm1; bh=zenQ4qOz/ivJ9x3YQBxOlw8Ri878a5kVaZteCBeR348=; b=LFdrrcmt
        WTcGLcGB/eJNmwJQJq8aQtp8GJudMHN1LKOk+BfgEZSOjYKOvp6gZew8yqJQitt4
        /Gkwysz19hyN7bx2VgNRAzoeuwNHi0eQ0W0GZeS/bNm5xdk+hKAGuRQWQes9Cvmq
        iUIWcy4v9uWXctBQHKYuVjqRYsm2HHkEz+vV3WkHutUvP9Tbyk6R2L9WreUCA0DB
        SBgw2L7PgYjZVfzwQoTZB79QGx9hXw+RfYR6n7ahcJavOWSobhFNd9sm4fcf2TpT
        xcYHFD9eOEDQsoAZsD4eRy1aFOMIqJwpah5PGi+R1hx+XOfDjHhVKEif8GdNC5jT
        2jdqDXUEYps9VA==
In-Reply-To: <87k256ek3e.fsf-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, mszeredi-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jlayton-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, Linux Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, trondmy-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org, viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org

On Wed, 2017-05-24 at 03:26 -0500, Eric W. Biederman wrote:
> 
> So far no one has even bothered to seriously try the one solution that
> is guaranteed to work because it takes a lot of changes to kernel code.
> I believe the last effort snagged on what a pain it is to refactor the
> user mode helper infrastructure.

Yes, that's mostly true in my case although I wouldn't say I haven't looked at
it seriously but equally I haven't got anything towards it yet either, sorry.

I'm likely going to revisit this based on a couple of approaches.

One is just what you describe and I had already been looking at this some time
ago. It seems to me that adding a work queue type that starts and retains a
process until the work queue is destroyed (similar to the way the work queue sub
system starts a fail over thread for use under resource exhaustion) would be a
sensible way to do it.

This doesn't mean I think it's a good idea for reasons I've outlined in the past
but the approach does warrant the effort to work out if it can be used without
problems.

And there's also the request key infrastructure which, as it is now, gets in the
road of verifying results, *sigh*.

Ian
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
