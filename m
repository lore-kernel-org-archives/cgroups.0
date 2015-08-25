From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 3/3] sched: Implement interface for cgroup unified
 hierarchy
Date: Tue, 25 Aug 2015 11:24:42 +0200
Message-ID: <20150825092441.GA24131@gmail.com>
References: <20150824170427.GA27262@mtj.duckdns.org>
 <CAPM31RJi07qs42YsH=4JQSbZ+J-zCLv8e7yELb3tF_qAZmLqRA@mail.gmail.com>
 <20150824210223.GH28944@mtj.duckdns.org>
 <CAPM31R+i7BD8x9h_6wZVTa0zCB7XP0SGL5dSA-n6h9PTeAEhug@mail.gmail.com>
 <20150824211707.GJ28944@mtj.duckdns.org>
 <CAPM31R+vt1oAPCB-q6570RqZtJVBu5MH=gcQD2m9mjauStV7MA@mail.gmail.com>
 <20150824214000.GL28944@mtj.duckdns.org>
 <CAPM31R+Mnk=AL6h05eMMQvPEEfnjkB3iGb+oZj28jAQ9-ajOxA@mail.gmail.com>
 <20150824224936.GO28944@mtj.duckdns.org>
 <CAPM31RKr5K0F6b70wJronTcvXRLBYRuOvH+aFeDTVeZiDVZz=Q@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=xEc4AUG48/wUJleRpsPHmodGjBL1bxDLQJTCcsUv+SM=;
        b=eICgsBJtT2+rOHn1zgpD/D1neJW1iIWTYt6uHxk8dB/UR4i3qEYGFT6jRu0p1PpX7c
         lirm8h1CzgKmUJ0xK5oO60Vw5E0CGqykewtnAjy1/VLEdY3MarB1ZR0RDXZKYFRr71fD
         cO8dkJXE+mrW0kyflq4hur6GMS1ANkPxb136GgO2Mob2ottgTJxIhBlrBkO7riT9CAg7
         iMRrSoJdBf1Z3MNYE2xsuidtptkeAzoHlLT1FXJmc7rxDs/jZg9sfI5f0CeYaQOW3COA
         oyMPXxQ2OGJoI7FHs89y1dQuK6gPfVNOMEdAie1t/oTbK2bxT2Lb9b4KbNPTmU9QPMSr
         mGgg==
Content-Disposition: inline
In-Reply-To: <CAPM31RKr5K0F6b70wJronTcvXRLBYRuOvH+aFeDTVeZiDVZz=Q@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Paul Turner <pjt@google.com>, Tejun Heo <tj@kernel.org>
Cc: Tejun Heo <tj@kernel.org>, Austin S Hemmelgarn <ahferroin7@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, lizefan@huawei.com, cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-team <kernel-team@fb.com>, Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>


* Paul Turner <pjt@google.com> wrote:

> > Anyways, a point here is that threads of the same process competing
> > isn't a new problem.  There are many ways to make those threads play
> > nice as the application itself often has to be involved anyway,
> > especially for something like qemu which is heavily involved in
> > provisioning resources.
> 
> It's certainly not a new problem, but it's a real one, and it's
> _hard_.  You're proposing removing the best known solution.

Also, just to make sure this is resolved properly, I'm NAK-ing the current 
scheduler bits in this series:

  NAKed-by: Ingo Molnar <mingo@kernel.org>

until all of pjt's API design concerns are resolved. This is conceptual, it is not 
a 'we can fix it later' detail.

Tejun, please keep me Cc:-ed to future versions of this series so that I can lift 
the NAK if things get resolved.

Thanks,

	Ingo
