From: Chris Down <chris@chrisdown.name>
Subject: Re: [PATCH 1/2] mm, memcg: Avoid stale protection values when cgroup
 is above protection
Date: Thu, 30 Apr 2020 02:46:03 +0100
Message-ID: <20200430014603.GB2754277@chrisdown.name>
References: <cover.1588092152.git.chris@chrisdown.name>
 <d454fca5d6b38b74d8dc35141e8519b02089a698.1588092152.git.chris@chrisdown.name>
 <CALOAHbCotD1-+o_XZPU_4_i8Nn98r5F_5NpGVd=z6UG=rUcCmA@mail.gmail.com>
 <20200430011626.GA2754277@chrisdown.name>
 <CALOAHbCL_JJgcy9r99Kn81-o_t-fs_nQ+n7aKMHO-02QMCufEw@mail.gmail.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kVsytFlvwmRlPq2e2ylTjFJxkqfOFOkO0kcwGuxLXfk=;
        b=sf3CTAKS22+/2W8CwVyZC4W5QTvjxrSQYXYwimx3E04EnhPb09pbOUhgikHbXuQcH8
         4+kqjU+Fm6hsIahZ+JkODsSb30DePYkcdcqXccwLuKGWPQYKN3XiBFqR9XU6ww7e4oJS
         9Sr9WGpbT8cDQDnyDiRS7W5/TjJvUOnc3fL/c=
Content-Disposition: inline
In-Reply-To: <CALOAHbCL_JJgcy9r99Kn81-o_t-fs_nQ+n7aKMHO-02QMCufEw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"; format="flowed"
Content-Transfer-Encoding: 7bit
To: Yafang Shao <laoar.shao@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <guro@fb.com>, Linux MM <linux-mm@kvack.org>, Cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

Yafang Shao writes:
>My concern is why we add these barriers to memcg protection
>specifically but don't add these barriers to the other memebers like
>memcg->oom_group which has the same issue ?
>What is the difference between these members and that members ?

There are certainly more missing cases -- I didn't look at oom_group 
specifically, but it sounds likely if there's not other mitigating factors.  
Most of us have just been busy and haven't had time to comprehensively fix all 
the potential store and load tears.

Tearing is another case of something that would be nice to fix once and for all 
in the memcg code, but isn't causing any significant issues for the timebeing.  
We should certainly aim to avoid introducing any new tearing opportunities, 
though :-)

So the answer is just that improvement is incremental and we've not had the 
time to track down and fix them all. If you find more cases, feel free to send 
out the patches and I'll be happy to take a look.
