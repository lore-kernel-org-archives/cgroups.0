From: Kent Overstreet <kent.overstreet@linux.dev>
Subject: Re: [PATCH 00/40] Memory allocation profiling
Date: Wed, 3 May 2023 12:03:11 -0400
Message-ID: <ZFKFv6F3pRtnAWSS@moria.home.lan>
References: <20230501165450.15352-1-surenb@google.com>
 <ZFIMaflxeHS3uR/A@dhcp22.suse.cz>
 <ZFIOfb6/jHwLqg6M@moria.home.lan>
 <ZFISlX+mSx4QJDK6@dhcp22.suse.cz>
 <20230503115051.30b8a97f@meshulam.tesarici.cz>
 <ZFIv+30UH7+ySCZr@moria.home.lan>
 <25a1ea786712df5111d7d1db42490624ac63651e.camel@HansenPartnership.com>
 <ZFJ9hlQ3ZIU1XYCY@moria.home.lan>
 <f57b77b0-74da-41a3-a3bc-969ded4e0410@lucifer.local>
Mime-Version: 1.0
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1683129803;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=MZ0TWwv0Mpu9IjWcxRCWjJEEQ++kpZPmKK/VcTJkl7k=;
        b=FpGctQbM8W0rfqOGZOmSKFnYLpxrclq3L7E+rrXnS/9nXRbb9R5M7EzAN6wvhioCICdsHM
        WM800GTR3zcYRzwg97hBrpkz/9ZsEWI3RL80N/2zwrpf92rM0McRD43/F36Q+ZHI2sCc0L
        g2qQO4EQowCmjkSmuSEX+YK+w94lB2M=
Content-Disposition: inline
In-Reply-To: <f57b77b0-74da-41a3-a3bc-969ded4e0410@lucifer.local>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Lorenzo Stoakes <lstoakes@gmail.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Petr =?utf-8?B?VGVzYcWZw61r?= <petr@tesarici.cz>, Michal Hocko <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org, vbabka@suse.cz, hannes@cmpxchg.org, roman.gushchin@linux.dev, mgorman@suse.de, dave@stgolabs.net, willy@infradead.org, liam.howlett@oracle.com, corbet@lwn.net, void@manifault.com, peterz@infradead.org, juri.lelli@redhat.com, ldufour@linux.ibm.com, catalin.marinas@arm.com, will@kernel.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com, x86@kernel.org, peterx@redhat.com, david@redhat.com, axboe@kernel.dk, mcgrof@kernel.org, masahiroy@kernel.org, nathan@kernel.org, dennis@kernel.org, tj@kernel.org, muchun.song@linux.dev, rppt@kernel.org, pa

On Wed, May 03, 2023 at 04:37:36PM +0100, Lorenzo Stoakes wrote:
> As an outside observer, I can assure you that absolutely came across as a
> personal attack, and the precise kind that puts people off from
> contributing. I should know as a hobbyist contributor myself.
> 
> > If I was mistaken I do apologize, but lately I've run across quite a lot
> > of people offering review feedback to patches I post that turn out to
> > have 0 or 10 patches in the kernel, and - to be blunt - a pattern of
> > offering feedback in strong language with a presumption of experience
> > that takes a lot to respond to adequately on a technical basis.
> >
> 
> I, who may very well not merit being considered a contributor of
> significant merit in your view, have had such 'drive-by' commentary on some
> of my patches by precisely this type of person, and at no time felt the
> need to question whether they were a true Scotsman or not. It's simply not
> productive.
> 
> > I don't think a suggestion to spend a bit more time reading code instead
> > of speculating is out of order! We could all, put more effort into how
> > we offer review feedback.
> 
> It's the means by which you say it that counts for everything. If you feel
> the technical comments might not be merited on a deeper level, perhaps ask
> a broader question, or even don't respond at all? There are other means
> available.
> 
> It's remarkable the impact comments like the one you made can have on
> contributors, certainly those of us who are not maintainers and are
> naturally plagued with imposter syndrome, so I would ask you on a human
> level to try to be a little more considerate.
> 
> By all means address technical issues as robustly as you feel appropriate,
> that is after all the purpose of code review, but just take a step back and
> perhaps find the 'cuddlier' side of yourself when not addressing technical
> things :)

Thanks for your reply, it's level headed and appreciated.

But I personally value directness, and I see quite a few people in this
thread going all out on the tone policing - but look, without the
directness the confusion (that Petr is not actually a new contributor)
never would've been cleared up.

Food for thought, perhaps?
