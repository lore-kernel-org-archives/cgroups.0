From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v4 0/2] cgroup: allow management of subtrees by new
 cgroup namespaces
Date: Tue, 31 May 2016 14:18:04 -0400
Message-ID: <20160531181804.GL29775@mtj.duckdns.org>
References: <20160520152244.GB5632@htj.duckdns.org>
 <1463758258.8091.3.camel@HansenPartnership.com>
 <20160520160352.GC5632@htj.duckdns.org>
 <1463760550.8091.13.camel@HansenPartnership.com>
 <20160520161759.GD5632@htj.duckdns.org>
 <1463761509.8091.19.camel@HansenPartnership.com>
 <20160520165326.GE5632@htj.duckdns.org>
 <1463765326.8091.42.camel@HansenPartnership.com>
 <20160520174938.GF5632@htj.duckdns.org>
 <CAOviyag8PA2EqX_8tKq+KoOZ8m6osVyS49GzmuBzN5UDr6zVTA@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6EzhTbGpwMOMB64XVCjbyDcKtPLyHAXCE0IiRt3z2i0=;
        b=i4MsER+61tc3UENSa15d1pCQ8Ykw3tGYl5BsLuckL69IW9RTGrg+5TW/ynMNAzCtDo
         2y3IkSLLhNa6fpE3ar3LE71AtoDi5fsTnuziVbNfnuBjbvKEug2weWd4LwII/EPqC3cX
         1Cuc/kYE1Qjp0LcOCJOko13Kn2fecPlAGC1QdAoJr7pvSfOilMOGRp/tM71/45HU6CLV
         7Sy/vMjH7r3gIzPvadgW+AyvqLNtD2vvSv/ipdc/cqzDia5eb6aMCzldI+dmOEEEby6A
         2FQgOJBXuO6lZYaJHjtlH2JPF6ra7yymZrO4XAVWw9dOYxxb8yRdFQdcdv8VvrE+8CB7
         QZ5g==
Content-Disposition: inline
In-Reply-To: <CAOviyag8PA2EqX_8tKq+KoOZ8m6osVyS49GzmuBzN5UDr6zVTA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Aleksa Sarai <cyphar@cyphar.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Aleksa Sarai <asarai@suse.de>, Li Zefan <lizefan@huawei.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, dev <dev@opencontainers.org>

Hello, Aleksa.

On Sat, May 28, 2016 at 03:12:16PM +1000, Aleksa Sarai wrote:
> I see two options here, which would allow us to have subtree
> delegation without losing hierarchical structure:
> 
> 1. Don't enable subtree delegation on v1 hierarchies. This would be
> the simplest solution, and would cut out most people from using this
> feature today -- but it would mean less work around trying to figure
> out which hierarchies are safe to delegate (we make it explicit that
> when you enable a cgroup on v2 that it must be safe to delegate by an
> unprivileged user). We also get the benefit of having the more strict
> cgroup.procs write rules.
> 2. Don't do subtree delegation on hierarchies that aren't
> hierarchical. This would have to be done in collaboration with the
> controllers (since cgroup core doesn't know which is hierarchical),
> and would allow all users of cgroups today to get subtree delegation.

Regardless of the above two, the proposed solution is too hacky and
doesn't fit with the overall design.  At the moment, I'm not sure the
problem is worth solving.

> >> > Why does an unpriv NS need to have cgroup delegated to it without
> >> > cooperation from cgroup manager?
> >>
> >> There's actually many answers to this.  The one I'm insterested in is
> >> the ability for applications to make use of container features without
> >> having to ask permission from some orchestration engine.  The problem
> >
> > What's "container features"?  Do you mean resource control by that?
> 
> Yes. Also the device cgroup. And ignoring the container usecase, it
> would be useful to regular programs if they could use cgroup resource
> accounting as part of their regular operation. Regular processes can
> use rlimits -- why can't they use cgroups without needing cooperation
> from an admin process (which makes for security and administration
> issues).

The current VFS based interface simply isn't conducive to such usage.
e.g. What if someone else relocates the process while it was trying to
access its interface files?  What if the permission or ownership
changes beneath the process.

> If I understand correctly, the security issues James is referring to
> is that the cgroup manager could have a bug in it (and because the
> cgroup interface is the filesystem, it would probably be some kind of
> write-to-any-path bug). This is an intrinsic part of the model of "you
> need to have cooperation with an admin process in order to use
> resource limiting for your own processes".

Sure, that's the inherent characteristic of the interface that cgroup
ended up with.  I'm not a big fan of it either but 1. it still is a
workable model 2. adding mismatching hacks on top is highly likely to
lead to interface disaster in the long term.

Thanks.

-- 
tejun
