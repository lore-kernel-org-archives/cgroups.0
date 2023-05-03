From: Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH 34/40] lib: code tagging context capture support
Date: Wed, 3 May 2023 12:45:29 -0700
Message-ID: <CAJuCfpGq4CjFLJ=QdQZUJPN72ecvWhVi_vUKrOz5_DvMAM07EQ@mail.gmail.com>
References: <20230501165450.15352-1-surenb@google.com> <20230501165450.15352-35-surenb@google.com>
 <ZFIO3tXCbmTn53uv@dhcp22.suse.cz> <CAJuCfpHrZ4kWYFPvA3W9J+CmNMuOtGa_ZMXE9fOmKsPQeNt2tg@mail.gmail.com>
 <b8ab89e6-0456-969d-ed31-fa64be0a0fd0@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-fsdevel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683143140; x=1685735140;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bq44fWKfzB7azpC5445h4zSgjB+E0XG23Sx5k3P/Wrs=;
        b=mNn8mOJ969yUibKfAWrXgatuIFi6FVIM4EsSSH9KQ1Go4d1sYzKZHUi8VHjbX6pfWa
         OlJ16nZGAbvURg1kkDTdEvJDfJPD2YhA8jF3Bo81PkL1ob0v9cS2gkR4gCqMlpmjnr/s
         tWs9Fu3MohlaypLe2rIvRSkpy7E5gp65K6pp8163QEUwdmBPDYTBTVK0GaffIx+/jWG1
         GkJ4oD48JkxrW+rrbEhXrrnBxumK3LN05X4J4kXdI0k+pYkkAnfDQi3ANZniOpY63cWz
         Q+VUnUlPsKkbZjKcze+vAukdxm3Nrif9W+zvOKGcMfCU5FAKE+MOBW4LpPVOFpo/QEqA
         mUdg==
In-Reply-To: <b8ab89e6-0456-969d-ed31-fa64be0a0fd0@intel.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="windows-1252"
To: Dave Hansen <dave.hansen@intel.com>
Cc: Michal Hocko <mhocko@suse.com>, akpm@linux-foundation.org, kent.overstreet@linux.dev, vbabka@suse.cz, hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de, dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, tj@kernel.org, muchun.song@linux.dev, rppt@kernel.org, paulmck@kernel.org, pasha.tatashin@soleen.com, yosryahmed@google.com, yuzhao@google.com, dhowells@redhat.com, hughd@google.com, an

On Wed, May 3, 2023 at 8:26=E2=80=AFAM Dave Hansen <dave.hansen@intel.com> =
wrote:
>
> On 5/3/23 08:18, Suren Baghdasaryan wrote:
> >>> +static inline void rem_ctx(struct codetag_ctx *ctx,
> >>> +                        void (*free_ctx)(struct kref *refcount))
> >>> +{
> >>> +     struct codetag_with_ctx *ctc =3D ctx->ctc;
> >>> +
> >>> +     spin_lock(&ctc->ctx_lock);
> >> This could deadlock when allocator is called from the IRQ context.
> > I see. spin_lock_irqsave() then?
>
> Yes.  But, even better, please turn on lockdep when you are testing.  It
> will find these for you.  If you're on x86, we have a set of handy-dandy
> debug options that you can add to an existing config with:
>
>         make x86_debug.config

Nice!
I thought I tested with lockdep enabled but I might be wrong. The
beauty of working on multiple patchsets in parallel is that I can't
remember what I did for each one :)

>
> That said, I'm as concerned as everyone else that this is all "new" code
> and doesn't lean on existing tracing or things like PAGE_OWNER enough.

Yeah, that's being actively discussed.

>
