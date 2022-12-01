From: Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] mm: remove lock_page_memcg() from rmap
Date: Thu, 1 Dec 2022 11:28:14 -0800 (PST)
Message-ID: <67a63be3-e5c3-946e-1565-c6ae8fee9a@google.com>
References: <20221123181838.1373440-1-hannes@cmpxchg.org> <16dd09c-bb6c-6058-2b3-7559b5aefe9@google.com> <Y4TpCJ+5uCvWE6co@cmpxchg.org> <Y4ZYsrXLBFDIxuoO@cmpxchg.org> <3659bbe0-ccf2-7feb-5465-b287593aa421@google.com> <CALvZod7_FjO-CjzHUpQTsCTm4-68a1eKi_qY=4XdF+g7yMLd4Q@mail.gmail.com>
 <e0918c92-90cd-e3ed-f4e6-92d02062c252@google.com> <Y4fZbFNVckh1g4WO@cmpxchg.org> <33f2f836-98a0-b593-1d43-b289d645db5@google.com> <Y4jNvzpX4g42afvP@cmpxchg.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:message-id:in-reply-to:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=LB2YhMqTu2ntQjGIXenPSlW+YY6N15Qvn6akcp9m04Q=;
        b=iHxxOgC1AQ5I6cQYKhhBLqMu9WvJCbCwz3uq3QI2q1BeAakagA1VocuP62HL+GrOlk
         J9hfSSOgNfmYHdIpW97ulaXYPTUV9B9JLIrMNrj4U2RIEWJQtG3CYnormFYFDQqNKvHE
         iGwPojD/manJG2L4zTxfl7adGaS4s7kVRLEoazjhflAJP7L4goZ23CLlctlvSAye8+5V
         0DEFHxRaU6m++RfwEMZdQ/FYaKei/CjAcYsu8vjgp8XDnHTXJpIIiL+EChAvIcJfMF4t
         b8J0yxZiGe6lZB0IlKNbBxrMVvULpK/S2vnB1snQlLZfQ4b10XCXbFM7DBnoFHgewfT7
         Zd2A==
In-Reply-To: <Y4jNvzpX4g42afvP@cmpxchg.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Hugh Dickins <hughd@google.com>, Shakeel Butt <shakeelb@google.com>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, 1 Dec 2022, Johannes Weiner wrote:
> On Wed, Nov 30, 2022 at 04:13:23PM -0800, Hugh Dickins wrote:
> 
> > And I don't know what will be best for the preliminary precharge pass:
> > doesn't really want the page lock at all, but it may be unnecessary
> > complication to avoid taking it then unlocking it in that pass.
> 
> We could make it conditional on target, which precharge doesn't pass,
> but I agree it's likely not worth optimizing that code at this point.

I hadn't noticed that NULL target so easily distinguishes that case:
unless it goes on to uglify things more (which I think it won't, seeing
now how there are already plenty of conditionals on target), I would
prefer to avoid the trylock and unlock in the precharge case; but
decide for yourself.

Hugh
