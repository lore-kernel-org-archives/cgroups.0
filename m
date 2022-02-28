From: Shakeel Butt <shakeelb@google.com>
Subject: Re: [PATCH] memcg: async flush memcg stats from perf sensitive codepaths
Date: Mon, 28 Feb 2022 14:46:44 -0800
Message-ID: <CALvZod61XyMJzrvU0Wvp8iWV878rZQYsa407RhoZYeiJV5j5SQ@mail.gmail.com>
References: <20220226002412.113819-1-shakeelb@google.com> <20220225165842.561d3a475310aeab86a2d653@linux-foundation.org>
 <CALvZod7SA17vounKnq1KX23172rztNN_Oo0K1XaeEuS4JVEhMw@mail.gmail.com> <20220228184653.GA1812@blackbody.suse.cz>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LglAJFBfW0192A+zdtC6aPQEwQomXk3iQX8CrMvwboE=;
        b=Q1mmID59L3r+ZQjhjmMSnqIrxTddfLL+dg5Yncv+WGGQrW3mSeBNuaKUkiOgbD16ON
         Y0LTiD+wKPqFjsANDBpDGbLewVglEMBb+vPQ7iNIWROAxQKLDwNXCF+WYl02BWzhGLrM
         RHRxrBI1VRXCO9gQotZhnjXQoYxNZA/2S1cnEpTKfFZzBzDcEjjcpQ4O2PnBazcDncIs
         +nVGzkVgPfD0o3Bbl0Qfx8P6RFMUgV/vo7Bq5I8obRVLwbq2yKktjX+2sOG0qerdAjJ8
         I9L84JOIAHkzoTTOeBLgd7XNiy6mErmdRwXno8BokmhWTsT2XfcKd6xPZPwgfGwfXHJW
         UKJQ==
In-Reply-To: <20220228184653.GA1812@blackbody.suse.cz>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="macroman"
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Ivan Babrou <ivan@cloudflare.com>, Cgroups <cgroups@vger.kernel.org>, Linux MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, Daniel Dao <dqminh@cloudflare.com>, stable <stable@vger.kernel.org>

On Mon, Feb 28, 2022 at 10:46 AM Michal Koutn=C3=BD <mkoutny@suse.com> wrot=
e:
>
> On Fri, Feb 25, 2022 at 05:42:57PM -0800, Shakeel Butt <shakeelb@google.c=
om> wrote:
> > Yes, the right fix would be to optimize the flushing code (but that
> > would require more work/time). However I still think letting
> > performance critical code paths to skip the sync flush would be good
> > in general. So, if the current patch is not to your liking we can
> > remove mem_cgroup_flush_stats() from workingset_refault().
>
> What about flushing just the subtree of the memcg where the refault
> happens?
> It doesn't reduce the overall work and there's still full-tree
> cgroup_rstat_lock but it should make the chunks of work smaller
> durations more regular.
>

We can try that and I will send a patch to Ivan and Daniel to try on
their workload to see the real impact of targeted memcg flushing.
However I am not very optimistic about it.
