From: Tim Hockin <thockin-Rl2oBbRerpQdnm+yROfE0A@public.gmane.org>
Subject: Re: cgroup: status-quo and userland efforts
Date: Thu, 27 Jun 2013 08:29:21 -0700
Message-ID: <CAAAKZwt9QdddFrEjvdBsi3sbQXScKyzY=vZpYXqTwjGUebH1Ag@mail.gmail.com>
References: <20130406012159.GA17159@mtj.dyndns.org> <CAAAKZwvh_R2Xz--bmSLiN33fsqKanOJMq_6+6hoFWFRx38O4gA@mail.gmail.com>
 <20130422214159.GG12543@htj.dyndns.org> <CAAAKZwuXJwwyj7KSqb7rZ+nrTwBWEaUCWfa7kWecTBnHL8koGw@mail.gmail.com>
 <CAAAKZwvP_7wBBYMmtFuiE2hZt=ByaLrnTyiR83CZr3OMip63Gg@mail.gmail.com>
 <20130625000118.GT1918@mtj.dyndns.org> <CAAAKZwt09k-qUwLCnMpAQeYJ-S0XtkjXe4=bJ-G_fcrkAqEzoA@mail.gmail.com>
 <20130626212047.GB4536@htj.dyndns.org> <1372311907.5871.78.camel@marge.simpson.net>
 <20130627132206.GE4003@sergelap>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        bh=cv5Q6uPoQGtXS9K8bJyyVpsEoQ5lugGj1Y6Sq/YaQ7c=;
        b=IZzrlaRCoweDzAmYKfY5q2cOqmZ1Z1OI8sQ35p1aJW63BzOwQ4Fv+C0FYzA/Bs+JlF
         0bl3OP4CbxSi+c1WJHvPtDwA8RbpwQ5/nP97bhj8XpVYQX6UO1nLDdu+SGBH4x30m/Ep
         XyhXiW9G6vVw2cssTxoBA1pEX4L3a0n6YA1t3sVAW9caMyeSNf+1GpbIfTMQYG2Si4Ls
         ctXlm3f/3kS8BUjqF0yuVSjF3GVnBHHGc/m7jduRwk7SPkFdUX9AxI6VLayesbDnCc4R
         O4jFl9aohNPem4xXF94mIMyAJHsOk44rjGdgFA2zgk4lUGlirOd+TBfQaf2jbYTUjo3k
         +wig==
In-Reply-To: <20130627132206.GE4003@sergelap>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org>
Cc: Mike Galbraith <bitbucket-BGeptl67XyCzQB+pC5nmwQ@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Containers <containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>, Kay Sievers <kay.sievers-tD+1rO4QERM@public.gmane.org>, lpoetter <lpoetter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, workman-devel <workman-devel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, jpoimboe <jpoimboe-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "dhaval.giani" <dhaval.giani-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

On Thu, Jun 27, 2013 at 6:22 AM, Serge Hallyn <serge.hallyn-GeWIH/nMZzLQT0dZR+AlfA@public.gmane.org> wrote:
> Quoting Mike Galbraith (bitbucket-BGeptl67XyCzQB+pC5nmwQ@public.gmane.org):
>> On Wed, 2013-06-26 at 14:20 -0700, Tejun Heo wrote:
>> > Hello, Tim.
>> >
>> > On Mon, Jun 24, 2013 at 09:07:47PM -0700, Tim Hockin wrote:
>> > > I really want to understand why this is SO IMPORTANT that you have to
>> > > break userspace compatibility?  I mean, isn't Linux supposed to be the
>> > > OS with the stable kernel interface?  I've seen Linus rant time and
>> > > time again about this - why is it OK now?
>> >
>> > What the hell are you talking about?  Nobody is breaking userland
>> > interface.  A new version of interface is being phased in and the old
>> > one will stay there for the foreseeable future.  It will be phased out
>> > eventually but that's gonna take a long time and it will have to be
>> > something hardly noticeable.  Of course new features will only be
>> > available with the new interface and there will be efforts to nudge
>> > people away from the old one but the existing interface will keep
>> > working it does.
>>
>> I can understand some alarm.  When I saw the below I started frothing at
>> the face and howling at the moon, and I don't even use the things much.
>>
>> http://lists.freedesktop.org/archives/systemd-devel/2013-June/011521.html
>>
>> Hierarchy layout aside, that "private property" bit says that the folks
>> who currently own and use the cgroups interface will lose direct access
>> to it.  I can imagine folks who have become dependent upon an on the fly
>> management agents of their own design becoming a tad alarmed.
>
> FWIW, the code is too embarassing yet to see daylight, but I'm playing
> with a very lowlevel cgroup manager which supports nesting itself.
> Access in this POC is low-level ("set freezer.state to THAWED for cgroup
> /c1/c2", "Create /c3"), but the key feature is that it can run in two
> modes - native mode in which it uses cgroupfs, and child mode where it
> talks to a parent manager to make the changes.

In this world, are users able to read cgroup files, or do they have to
go through a central agent, too?

> So then the idea would be that userspace (like libvirt and lxc) would
> talk over /dev/cgroup to its manager.  Userspace inside a container
> (which can't actually mount cgroups itself) would talk to its own
> manager which is talking over a passed-in socket to the host manager,
> which in turn runs natively (uses cgroupfs, and nests "create /c1" under
> the requestor's cgroup).

How do you handle updates of this agent?  Suppose I have hundreds of
running containers, and I want to release a new version of the cgroupd
?

(note: inquiries about the implementation do not denote acceptance of
the model :)

> At some point (probably soon) we might want to talk about a standard API
> for these things.  However I think it will have to come in the form of
> a standard library, which knows to either send requests over dbus to
> systemd, or over /dev/cgroup sock to the manager.
>
> -serge
