From: Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH] memcg: sync flush only if periodic flush is delayed
Date: Mon, 14 Mar 2022 13:57:09 +0100
Message-ID: <20220314125709.GA12347@blackbody.suse.cz>
References: <20220304184040.1304781-1-shakeelb@google.com>
 <20220311160051.GA24796@blackbody.suse.cz>
 <20220312190715.cx4aznnzf6zdp7wv@google.com>
Mime-Version: 1.0
Return-path: <stable-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1647262631; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rDnjmno3RNaHoqZQk8WStttjohZNlh5HTFSnG4DmMuc=;
        b=mY8tCJ8kdj2//VBcpDAmvBBhExrUmqIb9QskcfqVQbsBuGJos52kN/oZy8yP8s3R3YkMAT
        55/zyV4NfDXeabMudRc7XBOL6SWU7OgUWrhN5/gRR9UioEoI1goBUSum1ejzdOss6B/OHt
        9gluR5EzP1m6EZGprUljPNBmw0yLXtU=
Content-Disposition: inline
In-Reply-To: <20220312190715.cx4aznnzf6zdp7wv@google.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Shakeel Butt <shakeelb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Ivan Babrou <ivan@cloudflare.com>, Frank Hofmann <fhofmann@cloudflare.com>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Daniel Dao <dqminh@cloudflare.com>, stable@vger.kernel.org

Hi 2.

On Sat, Mar 12, 2022 at 07:07:15PM +0000, Shakeel Butt <shakeelb@google.com> wrote:
> It is (b) that I am aiming for in this patch. At least (a) was not
> happening in the cloudflare experiments. Are you suggesting having a
> dedicated high priority wq would solve both (a) and (b)?
> [...]
> > We can't argue what's the effect of periodic only flushing so this
> > newly introduced factor would inherit that too. I find it superfluous.
> 
> 
> Sorry I didn't get your point. What is superfluous?

Let me retell my understanding.
The current implementation flushes based on cumulated error and time.
Your patch proposes conditioning the former with another time-based
flushing, whose duration can be up to 2 times longer than the existing
periodic flush.

Assuming the periodic flush is working, the reader won't see data older
than 2 seconds, so the additional sync-flush after (possible) 4 seconds
seems superfluous.

(In the case of periodic flush being stuck, I thought the factor 2=4s/2s
was superfluous, another magic parameter.)

I'm comparing here your proposal vs no synchronous flushing in
workingset_refault().

> Do you have any strong concerns with the currect patch?

Does that clarify?

(I agree with your initial thesis this can be iterated before it evolves
to everyone's satisfaction.)


Michal

