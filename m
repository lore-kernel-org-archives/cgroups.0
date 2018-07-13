From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [RFC PATCH 10/10] psi: aggregate ongoing stall events when
 somebody reads pressure
Date: Fri, 13 Jul 2018 18:49:20 -0400
Message-ID: <20180713224920.GA31566@cmpxchg.org>
References: <20180712172942.10094-1-hannes@cmpxchg.org>
 <20180712172942.10094-11-hannes@cmpxchg.org>
 <CAJuCfpHGhSs6upZj0ARng-rE1Nbtcr_XHynZhN7EgGdC16tpPg@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HZKdE5BEkuE41busR47XjmYnRCtqFvpmYwJ64dAu8iU=;
        b=RfPu4v/XumHDR+n+s8fcBUN+mzsf8UVrzt5PgLxCRGYRdHEwfcCXpc3LlZfMgz7t6e
         s+y+uo/IYQYbDXLiJE0NjWCaWHA315ilkxI/tBTDRPgH7CBlOzoyg/Q9RSZeFdVqUM9u
         cidAzqAKgO0wKELYoZOPfR8BQGFy9dx5Lkt+VRxi8XNw9SobhD5yBiIRB19EHSBUTrZn
         28A54Lh2FIEYS5hkFOTqoKgzjuxbvzzN+ul4ks6Yqla3LIxEJ0eFgWzSMH7QhVl2VTiL
         gdj90CU3rqiO7dHORF9aYdZIsJ+DBDuyVkUWGrj9TvKrQKHExpY6uf1YrsIVIslHoidD
         8Wxw==
Content-Disposition: inline
In-Reply-To: <CAJuCfpHGhSs6upZj0ARng-rE1Nbtcr_XHynZhN7EgGdC16tpPg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Suren Baghdasaryan <surenb@google.com>
Cc: Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Vinayak Menon <vinmenon@codeaurora.org>, Christopher Lameter <cl@linux.com>, Mike Galbraith <efault@gmx.de>, Shakeel Butt <shakeelb@google.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Fri, Jul 13, 2018 at 03:13:07PM -0700, Suren Baghdasaryan wrote:
> On Thu, Jul 12, 2018 at 10:29 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> > might want to know about and react to stall states before they have
> > even concluded (e.g. a prolonged reclaim cycle).
> >
> > This patches the procfs/cgroupfs interface such that when the pressure
> > metrics are read, the current per-cpu states, if any, are taken into
> > account as well.
> >
> > Any ongoing states are concluded, their time snapshotted, and then
> > restarted. This requires holding the rq lock to avoid corruption. It
> > could use some form of rq lock ratelimiting or avoidance.
> >
> > Requested-by: Suren Baghdasaryan <surenb@google.com>
> > Not-yet-signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> > ---
> 
> IMHO this description is a little difficult to understand. In essence,
> PSI information is being updated periodically every 2secs and without
> this patch the data can be stale at the time when we read it (because
> it was last updated up to 2secs ago). To avoid this we update the PSI
> "total" values when data is being read.

That fix I actually folded into the main patch. We now always update
the total= field at the time the user reads to include all concluded
events, even if we sampled less than 2s ago. Only the running averages
are still bound to the 2s sampling window.

What this patch adds on top is for total= to include any *ongoing*
stall events that might be happening on a CPU at the time of reading
from the interface, like a reclaim cycle that hasn't finished yet.
