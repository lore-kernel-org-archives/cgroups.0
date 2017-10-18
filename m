From: Paul Moore <paul@paul-moore.com>
Subject: Re: RFC(v2): Audit Kernel Container IDs
Date: Wed, 18 Oct 2017 15:58:13 -0400
Message-ID: <CAHC9VhTBd1pNqavFpQqDHwhW=j7AX8gDL0H_c_VBD07SMMLZmQ@mail.gmail.com>
References: <20171012141359.saqdtnodwmbz33b2@madcap2.tricolour.ca>
 <75b7d6a6-42ba-2dff-1836-1091c7c024e7@schaufler-ca.com> <20171017003340.whjdkqmkw4lydwy7@madcap2.tricolour.ca>
 <2319693.5l3M4ZINGd@x2> <1508243469.6230.24.camel@redhat.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=MAieFk74nWeXBGb6JTe7E0jtK2nE9wrmaPzKOpAYwfg=;
        b=bb4X7G4ZtMBRwc/7dEU54J8/dOka4zVBbImNTjQktw4fVDbzlrSS1DAIuyLgro7N2C
         tzk5R+d5yOgCgmYk1W6OXL8ZnLbIc1qjMlo7e5MJXGnIr+8DZZoO43oDVyyApwHcRKWc
         bcBxuPslMQDjHXozlVUT3BdISklsEAEE4q/2Z2ry8Sqm/hImxnpawqIZ0yQbeDrSppAi
         UNJKCy/1js5W0cpYqRhn5Fd0jM+zcOP02NYF3QxzSipLhsPJbDvTl8IHopW9xCNl4guy
         tJUEZNXrbNTKFHq4h3DjoQ6HLNyrEfYxkmxvglhD/6uPxr9DXzh6QdlRO3LHq9u9NS+W
         mlNA==
In-Reply-To: <1508243469.6230.24.camel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Simo Sorce <simo@redhat.com>
Cc: Steve Grubb <sgrubb@redhat.com>, linux-audit@redhat.com, mszeredi@redhat.com, cgroups@vger.kernel.org, jlayton@redhat.com, Richard Guy Briggs <rgb@redhat.com>, Linux API <linux-api@vger.kernel.org>, Containers <containers@lists.linux-foundation.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Howells <dhowells@redhat.com>, Carlos O'Donell <carlos@redhat.com>, Linux Network Development <netdev@vger.kernel.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Lutomirski <luto@kernel.org>, Eric Paris <eparis@parisplace.org>, "Serge E. Hallyn" <serge@hallyn.com>, trondmy@primarydata.com, Al Viro <viro@zeniv.linux.org.uk>

On Tue, Oct 17, 2017 at 8:31 AM, Simo Sorce <simo@redhat.com> wrote:
> The container Id can be used also for authorization purposes (by other
> processes on the host), not just audit, I think this is why a separate
> control has been proposed.

Apologies, but I'm just now getting a chance to work my way through
this thread, and I wanted to make a quick comment on this point ...

The audit container ID (note I said "audit container ID" not
"container ID") is intended strictly for use by the audit subsystem at
this point.  Allowing other uses opens the door to a larger set of
problems we are trying to avoid (e.g. handling migration across
hosts).  We would love to have a generic kernel facility that the
audit subsystem could use to identify containers, but we don't, and
previous attempts have failed, so we have to create our own.  We are
intentionally trying to limit its scope in an attempt to limit
problems.  If a more general solution appears in the future I think we
would make every effect to migrate to that; keeping this initial
effort small should make that easier.

-- 
paul moore
www.paul-moore.com
