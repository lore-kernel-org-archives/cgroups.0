From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 00/40] Memory allocation profiling
Date: Wed, 3 May 2023 16:11:50 -0400
Message-ID: <20230503201150.GB197627@cmpxchg.org>
References: <ZFKNZZwC8EUbOLMv@slm.duckdns.org>
 <20230503180726.GA196054@cmpxchg.org>
 <ZFKlrP7nLn93iIRf@slm.duckdns.org>
 <ZFKqh5Dh93UULdse@slm.duckdns.org>
 <ZFKubD/lq7oB4svV@moria.home.lan>
 <ZFKu6zWA00AzArMF@slm.duckdns.org>
 <ZFKxcfqkUQ60zBB_@slm.duckdns.org>
 <CAJuCfpEPkCJZO2svT-GfmpJ+V-jSLyFDKM_atnqPVRBKtzgtnQ@mail.gmail.com>
 <ZFK6pwOelIlhV8Bm@slm.duckdns.org>
 <CAJuCfpG4TmRpT5iU7bJmKcjW2Tghstdo1b=qEG=tDsmtJQYuWA@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-arch-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20221208.gappssmtp.com; s=20221208; t=1683144713; x=1685736713;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=6aQuySOZ5f1xPp5M/IH7FdCb3YCBcIXK77oTLJoa1To=;
        b=B77wj2uaBiAWD8idxLhj65ewWhJv33njFprJjaUykYSV+6Yt7L5dCUa5lIV4RnTCul
         77+cSySse1ya6C7PyiB0e9SPkdj1lshr0RenyoypDVR8ikg/OEorh8RVaMkmDyZXhpHv
         oV4cTXFAC8UYttofZrb1JTodalX4rrORDCcsv+1Jx7UbO7bLKPm1QGHzfh1gWH9APa83
         /Rf/B+R6oZeNNgEfgORGaxElO0hO+QyuC06nrse5RwbHwLMFubuPNkiSJbC3/nSMBWBu
         ZZk1an8YPsQoRYqubaG4Ci1ht8gXo9iEZqN3Zi7lvLJvcUkK5IQDe48usFI3QGu+5mjm
         PenQ==
Content-Disposition: inline
In-Reply-To: <CAJuCfpG4TmRpT5iU7bJmKcjW2Tghstdo1b=qEG=tDsmtJQYuWA@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Suren Baghdasaryan <surenb@google.com>
Cc: Tejun Heo <tj@kernel.org>, Kent Overstreet <kent.overstreet@linux.dev>, Michal Hocko <mhocko@suse.com>, akpm@linux-foundation.org, vbabka@suse.cz, roman.gushchin@linux.dev, mgorman@suse.de, dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryahmed@google.com, yuzhao@google.com, dhowells@redhat.com, hu

On Wed, May 03, 2023 at 01:08:40PM -0700, Suren Baghdasaryan wrote:
> On Wed, May 3, 2023 at 12:49=E2=80=AFPM Tejun Heo <tj@kernel.org> wrote:
> > * Improving memory allocation visibility makes sense to me. To me, a mo=
re
> >   natural place for that feels like /proc/allocations next to other mem=
ory
> >   info files rather than under debugfs.
>=20
> TBH I would love that if this approach is acceptable.

Ack
