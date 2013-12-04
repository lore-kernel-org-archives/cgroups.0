From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [lxc-devel] cgroup management daemon
Date: Tue, 3 Dec 2013 20:24:16 -0500
Message-ID: <20131204012416.GY8277@htj.dyndns.org>
References: <20131125224335.GA15481@mail.hallyn.com>
 <20131203134506.GG8277@htj.dyndns.org>
 <20131204000344.GB24968@sergelap>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=gI4h2ixDiyeovKYGxY2WpAZNB9w+Vmnc+LHKfaI6KT8=;
        b=OBYy8V6o8pT8JzLdgx+Rhp9951ZF6rBAE5Vo06v1NlzRuz7fUno9/qO7TlyHq/RWUt
         Vamb6xmG8jA+gn5qvjVkzj+Ee34+G850UHfumVe2zV1vsqTTUkTxnvz5G21NtvciqgEG
         1JXfo3XTrFg63zMb2MvP3cewTPmjyTt/p0z8rU/X7DGVzEVR8hWR0VcQYB0Qdyf1a4MF
         1chKCuOWUnyM7Vrk/iTwgYu0avCPrjdlCi6Bt4BJ2b2+AUoeXDQMUqCn+7M2IC2k9Zjx
         KJuP68m5vQVB0QUFFvniR/TcIq3KHNs2OO5EW2zkagtng0O7r+eXXmWbU4tclja+ltwI
         7tyQ==
Content-Disposition: inline
In-Reply-To: <20131204000344.GB24968@sergelap>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Cc: "Serge E. Hallyn" <serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org>, =?iso-8859-1?Q?St=E9phane?= Graber <stgraber-/Ni+VN9Krahg9hUCZPvPmw@public.gmane.org>, Tim Hockin <thockin-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Victor Marmol <vmarmol-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Rohit Jnagal <jnagal-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, lxc-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org

Hello, Serge.

On Tue, Dec 03, 2013 at 06:03:44PM -0600, Serge Hallyn wrote:
> > As I communicated multiple times before, delegating write access to
> > control knobs to untrusted domain has always been a security risk and
> > is likely to continue to remain so.  Also, organizationally, a
> 
> Then that will need to be address with per-key blacklisting and/or
> per-value filtering in the manager.
> 
> Which is my way of saying:  can we please have a list of the security
> issues so we can handle them?  :)  (I've asked several times before
> but haven't seen a list or anyone offering to make one)

Unfortunately, for now, please consider everything blacklisted.  Yes,
it is true that some knobs should be mostly safe but given the level
of changes we're going through and the difficulty of properly auditing
anything for delegation to untrusted environment, I don't feel
comfortable at all about delegating through chown.  It is an
accidental feature which happened just because it uses filesystem as
its interface and it is no where near the top of the todo list.  It
has never worked properly and won't in any foreseeable future.

> > cgroup's control knobs belong to the parent not the cgroup itself.
> 
> After thinking awhile I think this makes perfect sense.  I haven't
> implemented set_value yet, and when I do I think I'll implement this
> guideline.

I'm kinda confused here.  You say *everything* is gonna go through the
manager and then talks about chowning directories.  Don't the two
conflict?

> > > Long-term we will want the cgroup manager to become more intelligent -
> > > to place its own limits on clients, to address cpu and device hotplug,
> > > etc.  Since we will not be doing that in the first prototype, the daemon
> > > will not keep any state about the clients.
> > 
> > Isn't the above conflicting with chowning control knobs?
> 
> Not sure what you mean by this.
> 
> To be clear what I'm talking about is having the client be able to say
> "grant 50% of cpus", then when more cpus are added, the actual cpuset
> gets recalculated.  This may well forever stay outside of the cgmanager
> scope.  It may be more appropriate to put that logic into the lmctfy
> layer.

Yes, something like that would be nice but if you give out raw access
to the control knobs by chowning them, I just don't see how that would
be implementable.  What am I missing here?

Thanks.

-- 
tejun
