From: Kent Overstreet <kent.overstreet@linux.dev>
Subject: Re: [PATCH 00/40] Memory allocation profiling
Date: Sun, 7 May 2023 13:01:57 -0400
Message-ID: <ZFfZhTiXqeV1enD4@moria.home.lan>
References: <20230501165450.15352-1-surenb@google.com>
 <ZFIMaflxeHS3uR/A@dhcp22.suse.cz>
 <CAJuCfpHxbYFxDENYFfnggh1D8ot4s493PQX0C7kD-JLvixC-Vg@mail.gmail.com>
 <ZFN1yswCd9wRgYPR@dhcp22.suse.cz>
 <CAJuCfpEkV_+pAjxyEpMqY+x7buZhSpj5qDF6KubsS=ObrQKUZg@mail.gmail.com>
 <ZFd9BiSorMldWiff@dhcp22.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1683478930;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=K2IKs9gP6n8AwGF/yIy3vUTevnAld9lGncsxDoAPz7I=;
        b=RBllo5SEteiXdDXnxk7cvHhWc/ZZh0WQhZDZBnP+ByAnv8lRSeIbU166BGu3cTiWFAlwdB
        nBFEChtqdNB9Z3bo6qijnMaFFiQ4D4cogj6akL7Hso38B4dGgPNp5YpE0GoUhkJAbR1zsk
        SwoHfdcoAv3j3qWwaVk8QGGqXSvbXYE=
Content-Disposition: inline
In-Reply-To: <ZFd9BiSorMldWiff@dhcp22.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Michal Hocko <mhocko@suse.com>
Cc: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org, vbabka@suse.cz, hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de, dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, tj@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryahmed@google.com, yuzhao@google.com, dhowells@redhat.com, hughd@google.com, andreyknvl@gmail.com

On Sun, May 07, 2023 at 12:27:18PM +0200, Michal Hocko wrote:
> On Thu 04-05-23 08:08:13, Suren Baghdasaryan wrote:
> > On Thu, May 4, 2023 at 2:07=E2=80=AFAM Michal Hocko <mhocko@suse.com> w=
rote:
> [...]
> > > e.g. is it really interesting to know that there is a likely memory
> > > leak in seq_file proper doing and allocation? No as it is the specific
> > > implementation using seq_file that is leaking most likely. There are
> > > other examples like that See?
> >=20
> > Yes, I see that. One level tracking does not provide all the
> > information needed to track such issues. Something more informative
> > would cost more. That's why our proposal is to have a light-weight
> > mechanism to get a high level picture and then be able to zoom into a
> > specific area using context capture. If you have ideas to improve
> > this, I'm open to suggestions.
>=20
> Well, I think that a more scalable approach would be to not track in
> callers but in the allocator itself. The full stack trace might not be
> all that important or interesting and maybe even increase the overall
> overhead but a partial one with a configurable depth would sound more
> interesting to me. A per cache hastable indexed by stack trace reference
> and extending slab metadata to store the reference for kfree path won't
> be free but the overhead might be just acceptable.

How would you propose to annotate what call chains need what depth of
stack trace recorded?

How would you propose to make this performant?
