From: Vipin Sharma <vipinsh@google.com>
Subject: Re: [Patch v3 0/2] cgroup: New misc cgroup controller
Date: Mon, 22 Mar 2021 11:24:55 -0700
Message-ID: <YFjg9+qGLMUoKj4h@google.com>
References: <20210304231946.2766648-1-vipinsh@google.com>
 <YETLqGIw1GekWdYK@slm.duckdns.org>
 <YEpoS90X19Z2QOro@blackbook>
 <YEupplaAWU1i0G6B@google.com>
 <YE+xEbwUoRj+snTY@blackbook>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=OALm4xfK1wwGwvHx7Gk4sNjSyWXfRLiJPZ9rAyaA/XM=;
        b=Qa63hcwdFdariUeX+riXwEreFLPTb8WrlMOljzBBFX7+lp14M5ndxajfImrIDPJgdI
         5tnI1Ok8NP2//d9SfWGA6kfZD4QxFSKXBpq4yIP2JdwI27pnQtHPN6unZSbl3cEyHlAt
         /Bqt6YvXxD5CJZo7tQbFS2DyO8VFSNopZzgykyEPzup90yrfD7qKbOb9U8hre5ZgDXnS
         w8ntMBJwlffDAVEsVx6MH8+bwCYwhsRnUOgmDPuKnSb+9ohMIobtcQ2gZMTr1mpHYpK8
         zDt4vXs1yZFQz2qoSg721rNpbpkBLZCOodzZyDXjvP8fcqmgWIOUNkE2sP8VonbGPHwg
         Svpw==
Content-Disposition: inline
In-Reply-To: <YE+xEbwUoRj+snTY@blackbook>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="iso-8859-1"
To: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Cc: Tejun Heo <tj@kernel.org>, rdunlap@infradead.org, thomas.lendacky@amd.com, brijesh.singh@amd.com, jon.grimm@amd.com, eric.vantassell@amd.com, pbonzini@redhat.com, hannes@cmpxchg.org, frankja@linux.ibm.com, borntraeger@de.ibm.com, corbet@lwn.net, seanjc@google.com, vkuznets@redhat.com, wanpengli@tencent.com, jmattson@google.com, joro@8bytes.org, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com, gingell@google.com, rientjes@google.com, dionnaglaze@google.com, kvm@vger.kernel.org, x86@kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, Mar 15, 2021 at 08:10:09PM +0100, Michal Koutn=FD wrote:
> On Fri, Mar 12, 2021 at 09:49:26AM -0800, Vipin Sharma <vipinsh@google.co=
m> wrote:
> > I will add some more information in the cover letter of the next versio=
n.
> Thanks.
>=20
> > Each one coming up with their own interaction is a duplicate effort
> > when they all need similar thing.
> Could this be expressed as a new BPF hook (when allocating/freeing such
> a resource unit)?
>=20
> The decision could be made based on the configured limit or even some
> other predicate.
>=20
> (I saw this proposed already but I haven't seen some more reasoning
> whether it's worse/better. IMO, BPF hooks are "cheaper" than full-blown
> controllers, though it's still new user API.)

I am not much knowledgeable with BPF, so, I might be wrong here.

There are couple of things which might not be addressed with BPF:
1. Which controller to use in v1 case? These are not abstract resources
   so in v1 where each controller have their own hierarchy it might not
   be easy to identify the best controller.

2. It seems to me that we won't be able to abstract out a single BPF
   program which can help with all of the resources types we are
   planning to use, again, because it is not an abstract type like
   network packets, and there will be different places in the source
   code to use these resources.

To me a cgroup tends to give much easier and well integrated solution when =
it
comes to scheduling and limiting a resource with existing tools in a
cloud infrastructure.

>=20
>=20
> > As per my understanding this is the only for way for loadable modules
> > (kvm-amd in this case) to access Kernel APIs. Let me know if there is a
> > better way to do it.
> I understood the symbols are exported for such modularized builds.
> However, making them non-GPL exposes them to any out-of-tree modules,
> although, the resource types are supposed to stay hardcoded in the misc
> controller. So my point was to make them EXPORT_SYMBOL_GPL to mark
> they're just a means of implementing the modularized builds and not an
> API. (But they'd remain API for out-of-tree GPL modules anyway, so take
> this reasoning of mine with a grain of salt.)
>=20
I see, I will change it to GPL.

Thanks
Vipin

