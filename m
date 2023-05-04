From: Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 00/40] Memory allocation profiling
Date: Thu, 4 May 2023 11:07:22 +0200
Message-ID: <ZFN1yswCd9wRgYPR@dhcp22.suse.cz>
References: <20230501165450.15352-1-surenb@google.com>
 <ZFIMaflxeHS3uR/A@dhcp22.suse.cz>
 <CAJuCfpHxbYFxDENYFfnggh1D8ot4s493PQX0C7kD-JLvixC-Vg@mail.gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-arch-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1683191243; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+qJXmRqw+FfGzaNlkZLDu9Le9CEnkyHeMqv8Le5oQts=;
        b=ANDPuuGSLrqGeihHM91AJqPDxRdii3XkVbscUjditUheMtvnk8aFBqZLYzfGOSm4Wpep5y
        MN0JxYMPYvRX9Ro+qxZW6USNL5DsbvnuexjUyhsNUQ1F8AiMfWl8V+BA7+Nj2/Wdmi4sGz
        dYzHf3+YdyqXWoFquZFW6OeAMIcZ5Gc=
Content-Disposition: inline
In-Reply-To: <CAJuCfpHxbYFxDENYFfnggh1D8ot4s493PQX0C7kD-JLvixC-Vg@mail.gmail.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, kent.overstreet@linux.dev, vbabka@suse.cz, hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de, dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, tj@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryahmed@google.com, yuzhao@google.com, dhowells@redhat.com, hughd@google.com, andreyknvl@gmail.com, keescook@chr

On Wed 03-05-23 08:09:28, Suren Baghdasaryan wrote:
> On Wed, May 3, 2023 at 12:25=E2=80=AFAM Michal Hocko <mhocko@suse.com> wr=
ote:
[...]
> Thanks for summarizing!
>=20
> > At least those I find the most important:
> > - This is a big change and it adds a significant maintenance burden
> >   because each allocation entry point needs to be handled specifically.
> >   The cost will grow with the intended coverage especially there when
> >   allocation is hidden in a library code.
>=20
> Do you mean with more allocations in the codebase more codetags will
> be generated? Is that the concern?

No. I am mostly concerned about the _maintenance_ overhead. For the
bare tracking (without profiling and thus stack traces) only those
allocations that are directly inlined into the consumer are really
of any use. That increases the code impact of the tracing because any
relevant allocation location has to go through the micro surgery.=20

e.g. is it really interesting to know that there is a likely memory
leak in seq_file proper doing and allocation? No as it is the specific
implementation using seq_file that is leaking most likely. There are
other examples like that See?

> Or maybe as you commented in
> another patch that context capturing feature does not limit how many
> stacks will be captured?

That is a memory overhead which can be really huge and it would be nice
to be more explicit about that in the cover letter. It is a downside for
sure but not something that has a code maintenance impact and it is an
opt-in so it can be enabled only when necessary.

Quite honestly, though, the more I look into context capturing part it
seems to me that there is much more to be reconsidered there and if you
really want to move forward with the code tagging part then you should
drop that for now. It would make the whole series smaller and easier to
digest.

> > - It has been brought up that this is duplicating functionality already
> >   available via existing tracing infrastructure. You should make it very
> >   clear why that is not suitable for the job
>=20
> I experimented with using tracing with _RET_IP_ to implement this
> accounting. The major issue is the _RET_IP_ to codetag lookup runtime
> overhead which is orders of magnitude higher than proposed code
> tagging approach. With code tagging proposal, that link is resolved at
> compile time. Since we want this mechanism deployed in production, we
> want to keep the overhead to the absolute minimum.
> You asked me before how much overhead would be tolerable and the
> answer will always be "as small as possible". This is especially true
> for slab allocators which are ridiculously fast and regressing them
> would be very noticable (due to the frequent use).

It would have been more convincing if you had some numbers at hands.
E.g. this is a typical workload we are dealing with. With the compile
time tags we are able to learn this with that much of cost. With a dynamic
tracing we are able to learn this much with that cost. See? As small as
possible is a rather vague term that different people will have a very
different idea about.

> There is another issue, which I think can be solved in a smart way but
> will either affect performance or would require more memory. With the
> tracing approach we don't know beforehand how many individual
> allocation sites exist, so we have to allocate code tags (or similar
> structures for counting) at runtime vs compile time. We can be smart
> about it and allocate in batches or even preallocate more than we need
> beforehand but, as I said, it will require some kind of compromise.

I have tried our usual distribution config (only vmlinux without modules
so the real impact will be larger as we build a lot of stuff into
modules) just to get an idea:
   text    data     bss     dec     hex filename
28755345        17040322        19845124        65640791        3e99957 vml=
inux.before
28867168        17571838        19386372        65825378        3ec6a62 vml=
inux.after

Less than 1% for text 3% for data.  This is not all that terrible
for an initial submission and a more dynamic approach could be added
later. E.g. with a smaller pre-allocated hash table that could be
expanded lazily. Anyway not something I would be losing sleep over. This
can always be improved later on.

> I understand that code tagging creates additional maintenance burdens
> but I hope it also produces enough benefits that people will want
> this. The cost is also hopefully amortized when additional
> applications like the ones we presented in RFC [1] are built using the
> same framework.

TBH I am much more concerned about the maintenance burden on the MM side
than the actual code tagging itslef which is much more self contained. I
haven't seen other potential applications of the same infrastructure and
maybe the code impact would be much smaller than in the MM proper. Our
allocator API is really hairy and convoluted.

> > - We already have page_owner infrastructure that provides allocation
> >   tracking data. Why it cannot be used/extended?
>=20
> 1. The overhead.

Do you have any numbers?

> 2. Covers only page allocators.

Yes this sucks.
>=20
> I didn't think about extending the page_owner approach to slab
> allocators but I suspect it would not be trivial. I don't see
> attaching an owner to every slab object to be a scalable solution. The
> overhead would again be of concern here.

This would have been a nice argument to mention in the changelog so that
we know that you have considered that option at least. Why should I (as
a reviewer) wild guess that?

> I should point out that there was one important technical concern
> about lack of a kill switch for this feature, which was an issue for
> distributions that can't disable the CONFIG flag. In this series we
> addressed that concern.

Thanks, that is certainly appreciated. I haven't looked deeper into that
part but from the cover letter I have understood that CONFIG_MEM_ALLOC_PROF=
ILING
implies unconditional page_ext and therefore the memory overhead
assosiated with that. There seems to be a killswitch nomem_profiling but
from a quick look it doesn't seem to disable page_ext allocations. I
might be missing something there of course. Having a highlevel
describtion for that would be really nice as well.

> [1] https://lore.kernel.org/all/20220830214919.53220-1-surenb@google.com/

--=20
Michal Hocko
SUSE Labs
